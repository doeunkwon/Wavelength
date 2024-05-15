import uuid
from database import get_driver
from fastapi import HTTPException, Body, APIRouter
from app.models import User

router = APIRouter()

# Function to create a new user


@router.post("/users")
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
                    # Cypher query to create a new user node with generated ID
                    cypher_query = """
                    CREATE (u:User {
                    uid: $uid,
                    firstName: $firstName,
                    lastName: $lastName,
                    birthday: $birthday,
                    username: $username,
                    email: $email,
                    password: $password,
                    location: $location,
                    interests: $interests,
                    emoji: $emoji,
                    color: $color,
                    qrCode: $qrCode
                    })
                    RETURN u
                    """
                    # Execute the query with user data (including generated ID)
                    result = session.run(
                        cypher_query, {"uid": new_uid, **user.model_dump()})
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
@router.get("/users")
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
            users.append(User(
                firstName=user["firstName"],
                lastName=user["lastName"],
                birthday=user["birthday"],
                username=user["username"],
                email=user["email"],
                password=user["password"],
                location=user["location"],
                interests=user["interests"],
                emoji=user["emoji"],
                color=user["color"],
                qrCode=user["qrCode"]
            ))
    driver.close()
    return users

# Function to delete a user


@router.delete("/users/{uid}")
async def delete_user(uid: str):
    try:
        driver = get_driver()
        with driver.session() as session:
            # Build Cypher query with identifier
            cypher_query = f"""
            MATCH (u:User {{uid: $uid}})
            DETACH DELETE u
            RETURN COUNT(u) AS usersDeleted
            """

            # Execute the query with identifier
            result = session.run(cypher_query, {"uid": uid})
            users_deleted = result.single()["usersDeleted"]

            # Handle deletion result
            if users_deleted == 0:
                raise HTTPException(status_code=404, detail="User not found")

            driver.close()
            return {"message": f"Successfully deleted {users_deleted} user(s) and their relationships."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting user: {str(e)}")
