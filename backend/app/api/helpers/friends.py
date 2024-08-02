from app.models import Friend
from database.neo4j import graph
from fastapi import HTTPException
from typing import Optional


def get_friend(fid: str) -> Optional[Friend]:
    try:
        # Build Cypher query with identifier
        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        RETURN f
        """

        # Execute the query with identifier
        result = graph.query(cypher_query, {"fid": fid})
        friend = result[0]

        # Handle friend not found case
        if not friend:
            raise HTTPException(status_code=404, detail="Friend not found.")

        # Return the friend data
        return friend["f"]

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching friend: {str(e)}"
        )


def delete_friend(fid: str):
    try:
        # Build Cypher query with identifier and both relationship matches
        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        OPTIONAL MATCH (m:Memory)-[:ABOUT]->(f)
        OPTIONAL MATCH (f)-[:HAS_SCORE]->(s:Score)
        OPTIONAL MATCH (f)-[:HAS_VALUE]->(v:Value)
        DETACH DELETE s, v, m, f
        """

        # Execute the query with identifier
        result = graph.query(cypher_query, {"fid": fid})

        message = f"Friend and associated relationships successfully deleted."

        return {"message": message}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting friend: {str(e)}"
        )
