from fastapi import APIRouter, Body, Depends, HTTPException
from dotenv import load_dotenv
# from huggingface_hub import InferenceClient
from langchain.chains import GraphCypherQAChain
from langchain_core.prompts import FewShotPromptTemplate, PromptTemplate
from langchain_google_genai import ChatGoogleGenerativeAI
from app.models import Prompt
from app.api.private.auth import get_current_user
from helper import get_env_variable
from database.neo4j import graph
from app.api.helpers.llm import examples, example_prompt, prompt_prefix, prompt_suffix, uid_modified_prompt, rag_response_prompt, gen_response_prompt
from app.api.helpers.general import test_print
# import json

load_dotenv()

router = APIRouter()

# Load environment variables once at startup
# llama_model_id = get_env_variable("LLAMA_MODEL_ID")
gemini_api_key = get_env_variable("GEMINI_API_KEY")

example_prompt = PromptTemplate.from_template(example_prompt)

prompt = FewShotPromptTemplate(
    examples=examples,
    example_prompt=example_prompt,
    prefix=prompt_prefix,
    suffix=prompt_suffix,
    input_variables=["question", "schema"]
)

# Initialize LLM clients outside of request handlers
# llama = InferenceClient(model=llama_model_id, timeout=120)
gemini = ChatGoogleGenerativeAI(
    model="gemini-pro", google_api_key=gemini_api_key, temperature=1.0)

chain = GraphCypherQAChain.from_llm(
    graph=graph, llm=gemini, cypher_prompt=prompt, verbose=True, return_intermediate_steps=True)

# This function tries to query the Neo4j KG if the question is relevant, otherwise, it answers generally as trained.


@router.post("/private/llm/rag")
async def answer_with_rag(
    token: str = Depends(get_current_user),
    prompt: Prompt = Body(...),
):
    if not token.get("uid"):
        return HTTPException(status_code=401, detail="Unauthorized access")

    try:
        uid = token["uid"]
        modified_prompt = uid_modified_prompt(uid, prompt.content)

        test_print("Modified Prompt: " + modified_prompt)

        response = chain.invoke({"query": modified_prompt})
        context = response.get("intermediate_steps", [{}])[
            1].get("context", "")

        test_print("Context: " + str(context))

        if context:
            response_prompt = rag_response_prompt(context, prompt.content)

            test_print("Response Prompt: " + response_prompt, case=1)

            response = gemini.invoke(response_prompt)
            answer = response.content
            return answer
        else:
            response_prompt = gen_response_prompt(prompt.content)

            test_print("Response Prompt: " + response_prompt, case=2)

            response = gemini.invoke(response_prompt)
            answer = response.content
            return answer

    except Exception as e:
        # If the LLM fails to generate a legal Cypher statement
        if "Generated Cypher Statement is not valid" in str(e):
            try:
                response_prompt = gen_response_prompt(prompt.content)

                test_print("Response Prompt: " + response_prompt, case=3)

                response = gemini.invoke(response_prompt)
                answer = response.content
                return answer
            except Exception as e:
                raise HTTPException(
                    500, detail=f"Error generating answer: {str(e)}")
        else:
            raise HTTPException(
                500, detail=f"Error generating answer: {str(e)}")

# @router.post("/private/llm")
# async def answer(
#     token: str = Depends(get_current_user),
#     prompt: Prompt = Body(...),
# ):
#     if not token.get("uid"):
#         return HTTPException(status_code=401, detail="Unauthorized access")

#     try:
#         response = llama.post(
#             json={
#                 "inputs": prompt.content,
#                 "parameters": {"max_new_tokens": 200},
#                 "task": "text-generation",
#             }
#         )
#         generated_text = json.loads(response.decode())[0]["generated_text"]
#         return generated_text

#     except Exception as e:
#         raise HTTPException(500, detail=f"Error generating answer: {str(e)}")
