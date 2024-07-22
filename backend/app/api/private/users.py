from fastapi import Depends, APIRouter
from app.api.helpers.auth import get_current_user, hash_password
from app.api.helpers.users import delete_user as delete_user_helper, update_user as update_user_helper, get_user as get_user_helper

'''
Functions for logged-in users to perform on their own protected data (hence user must be authenticated and requires a token).
Ex) Logged-in users can read, update, and delete their own profiles.
'''

router = APIRouter()


# Function to fetch a single user by UID


@router.get("/private/users")
async def get_user(token: str = Depends(get_current_user)):
    uid = token["uid"]
    return get_user_helper(uid)

# Function to delete a user


@router.delete("/private/users")
async def delete_user(token: str = Depends(get_current_user)):
    uid = token["uid"]
    return delete_user_helper(uid)

# Function to update a user


@router.put("/private/users")
async def update_user(token: str = Depends(get_current_user), new_data: dict = {}):
    uid = token["uid"]
    # If the updated fields contains "password", then hash the password
    if "password" in new_data.keys():
        hashed_password = hash_password(new_data["password"])
        new_data["password"] = hashed_password

    return update_user_helper(uid, new_data)
