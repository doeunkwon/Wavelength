from fastapi import FastAPI

from app.api.public.users import router as pub_users_router
from app.api.public.friends import router as pub_friends_router
from app.api.public.memories import router as pub_memories_router
from app.api.public.relationships import router as pub_relationships_router
from app.api.public.scores import router as pub_scores_router
from app.api.public.values import router as pub_values_router

from app.api.private.auth import router as pri_auth_router
from app.api.private.users import router as pri_users_router
from app.api.private.llm import router as pri_llm_router

app = FastAPI()

app.include_router(pub_users_router)
app.include_router(pub_friends_router)
app.include_router(pub_memories_router)
app.include_router(pub_relationships_router)
app.include_router(pub_scores_router)
app.include_router(pub_values_router)

app.include_router(pri_auth_router)
app.include_router(pri_users_router)
app.include_router(pri_llm_router)
