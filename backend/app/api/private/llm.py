from fastapi import APIRouter, Body
from dotenv import load_dotenv
from huggingface_hub import InferenceClient
from app.models import Prompt
import json

load_dotenv()

router = APIRouter()

model_id = "meta-llama/Meta-Llama-3-8B-Instruct"

inference_client = InferenceClient(
    model=model_id,
    timeout=120
)


@router.post("/private/answer")
async def answer(prompt: Prompt = Body(...)):
    response = inference_client.post(
        json={
            "inputs": prompt.content,
            "parameters": {"max_new_tokens": 200},
            "task": "text-generation",
        }
    )
    generated_text = json.loads(response.decode())[0]["generated_text"]
    return generated_text
