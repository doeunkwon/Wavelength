from fastapi import HTTPException, APIRouter
from database.neo4j import graph

router = APIRouter()


@router.delete("/public/breakdown/{bid}")
async def delete_breakdown(bid: str):
    try:
        # Cypher query to delete a score with the given ID using DETACH
        cypher_query = """
        MATCH (b:Breakdown {bid: $bid})
        DETACH DELETE b
        """

        # Execute the query with score ID
        graph.query(cypher_query, {"bid": bid})

        return {"message": "Breakdown successfully deleted."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting breakdown: {str(e)}")
