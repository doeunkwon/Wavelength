from fastapi import APIRouter, Depends, HTTPException
from dotenv import load_dotenv
from langchain.chains import GraphCypherQAChain
from langchain_google_genai import ChatGoogleGenerativeAI
from app.api.helpers.auth import get_current_user
from app.api.helpers.users import get_user
from app.api.helpers.friends import get_friend
from helper import get_env_variable
from database.neo4j import graph
from app.api.helpers.llm import score_prompt
from app.api.helpers.general import test_print

load_dotenv()

router = APIRouter()

# Load environment variables once at startup
gemini_api_key = get_env_variable("GEMINI_API_KEY")

# Initialize LLM clients outside of request handlers
gemini = ChatGoogleGenerativeAI(
    model="gemini-pro", google_api_key=gemini_api_key, temperature=1.0)

chain = GraphCypherQAChain.from_llm(
    graph=graph, llm=gemini, verbose=True, return_intermediate_steps=True)


@router.post("/private/llm/score/{fid}")
async def score(
    fid: str,
    token: str = Depends(get_current_user)
):
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        uid = token["uid"]

        # Fetch user info
        user = get_user(uid)

        # Fetch friend info
        friend = get_friend(fid)

        prompt = score_prompt(user, friend)

        test_print(prompt)

        response = gemini.invoke(prompt)
        answer = response.content
        return answer

    except Exception as e:
        raise HTTPException(
            500, detail=f"Error generating answer: {str(e)}")
