from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.audit import log_action
from app.core.deps import get_current_user
from app.core.errors import ConflictError, UnauthorizedError
from app.core.security import create_access_token, hash_password, verify_password
from app.db.session import get_db
from app.models.business import Business, User, UserRole
from app.schemas.auth import LoginRequest, RegisterRequest, TokenResponse, UserOut

router = APIRouter(prefix="/auth", tags=["auth"])


def _user_out(user: User) -> UserOut:
    return UserOut(
        id=user.id, name=user.name, email=user.email, role=user.role,
        business_id=user.business_id, business_name=user.business.name,
    )


@router.post("/register", response_model=TokenResponse)
def register(payload: RegisterRequest, db: Session = Depends(get_db)):
    existing = db.scalar(select(User).where(User.email == payload.email))
    if existing:
        raise ConflictError("EMAIL_ALREADY_REGISTERED", "Ya existe una cuenta con este correo electrónico.")

    business = Business(name=payload.business_name)
    db.add(business)
    db.flush()

    user = User(
        business_id=business.id,
        name=payload.user_name,
        email=payload.email,
        hashed_password=hash_password(payload.password),
        role=UserRole.admin,  # quien registra el negocio es su primer administrador
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    log_action(db, business_id=business.id, user_id=user.id, action="REGISTER_BUSINESS", entity="business", entity_id=business.id)

    token = create_access_token(subject=user.id, extra_claims={"role": user.role.value, "business_id": business.id})
    return TokenResponse(token=token, user=_user_out(user))


@router.post("/login", response_model=TokenResponse)
def login(payload: LoginRequest, db: Session = Depends(get_db)):
    user = db.scalar(select(User).where(User.email == payload.email))
    if not user or not verify_password(payload.password, user.hashed_password):
        raise UnauthorizedError(message="Correo o contraseña incorrectos.")
    if not user.is_active:
        raise UnauthorizedError(message="Esta cuenta está desactivada.")

    log_action(db, business_id=user.business_id, user_id=user.id, action="LOGIN", entity="user", entity_id=user.id)

    token = create_access_token(subject=user.id, extra_claims={"role": user.role.value, "business_id": user.business_id})
    return TokenResponse(token=token, user=_user_out(user))


@router.get("/me", response_model=UserOut)
def me(current_user: User = Depends(get_current_user)):
    return _user_out(current_user)
