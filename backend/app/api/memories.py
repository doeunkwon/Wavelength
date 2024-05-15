from database import get_driver
from fastapi import HTTPException, Body, APIRouter
from app.models import Memory

router = APIRouter()

# Function to create a new memory


@router.post("/memories")
async def create_memory(memory: Memory = Body(...)):
    try:
        driver = get_driver()
        with driver.session() as session:
            # Cypher query to create a new memory node
            cypher_query = """
            CREATE (m:Memory {
                mid: $mid,
                content: $content,
                timestamp: $timestamp
            })
            RETURN m
            """

            # Execute the query with memory data
            result = session.run(cypher_query, memory.dict())
            # Assuming a single memory is created
            created_memory = result.single()["m"]

            # Close the driver connection
            driver.close()
            return created_memory
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating memory: {str(e)}")

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
