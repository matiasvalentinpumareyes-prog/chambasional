from datetime import datetime

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.audit import ImportType
from app.models.customer import Customer

REQUIRED_FIELDS: dict[ImportType, list[str]] = {
    ImportType.customers: ["first_name", "last_name"],
    ImportType.products: ["name", "price"],
    ImportType.sales: ["customer_email", "product_sku", "quantity", "date"],
}


def validate_rows(db: Session, business_id: str, import_type: ImportType, rows: list[dict[str, str]]) -> dict:
    """
    Valida cada fila del archivo ANTES de importar nada (sección 10):
    columnas faltantes, tipos incorrectos, fechas inválidas, duplicados,
    productos inexistentes, valores negativos, ventas sin cliente. Nunca
    se escribe en la base de datos desde esta función — solo valida.
    """
    errors: list[dict] = []
    warnings: list[dict] = []
    seen_emails: set[str] = set()

    existing_emails: set[str] = set()
    if import_type == ImportType.customers:
        existing_emails = {
            e for (e,) in db.execute(select(Customer.email).where(Customer.business_id == business_id, Customer.email.isnot(None)))
        }

    required = REQUIRED_FIELDS[import_type]
    accepted_row_numbers: set[int] = set()

    for idx, row in enumerate(rows):
        row_number = idx + 2  # +1 índice base 0, +1 por la fila de cabecera
        row_has_error = False

        for field in required:
            value = row.get(field, "")
            if not value or not str(value).strip():
                errors.append({"row": row_number, "field": field, "message": f'Falta el campo obligatorio "{field}".'})
                row_has_error = True

        if import_type == ImportType.customers:
            email = row.get("email", "").strip()
            if email:
                if email in seen_emails:
                    errors.append({"row": row_number, "field": "email", "message": "Email duplicado dentro del archivo."})
                    row_has_error = True
                if email in existing_emails:
                    warnings.append({"row": row_number, "field": "email", "message": "Ya existe un cliente con este email; se omitirá."})
                seen_emails.add(email)
            else:
                warnings.append({"row": row_number, "field": "email", "message": "Cliente sin email: no podrá recibir campañas por ese canal."})

        if import_type == ImportType.products:
            price_raw = row.get("price", "")
            try:
                price = float(price_raw)
                if price < 0:
                    errors.append({"row": row_number, "field": "price", "message": "El precio debe ser mayor o igual a 0."})
                    row_has_error = True
            except (ValueError, TypeError):
                if price_raw:
                    errors.append({"row": row_number, "field": "price", "message": "El precio debe ser un número válido."})
                    row_has_error = True

        if import_type == ImportType.sales:
            qty_raw = row.get("quantity", "")
            try:
                qty = float(qty_raw)
                if qty <= 0:
                    errors.append({"row": row_number, "field": "quantity", "message": "La cantidad debe ser mayor a 0."})
                    row_has_error = True
            except (ValueError, TypeError):
                if qty_raw:
                    errors.append({"row": row_number, "field": "quantity", "message": "La cantidad debe ser un número válido."})
                    row_has_error = True

            date_raw = row.get("date", "")
            if date_raw:
                try:
                    datetime.fromisoformat(date_raw)
                except ValueError:
                    errors.append({"row": row_number, "field": "date", "message": "Fecha inválida (usar formato ISO: AAAA-MM-DD)."})
                    row_has_error = True

            customer_email = row.get("customer_email", "").strip()
            if customer_email and customer_email not in existing_emails:
                errors.append({"row": row_number, "field": "customer_email", "message": "No existe un cliente con este email."})
                row_has_error = True

        if not row_has_error:
            accepted_row_numbers.add(row_number)

    rejected_row_numbers = {e["row"] for e in errors}
    return {
        "total_rows": len(rows),
        "accepted_rows": len(rows) - len(rejected_row_numbers),
        "rejected_rows": len(rejected_row_numbers),
        "errors": errors,
        "warnings": warnings,
    }
