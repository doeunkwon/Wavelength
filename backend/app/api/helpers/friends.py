from database.neo4j import graph
from fastapi import HTTPException


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
