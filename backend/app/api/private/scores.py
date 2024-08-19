import uuid
from app.api.helpers.auth import get_current_user
from database.neo4j import graph
from fastapi import Depends, HTTPException, Body, APIRouter
from app.models import Score
from app.api.helpers.general import get_neo4j_datetime_iso8601

router = APIRouter()

# Function to create a new score


@router.post("/private/scores")
async def create_score(
        score: Score = Body(...),
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        while True:
            # Generate a new UUID for the score ID
            new_sid = str(uuid.uuid4())

            # Check if the score ID already exists
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
                return created_score  # Return the created score here
            else:
                # Handle duplicate score ID case (optional)
                raise HTTPException(
                    status_code=409, detail="Score ID already exists."
                )

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating score: {str(e)}"
        )

# The final "return" statement is removed since we already return inside the loop


# Function to fetch all scores

@router.get("/private/scores")
async def get_all_scores(token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        uid = token["uid"]

        # Cypher query to fetch all scores for the user using HAS_SCORE relationship
        cypher_query = """
        MATCH (u:User {uid: $uid})-[:HAS_SCORE]->(s:Score)
        RETURN s
        """

        # Execute the query with user ID
        result = graph.query(cypher_query, {"uid": uid})

        # Extract scores from the result
        scores = [record["s"] for record in result]

        # Return a list of all scores for the user
        return scores

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching scores: {str(e)}"
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
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting score: {str(e)}")
