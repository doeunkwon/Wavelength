import uuid
from app.api.helpers.auth import get_current_user
from database.neo4j import graph
from fastapi import Depends, HTTPException, Body, APIRouter
from app.models import Breakdown

router = APIRouter()


@router.post("/private/breakdown/{fid}")
async def create_breakdown(
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
async def get_breakdown(
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


@router.put("/private/breakdown/{bid}/{fid}")
async def update_breakdown(
        fid: str,
        bid: str,
        breakdown_data: dict,
        token: str = Depends(get_current_user)):

    # Check if user is authorized
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:

        uid = token["uid"]

        print("CHECKPOINT 1")

        # Fetch existing memory data
        cypher_query = f"""
        MATCH (:User {{uid: $uid}})-[FRIENDS_WITH]->(:Friend {{fid: $fid}})-[:HAS_BREAKDOWN]->(b:Breakdown {{bid: $bid}})
        RETURN b
        """

        print("CHECKPOINT 2")

        result = graph.query(
            cypher_query, {"uid": uid, "fid": fid, "bid": bid})
        existing_breakdown = result[0]

        print("CHECKPOINT 3")

        # Check if memory exists
        if not existing_breakdown:
            raise HTTPException(status_code=404, detail="Breakdown not found.")

        # Merge existing and update data
        merged_data = {**existing_breakdown["b"], **breakdown_data}

        # Build Cypher query with identifier and SET clause
        cypher_query = f"""
        MATCH (b:Breakdown {{bid: $bid}})
        SET """

        set_clauses = [f"b.{field} = $breakdown_{
            field}" for field in merged_data if field != "bid"]

        if not set_clauses:
            raise HTTPException(
                status_code=400, detail="No valid update fields provided.")

        cypher_query += ", ".join(set_clauses)
        cypher_query += """
        RETURN b
        """

        # Prepare data with breakdown ID and merged update values
        data = {"bid": bid}
        for field, value in merged_data.items():
            if field != "bid":
                data[f"breakdown_{field}"] = value

        # Execute the query with identifier and data
        result = graph.query(cypher_query, data)
        updated_breakdown = result[0]["b"]

        return updated_breakdown
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error updating breakdown: {str(e)}"
        )
