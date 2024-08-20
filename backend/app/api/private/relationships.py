from fastapi import APIRouter, Depends, HTTPException
# Assuming you have a function to get the Neo4j driver
from app.api.helpers.auth import get_current_user
from database.neo4j import graph
from app.api.helpers.friends import delete_friend as delete_friend_helper
from app.api.helpers.relationships import get_value_relationships as get_value_relationships_helper, update_value_relationship as update_value_relationship_helper, get_memory_relationships as get_memory_relationships_helper, create_score_relationships as create_score_relationship_helper

router = APIRouter()

#
# ________________________________________________________________________________________________________________________________________________________
# ________________________________________________________________________________________________________________________________________________________
#
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

        # This is checking whether or not Friend is FRIENDS_WITH User
        # We don't allow a User to have a Memory about a Friend unless they're FRIENDS_WITH
        cypher_query = """
        MATCH (:User {uid: $uid})-[:FRIENDS_WITH]->(f:Friend {fid: $fid})
        RETURN f
        """

        # Handle friend not found case
        try:
            result = graph.query(cypher_query, {"uid": uid, "fid": fid})
            friend = result[0]["f"]

            cypher_query = """
            MATCH (user:User {uid: $uid}), (friend:Friend {fid: $fid}), (memory:Memory {mid: $mid})
            CREATE (user)-[has:HAS_MEMORY]->(memory)-[about:ABOUT]->(friend)
            """
            graph.query(cypher_query, {"uid": uid, "mid": mid, "fid": fid})
            return {"message": "Memory relationship successfully created."}

        except Exception as e:
            raise HTTPException(
                status_code=404, detail="Friend not found"
            )
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


@router.get("/private/relationships/memory/{fid}")
async def get_memory_relationships(
    fid: str,
    token: str = Depends(get_current_user)
):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        return get_memory_relationships_helper(uid, fid)
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching relationships: {str(e)}"
        )

#
# ________________________________________________________________________________________________________________________________________________________
# ________________________________________________________________________________________________________________________________________________________
#
# Relationship endpoints related to Friendship


@router.post("/private/relationships/friendship/{fid}")
async def create_friendship_relationship(
    # Capture data as a dictionary
    fid: str,
    token: str = Depends(get_current_user)
):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        uid = token["uid"]

        # Handle friend not found case
        try:
            cypher_query = """
            MATCH (f:Friend {fid: $fid})
            RETURN f
            """

            result = graph.query(cypher_query, {"fid": fid})
            friend = result[0]

            cypher_query = """
            MATCH (user:User {uid: $uid}), (friend:Friend {fid: $fid})
            CREATE (user)-[:FRIENDS_WITH]->(friend)
            """
            graph.query(cypher_query, {"uid": uid, "fid": fid})
            return {"message": "Friendship successfully created."}

        except Exception as e:
            raise HTTPException(status_code=404, detail="Friend not found.")
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )

#
# ________________________________________________________________________________________________________________________________________________________
# ________________________________________________________________________________________________________________________________________________________
#
# Relationship endpoints related to SCORE


@router.post("/private/relationships/score")
async def create_score_relationship(
    data: dict,
    token: str = Depends(get_current_user)
):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        sid = data["sid"]
        model = data["model"]
        general_id = token["uid"] if model == "User" else data["fid"]
        return create_score_relationship_helper(general_id, sid, model)
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )
