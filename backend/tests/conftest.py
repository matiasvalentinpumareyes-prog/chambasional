import os
from datetime import datetime, timezone

os.environ["DATABASE_URL"] = "postgresql+psycopg2://postgres:postgres@localhost:5432/db_regresape_test"

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

import app.models  # noqa: F401 registra todos los modelos
from app.core.security import create_access_token, hash_password
from app.db.session import Base, get_db
from app.main import app
from app.models.business import Business, User, UserRole
from app.models.customer import Channel, Customer
from app.models.product import Category, Product, ProductStatus

TEST_DATABASE_URL = os.environ["DATABASE_URL"]
engine = create_engine(TEST_DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


@pytest.fixture(scope="session", autouse=True)
def create_test_schema():
    Base.metadata.drop_all(bind=engine)
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)


@pytest.fixture()
def db_session():
    connection = engine.connect()
    transaction = connection.begin()
    session = TestingSessionLocal(bind=connection)

    # Patrón estándar de SQLAlchemy para tests: los endpoints llaman a
    # session.commit() de verdad, pero todo debe revertirse al terminar
    # el test. Se envuelve en un SAVEPOINT que se reinicia automáticamente
    # cada vez que el código de la aplicación hace commit.
    nested = connection.begin_nested()

    from sqlalchemy import event

    @event.listens_for(session, "after_transaction_end")
    def restart_savepoint(sess, trans):
        nonlocal nested
        if not nested.is_active:
            nested = connection.begin_nested()

    yield session

    session.close()
    transaction.rollback()
    connection.close()


@pytest.fixture()
def client(db_session):
    def override_get_db():
        yield db_session

    app.dependency_overrides[get_db] = override_get_db
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()


@pytest.fixture()
def business(db_session) -> Business:
    b = Business(name="Negocio de Prueba", currency="PEN")
    db_session.add(b)
    db_session.commit()
    db_session.refresh(b)
    return b


@pytest.fixture()
def other_business(db_session) -> Business:
    b = Business(name="Otro Negocio", currency="PEN")
    db_session.add(b)
    db_session.commit()
    db_session.refresh(b)
    return b


@pytest.fixture()
def admin_user(db_session, business) -> User:
    user = User(
        business_id=business.id, name="Admin", email="admin@test.com",
        hashed_password=hash_password("password123!"), role=UserRole.admin,
    )
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    return user


@pytest.fixture()
def other_admin_user(db_session, other_business) -> User:
    user = User(
        business_id=other_business.id, name="Otro Admin", email="otro@test.com",
        hashed_password=hash_password("password123!"), role=UserRole.admin,
    )
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    return user


@pytest.fixture()
def auth_headers(admin_user) -> dict:
    token = create_access_token(subject=admin_user.id, extra_claims={"role": admin_user.role.value, "business_id": admin_user.business_id})
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture()
def other_auth_headers(other_admin_user) -> dict:
    token = create_access_token(subject=other_admin_user.id, extra_claims={"role": other_admin_user.role.value, "business_id": other_admin_user.business_id})
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture()
def sample_product(db_session, business) -> Product:
    category = Category(business_id=business.id, name="Bebidas")
    db_session.add(category)
    db_session.flush()
    product = Product(business_id=business.id, category_id=category.id, sku="SKU-001", name="Café Premium", price=15.5, cost=6, status=ProductStatus.active)
    db_session.add(product)
    db_session.commit()
    db_session.refresh(product)
    return product


@pytest.fixture()
def sample_customer(db_session, business) -> Customer:
    customer = Customer(
        business_id=business.id, first_name="Juan", last_name="Pérez", email="juan@test.com",
        preferred_channel=Channel.whatsapp, consent=True, registered_at=datetime.now(timezone.utc),
    )
    db_session.add(customer)
    db_session.commit()
    db_session.refresh(customer)
    return customer
