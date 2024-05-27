import uuid
from database import get_driver
from fastapi import HTTPException, Body, APIRouter
from app.models import User
from app.api.private.auth import hash_password
from app.api.api_helper import delete_user as delete_user_helper, update_user as update_user_helper, get_user as get_user_helper

router = APIRouter()


# Function to create a new user
@router.post("/public/users")
async def create_user(user: User = Body(...)):
    try:
        driver = get_driver()
        with driver.session() as session:
            while True:
                # Generate a new UUID for the user ID
                new_uid = str(uuid.uuid4())

                # Check if the user ID already exists
                check_query = """
                MATCH (u:User {uid: $uid})
                RETURN u
                """
                result = session.run(check_query, uid=new_uid)

                # If no user found with the generated ID, proceed with creation
                if not result.single():
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
                    result = session.run(
                        cypher_query, {
                            "uid": new_uid, "hashed_password": hashed_password, **user.model_dump()}
                    )
                    # Assuming a single user is created
                    created_user = result.single()["u"]
                    break  # Exit the loop after successful creation

            # Close the driver connection
            driver.close()
            return created_user
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating user: {str(e)}"
        )


# Function to fetch all users
@router.get("/public/users")
async def get_users():
    driver = get_driver()
    with driver.session() as session:
        cypher_query = """
        MATCH (u:User)
        RETURN u
        """
        results = session.run(cypher_query)
        users = []
        for record in results:
            user = record["u"]
            users.append(user)
    driver.close()
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
