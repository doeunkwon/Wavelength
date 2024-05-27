from fastapi import APIRouter, Body, Depends, HTTPException
from dotenv import load_dotenv
from huggingface_hub import InferenceClient
from app.models import Prompt
import json
from app.api.private.auth import get_current_user

load_dotenv()

router = APIRouter()

model_id = "meta-llama/Meta-Llama-3-8B-Instruct"

inference_client = InferenceClient(
    model=model_id,
    timeout=120
)


@router.post("/private/answer")
async def answer(
    token: str = Depends(get_current_user),
    prompt: Prompt = Body(...),
):
    if not token.get("uid"):
        # Use 401 for unauthorized
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        response = inference_client.post(
            json={
                "inputs": prompt.content,
                "parameters": {"max_new_tokens": 200},
                "task": "text-generation",
            }
        )
        generated_text = json.loads(response.decode())[0]["generated_text"]
        return generated_text
    except Exception as e:
        raise HTTPException(500, detail=f"Error generating answer: {str(e)}")
