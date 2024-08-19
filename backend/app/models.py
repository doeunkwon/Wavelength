from typing import Optional, List
from pydantic import BaseModel

'''
The purpose of these models is to streamline forms (like creating a new User, Friend, or Interaction).
For instance, User is missing uid because when a new user is signing up, we don't expect the user to enter their own uid.
'''


class Value(BaseModel):
    title: str


class Score(BaseModel):
    percentage: int
    analysis: Optional[str]


class User(BaseModel):
    emoji: str
    color: str
    firstName: str
    lastName: str
    username: str
    email: str
    password: str  # Hash passwords before storing
    goals: str
    interests: List[str]
    values: List[str]
    scorePercentage: int
    tokenCount: int
    memoryCount: int


class Friend(BaseModel):
    emoji: str
    scorePercentage: int
    scoreAnalysis: str
    color: str
    firstName: str
    lastName: str
    goals: str
    interests: List[str]
    values: List[str]
    tokenCount: int
    memoryCount: int


class Memory(BaseModel):
    date: str  # !!! change to some Date datatype
    title: str
    content: str
    tokens: int
