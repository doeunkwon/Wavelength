from app.models import User
from database.neo4j import graph
from fastapi import HTTPException
from typing import Optional


def get_user(uid: str) -> Optional[User]:
    # Build Cypher query with identifier
    cypher_query = f"""
    MATCH (u:User {{uid: $uid}})
    RETURN u
    """

    # Handle user not found case
    try:
        # Execute the query with identifier
        result = graph.query(cypher_query, {"uid": uid})
        user = result[0]

        # Return the user data
        return user["u"]

    except Exception as e:
        raise HTTPException(status_code=404, detail="User not found.")


def update_user(uid: str, new_data: dict):
    # Fetch existing user data
    cypher_query = f"""
    MATCH (u:User {{uid: $uid}})
    RETURN u
    """
    result = graph.query(cypher_query, {"uid": uid})
    existing_user = result[0]

    # Check if user exists
    if not existing_user:
        raise HTTPException(status_code=404, detail="User not found.")

    merged_data = {**existing_user["u"], **new_data}

    cypher_query = f"""
    MATCH (u:User {{uid: $uid}})
    SET """

    set_clauses = [f"u.{field} = $user_{
        field}" for field in merged_data if field != "uid"]

    if not set_clauses:
        raise HTTPException(
            status_code=400, detail="No valid update fields provided.")

    cypher_query += ", ".join(set_clauses)
    cypher_query += """
        RETURN u
        """

    data = {"uid": uid}
    for field, value in merged_data.items():
        if field != "uid":
            data[f"user_{field}"] = value

    result = graph.query(cypher_query, data)
    updated_user = result[0]

    return updated_user["u"]


def delete_user(uid: str):
    # Build Cypher query with identifier and both relationship matches
    cypher_query = f"""
    MATCH (u:User {{uid: $uid}})
    OPTIONAL MATCH (u)-[:HAS_MEMORY]->(m:Memory)
    OPTIONAL MATCH (u)-[:FRIENDS_WITH]->(f:Friend)
    OPTIONAL MATCH (u)-[:HAS_SCORE]->(s:Score)
    OPTIONAL MATCH (u)-[:HAS_VALUE]->(v:Value)
    DETACH DELETE u, m, f, s, v
    """

    # Execute the query with identifier
    graph.query(cypher_query, {"uid": uid})

    return {"message": "User successfully deleted."}
