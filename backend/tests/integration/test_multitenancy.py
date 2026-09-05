def test_business_cannot_list_another_business_customers(client, auth_headers, other_auth_headers, sample_customer):
    """
    sample_customer pertenece a `business`. Un usuario autenticado de
    `other_business` NUNCA debe poder verlo en su propio listado, sin
    importar qué filtros use el frontend.
    """
    response = client.get("/api/customers", headers=other_auth_headers)
    assert response.status_code == 200
    ids = [c["id"] for c in response.json()["items"]]
    assert sample_customer.id not in ids


def test_business_cannot_get_another_business_customer_by_id(client, other_auth_headers, sample_customer):
    """Ni siquiera conociendo el ID exacto del cliente de otro negocio, debe poder consultarlo."""
    response = client.get(f"/api/customers/{sample_customer.id}", headers=other_auth_headers)
    assert response.status_code == 404


def test_business_cannot_update_another_business_customer(client, other_auth_headers, sample_customer):
    response = client.put(
        f"/api/customers/{sample_customer.id}", headers=other_auth_headers, json={"first_name": "Hackeado"}
    )
    assert response.status_code == 404


def test_business_cannot_see_another_business_products(client, other_auth_headers, sample_product):
    response = client.get("/api/products", headers=other_auth_headers)
    assert response.status_code == 200
    ids = [p["id"] for p in response.json()["items"]]
    assert sample_product.id not in ids


def test_business_cannot_create_sale_for_another_business_customer(client, other_auth_headers, sample_customer, sample_product):
    """Un negocio no debe poder registrar una venta usando el cliente de otro negocio."""
    response = client.post(
        "/api/sales", headers=other_auth_headers,
        json={"customer_id": sample_customer.id, "items": [{"product_id": sample_product.id, "quantity": 1}], "channel": "internal"},
    )
    assert response.status_code == 404


def test_dashboard_metrics_are_isolated_per_business(client, auth_headers, other_auth_headers, sample_customer):
    """El dashboard de un negocio no debe reflejar clientes de otro negocio."""
    own = client.get("/api/dashboard", headers=auth_headers).json()
    other = client.get("/api/dashboard", headers=other_auth_headers).json()
    assert own["total_customers"] == 1
    assert other["total_customers"] == 0
