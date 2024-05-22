from fastapi import FastAPI
from app.api.public.users import router as users_router
from app.api.public.memories import router as memories_router
from app.api.public.relationships import router as relationships_router
from app.api.private.auth import router as auth_router

app = FastAPI()

app.include_router(users_router)
app.include_router(memories_router)
app.include_router(relationships_router)
app.include_router(auth_router)
