from sqlalchemy.orm import Session

from app.models.audit import AuditLog


def log_action(
    db: Session,
    *,
    business_id: str | None,
    user_id: str | None,
    action: str,
    entity: str,
    entity_id: str | None = None,
    result: str = "success",
    metadata: dict | None = None,
) -> None:
    """
    Registra una acción de auditoría (sección 51). Se llama explícitamente
    desde los endpoints que modifican datos sensibles (creación de
    campañas, cambios de configuración, importaciones, login). Nunca
    registra contraseñas ni secretos.
    """
    entry = AuditLog(
        business_id=business_id,
        user_id=user_id,
        action=action,
        entity=entity,
        entity_id=entity_id,
        result=result,
        metadata_json=metadata,
    )
    db.add(entry)
    db.commit()
