from fastapi import APIRouter, Depends, HTTPException
from app.api.helpers.auth import get_current_user
from app.api.helpers.llm import score as score_helper

router = APIRouter()


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
    except Exception as e:
        raise HTTPException(
            500, detail=f"Error generating answer: {str(e)}")
