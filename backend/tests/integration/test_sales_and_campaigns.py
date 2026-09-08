def test_create_sale_updates_customer_metrics_immediately(client, auth_headers, sample_customer, sample_product):
    response = client.post(
        "/api/sales", headers=auth_headers,
        json={"customer_id": sample_customer.id, "items": [{"product_id": sample_product.id, "quantity": 2}], "channel": "internal"},
    )
    assert response.status_code == 201
    sale = response.json()
    assert sale["total"] == 31.0  # 15.5 * 2

    customer = client.get(f"/api/customers/{sample_customer.id}", headers=auth_headers).json()
    assert customer["purchase_count"] == 1
    assert customer["total_spend"] == 31.0
    # El cliente acaba de comprar: su riesgo de churn debe ser bajo, no crítico.
    assert customer["churn"] is not None
    assert customer["churn"]["risk_level"] == "low"


def test_create_sale_fails_for_inactive_product(client, auth_headers, sample_customer, db_session, business):
    from app.models.comercio import Producto

    inactive = Product(business_id=business.id, sku="INACTIVE-1", name="Descontinuado", price=10, status=ProductStatus.inactive)
    db_session.add(inactive)
    db_session.commit()

    response = client.post(
        "/api/sales", headers=auth_headers,
        json={"customer_id": sample_customer.id, "items": [{"product_id": inactive.id, "quantity": 1}], "channel": "internal"},
    )
    assert response.status_code == 400
    assert response.json()["error"]["code"] == "PRODUCT_INACTIVE"


def test_create_sale_fails_atomically_if_one_item_is_invalid(client, auth_headers, sample_customer, sample_product):
    """
    Sección 55: si un item de la venta falla, no debe quedar una venta
    parcialmente guardada con solo algunos de sus items.
    """
    response = client.post(
        "/api/sales", headers=auth_headers,
        json={
            "customer_id": sample_customer.id,
            "items": [{"product_id": sample_product.id, "quantity": 1}, {"product_id": "no-existe", "quantity": 1}],
            "channel": "internal",
        },
    )
    assert response.status_code == 400

    sales = client.get("/api/sales", headers=auth_headers).json()
    assert sales["total"] == 0


def test_customer_crud_flow(client, auth_headers):
    create_response = client.post("/api/customers", headers=auth_headers, json={
        "first_name": "Maria", "last_name": "Lopez", "email": "maria@test.com", "preferred_channel": "email", "consent": True,
    })
    assert create_response.status_code == 201
    customer_id = create_response.json()["id"]

    update_response = client.put(f"/api/customers/{customer_id}", headers=auth_headers, json={"city": "Lima"})
    assert update_response.status_code == 200
    assert update_response.json()["city"] == "Lima"

    deactivate_response = client.delete(f"/api/customers/{customer_id}", headers=auth_headers)
    assert deactivate_response.status_code == 200
    assert deactivate_response.json()["status"] == "inactive"


def test_import_preview_does_not_persist_data(client, auth_headers):
    """La vista previa de importación nunca debe escribir clientes reales antes de confirmar (sección 10)."""
    response = client.post("/api/imports/preview", headers=auth_headers, json={
        "type": "customers", "file_name": "clientes.csv",
        "rows": [{"first_name": "Test", "last_name": "Import", "email": "import@test.com"}],
    })
    assert response.status_code == 200
    assert response.json()["accepted_rows"] == 1

    customers = client.get("/api/customers", headers=auth_headers).json()
    assert customers["total"] == 0


def test_campaign_simulation_never_changes_real_state(client, auth_headers, sample_customer):
    campaign_response = client.post("/api/campaigns", headers=auth_headers, json={
        "name": "Campaña de prueba", "offer": "10% de descuento", "channel": "email",
        "start_date": "2026-09-01T00:00:00Z", "message": "Hola {{customer_name}}",
        "target_customer_ids": [sample_customer.id],
    })
    assert campaign_response.status_code == 201
    campaign_id = campaign_response.json()["id"]
    assert campaign_response.json()["status"] == "draft"

    sim_response = client.post(f"/api/campaigns/{campaign_id}/simulate", headers=auth_headers)
    assert sim_response.status_code == 200
    assert sim_response.json()["is_simulation"] is True

    # La campaña sigue en borrador: simular no la activa ni envía nada real.
    campaign_after = client.get(f"/api/campaigns/{campaign_id}", headers=auth_headers).json()
    assert campaign_after["status"] == "draft"


def test_activating_campaign_sends_via_mock_provider_and_updates_recipients(client, auth_headers, sample_customer):
    campaign_response = client.post("/api/campaigns", headers=auth_headers, json={
        "name": "Campaña activable", "offer": "10% de descuento", "channel": "email",
        "start_date": "2026-09-01T00:00:00Z", "message": "Hola {{customer_name}}",
        "target_customer_ids": [sample_customer.id],
    })
    campaign_id = campaign_response.json()["id"]

    activate_response = client.patch(f"/api/campaigns/{campaign_id}/status", headers=auth_headers, json={"status": "active"})
    assert activate_response.status_code == 200
    assert activate_response.json()["status"] == "active"
    # El destinatario con consentimiento debe quedar marcado como enviado (vía MockProvider).
    assert activate_response.json()["metrics"]["sent"] == 1
