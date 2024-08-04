from app.models import Friend
from database.neo4j import graph
from fastapi import HTTPException
from typing import Optional


def get_friend(uid: str, fid: str) -> Optional[Friend]:

    cypher_query = """
    MATCH (:User {uid: $uid})-[:FRIENDS_WITH]->(f:Friend {fid: $fid})
    RETURN f
    """

    result = graph.query(cypher_query, {"uid": uid, "fid": fid})
    friend = result[0]

    # Handle friend not found case
    if not friend:
        raise HTTPException(status_code=404, detail="Friend not found.")

    # Return the friend data
    return friend["f"]


def delete_friend(uid: str, fid: str):
    # Build Cypher query with identifier and both relationship matches
    cypher_query = f"""
    MATCH (:User {{uid: $uid}})-[:FRIENDS_WITH]->(f:Friend {{fid: $fid}})
    OPTIONAL MATCH (m:Memory)-[:ABOUT]->(f)
    OPTIONAL MATCH (f)-[:HAS_SCORE]->(s:Score)
    OPTIONAL MATCH (f)-[:HAS_VALUE]->(v:Value)
    DETACH DELETE s, v, m, f
    """

    # Execute the query with identifier
    graph.query(cypher_query, {"uid": uid, "fid": fid})

    return {"message": "Friend and associated relationships successfully deleted."}
