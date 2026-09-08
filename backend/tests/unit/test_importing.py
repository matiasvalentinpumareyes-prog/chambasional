from app.models.auditoria import Import


def test_validate_customers_rejects_missing_required_fields(db_session):
    from app.services.importing import validate_rows

    rows = [{"first_name": "", "last_name": "Pérez", "email": "x@test.com"}]
    result = validate_rows(db_session, "biz1", ImportType.customers, rows)
    assert result["rejected_rows"] == 1
    assert any(e["field"] == "first_name" for e in result["errors"])


def test_validate_customers_detects_duplicate_emails_in_file(db_session):
    from app.services.importing import validate_rows

    rows = [
        {"first_name": "Ana", "last_name": "Lopez", "email": "ana@test.com"},
        {"first_name": "Ana2", "last_name": "Lopez2", "email": "ana@test.com"},
    ]
    result = validate_rows(db_session, "biz1", ImportType.customers, rows)
    assert result["rejected_rows"] == 1
    assert any("duplicado" in e["message"].lower() for e in result["errors"])


def test_validate_customers_without_email_is_warning_not_error(db_session):
    from app.services.importing import validate_rows

    rows = [{"first_name": "Ana", "last_name": "Lopez", "email": ""}]
    result = validate_rows(db_session, "biz1", ImportType.customers, rows)
    assert result["accepted_rows"] == 1
    assert result["rejected_rows"] == 0
    assert len(result["warnings"]) == 1


def test_validate_products_rejects_negative_price(db_session):
    from app.services.importing import validate_rows

    rows = [{"name": "Producto X", "price": "-5"}]
    result = validate_rows(db_session, "biz1", ImportType.products, rows)
    assert result["rejected_rows"] == 1


def test_validate_sales_rejects_invalid_date(db_session):
    from app.services.importing import validate_rows

    rows = [{"customer_email": "", "product_sku": "SKU-1", "quantity": "2", "date": "not-a-date"}]
    result = validate_rows(db_session, "biz1", ImportType.sales, rows)
    assert any(e["field"] == "date" for e in result["errors"])


def test_validate_sales_rejects_zero_or_negative_quantity(db_session):
    from app.services.importing import validate_rows

    rows = [{"customer_email": "", "product_sku": "SKU-1", "quantity": "0", "date": "2026-01-01"}]
    result = validate_rows(db_session, "biz1", ImportType.sales, rows)
    assert any(e["field"] == "quantity" for e in result["errors"])
