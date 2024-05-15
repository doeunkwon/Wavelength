from fastapi import FastAPI
from app.api.users import router as users_router
from app.api.memories import router as memories_router
from app.api.relationships import router as relationships_router

app = FastAPI()

app.include_router(users_router)
app.include_router(memories_router)
app.include_router(relationships_router)
