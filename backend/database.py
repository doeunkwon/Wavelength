from neo4j import GraphDatabase
from config import URI, AUTH
from fastapi import HTTPException


def get_driver():
    driver = GraphDatabase.driver(URI, auth=AUTH)
    try:
        driver.verify_connectivity()
        return driver
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error connecting to Neo4j: {str(e)}")
