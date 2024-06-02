import uuid
from fastapi import HTTPException, Body, APIRouter
from app.models import User
from app.api.private.auth import hash_password
from app.api.helpers.functions import delete_user as delete_user_helper, update_user as update_user_helper, get_user as get_user_helper
from database.neo4j import graph

router = APIRouter()


@router.post("/public/users")
async def create_user(user: User = Body(...)):
    try:
        while True:
            # Generate a new UUID for the user ID
            new_uid = str(uuid.uuid4())

            # Check if the user ID already exists
            check_query = """
            MATCH (u:User {uid: $uid})
            RETURN u
            """
            result = graph.query(check_query, {"uid": new_uid})

            # If no user found with the generated ID, proceed with creation
            if len(result) == 0:
                # Hash the password before storing
                hashed_password = hash_password(user.password)

                # Cypher query to create a new user node with generated ID
                cypher_query = """
                CREATE (u:User {
                    uid: $uid,
                    firstName: $firstName,
                    lastName: $lastName,
                    birthday: $birthday,
                    username: $username,
                    email: $email,
                    password: $hashed_password,
                    location: $location,
                    interests: $interests,
                    emoji: $emoji,
                    color: $color,
                    qrCode: $qrCode
                })
                RETURN u
                """
                # Execute the query with user data (including hashed password)
                result = graph.query(
                    cypher_query, {
                        "uid": new_uid,
                        "hashed_password": hashed_password,
                        **user.model_dump()
                    }
                )
                # Assuming a single user is created (remove the loop)
                created_user = result[0]["u"]
                return created_user  # Return the created user here
            else:
                # Handle duplicate user ID case (optional)
                raise HTTPException(
                    status_code=409, detail="User ID already exists"
                )

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating user: {str(e)}"
        )

# The final "return" statement is removed since we already return inside the loop


# Function to fetch all users
@router.get("/public/users")
async def get_users():
    cypher_query = """
    MATCH (u:User)
    RETURN u
    """
    results = graph.query(cypher_query)
    users = []
    for record in results:
        user = record["u"]
        users.append(user)
    return users

# Function to fetch a single user by UID


@router.get("/public/users/{uid}")
async def get_user(uid: str):
    return get_user_helper(uid)

# Function to delete a user


@router.delete("/public/users/{uid}")
async def delete_user(uid: str):
    return delete_user_helper(uid)

# Function to update a user


@router.put("/public/users/{uid}")
async def update_user(uid: str, new_data: dict):
    return update_user_helper(uid, new_data)
