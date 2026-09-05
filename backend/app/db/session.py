from collections.abc import Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

from app.core.config import settings

engine = create_engine(settings.DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


class Base(DeclarativeBase):
    """Clase base declarativa de todos los modelos ORM."""

    pass


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
