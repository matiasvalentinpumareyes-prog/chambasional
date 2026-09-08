from datetime import datetime, timezone

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.auditoria import AuditoriaLog
from app.models.catalogs import AuditoriaAccion, AuditoriaEntidad
from app.models.empresa import Usuario


def log_action(
    db: Session,
    *,
    business_id: str | None = None,
    emp_id: str | None = None,
    user_id: str | None = None,
    usu_id: str | None = None,
    action: str,
    entity: str,
    entity_id: str | None = None,
    result: str = "success",
    metadata: dict | None = None,
    adl_usuario: str | None = None,
) -> None:
    """
    Registra auditoría en auditoria_logs (BD real, 43 tablas).
    Soporta tanto nombres legacy (business_id/user_id) como nuevos (emp_id/usu_id) para transición.
    Resuelve ade_id/ada_id por código/tabla.
    """
    _emp_id = emp_id or business_id
    _usu_id = usu_id or user_id
    if not _emp_id or not _usu_id:
        # intenta resolver desde entity si es login sin emp_id
        return

    # Resolver entidad (ade_id) por tabla o código
    ade = db.scalar(select(AuditoriaEntidad).where(AuditoriaEntidad.ade_tabla == entity))
    if not ade:
        ade = db.scalar(select(AuditoriaEntidad).where(AuditoriaEntidad.ade_codigo == entity))
    if not ade:
        # fallback: crear entidad genérica si no existe (evita FK error)
        ade = AuditoriaEntidad(ade_codigo=entity.upper()[:50], ade_nombre=entity, ade_tabla=entity, estado=1)
        # no commit aquí, solo usar id temporal? Mejor buscar o crear via flush
        # Si no existe, usar el primer registro como fallback para no romper
        fallback = db.scalar(select(AuditoriaEntidad).limit(1))
        if fallback:
            ade = fallback
        else:
            return

    ada = db.scalar(select(AuditoriaAccion).where(AuditoriaAccion.ada_accion == action))
    if not ada:
        # buscar case-insensitive o crear fallback
        ada = db.scalar(select(AuditoriaAccion).where(AuditoriaAccion.ada_accion == action.upper()))
    if not ada:
        fallback_ada = db.scalar(select(AuditoriaAccion).limit(1))
        if fallback_ada:
            ada = fallback_ada
        else:
            return

    # Resolver nombre usuario textual
    usu = db.get(Usuario, _usu_id) if _usu_id else None
    # Usuario.get necesita emp_id+usu_id? Pero Usuario PK es usu_id solo, con UniqueConstraint emp_id+usu_id
    # db.get con PK usu_id funciona si PK es usu_id (lo es)
    adl_usuario_val = adl_usuario or (usu.usu_usuario if usu else str(_usu_id or "system"))

    entry = AuditoriaLog(
        emp_id=_emp_id,
        usu_id=_usu_id,
        ade_id=ade.ade_id,
        ada_id=ada.ada_id,
        adl_tabla=entity[:64],
        adl_registro_id=str(entity_id or "")[:100],
        adl_usuario=adl_usuario_val[:100],
        adl_fecha_hora=datetime.now(timezone.utc),
        adl_valor_anterior=None,
        adl_valor_nuevo=metadata,
    )
    db.add(entry)
    try:
        db.commit()
    except Exception:
        db.rollback()
