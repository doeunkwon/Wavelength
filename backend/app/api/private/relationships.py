from fastapi import APIRouter, Depends, HTTPException
# Assuming you have a function to get the Neo4j driver
from app.api.helpers.auth import get_current_user
from database.neo4j import graph
from app.api.helpers.friends import delete_friend as delete_friend_helper
from app.api.helpers.relationships import get_value_relationship as get_value_relationship_helper

router = APIRouter()

# Relationship endpoints related to MEMORY


@router.post("/private/relationships/memory")
async def create_memory_relationship(
    relationship: dict[str, str],  # Capture data as a dictionary
    token: str = Depends(get_current_user)
):
    try:
        uid = token["uid"]
        mid = relationship["mid"]
        fid = relationship["fid"]

        cypher_query = """
        MATCH (user:User {uid: $uid}), (friend:Friend {fid: $fid}), (memory:Memory {mid: $mid})
        CREATE (user)-[has:HAS_MEMORY]->(memory)-[about:ABOUT]->(friend)
        """
        graph.query(cypher_query, {"uid": uid, "mid": mid, "fid": fid})
        return {"message": "Memory relationship successfully created."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


# Relationship endpoints related to Friendship

@router.post("/private/relationships/friendship/{fid}")
async def create_friendship_relationship(
    # Capture data as a dictionary
    fid: str,
    token: str = Depends(get_current_user)
):
    try:
        uid = token["uid"]

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


@router.delete("/private/relationships/friendship/{fid}")
async def delete_friendship_relationship(
    fid: str,  # Capture data as a dictionary
    token: str = Depends(get_current_user)
):
    try:
        uid = token["uid"]

        cypher_query = """
        MATCH (user:User {uid: $uid})-[r:FRIENDS_WITH]->(friend:Friend {fid: $fid})
        DELETE r
        """
        # Delete the friendship
        graph.query(cypher_query, {"uid": uid, "fid": fid})

        # Delete the friend
        delete_friend_helper(fid)

        return {"message": "Friendship and friend successfully deleted."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting relationship: {str(e)}"
        )


# Relationship endpoints related to SCORE

@router.post("/private/relationships/user_score/{sid}")
async def create_user_score_relationship(
    sid: str,  # Capture data as a dictionary
    token: str = Depends(get_current_user)
):
    try:
        uid = token["uid"]

        cypher_query = """
        MATCH (user:User {uid: $uid}), (score:Score {sid: $sid})
        CREATE (user)-[has:HAS_SCORE]->(score)
        """
        graph.query(cypher_query, {"uid": uid, "sid": sid})
        return {"message": "User score relationship successfully created."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


# Relationship endpoints related to VALUE


@router.post("/private/relationships/user_value/{vid}")
async def create_user_value_relationship(
    vid: str,  # Capture data as a dictionary
    token: str = Depends(get_current_user)
):
    try:
        uid = token["uid"]

        cypher_query = """
        MATCH (user:User {uid: $uid}), (value:Value {vid: $vid})
        CREATE (user)-[has:HAS_VALUE]->(value)
        """
        graph.query(cypher_query, {"uid": uid, "vid": vid})
        return {"message": "User value relationship successfully created."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


@router.get("/private/relationships/user_value")
async def get_user_value_relationship(
    token: str = Depends(get_current_user)
):
    uid = token["uid"]
    return get_value_relationship_helper(uid, 'User')
