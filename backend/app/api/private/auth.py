from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from passlib.context import CryptContext
from datetime import datetime, timedelta
from jose import JWTError, jwt
from config import SECRET_KEY, ACCESS_TOKEN_EXPIRE_MINUTES
from database.neo4j import graph
from dotenv import load_dotenv
from helper import get_env_variable

'''
Handles user login and authorization for users to access their own protected data.
'''

load_dotenv()

algorithm = get_env_variable("ALGORITHM")

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/login")

router = APIRouter()


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire.timestamp()})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=algorithm)
    return encoded_jwt


async def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[algorithm])
        uid: str = payload.get("sub")
        if uid is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Could not validate credentials",
            )
        user = await get_user_by_uid(uid)
        return user
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
        )


@router.post("/private/login")
async def login(form: OAuth2PasswordRequestForm = Depends()):
    try:
        # Build Cypher query with username
        cypher_query = """
        MATCH (u:User {username: $username})
        RETURN u
        """

        # Execute the query with username from form
        result = graph.query(cypher_query, {"username": form.username})
        user = result[0]["u"]

        # Handle user not found case
        if not user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, detail="Incorrect username or password"
            )

        # Verify password directly from user object
        if not verify_password(form.password, user["password"]):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, detail="Incorrect username or password"
            )

        access_token = create_access_token(data={"sub": user["uid"]})

        return {"access_token": access_token, "token_type": "bearer"}

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching user: {str(e)}"
        )


@router.post("/private/logout")
async def logout():
    # Logout by relying on token expiration
    # No additional logic needed as tokens expire after a set time (ACCESS_TOKEN_EXPIRE_MINUTES)

    return {"message": "Successfully logged out"}


# Function to retrieve user by username
async def get_user_by_uid(uid: str):
    try:
        # Build Cypher query with uid
        cypher_query = """
        MATCH (u:User {uid: $uid})
        RETURN u
        """

        # Execute the query with uid
        result = graph.query(cypher_query, {"uid": uid})
        user = result[0]

        # Handle user not found case
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        # Return the user data
        return user["u"]

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching user: {str(e)}"
        )
