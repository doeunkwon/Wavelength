from neo4j import GraphDatabase
from config import AUTH
from fastapi import HTTPException
from dotenv import load_dotenv
from backend_helper import get_env_variable

load_dotenv()

uri = get_env_variable("URI")


def get_driver():
    driver = GraphDatabase.driver(uri, auth=AUTH)
    try:
        driver.verify_connectivity()
        return driver
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error connecting to Neo4j: {str(e)}")
