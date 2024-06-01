from fastapi import APIRouter, Body, Depends, HTTPException
from dotenv import load_dotenv
from huggingface_hub import InferenceClient
from langchain.chains import GraphCypherQAChain
from langchain_google_genai import ChatGoogleGenerativeAI
from app.models import Prompt
from app.api.private.auth import get_current_user
from backend_helper import get_env_variable
from database.neo4j import graph
import json

load_dotenv()

router = APIRouter()

llama_model_id = get_env_variable("LLAMA_MODEL_ID")
gemini_api_key = get_env_variable("GEMINI_API_KEY")

llama = InferenceClient(
    model=llama_model_id,
    timeout=120
)

gemini = ChatGoogleGenerativeAI(
    model="gemini-pro", google_api_key=gemini_api_key, temperature=0)

chain = GraphCypherQAChain.from_llm(
    graph=graph, llm=gemini, verbose=True, return_intermediate_steps=True)


@router.post("/private/llm")
async def answer(
    token: str = Depends(get_current_user),
    prompt: Prompt = Body(...),
):
    if not token.get("uid"):
        # Use 401 for unauthorized
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        response = llama.post(
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


@router.post("/private/llm/rag")
async def answer_with_rag(
    token: str = Depends(get_current_user),
    prompt: Prompt = Body(...),
):
    if not token.get("uid"):
        # Use 401 for unauthorized
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        response = chain.invoke({"query": prompt.content})
        context = response["intermediate_steps"][1]["context"]

        # Inject context into the prompt
        response_prompt = f'''The answer to the question {prompt.content} is {context}.
        Present the answer in natural language.'''

        # Use LLM to analyze context and generate natural language response
        response = gemini.invoke(response_prompt)
        answer = response.content

        return answer

    except Exception as e:
        raise HTTPException(500, detail=f"Error generating answer: {str(e)}")
