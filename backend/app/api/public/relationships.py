from fastapi import APIRouter, Depends, HTTPException, Body
# Assuming you have a function to get the Neo4j driver
from database import get_driver

router = APIRouter()


@router.post("/public/relationships/memory")
async def create_user_memory_relationship(
    relationship: dict,  # Capture data as a dictionary
):
    try:
        driver = get_driver()
        with driver.session() as session:
            uid1 = relationship["uid1"]  # Access data from the dictionary
            mid = relationship["mid"]
            uid2 = relationship["uid2"]

            cypher_query = """
            MATCH (user1:User {uid: $uid1}), (user2:User {uid: $uid2}), (memory:Memory {mid: $mid})
            CREATE (user1)-[has:HAS]->(memory)-[about:ABOUT]->(user2)
            RETURN user1, memory, user2
            """
            session.run(cypher_query, {"uid1": uid1, "mid": mid, "uid2": uid2})
            print(f"Cypher Query Executed: {cypher_query}")
        return {"message": "Relationship created successfully."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


@router.post("/public/relationships/friendship")
async def create_user_friendship_relationship(
    relationship: dict,  # Capture data as a dictionary
):
    try:
        driver = get_driver()
        with driver.session() as session:
            uid1 = relationship["uid1"]  # Access data from the dictionary
            uid2 = relationship["uid2"]

            cypher_query = """
            MATCH (user1:User {uid: $uid1}), (user2:User {uid: $uid2})
            CREATE (user1)-[:FRIENDS_WITH]->(user2)
            CREATE (user2)-[:FRIENDS_WITH]->(user1)
            RETURN user1, user2
            """
            session.run(cypher_query, {"uid1": uid1, "uid2": uid2})
            print(f"Cypher Query Executed: {cypher_query}")
        return {"message": "Relationship created successfully."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


@router.delete("/public/relationships/friendship")
async def create_user_friendship_relationship(
    relationship: dict,  # Capture data as a dictionary
):
    try:
        driver = get_driver()
        with driver.session() as session:
            uid1 = relationship["uid1"]  # Access data from the dictionary
            uid2 = relationship["uid2"]

            cypher_query = """
            MATCH (user1:User {uid: $uid1})-[r:FRIENDS_WITH]->(user2:User {uid: $uid2})
            DELETE r
            UNION
            MATCH (user2:User {uid: $uid2})-[r:FRIENDS_WITH]->(user1:User {uid: $uid1})
            DELETE r
            """
            session.run(cypher_query, {"uid1": uid1, "uid2": uid2})
            print(f"Cypher Query Executed: {cypher_query}")
        return {"message": "Relationship deleted successfully."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting relationship: {str(e)}"
        )
