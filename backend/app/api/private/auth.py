from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from passlib.context import CryptContext
from datetime import datetime, timedelta
from jose import JWTError, jwt
from config import SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES
from database import get_driver

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
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
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
        driver = get_driver()
        with driver.session() as session:
            # Build Cypher query with username
            cypher_query = """
            MATCH (u:User {username: $username})
            RETURN u
            """

            # Execute the query with username from form
            result = session.run(cypher_query, {"username": form.username})
            user = result.single()["u"]

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


# Function to retrieve user by username
async def get_user_by_uid(uid: str):
    try:
        driver = get_driver()
        with driver.session() as session:
            # Build Cypher query with uid
            cypher_query = """
            MATCH (u:User {uid: $uid})
            RETURN u
            """

            # Execute the query with uid
            result = session.run(cypher_query, {"uid": uid})
            user = result.single()

            # Handle user not found case
            if not user:
                raise HTTPException(status_code=404, detail="User not found")

            # Return the user data
            return user["u"]

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Error fetching user: {str(e)}"
        )
