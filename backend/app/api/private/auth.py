from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordRequestForm
from app.api.helpers.auth import login as login_helper, logout as logout_helper

'''
Handles user login and authorization for users to access their own protected data.
'''

router = APIRouter()


@router.post("/private/login")
async def login(form: OAuth2PasswordRequestForm = Depends()):
    return login_helper(form)


@router.post("/private/logout")
async def logout():
    return logout_helper()
