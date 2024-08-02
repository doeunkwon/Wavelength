from app.models import Friend, User


def score_prompt(user: User, friend: Friend): return f'''
    My name is {user["firstName"]} {user["lastName"]}.
    My goals: {user["goals"]}.
    My interests: {user["interests"]}.
    My friend's name is {friend["firstName"]} {friend["lastName"]}.
    {friend["firstName"]}'s goals: {friend["goals"]}.
    {friend["firstName"]}'s interests: {friend["interests"]}.
    Give us a match score out of 100%.
    Explain why you gave us that score.
'''
