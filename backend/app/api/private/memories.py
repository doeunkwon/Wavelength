import uuid
from app.api.helpers.auth import get_current_user
from database.neo4j import graph
from fastapi import Depends, HTTPException, Body, APIRouter
from app.models import Memory

router = APIRouter()

# Function to create a new memory


@router.post("/private/memories/{fid}")
async def create_memory(
        fid: str,
        memory: Memory = Body(...),
        token: str = Depends(get_current_user)
):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        while True:
            # Generate a new UUID for the memory ID
            new_mid = str(uuid.uuid4())

            # Check if the memory ID already exists
            check_query = """
            MATCH (m:Memory {mid: $mid})
            RETURN m
            """
            result = graph.query(check_query, {"mid": new_mid})

            # If no memory found with the generated ID, proceed with creation
            if len(result) == 0:

                # Cypher query to create a new memory node with generated ID
                cypher_query = """
                CREATE (m:Memory {
                    mid: $mid,
                    date: $date,
                    title: $title,
                    content: $content,
                    tokens: $tokens
                })
                RETURN m
                """
                # Execute the query with memory data
                result = graph.query(
                    cypher_query, {
                        "mid": new_mid,
                        **memory.model_dump()}
                )
                # Assuming a single memory is created
                created_memory = result[0]["m"]

                try:

                    cypher_query = """
                    MATCH (user:User {uid: $uid}), (memory:Memory {mid: $mid}), (friend:Friend {fid: $fid})
                    CREATE (user)-[:HAS_MEMORY]->(memory)-[:ABOUT]->(friend)
                    """
                    graph.query(cypher_query, {
                                "uid": uid, "mid": created_memory["mid"], "fid": fid})
                    # Return the created memory's mid
                    return {"mid": created_memory["mid"]}

                except Exception as e:
                    raise HTTPException(
                        status_code=404, detail="Memory not found.")

            else:
                # Handle duplicate memory ID case (optional)
                raise HTTPException(
                    status_code=409, detail="Memory ID already exists."
                )

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating memory: {str(e)}"
        )

# Function to fetch all memories with a friend


@router.get("/private/memories/{fid}")
async def get_memories(
    fid: str,
    token: str = Depends(get_current_user)
):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        # Cypher query to fetch memories shared with the friend
        cypher_query = """
        MATCH (:User {uid: $uid})-[:HAS_MEMORY]-(m:Memory)-[:ABOUT]->(:Friend {fid: $fid})
        RETURN m
        """

        results = graph.query(cypher_query, {"uid": uid, "fid": fid})

        memories = []
        for record in results:
            memory = record["m"]
            memories.append(memory)

        return memories

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching memories: {str(e)}"
        )

# Function to delete a memory


@router.delete("/private/memories/{mid}")
async def delete_memory(
        mid: str,
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        # Cypher query to delete a memory with the given ID using DETACH
        cypher_query = """
        MATCH (:User {uid:$uid})-[:HAS_MEMORY]->(m:Memory {mid: $mid})
        DETACH DELETE m
        """

        # Execute the query with memory ID
        graph.query(cypher_query, {"uid": uid, "mid": mid})

        return {"message": "Memory successfully deleted."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting memory: {str(e)}")

# Function to update a memory


@router.put("/private/memories/{mid}")
async def update_memory(
        mid: str,
        memory_data: dict,
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        # Fetch existing memory data
        cypher_query = f"""
        MATCH (:User {{uid: $uid}})-[:HAS_MEMORY]->(m:Memory {{mid: $mid}})
        RETURN m
        """
        result = graph.query(cypher_query, {"uid": uid, "mid": mid})
        existing_memory = result[0]

        # Check if memory exists
        if not existing_memory:
            raise HTTPException(status_code=404, detail="Memory not found.")

        # Merge existing and update data
        merged_data = {**existing_memory["m"], **memory_data}

        # Build Cypher query with identifier and SET clause
        cypher_query = f"""
        MATCH (m:Memory {{mid: $mid}})
        SET """

        set_clauses = [f"m.{field} = $memory_{
            field}" for field in merged_data if field != "mid"]

        if not set_clauses:
            raise HTTPException(
                status_code=400, detail="No valid update fields provided.")

        cypher_query += ", ".join(set_clauses)
        cypher_query += """
        RETURN m
        """

        # Prepare data with memory ID and merged update values
        data = {"mid": mid}
        for field, value in merged_data.items():
            if field != "mid":
                data[f"memory_{field}"] = value

        # Execute the query with identifier and data
        result = graph.query(cypher_query, data)
        updated_memory = result[0]["m"]

        return updated_memory
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error updating memory: {str(e)}"
        )
    return

# Function to fetch a single memory by MID


@router.get("/private/memories/{mid}")
async def get_memory(
        mid: str,
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        # Build Cypher query with identifier
        cypher_query = f"""
        MATCH (:User {{uid: $uid}})-[:HAS_MEMORY]->(m:Memory {{mid: $mid}})
        RETURN m
        """

        # Handle memory not found case
        try:
            # Execute the query with identifier
            result = graph.query(cypher_query, {"uid": uid, "mid": mid})
            memory = result[0]

            # Return the memory data
            return memory["m"]

        except Exception as e:
            raise HTTPException(status_code=404, detail="Memory not found.")

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching memory: {str(e)}"
        )
