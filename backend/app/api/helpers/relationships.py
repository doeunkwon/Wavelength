from fastapi import HTTPException
from database.neo4j import graph

#
# ________________________________________________________________________________________________________________________________________________________
# ________________________________________________________________________________________________________________________________________________________
#
# Relationship endpoints related to MEMORY


def get_memory_relationships(uid: str, fid: str):
    cypher_query = """
    MATCH (:User {uid: $uid})-[:HAS_MEMORY]->(m:Memory)-[:ABOUT]->(:Friend {fid: $fid})
    RETURN m.content AS content
    """
    result = graph.query(cypher_query, {"uid": uid, "fid": fid})
    memories = [memory['content'] for memory in result]
    return memories

#
# ________________________________________________________________________________________________________________________________________________________
# ________________________________________________________________________________________________________________________________________________________
#
# Relationship endpoints related to VALUE


def get_value_relationships(general_id: str, model: str):
    cypher_query = f"""
    MATCH (:{model} {{{'uid' if model == 'User' else 'fid'}: $general_id}})-[h:HAS_VALUE]->(v:Value)
    RETURN v.title AS title, h.percentage AS percentage
    """
    result = graph.query(cypher_query, {"general_id": general_id})
    value_pairs = [{value['title']: value['percentage']}
                   for value in result]
    return value_pairs


def update_value_relationship(general_id: str, model: str, vid: str, percentage: int):
    cypher_query = f"""
    MATCH (:{model} {{{'uid' if model == 'User' else 'fid'}: $general_id}})-[h:HAS_VALUE]->(:Value {{vid: $vid}})
    SET h.percentage = $percentage
    """

    graph.query(cypher_query, {
                "general_id": general_id, "vid": vid, "percentage": percentage})

    return {"message": "Value successfully updated."}

#
# ________________________________________________________________________________________________________________________________________________________
# ________________________________________________________________________________________________________________________________________________________
#
# Relationship endpoints related to SCORE


def create_score_relationships(general_id: str, sid: str, model: str):
    # Handle score not found case
    try:
        cypher_query = """
        MATCH (s:Score {sid: $sid})
        RETURN s
        """

        result = graph.query(cypher_query, {"sid": sid})
        score = result[0]
        cypher_query = f"""
        MATCH (user:{model} {{{'uid' if model == 'User' else 'fid'}: $general_id}}), (score:Score {{sid: $sid}})
        CREATE (user)-[has:HAS_SCORE]->(score)
        """
        graph.query(cypher_query, {"general_id": general_id, "sid": sid})
        return {"message": "Score relationship successfully created."}
    except Exception as e:
        raise HTTPException(status_code=404, detail="Score not found.")
