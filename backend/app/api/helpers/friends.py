from app.models import Friend
from app.api.helpers.general import test_print
from database.neo4j import graph
from fastapi import HTTPException
from typing import Optional


def get_friend(uid: str, fid: str) -> Optional[Friend]:

    cypher_query = """
    MATCH (:User {uid: $uid})-[:FRIENDS_WITH]->(f:Friend {fid: $fid})
    RETURN f
    """

    # Handle friend not found case
    try:
        result = graph.query(cypher_query, {"uid": uid, "fid": fid})
        friend = result[0]

        # Return the friend data
        return friend["f"]

    except Exception as e:
        raise HTTPException(status_code=404, detail="Friend not found.")


def delete_friend(uid: str, fid: str):

    # Handle friend not found case

    try:
        cypher_query = """
        MATCH (:User {uid: $uid})-[:FRIENDS_WITH]->(f:Friend {fid: $fid})
        RETURN f
        """

        result = graph.query(cypher_query, {"uid": uid, "fid": fid})
        friend = result[0]

        cypher_query = f"""
        MATCH (:User {{uid: $uid}})-[:FRIENDS_WITH]->(f:Friend {{fid: $fid}})
        OPTIONAL MATCH (m:Memory)-[:ABOUT]->(f)
        OPTIONAL MATCH (f)-[:HAS_SCORE]->(s:Score)
        OPTIONAL MATCH (f)-[:HAS_BREAKDOWN]->(b:Breakdown)
        DETACH DELETE s, b, m, f
        """

        # Execute the query with identifier
        graph.query(cypher_query, {"uid": uid, "fid": fid})

        return {"message": "Friend and associated relationships successfully deleted."}

    except Exception as e:
        raise HTTPException(status_code=404, detail="Friend not found.")
