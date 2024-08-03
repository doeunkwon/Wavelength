from typing import List
from app.models import Friend, User


def score_prompt(user: User, user_values: List[dict], friend: Friend, friend_values: List[dict]): return f'''
    My name is {user["firstName"]} {user["lastName"]}.
    Here are my goals: {user["goals"]}.
    Here are my interests: {user["interests"]}.
    Here are my values and how much they mean to me out of 100: {user_values}.
    My friend's name is {friend["firstName"]} {friend["lastName"]}.
    Here are {friend["firstName"]}'s goals: {friend["goals"]}.
    Here are {friend["firstName"]}'s interests: {friend["interests"]}.
    Here are my values and how much they mean to {friend["firstName"]} out of 100: {friend_values}
    Give us a compatibility score out of 100%.
    Please provide a paragraph summarizing the compatibility between {friend["firstName"]} and I, including reasons for the compatibility score.
    Do not include any headings or bullet points.
'''
