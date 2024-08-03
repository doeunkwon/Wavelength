from typing import Type
from app.models import Friend, User
from database.neo4j import graph
from fastapi import HTTPException


def get_value_relationship(general_id: str, model: str):
    try:

        cypher_query = f"""
        MATCH (:{model} {{{'uid' if model == 'User' else 'fid'}: $general_id}})-[has:HAS_VALUE]->(v:Value)
        RETURN v.title AS title, v.percentage AS percentage
        """
        result = graph.query(cypher_query, {"general_id": general_id})
        value_pairs = [{value['title']: value['percentage']}
                       for value in result]
        return value_pairs
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching relationships: {str(e)}"
        )
