import uuid
from fastapi import Depends, HTTPException, Body, APIRouter
from app.models import Friend
from app.api.helpers.auth import get_current_user
from database.neo4j import graph
from app.api.helpers.friends import delete_friend as delete_friend_helper, get_friend as get_friend_helper

router = APIRouter()


@router.post("/private/friends")
async def create_friend(
        friend: Friend = Body(...),
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

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
                    scorePercentage: $scorePercentage,
                    scoreAnalysis: $scoreAnalysis,
                    emoji: $emoji,
                    color: $color,
                    firstName: $firstName,
                    lastName: $lastName,
                    goals: $goals,
                    interests: $interests,
                    values: $values,
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

                try:

                    cypher_query = """
                    MATCH (user:User {uid: $uid}), (friend:Friend {fid: $fid})
                    CREATE (user)-[:FRIENDS_WITH]->(friend)
                    """
                    graph.query(cypher_query, {
                                "uid": uid, "fid": created_friend["fid"]})
                    return {"message": "Friendship successfully created."}

                except Exception as e:
                    raise HTTPException(
                        status_code=404, detail="Friend not found.")
            else:
                # Handle duplicate user ID case (optional)
                raise HTTPException(
                    status_code=409, detail="Friend ID already exists."
                )

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating friend: {str(e)}"
        )

# The final "return" statement is removed since we already return inside the loop <- (July 20, 2024: Again, what does "loop" mean?)


# Function to fetch all friend instances in DB
@router.get("/private/friends")
async def get_friends(token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        cypher_query = """
        MATCH (:User {uid: $uid})-[:FRIENDS_WITH]->(f:Friend)
        RETURN f
        """
        results = graph.query(cypher_query, {"uid": uid})
        friends = []
        for record in results:
            friend = record["f"]
            friends.append(friend)
        return friends
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching friends: {str(e)}"
        )


# Function to fetch a single friend by FID


@router.get("/private/friends/{fid}")
async def get_friend(
        fid: str,
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]
        return get_friend_helper(uid, fid)

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching friend: {str(e)}"
        )

# Function to delete a friend


@router.delete("/private/friends/{fid}")
async def delete_friend(
        fid: str,
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        return delete_friend_helper(uid, fid)
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting friend: {str(e)}"
        )

# Function to update a friend


@router.put("/private/friends/{fid}")
async def update_friend(
        fid: str,
        new_data: dict,
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        # Fetch existing friend data
        cypher_query = f"""
        MATCH (:User {{uid:$uid}})-[:FRIENDS_WITH]->(f:Friend {{fid: $fid}})
        RETURN f
        """
        result = graph.query(cypher_query, {"uid": uid, "fid": fid})
        existing_friend = result[0]

        # Check if friend exists
        if not existing_friend:
            raise HTTPException(status_code=404, detail="Friend not found.")

        merged_data = {**existing_friend["f"], **new_data}

        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        SET """

        set_clauses = [f"f.{field} = $friend_{
            field}" for field in merged_data if field != "fid"]

        if not set_clauses:
            raise HTTPException(
                status_code=400, detail="No valid update fields provided.")

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
