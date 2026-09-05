from pydantic import BaseModel, EmailStr, Field

from app.models.business import UserRole


class RegisterRequest(BaseModel):
    business_name: str = Field(min_length=1, max_length=200)
    user_name: str = Field(min_length=1, max_length=200)
    email: EmailStr
    password: str = Field(min_length=8, max_length=100)


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class UserOut(BaseModel):
    id: str
    name: str
    email: str
    role: UserRole
    business_id: str
    business_name: str

    model_config = {"from_attributes": True}


class TokenResponse(BaseModel):
    token: str
    user: UserOut
