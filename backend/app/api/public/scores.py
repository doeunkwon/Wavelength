import uuid
from database.neo4j import graph
from fastapi import HTTPException, Body, APIRouter
from app.models import Score
from app.api.helpers.general import get_neo4j_datetime

router = APIRouter()

# Function to create a new score


@router.post("/public/scores")
async def create_score(score: Score = Body(...)):
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
                neo4j_timestamp = get_neo4j_datetime()

                # Cypher query to create a new score node with generated ID
                cypher_query = """
                CREATE (s:Score {
                    sid: $sid,
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
                    status_code=409, detail="Score ID already exists"
                )

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating score: {str(e)}"
        )

# The final "return" statement is removed since we already return inside the loop


# Function to delete a score


@router.delete("/public/scores/{sid}")
async def delete_score(sid: str):
    try:
        # Cypher query to delete a score with the given ID using DETACH
        cypher_query = """
        MATCH (s:Score {sid: $sid})
        DETACH DELETE s
        """

        # Execute the query with score ID
        graph.query(cypher_query, {"sid": sid})

        return {"message": "Score successfully deleted"}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting score: {str(e)}")
