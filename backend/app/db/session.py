from collections.abc import Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.core.config import settings
from app.models.base import Base  # single source of truth — 43 tablas BD real

engine = create_engine(settings.DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db() -> Generator[Session, None, None]:
    """
    Dependencia de FastAPI que entrega una sesión de base de datos por
    request y garantiza que siempre se cierre, incluso si la request falla.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
