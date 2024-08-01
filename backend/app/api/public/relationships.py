from fastapi import APIRouter, Depends, HTTPException, Body
# Assuming you have a function to get the Neo4j driver
from database.neo4j import graph
from typing import List, Union
from app.models import Score

router = APIRouter()

# Relationship endpoints related to MEMORY


@router.post("/public/relationships/memory")
async def create_memory_relationship(
    relationship: dict[str, str],  # Capture data as a dictionary
):
    try:
        uid = relationship["uid"]  # Access data from the dictionary
        mid = relationship["mid"]
        fid = relationship["fid"]

        cypher_query = """
        MATCH (user:User {uid: $uid}), (friend:Friend {fid: $fid}), (memory:Memory {mid: $mid})
        CREATE (user)-[has:HAS_MEMORY]->(memory)-[about:ABOUT]->(friend)
        """
        graph.query(cypher_query, {"uid": uid, "mid": mid, "fid": fid})
        return {"message": "Relationship successfully created."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


# Relationship endpoints related to Friendship

@router.post("/public/relationships/friendship")
async def create_friendship_relationship(
    # Capture data as a dictionary
    relationship: dict[str, str],
):
    try:
        uid = relationship["uid"]  # Access data from the dictionary
        fid = relationship["fid"]

        cypher_query = """
        MATCH (user:User {uid: $uid}), (friend:Friend {fid: $fid})
        CREATE (user)-[:FRIENDS_WITH]->(friend)
        """
        graph.query(cypher_query, {"uid": uid, "fid": fid})
        return {"message": "Friendship successfully created."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


@router.delete("/public/relationships/friendship")
async def delete_friendship_relationship(
    relationship: dict[str, str],  # Capture data as a dictionary
):
    try:
        uid = relationship["uid"]  # Access data from the dictionary
        fid = relationship["fid"]

        cypher_query = """
        MATCH (user:User {uid: $uid})-[r:FRIENDS_WITH]->(friend:Friend {fid: $fid})
        DETACH DELETE friend, r
        """
        graph.query(cypher_query, {"uid": uid, "fid": fid})
        return {"message": "Friendship and friend successfully deleted."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting relationship: {str(e)}"
        )


# Relationship endpoints related to SCORE

@router.post("/public/relationships/user_score")
async def create_user_score_relationship(
    relationship: dict[str, str],  # Capture data as a dictionary
):
    try:
        uid = relationship["uid"]  # Access data from the dictionary
        sid = relationship["sid"]

        cypher_query = """
        MATCH (user:User {uid: $uid}), (score:Score {sid: $sid})
        CREATE (user)-[has:HAS_SCORE]->(score)
        """
        graph.query(cypher_query, {"uid": uid, "sid": sid})
        return {"message": "Relationship successfully created."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


@router.post("/public/relationships/friend_score")
async def create_friend_score_relationship(
    relationship: dict[str, str],  # Capture data as a dictionary
):
    try:
        fid = relationship["fid"]  # Access data from the dictionary
        sid = relationship["sid"]

        cypher_query = """
        MATCH (friend:Friend {fid: $fid}), (score:Score {sid: $sid})
        CREATE (friend)-[has:HAS_SCORE]->(score)
        """
        graph.query(cypher_query, {"fid": fid, "sid": sid})
        return {"message": "Relationship successfully created."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )

# Relationship endpoints related to VALUE


@router.post("/public/relationships/user_value")
async def create_user_value_relationship(
    relationship: dict[str, str],  # Capture data as a dictionary
):
    try:
        uid = relationship["uid"]  # Access data from the dictionary
        vid = relationship["vid"]

        cypher_query = """
        MATCH (user:User {uid: $uid}), (value:Value {vid: $vid})
        CREATE (user)-[has:HAS_VALUE]->(value)
        """
        graph.query(cypher_query, {"uid": uid, "vid": vid})
        return {"message": "Relationship successfully created."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


@router.post("/public/relationships/friend_value")
async def create_friend_value_relationship(
    relationship: dict[str, str],  # Capture data as a dictionary
):
    try:
        fid = relationship["fid"]  # Access data from the dictionary
        vid = relationship["vid"]

        cypher_query = """
        MATCH (friend:Friend {fid: $fid}), (value:Value {vid: $vid})
        CREATE (friend)-[has:HAS_VALUE]->(value)
        """
        graph.query(cypher_query, {"fid": fid, "vid": vid})
        return {"message": "Relationship successfully created."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )
