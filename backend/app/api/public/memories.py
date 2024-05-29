import uuid
from database.neo4j import graph
from fastapi import HTTPException, Body, APIRouter
from app.models import Memory
from app.api.api_helper import get_neo4j_datetime

router = APIRouter()

# Function to create a new memory


@router.post("/public/memories")
async def create_memory(memory: Memory = Body(...)):
    try:
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
                neo4j_timestamp = get_neo4j_datetime()

                # Cypher query to create a new memory node with generated ID
                cypher_query = """
                CREATE (m:Memory {
                    mid: $mid,
                    content: $content,
                    timestamp: $timestamp
                })
                RETURN m
                """
                # Execute the query with memory data (including timestamp)
                result = graph.query(
                    cypher_query, {
                        "mid": new_mid, "timestamp": neo4j_timestamp, **memory.model_dump()}
                )
                # Assuming a single memory is created
                created_memory = result[0]["m"]
                return created_memory  # Return the created memory here
            else:
                # Handle duplicate memory ID case (optional)
                raise HTTPException(
                    status_code=409, detail="Memory ID already exists"
                )

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating memory: {str(e)}"
        )

# The final "return" statement is removed since we already return inside the loop


# Function to delete a memory


@router.delete("/public/memories/{mid}")
async def delete_memory(mid: str):
    try:
        # Cypher query to delete a memory with the given ID using DETACH
        cypher_query = """
        MATCH (m:Memory {mid: $mid})
        DETACH DELETE m
        """

        # Execute the query with memory ID
        graph.query(cypher_query, {"mid": mid})

        return {"message": "Memory deleted successfully"}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting memory: {str(e)}")

# Function to update a memory


@router.put("/public/memories/{mid}")
async def update_memory(mid: str, memory_data: dict):
    try:
        # Fetch existing memory data
        cypher_query = f"""
        MATCH (m:Memory {{mid: $mid}})
        RETURN m
        """
        result = graph.query(cypher_query, {"mid": mid})
        existing_memory = result[0]

        # Check if memory exists
        if not existing_memory:
            raise HTTPException(status_code=404, detail="Memory not found")

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
                status_code=400, detail="No valid update fields provided")

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

# Function to fetch all memories


@router.get("/public/memories")
async def get_memories():
    cypher_query = """
    MATCH (m:Memory)
    RETURN m
    """
    results = graph.query(cypher_query)
    memories = []
    for record in results:
        memory = record["m"]
        memories.append(memory)
    return memories

# Function to fetch a single memory by MID


@router.get("/public/memories/{mid}")
async def get_memory(mid: str):
    try:
        # Build Cypher query with identifier
        cypher_query = f"""
        MATCH (m:Memory {{mid: $mid}})
        RETURN m
        """

        # Execute the query with identifier
        result = graph.query(cypher_query, {"mid": mid})
        memory = result[0]

        # Handle memory not found case
        if not memory:
            raise HTTPException(status_code=404, detail="Memory not found")

        # Return the memory data
        return memory["m"]

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching memory: {str(e)}"
        )
