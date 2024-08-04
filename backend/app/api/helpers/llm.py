from typing import List
from app.models import Friend, User
from dotenv import load_dotenv
from langchain.chains import GraphCypherQAChain
from langchain_google_genai import ChatGoogleGenerativeAI
from app.api.helpers.users import get_user
from app.api.helpers.friends import get_friend
from helper import get_env_variable
from database.neo4j import graph
from app.api.helpers.relationships import get_memory_relationships, get_value_relationships
from app.api.helpers.general import test_print

load_dotenv()

# Load environment variables once at startup
gemini_api_key = get_env_variable("GEMINI_API_KEY")

# Initialize LLM clients outside of request handlers
gemini = ChatGoogleGenerativeAI(
    model="gemini-pro", google_api_key=gemini_api_key, temperature=1.0)

chain = GraphCypherQAChain.from_llm(
    graph=graph, llm=gemini, verbose=True, return_intermediate_steps=True)


def score_prompt(user: User, user_values: List[dict], friend: Friend, friend_values: List[dict], memories: List[str]): return f'''
    I am {user["firstName"]} {user["lastName"]}.
    My goals are: {user["goals"]}.
    My interests include: {user["interests"]}.
    My values, rated out of 100, are: {user_values}.

    My friend's name is {friend["firstName"]} {friend["lastName"]}.
    {friend["firstName"]}'s goals are: {friend["goals"]}.
    {friend["firstName"]} is interested in: {friend["interests"]}.
    My values are important to {friend["firstName"]} to the following extent: {friend_values}.
    I have these memories with {friend["firstName"]}: {memories}.

    Please follow these steps:
    1. Calculate a compatibility score between me and {friend["firstName"]} from 0% to 100%, using only whole numbers.
    2. Provide a comprehensive paragraph detailing our compatibility. Include specific references to shared interests, values, goals, and relevant memories when explaining the score.
    3. Ensure the response is formatted as a single paragraph without headings or bullet points.
'''


def score(uid: str, fid: str):

    # Fetch user info
    user = get_user(uid)
    user_values = get_value_relationships(uid, 'User')

    # Fetch friend info
    friend = get_friend(uid, fid)
    friend_values = get_value_relationships(fid, 'Friend')

    # Fetch all user memories with friend
    memories = get_memory_relationships(uid, fid)

    prompt = score_prompt(user, user_values, friend,
                          friend_values, memories)

    test_print(prompt)

    response = gemini.invoke(prompt)
    answer = response.content
    return answer
