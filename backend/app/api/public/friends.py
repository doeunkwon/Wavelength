import uuid
from fastapi import HTTPException, Body, APIRouter
from app.models import Friend
from app.api.helpers.friends import delete_friend as delete_friend_helper, update_friend as update_friend_helper, get_friend as get_friend_helper
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
                    birthday: $birthday,
                    passion: $passion,
                    goal: $goal,
                    discipline: $discipline,
                    honesty: $honesty,
                    positivity: $positivity,
                    growth: $growth,
                    interests: $interests
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


# Function to fetch all friends
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
    return get_friend_helper(fid)

# Function to delete a friend


@router.delete("/public/friends/{fid}")
async def delete_friend(fid: str):
    return delete_friend_helper(fid)

# Function to update a friend


@router.put("/public/friends/{fid}")
async def update_friend(fid: str, new_data: dict):
    return update_friend_helper(fid, new_data)
