import uuid
from app.api.helpers.auth import get_current_user
from database.neo4j import graph
from fastapi import Depends, HTTPException, Body, APIRouter
from app.models import Breakdown

router = APIRouter()


@router.post("/private/breakdown/{fid}")
async def create_user_breakdown(
        fid: str,
        breakdown: Breakdown = Body(...),
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        while True:

            # Generate a new UUID for the score ID (existing logic)
            new_bid = str(uuid.uuid4())

            # Check for duplicate ID and create score (existing logic)
            check_query = """
            MATCH (b:Breakdown {bid: $bid})
            RETURN b
            """
            result = graph.query(check_query, {"bid": new_bid})

            # If no score found with the generated ID, proceed with creation
            if len(result) == 0:

                # Cypher query to create a new score node with generated ID
                cypher_query = """
                CREATE (b:Breakdown {
                    bid: $bid,
                    goal: $goal,
                    value: $value,
                    interest: $interest,
                    memory: $memory
                })
                RETURN b
                """
                # Execute the query with score data (including timestamp)
                result = graph.query(
                    cypher_query, {
                        "bid": new_bid, **breakdown.model_dump()}
                )
                # Assuming a single score is created
                created_breakdown = result[0]["b"]

                try:

                    cypher_query = """
                    MATCH (friend:Friend {fid: $fid}), (breakdown:Breakdown {bid: $bid})
                    CREATE (friend)-[:HAS_BREAKDOWN]->(breakdown)
                    """
                    graph.query(cypher_query, {
                                "fid": fid, "bid": created_breakdown["bid"]})
                    # Return the created memory's mid
                    return {"bid": created_breakdown["bid"]}

                except Exception as e:
                    raise HTTPException(
                        status_code=404, detail="Breakdown not found.")

            else:
                # Handle duplicate score ID case (optional)
                raise HTTPException(
                    status_code=409, detail="Breakdown ID already exists."
                )

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error creating breakdown: {str(e)}"
        )


@router.get("/private/breakdown/{fid}")
async def get_friend_breakdown(
    fid: str,
    token: str = Depends(get_current_user)
):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        # Cypher query to fetch all scores for the user using HAS_SCORE relationship
        cypher_query = """
        MATCH (:Friend {fid: $fid})-[:HAS_BREAKDOWN]->(b:Breakdown)
        RETURN b
        """

        # Execute the query with user ID
        result = graph.query(cypher_query, {"fid": fid})

        # Extract scores from the result
        breakdown = result[0]["b"]

        # Return a list of all scores for the user
        return breakdown

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching breakdown: {str(e)}"
        )
