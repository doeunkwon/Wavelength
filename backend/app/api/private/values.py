import uuid
from app.api.helpers.general import test_print
from app.api.helpers.auth import get_current_user
from database.neo4j import graph
from fastapi import Depends, HTTPException, Body, APIRouter
from app.models import Value

router = APIRouter()

# Function to create a new value


@router.post("/private/values")
async def create_value(
        value: Value = Body(...),
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        while True:
            # Generate a new UUID for the value ID
            new_vid = str(uuid.uuid4())

            # Check if the value ID already exists
            check_query = """
            MATCH (v:Value {vid: $vid})
            RETURN v
            """
            result = graph.query(check_query, {"vid": new_vid})

            # If no value found with the generated ID, proceed with creation
            if len(result) == 0:

                # Cypher query to create a new value node with generated ID
                cypher_query = """
                CREATE (v:Value {
                    vid: $vid,
                    title: $title
                })
                RETURN v
                """
                # Execute the query with value data (including timestamp)
                result = graph.query(
                    cypher_query, {
                        "vid": new_vid, **value.model_dump()}
                )
                # Assuming a single value is created
                created_value = result[0]["v"]
                return created_value  # Return the created value here
            else:
                # Handle duplicate value ID case (optional)
                raise HTTPException(
                    status_code=409, detail="Value ID already exists."
                )

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating value: {str(e)}"
        )

# The final "return" statement is removed since we already return inside the loop


# Function to delete a value


@router.delete("/private/values/{vid}")
async def delete_value(
        vid: str,
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        # Handle value not found case
        try:
            cypher_query = """
            MATCH (:User {uid: $uid})-[:HAS_VALUE]->(v:Value {vid: $vid})
            RETURN v
            """

            result = graph.query(cypher_query, {"uid": uid, "vid": vid})
            value = result[0]

            # Cypher query to delete a value with the given ID using DETACH
            cypher_query = """
            MATCH (:User {uid: $uid})-[:HAS_VALUE]->(v:Value {vid: $vid})
            DETACH DELETE v
            """

            # Execute the query with value ID
            graph.query(cypher_query, {"uid": uid, "vid": vid})

            return {"message": "Value successfully deleted."}

        except Exception as e:
            raise HTTPException(status_code=404, detail="Value not found.")
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting value: {str(e)}")
