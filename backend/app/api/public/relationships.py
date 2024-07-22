from fastapi import APIRouter, Depends, HTTPException, Body
# Assuming you have a function to get the Neo4j driver
from database.neo4j import graph

router = APIRouter()

# Endpoints related to relationship with Friend model


@router.post("/public/relationships/friend_memory")
async def create_friend_memory_relationship(
    relationship: dict,  # Capture data as a dictionary
):
    try:
        uid = relationship["uid"]  # Access data from the dictionary
        mid = relationship["mid"]
        fid = relationship["fid"]

        cypher_query = """
        MATCH (user:User {uid: $uid}), (friend:Friend {fid: $fid}), (memory:Memory {mid: $mid})
        CREATE (user)-[has:HAS]->(memory)-[about:ABOUT]->(friend)
        """
        graph.query(cypher_query, {"uid": uid, "mid": mid, "fid": fid})
        return {"message": "Relationship created successfully."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


@router.post("/public/relationships/friend_friendship")
async def create_friend_friendship_relationship(
    relationship: dict,  # Capture data as a dictionary
):
    try:
        uid = relationship["uid"]  # Access data from the dictionary
        fid = relationship["fid"]
        score = relationship["score"]

        cypher_query = """
        MATCH (user:User {uid: $uid}), (friend:Friend {fid: $fid})
        CREATE (user)-[:FRIENDS_WITH {score: $score}]->(friend)
        """
        graph.query(cypher_query, {"uid": uid,
                    "fid": fid, "score": score})
        print(f"Cypher Query Executed: {cypher_query}")
        return {"message": "Relationship created successfully."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating relationship: {str(e)}"
        )


@router.delete("/public/relationships/friend_friendship")
async def create_friend_friendship_relationship(
    relationship: dict,  # Capture data as a dictionary
):
    try:
        uid = relationship["uid"]  # Access data from the dictionary
        fid = relationship["fid"]
        score = relationship["score"]

        cypher_query = """
        MATCH (user:User {uid: $uid})-[r:FRIENDS_WITH {score: $score}]->(friend:Friend {fid: $fid})
        DELETE r
        """
        graph.query(cypher_query, {"uid": uid,
                    "fid": fid, "score": score})
        print(f"Cypher Query Executed: {cypher_query}")
        return {"message": "Relationship deleted successfully."}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting relationship: {str(e)}"
        )

# Endpoints related to relationship with User model


# @router.post("/public/relationships/user_memory")
# async def create_user_memory_relationship(
#     relationship: dict,  # Capture data as a dictionary
# ):
#     try:
#         uid1 = relationship["uid1"]  # Access data from the dictionary
#         mid = relationship["mid"]
#         uid2 = relationship["uid2"]

#         cypher_query = """
#         MATCH (user1:User {uid: $uid1}), (user2:User {uid: $uid2}), (memory:Memory {mid: $mid})
#         CREATE (user1)-[has:HAS]->(memory)-[about:ABOUT]->(user2)
#         """
#         graph.query(cypher_query, {"uid1": uid1, "mid": mid, "uid2": uid2})
#         return {"message": "Relationship created successfully."}
#     except Exception as e:
#         raise HTTPException(
#             status_code=500, detail=f"Error creating relationship: {str(e)}"
#         )


# @router.post("/public/relationships/user_friendship")
# async def create_user_friendship_relationship(
#     relationship: dict,  # Capture data as a dictionary
# ):
#     try:
#         uid1 = relationship["uid1"]  # Access data from the dictionary
#         uid2 = relationship["uid2"]

#         cypher_query = """
#         MATCH (user1:User {uid: $uid1}), (user2:User {uid: $uid2})
#         CREATE (user1)-[:FRIENDS_WITH]->(user2)
#         CREATE (user2)-[:FRIENDS_WITH]->(user1)
#         """
#         graph.query(cypher_query, {"uid1": uid1, "uid2": uid2})
#         return {"message": "Relationship created successfully."}
#     except Exception as e:
#         raise HTTPException(
#             status_code=500, detail=f"Error creating relationship: {str(e)}"
#         )


# @router.delete("/public/relationships/user_friendship")
# async def create_user_friendship_relationship(
#     relationship: dict,  # Capture data as a dictionary
# ):
#     try:
#         uid1 = relationship["uid1"]  # Access data from the dictionary
#         uid2 = relationship["uid2"]

#         cypher_query = """
#         MATCH (user1:User {uid: $uid1})-[r:FRIENDS_WITH]->(user2:User {uid: $uid2})
#         DELETE r
#         UNION
#         MATCH (user2:User {uid: $uid2})-[r:FRIENDS_WITH]->(user1:User {uid: $uid1})
#         DELETE r
#         """
#         graph.query(cypher_query, {"uid1": uid1, "uid2": uid2})
#         print(f"Cypher Query Executed: {cypher_query}")
#         return {"message": "Relationship deleted successfully."}
#     except Exception as e:
#         raise HTTPException(
#             status_code=500, detail=f"Error deleting relationship: {str(e)}"
#         )
