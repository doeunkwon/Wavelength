from pydantic import BaseModel


class User(BaseModel):
    uid: str
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
    mid: str
    content: str
    timestamp: str
