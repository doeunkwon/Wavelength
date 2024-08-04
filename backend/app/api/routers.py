from fastapi import FastAPI

from app.api.public.users import router as pub_users_router
from app.api.public.scores import router as pub_scores_router

from app.api.private.auth import router as pri_auth_router
from app.api.private.friends import router as pri_friends_router
from app.api.private.llm import router as pri_llm_router
from app.api.private.memories import router as pri_memories_router
from app.api.private.relationships import router as pri_relationships_router
from app.api.private.scores import router as pri_scores_router
from app.api.private.users import router as pri_users_router
from app.api.private.values import router as pri_values_router

app = FastAPI()

app.include_router(pub_users_router)
app.include_router(pub_scores_router)

app.include_router(pri_auth_router)
app.include_router(pri_friends_router)
app.include_router(pri_llm_router)
app.include_router(pri_memories_router)
app.include_router(pri_relationships_router)
app.include_router(pri_scores_router)
app.include_router(pri_users_router)
app.include_router(pri_values_router)
