from typing import List
from app.models import Friend, User


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
