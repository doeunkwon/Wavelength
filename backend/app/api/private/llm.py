from fastapi import APIRouter, Depends, HTTPException
from app.api.helpers.auth import get_current_user
from app.api.helpers.llm import score as score_helper
from fastapi.exceptions import HTTPException as FastAPIHTTPException
import logging

router = APIRouter()

# Set up basic logging configuration
logging.basicConfig(level=logging.ERROR)


@router.post("/private/llm/score/{fid}")
async def score(
    fid: str,
    token: str = Depends(get_current_user)
):
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        uid = token["uid"]
        return score_helper(uid, fid)

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
