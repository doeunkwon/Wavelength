from typing import Type
from app.models import Friend, User
from database.neo4j import graph
from fastapi import HTTPException


def get_value_relationships(general_id: str, model: str):
    try:

        cypher_query = f"""
        MATCH (:{model} {{{'uid' if model == 'User' else 'fid'}: $general_id}})-[h:HAS_VALUE]->(v:Value)
        RETURN v.title AS title, h.percentage AS percentage
        """
        result = graph.query(cypher_query, {"general_id": general_id})
        value_pairs = [{value['title']: value['percentage']}
                       for value in result]
        return value_pairs
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching relationships: {str(e)}"
        )


def update_value_relationship(general_id: str, model: str, vid: str, percentage: int):
    try:

        # # Fetch existing value data
        # cypher_query = f"""
        # MATCH (v:Value {{vid: $vid}})
        # RETURN v
        # """
        # result = graph.query(cypher_query, {"vid": vid})
        # existing_value = result[0]

        # # Check if value exists
        # if not existing_value:
        #     raise HTTPException(status_code=404, detail="Value not found.")

        cypher_query = f"""
        MATCH (:{model} {{{'uid' if model == 'User' else 'fid'}: $general_id}})-[h:HAS_VALUE]->(:Value {{vid: $vid}})
        SET h.percentage = $percentage
        """

        graph.query(cypher_query, {
                    "general_id": general_id, "vid": vid, "percentage": percentage})

        return {"message": "Value successfully updated."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error updating user: {str(e)}"
        )
    return
