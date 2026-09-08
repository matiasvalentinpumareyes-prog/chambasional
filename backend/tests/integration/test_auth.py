def test_register_creates_business_and_admin_user(client):
    response = client.post("/api/auth/register", json={
        "business_name": "Mi Negocio", "user_name": "Ana", "email": "ana@negocio.com", "password": "SuperSegura123",
    })
    assert response.status_code == 200
    data = response.json()
    assert data["user"]["role"] == "admin"
    assert "token" in data


def test_register_rejects_duplicate_email(client):
    payload = {"business_name": "N1", "user_name": "A", "email": "dup@test.com", "password": "SuperSegura123"}
    client.post("/api/auth/register", json=payload)
    response = client.post("/api/auth/register", json={**payload, "business_name": "N2"})
    assert response.status_code == 409
    assert response.json()["error"]["code"] == "EMAIL_ALREADY_REGISTERED"


def test_login_with_wrong_password_fails(client):
    client.post("/api/auth/register", json={"business_name": "N", "user_name": "A", "email": "u@test.com", "password": "SuperSegura123"})
    response = client.post("/api/auth/login", json={"email": "u@test.com", "password": "incorrecta"})
    assert response.status_code == 401


def test_protected_endpoint_requires_authentication(client):
    """Sección 60: un usuario no autenticado no debe poder acceder a datos."""
    response = client.get("/api/customers")
    assert response.status_code == 401


def test_protected_endpoint_rejects_invalid_token(client):
    response = client.get("/api/customers", headers={"Authorization": "Bearer token-invalido"})
    assert response.status_code == 401


def test_settings_endpoint_requires_admin_role(client, db_session, business):
    from app.core.security import create_access_token, hash_password
    from app.models.empresa import Usuario

    non_admin = User(
        business_id=business.id, name="Vendedor", email="vendedor@test.com",
        hashed_password=hash_password("password123!"), role=UserRole.business_user,
    )
    db_session.add(non_admin)
    db_session.commit()

    token = create_access_token(subject=non_admin.id, extra_claims={"role": "business_user", "business_id": business.id})
    response = client.get("/api/settings", headers={"Authorization": f"Bearer {token}"})
    assert response.status_code == 403
