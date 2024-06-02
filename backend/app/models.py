from pydantic import BaseModel


class User(BaseModel):
    firstName: str
    lastName: str
    birthday: str  # Might want to use a date type here
    username: str
    email: str
    password: str  # Hash passwords before storing
    location: str
    interests: list[str]
    emoji: str
    color: str
    qrCode: str  # Store as binary data type


class Memory(BaseModel):
    content: str


class Prompt(BaseModel):
    content: str
