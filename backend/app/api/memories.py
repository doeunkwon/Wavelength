import uuid
from database import get_driver
from fastapi import HTTPException, Body, APIRouter
from app.models import Memory
from app.api.helper import get_neo4j_datetime

router = APIRouter()

# Function to create a new memory


@router.post("/memories")
async def create_memory(memory: Memory = Body(...)):
    try:
        driver = get_driver()
        with driver.session() as session:
            while True:
                # Generate a new UUID for the memory ID
                new_mid = str(uuid.uuid4())

                # Check if the memory ID already exists
                check_query = """
                MATCH (m:Memory {mid: $mid})
                RETURN m
                """
                result = session.run(check_query, mid=new_mid)

                # If no memory found with the generated ID, proceed with creation
                if not result.single():
                    neo4j_timestamp = get_neo4j_datetime()
                    # Cypher query to create a new memory node with generated ID
                    cypher_query = """
                    CREATE (m:Memory {
                        mid: $mid,
                        content: $content,
                        timestamp: $timestamp
                    })
                    RETURN m
                    """
                    # Execute the query with memory data (including generated ID)
                    result = session.run(
                        cypher_query, {"mid": new_mid, "timestamp": neo4j_timestamp, **memory.model_dump()})
                    # Assuming a single memory is created
                    created_memory = result.single()["m"]
                    break  # Exit the loop after successful creation

            # Close the driver connection
            driver.close()
            return created_memory
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating memory: {str(e)}"
        )


# Function to delete a memory


@router.delete("/memories/{mid}")
async def delete_memory(mid: str):
    try:
        driver = get_driver()
        with driver.session() as session:
            # Cypher query to delete a memory with the given ID using DETACH
            cypher_query = """
            MATCH (m:Memory {mid: $mid})
            DETACH DELETE m
            """

            # Execute the query with memory ID
            session.run(cypher_query, {"mid": mid})

            # Close the driver connection
            driver.close()
            return {"message": "Memory deleted successfully"}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting memory: {str(e)}")
