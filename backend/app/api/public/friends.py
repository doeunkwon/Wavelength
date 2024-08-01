import uuid
from fastapi import HTTPException, Body, APIRouter
from app.models import Friend
from database.neo4j import graph

'''
Public (no log-in required) operations on Friend model.
'''

router = APIRouter()


@router.post("/public/friends")
async def create_friend(friend: Friend = Body(...)):
    try:
        while True:
            # Generate a new UUID for the friend ID
            new_fid = str(uuid.uuid4())

            # Check if the friend ID already exists
            check_query = """
            MATCH (f:Friend {fid: $fid})
            RETURN f
            """
            result = graph.query(check_query, {"fid": new_fid})

            # If no friend found with the generated ID, proceed with creation
            if len(result) == 0:

                # Cypher query to create a new friend node with generated ID
                cypher_query = """
                CREATE (f:Friend {
                    fid: $fid,
                    emoji: $emoji,
                    color: $color,
                    firstName: $firstName,
                    lastName: $lastName,
                    goals: $goals,
                    interests: $interests,
                    tokenCount: $tokenCount,
                    memoryCount: $memoryCount
                })
                RETURN f
                """
                # Execute the query with friend data
                result = graph.query(
                    cypher_query, {
                        "fid": new_fid,
                        **friend.model_dump()
                    }
                )
                # Assuming a single friend is created (remove the loop) <- (July 20, 2024: what does "remove the loop" mean?)
                created_friend = result[0]["f"]
                return created_friend  # Return the created user here
            else:
                # Handle duplicate user ID case (optional)
                raise HTTPException(
                    status_code=409, detail="Friend ID already exists"
                )

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating friend: {str(e)}"
        )

# The final "return" statement is removed since we already return inside the loop <- (July 20, 2024: Again, what does "loop" mean?)


# Function to fetch all friend instances in DB
@router.get("/public/friends")
async def get_friends():
    cypher_query = """
    MATCH (f:Friend)
    RETURN f
    """
    results = graph.query(cypher_query)
    friends = []
    for record in results:
        friend = record["f"]
        friends.append(friend)
    return friends

# Function to fetch a single friend by FID


@router.get("/public/friends/{fid}")
async def get_friend(fid: str):
    try:
        # Build Cypher query with identifier
        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        RETURN f
        """

        # Execute the query with identifier
        result = graph.query(cypher_query, {"fid": fid})
        friend = result[0]

        # Handle friend not found case
        if not friend:
            raise HTTPException(status_code=404, detail="Friend not found")

        # Return the friend data
        return friend["f"]

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching friend: {str(e)}"
        )

# Function to delete a friend


@router.delete("/public/friends/{fid}")
async def delete_friend(fid: str):
    try:
        # Build Cypher query with identifier and both relationship matches
        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        OPTIONAL MATCH (m:Memory)-[:ABOUT]->(f)
        OPTIONAL MATCH (f)-[:HAS_SCORE]->(s:Score)
        OPTIONAL MATCH (f)-[:HAS_VALUE]->(v:Value)
        WITH f, count(m)
        DETACH DELETE f, m, s, v
        RETURN f IS NOT NULL AS friendExists, memoriesDeleted
        """

        # Execute the query with identifier
        result = graph.query(cypher_query, {"fid": fid})
        friend_exists = result[0]["friendExists"]
        memories_deleted = result[0]["memoriesDeleted"]

        # Handle deletion result
        if friend_exists:
            raise HTTPException(status_code=404, detail="Friend not found")

        message = f"Successfully deleted friend and {
            memories_deleted} associated relationships."

        return {"message": message}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting friend: {str(e)}"
        )

# Function to update a friend


@router.put("/public/friends/{fid}")
async def update_friend(fid: str, new_data: dict):
    try:
        # Fetch existing friend data
        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        RETURN f
        """
        result = graph.query(cypher_query, {"fid": fid})
        existing_friend = result[0]

        # Check if friend exists
        if not existing_friend:
            raise HTTPException(status_code=404, detail="Friend not found")

        merged_data = {**existing_friend["f"], **new_data}

        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        SET """

        set_clauses = [f"f.{field} = $friend_{
            field}" for field in merged_data if field != "fid"]

        if not set_clauses:
            raise HTTPException(
                status_code=400, detail="No valid update fields provided")

        cypher_query += ", ".join(set_clauses)
        cypher_query += """
        RETURN f
        """

        data = {"fid": fid}
        for field, value in merged_data.items():
            if field != "fid":
                data[f"friend_{field}"] = value

        result = graph.query(cypher_query, data)
        updated_friend = result[0]

        return updated_friend["f"]
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error updating friend: {str(e)}"
        )
