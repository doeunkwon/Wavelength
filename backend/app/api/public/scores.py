import uuid
from fastapi import HTTPException, APIRouter
from database.neo4j import graph

router = APIRouter()


@router.delete("/public/scores/{sid}")
async def delete_score(sid: str):
    try:
        # Cypher query to delete a score with the given ID using DETACH
        cypher_query = """
        MATCH (s:Score {sid: $sid})
        DETACH DELETE s
        """

        # Execute the query with score ID
        graph.query(cypher_query, {"sid": sid})

        return {"message": "Score successfully deleted."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting score: {str(e)}")
