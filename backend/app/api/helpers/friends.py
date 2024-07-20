from database.neo4j import graph
from fastapi import HTTPException


def get_friend(fid: str):
    try:
        # Build Cypher query with identifier
        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        RETURN f
        """

        # Execute the query with identifier
        result = graph.query(cypher_query, {"fid": fid})
        friend = result[0]

        # Handle friend not found case
        if not friend:
            raise HTTPException(status_code=404, detail="Friend not found")

        # Return the friend data
        return friend["f"]

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching friend: {str(e)}"
        )


def update_friend(fid: str, new_data: dict):
    try:
        # Fetch existing friend data
        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        RETURN f
        """
        result = graph.query(cypher_query, {"fid": fid})
        existing_friend = result[0]

        # Check if friend exists
        if not existing_friend:
            raise HTTPException(status_code=404, detail="Friend not found")

        merged_data = {**existing_friend["f"], **new_data}

        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        SET """

        set_clauses = [f"f.{field} = $friend_{
            field}" for field in merged_data if field != "fid"]

        if not set_clauses:
            raise HTTPException(
                status_code=400, detail="No valid update fields provided")

        cypher_query += ", ".join(set_clauses)
        cypher_query += """
        RETURN f
        """

        data = {"fid": fid}
        for field, value in merged_data.items():
            if field != "fid":
                data[f"friend_{field}"] = value

        result = graph.query(cypher_query, data)
        updated_friend = result[0]

        return updated_friend["f"]
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error updating friend: {str(e)}"
        )


def delete_friend(fid: str):
    try:
        # Build Cypher query with identifier and both relationship matches
        cypher_query = f"""
        MATCH (f:Friend {{fid: $fid}})
        OPTIONAL MATCH (m:Memory)-[:ABOUT]->(f)
        DETACH DELETE f, m
        RETURN COUNT(f) AS friendsDeleted
        """

        # Execute the query with identifier
        result = graph.query(cypher_query, {"fid": fid})
        friends_deleted = result[0]["friendsDeleted"]

        # Handle deletion result
        if friends_deleted != 1:
            raise HTTPException(status_code=404, detail="Friend not found")

        message = f"Successfully deleted the friend and the friend's associated relationships."

        return {"message": message}
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error deleting friend: {str(e)}"
        )
