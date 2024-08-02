import uuid
from app.api.helpers.general import test_print
from database.neo4j import graph
from fastapi import HTTPException, Body, APIRouter
from app.models import Value

router = APIRouter()

# Function to create a new value


@router.post("/public/values")
async def create_value(value: Value = Body(...)):
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
                    title: $title,
                    percentage: $percentage
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


@router.delete("/public/values/{vid}")
async def delete_value(vid: str):
    try:
        # Cypher query to delete a value with the given ID using DETACH
        cypher_query = """
        MATCH (v:Value {vid: $vid})
        DETACH DELETE v
        """

        # Execute the query with value ID
        graph.query(cypher_query, {"vid": vid})

        return {"message": "Value successfully deleted."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting value: {str(e)}")


@router.patch("/public/values/{vid}/{new_percentage}")
async def update_value(vid: str, new_percentage: int):
    try:
        # Fetch existing user data
        cypher_query = f"""
        MATCH (v:Value {{vid: $vid}})
        RETURN v
        """
        result = graph.query(cypher_query, {"vid": vid})
        existing_value = result[0]

        # Check if user exists
        if not existing_value:
            raise HTTPException(status_code=404, detail="Value not found.")

        cypher_query = f"""
        MATCH (v:Value {{vid: $vid}})
        SET v.percentage = $percentage
        RETURN v
        """

        result = graph.query(
            cypher_query, {"vid": vid, "percentage": new_percentage})

        updated_user = result[0]
        return updated_user["v"]
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error updating user: {str(e)}"
        )
    return
