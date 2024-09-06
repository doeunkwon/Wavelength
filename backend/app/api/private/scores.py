import uuid
from app.api.helpers.auth import get_current_user
from database.neo4j import graph
from fastapi import Depends, HTTPException, Body, APIRouter
from app.models import UserScore, FriendScore
from app.api.helpers.general import get_neo4j_datetime_iso8601
from fastapi.exceptions import HTTPException as FastAPIHTTPException
import logging

router = APIRouter()

# Set up basic logging configuration
logging.basicConfig(level=logging.ERROR)

# Function to create a new user score


@router.post("/private/scores")
async def create_user_score(
        score: UserScore = Body(...),
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        # # Count existing scores for the user
        # count_query = """
        # MATCH (u:User {uid: $uid})-[:HAS_SCORE]->(s:Score)
        # RETURN count(s) AS score_count
        # """
        # user_scores = graph.query(count_query, {"uid": token.get("uid")})
        # score_count = user_scores[0]["score_count"]

        # # Check if adding the score will exceed limit
        # if score_count >= 20:
        #     # Delete the oldest score (assuming scores are linked by a relationship)
        #     delete_query = """
        #     MATCH (u:User {uid: $uid})-[:HAS_SCORE]->(s:Score)
        #     WITH s ORDER BY s.timestamp ASC LIMIT 1
        #     DETACH DELETE s
        #     """
        #     graph.query(delete_query, {"uid": token.get("uid")})

        while True:

            # Generate a new UUID for the score ID (existing logic)
            new_sid = str(uuid.uuid4())

            # Check for duplicate ID and create score (existing logic)
            check_query = """
            MATCH (s:Score {sid: $sid})
            RETURN s
            """
            result = graph.query(check_query, {"sid": new_sid})

            # If no score found with the generated ID, proceed with creation
            if len(result) == 0:
                neo4j_timestamp = get_neo4j_datetime_iso8601()

                # Cypher query to create a new score node with generated ID
                cypher_query = """
                CREATE (s:Score {
                    sid: $sid,
                    timestamp: $timestamp,
                    percentage: $percentage,
                    analysis: $analysis
                })
                RETURN s
                """
                # Execute the query with score data (including timestamp)

                result = graph.query(
                    cypher_query, {
                        "sid": new_sid, "timestamp": neo4j_timestamp, "percentage": score.percentage, "analysis": None}
                )
                # Assuming a single score is created
                created_score = result[0]["s"]

                try:

                    cypher_query = """
                    MATCH (user:User {uid: $uid}), (score:Score {sid: $sid})
                    CREATE (user)-[:HAS_SCORE]->(score)
                    """
                    graph.query(cypher_query, {
                                "uid": uid, "sid": created_score["sid"]})
                    # Return the created memory's mid
                    return {"sid": created_score["sid"]}

                except Exception as e:
                    raise HTTPException(
                        status_code=404, detail="Memory not found.")

            else:
                # Handle duplicate score ID case (optional)
                raise HTTPException(
                    status_code=409, detail="Score ID already exists."
                )

    except FastAPIHTTPException as e:
        # Re-raise any HTTPExceptions (400, etc.)
        logging.error(str(e))
        raise e

    except Exception as e:
        # Handle other exceptions with a 500 error
        logging.error(str(e), exc_info=True)
        raise HTTPException(
            status_code=500, detail=f"Error fetching user: {str(e)}"
        )

# Function to create a new friend score


@router.post("/private/scores/{fid}")
async def create_friend_score(
        fid: str,
        score: FriendScore = Body(...),
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        # # Count existing scores for the user
        # count_query = """
        # MATCH (u:User {uid: $uid})-[:HAS_SCORE]->(s:Score)
        # RETURN count(s) AS score_count
        # """
        # user_scores = graph.query(count_query, {"uid": token.get("uid")})
        # score_count = user_scores[0]["score_count"]

        # # Check if adding the score will exceed limit
        # if score_count >= 20:
        #     # Delete the oldest score (assuming scores are linked by a relationship)
        #     delete_query = """
        #     MATCH (u:User {uid: $uid})-[:HAS_SCORE]->(s:Score)
        #     WITH s ORDER BY s.timestamp ASC LIMIT 1
        #     DETACH DELETE s
        #     """
        #     graph.query(delete_query, {"uid": token.get("uid")})

        while True:

            # Generate a new UUID for the score ID (existing logic)
            new_sid = str(uuid.uuid4())

            # Check for duplicate ID and create score (existing logic)
            check_query = """
            MATCH (s:Score {sid: $sid})
            RETURN s
            """
            result = graph.query(check_query, {"sid": new_sid})

            # If no score found with the generated ID, proceed with creation
            if len(result) == 0:
                neo4j_timestamp = get_neo4j_datetime_iso8601()

                # Cypher query to create a new score node with generated ID
                cypher_query = """
                CREATE (s:Score {
                    sid: $sid,
                    timestamp: $timestamp,
                    percentage: $percentage,
                    analysis: $analysis
                })
                RETURN s
                """
                # Execute the query with score data (including timestamp)
                result = graph.query(
                    cypher_query, {
                        "sid": new_sid, "timestamp": neo4j_timestamp, **score.model_dump()}
                )
                # Assuming a single score is created
                created_score = result[0]["s"]

                try:

                    cypher_query = """
                    MATCH (friend:Friend {fid: $fid}), (score:Score {sid: $sid})
                    CREATE (friend)-[:HAS_SCORE]->(score)
                    """
                    graph.query(cypher_query, {
                                "fid": fid, "sid": created_score["sid"]})
                    # Return the created memory's mid
                    return {"sid": created_score["sid"]}

                except Exception as e:
                    raise HTTPException(
                        status_code=404, detail="Memory not found.")

            else:
                # Handle duplicate score ID case (optional)
                raise HTTPException(
                    status_code=409, detail="Score ID already exists."
                )

    except FastAPIHTTPException as e:
        # Re-raise any HTTPExceptions (400, etc.)
        logging.error(str(e))
        raise e

    except Exception as e:
        # Handle other exceptions with a 500 error
        logging.error(str(e), exc_info=True)
        raise HTTPException(
            status_code=500, detail=f"Error fetching user: {str(e)}"
        )


# Function to fetch all user scores

@router.get("/private/scores")
async def get_all_user_scores(
    token: str = Depends(get_current_user)
):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        uid = token["uid"]

        # Cypher query to fetch all scores for the user using HAS_SCORE relationship
        cypher_query = """
        MATCH (:User {uid: $uid})-[:HAS_SCORE]->(s:Score)
        RETURN s
        """

        # Execute the query with user ID
        result = graph.query(cypher_query, {"uid": uid})

        # Extract scores from the result
        scores = [record["s"] for record in result]

        # Return a list of all scores for the user
        return scores

    except FastAPIHTTPException as e:
        # Re-raise any HTTPExceptions (400, etc.)
        logging.error(str(e))
        raise e

    except Exception as e:
        # Handle other exceptions with a 500 error
        logging.error(str(e), exc_info=True)
        raise HTTPException(
            status_code=500, detail=f"Error fetching user: {str(e)}"
        )

# Function to fetch all friend scores


@router.get("/private/scores/{fid}")
async def get_all_friend_scores(
    fid: str,
    token: str = Depends(get_current_user)
):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        # Cypher query to fetch all scores for the user using HAS_SCORE relationship
        cypher_query = """
        MATCH (:Friend {fid: $fid})-[:HAS_SCORE]->(s:Score)
        RETURN s
        """

        # Execute the query with user ID
        result = graph.query(cypher_query, {"fid": fid})

        # Extract scores from the result
        scores = [record["s"] for record in result]

        # Return a list of all scores for the user
        return scores

    except FastAPIHTTPException as e:
        # Re-raise any HTTPExceptions (400, etc.)
        logging.error(str(e))
        raise e

    except Exception as e:
        # Handle other exceptions with a 500 error
        logging.error(str(e), exc_info=True)
        raise HTTPException(
            status_code=500, detail=f"Error fetching user: {str(e)}"
        )


# Function to delete a score


@router.delete("/private/scores/{sid}")
async def delete_score(
        sid: str,
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        # Handle score not found case
        try:
            cypher_query = """
            MATCH (:User {uid: $uid})-[:HAS_SCORE]->(s:Score {sid: $sid})
            RETURN s
            """

            result = graph.query(cypher_query, {"uid": uid, "sid": sid})
            score = result[0]

            # Cypher query to delete a score with the given ID using DETACH
            cypher_query = """
            MATCH (:User {uid: $uid})-[:HAS_SCORE]->(s:Score {sid: $sid})
            DETACH DELETE s
            """

            # Execute the query with score ID
            graph.query(cypher_query, {"uid": uid, "sid": sid})

            return {"message": "Score successfully deleted."}

        except Exception as e:
            raise HTTPException(status_code=404, detail="Score not found.")

    except FastAPIHTTPException as e:
        # Re-raise any HTTPExceptions (400, etc.)
        logging.error(str(e))
        raise e

    except Exception as e:
        # Handle other exceptions with a 500 error
        logging.error(str(e), exc_info=True)
        raise HTTPException(
            status_code=500, detail=f"Error fetching user: {str(e)}"
        )
