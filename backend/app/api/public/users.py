import uuid
from fastapi import HTTPException, Body, APIRouter
from app.models import User
from app.api.helpers.auth import hash_password
from app.api.helpers.users import delete_user as delete_user_helper, update_user as update_user_helper, get_user as get_user_helper
from database.neo4j import graph
from fastapi.exceptions import HTTPException as FastAPIHTTPException
import logging

'''
Master endpoints.
These endpoints can do pretty much everything.
Should mainly be restricted to admin use.
'''

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
                    emoji: $emoji,
                    color: $color,
                    firstName: $firstName,
                    lastName: $lastName,
                    username: $username,
                    email: $email,
                    password: $hashed_password,
                    goals: $goals,
                    values: $values,
                    interests: $interests,
                    scorePercentage: $scorePercentage,
                    tokenCount: $tokenCount,
                    memoryCount: $memoryCount
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
                # Return the created user's uid
                return {"uid": created_user["uid"]}
            else:
                # Handle duplicate user ID case (optional)
                raise HTTPException(
                    status_code=409, detail="User ID already exists."
                )

    except FastAPIHTTPException as e:
        # Re-raise any HTTPExceptions (400, etc.)
        logging.error(str(e))
        raise e

    except Exception as e:
        # Handle other exceptions with a 500 error
        logging.error(str(e), exc_info=True)
        raise HTTPException(
            status_code=500, detail=f"Error fetching user: {str(e)}"
        )
