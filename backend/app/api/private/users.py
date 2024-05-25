from database import get_driver
from fastapi import Depends, HTTPException, APIRouter
# Assuming this function verifies the token
from app.api.private.auth import get_current_user

router = APIRouter()


# Function to fetch a single user by UID


@router.get("/private/users")
async def get_user(token: str = Depends(get_current_user)):
    uid = token["uid"]
    try:
        driver = get_driver()
        with driver.session() as session:
            # Build Cypher query with identifier
            cypher_query = f"""
            MATCH (u:User {{uid: $uid}})
            RETURN u
            """

            # Execute the query with identifier
            result = session.run(cypher_query, {"uid": uid})
            user = result.single()

            # Handle user not found case
            if not user:
                raise HTTPException(status_code=404, detail="User not found")

            # Return the user data
            return user["u"]

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching user: {str(e)}"
        )

# Function to delete a user


@router.delete("/private/users")
async def delete_user(token: str = Depends(get_current_user)):
    uid = token["uid"]
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
            status_code=500, detail=f"Error deleting user: {str(e)}"
        )

# Function to update a user


@router.put("/private/users")
async def update_user(token: str = Depends(get_current_user), new_data: dict = {}):
    uid = token["uid"]
    try:
        driver = get_driver()
        with driver.session() as session:
            # Fetch existing user data
            cypher_query = f"""
            MATCH (u:User {{uid: $uid}})
            RETURN u
            """
            result = session.run(cypher_query, {"uid": uid})
            existing_user = result.single()

            # Check if user exists
            if not existing_user:
                raise HTTPException(status_code=404, detail="User not found")

            merged_data = {**existing_user["u"], **new_data}

            cypher_query = f"""
            MATCH (u:User {{uid: $uid}})
            SET """

            set_clauses = [f"u.{field} = $user_{
                field}" for field in merged_data if field != "uid"]

            if not set_clauses:
                raise HTTPException(
                    status_code=400, detail="No valid update fields provided")

            cypher_query += ", ".join(set_clauses)
            cypher_query += """
            RETURN u
            """

            data = {"uid": uid}
            for field, value in merged_data.items():
                if field != "uid":
                    data[f"user_{field}"] = value

            result = session.run(cypher_query, data)
            updated_user = result.single()

            driver.close()
            return updated_user["u"]

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error updating user: {str(e)}"
        )
