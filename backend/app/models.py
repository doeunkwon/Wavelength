from pydantic import BaseModel

'''
The purpose of these models is to streamline forms (like creating a new User, Friend, or Interaction).
For instance, User is missing uid because when a new user is signing up, we don't expect the user to enter their own uid.
'''


class User(BaseModel):
    emoji: str
    color: str
    firstName: str
    lastName: str
    birthday: str  # Might want to use a date type here
    username: str
    email: str
    password: str  # Hash passwords before storing
    passion: str
    workEthic: str
    personality: list[str]
    interests: list[str]


class Memory(BaseModel):
    content: str


class Prompt(BaseModel):
    content: str
