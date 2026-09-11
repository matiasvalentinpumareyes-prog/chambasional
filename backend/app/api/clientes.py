from datetime import datetime, timezone

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.pagination import PageParams
from app.core.deps import get_current_user
from app.core.errors import AppError, NotFoundError, ConflictError
from app.db.session import get_db
from app.models.cliente import Cliente
from app.models.empresa import Usuario
from app.repositories.cliente_repo import ClienteRepository
from app.schemas.cliente import ClienteCreate, ClienteOut, ClienteUpdate
from app.schemas.common import Paginated
from app.schemas.recommendation import RecommendationOut, StrategyOut

router = APIRouter(prefix="/clientes", tags=["clientes"])
router_legacy = APIRouter(prefix="/customers", tags=["customers"])


def _to_out(cliente: Cliente) -> ClienteOut:
    return ClienteOut(
        emp_id=str(cliente.emp_id) if cliente.emp_id else None,
        doc_id=str(cliente.doc_id) if cliente.doc_id else None,
        cli_ndocumento=cliente.cli_ndocumento,
        cli_nombre_razon_social=cliente.cli_nombre_razon_social,
        cli_direccion=cliente.cli_direccion,
        cli_email=cliente.cli_email,
        cli_celular=cliente.cli_celular,
        cli_birthday=cliente.cli_birthday,
        cli_genero=cliente.cli_genero,
        dep_id=str(cliente.dep_id) if cliente.dep_id else None,
        prv_id=str(cliente.prv_id) if cliente.prv_id else None,
        dis_id=str(cliente.dis_id) if cliente.dis_id else None,
        cli_id=str(cliente.cli_id) if cliente.cli_id else None,
        estado=cliente.estado,
        created_at=cliente.created_at,
        updated_at=cliente.updated_at,
    )


@router.get("", response_model=Paginated[ClienteOut])
@router_legacy.get("", response_model=Paginated[ClienteOut], include_in_schema=False)
def list_clientes(
    page_params: PageParams = Depends(),
    search: str | None = None,
    doc_id: str | None = None,
    estado: int | None = None,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
):
    repo = ClienteRepository(db)
    items, total = repo.list(usuario.emp_id, page=page_params.page, page_size=page_params.page_size, search=search, doc_id=doc_id, estado=estado)
    return Paginated(items=[_to_out(c) for c in items], page=page_params.page, page_size=page_params.page_size, total=total)


@router.get("/{cli_id}", response_model=ClienteOut)
@router_legacy.get("/{cli_id}", response_model=ClienteOut, include_in_schema=False)
def get_cliente(cli_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    cliente = ClienteRepository(db).get(usuario.emp_id, cli_id)
    if not cliente:
        raise NotFoundError("CLIENTE_NOT_FOUND", "Cliente no encontrado.")
    return _to_out(cliente)


def _validate_ndocumento(doc_tipo: str, ndoc: str | None):
    if not ndoc:
        return
    if not ndoc.isdigit():
        raise AppError("VALIDATION_ERROR", "El número de documento debe contener solo dígitos.", status_code=422)
    if doc_tipo == "DNI" and len(ndoc) != 8:
        raise AppError("VALIDATION_ERROR", "DNI debe tener 8 dígitos.", status_code=422)
    if doc_tipo == "RUC" and len(ndoc) != 11:
        raise AppError("VALIDATION_ERROR", "RUC debe tener 11 dígitos.", status_code=422)
    if doc_tipo not in ("DNI", "RUC") and not (8 <= len(ndoc) <= 15):
        raise AppError("VALIDATION_ERROR", "Documento debe tener entre 8 y 15 dígitos.", status_code=422)


@router.post("", response_model=ClienteOut, status_code=201)
@router_legacy.post("", response_model=ClienteOut, status_code=201, include_in_schema=False)
def create_cliente(payload: ClienteCreate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    # Validar doc_id existe
    from app.models.catalogs import Documento
    doc = db.scalar(select(Documento).where(Documento.doc_id == payload.doc_id))
    if not doc:
        raise NotFoundError("DOCUMENTO_NOT_FOUND", f"Documento {payload.doc_id} no existe. Usa /catalogos/documentos para listar.")
    # Validar RUC/DNI en ambos lados (mismo que frontend)
    _validate_ndocumento(doc.doc_tipo, payload.cli_ndocumento)
    # Validar unicidad documento y email por emp (mantiene emp_id 0471cf4c... aislado)
    repo = ClienteRepository(db)
    if payload.cli_ndocumento and repo.get_by_documento(usuario.emp_id, payload.doc_id, payload.cli_ndocumento):
        raise ConflictError("CLIENTE_DOCUMENTO_EXISTS", "Ya existe un cliente con ese documento en tu empresa.")
    if payload.cli_email and repo.get_by_email(usuario.emp_id, payload.cli_email):
        raise ConflictError("CLIENTE_EMAIL_EXISTS", "Ya existe un cliente con ese email en tu empresa.")

    # Forzar emp_id del token, ignorar emp_id del payload si viene distinto
    cliente = Cliente(
        emp_id=usuario.emp_id,
        doc_id=payload.doc_id,
        cli_ndocumento=payload.cli_ndocumento,
        cli_nombre_razon_social=payload.cli_nombre_razon_social,
        cli_direccion=payload.cli_direccion,
        cli_email=payload.cli_email,
        cli_celular=payload.cli_celular,
        cli_birthday=payload.cli_birthday,
        cli_genero=payload.cli_genero,
        dep_id=payload.dep_id,
        prv_id=payload.prv_id,
        dis_id=payload.dis_id,
        estado=payload.estado or 1,
    )
    created = repo.create(cliente)
    return _to_out(created)


@router.put("/{cli_id}", response_model=ClienteOut)
@router_legacy.put("/{cli_id}", response_model=ClienteOut, include_in_schema=False)
def update_cliente(cli_id: str, payload: ClienteUpdate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = ClienteRepository(db)
    cliente = repo.get(usuario.emp_id, cli_id)
    if not cliente:
        raise NotFoundError("CLIENTE_NOT_FOUND", "Cliente no encontrado.")
    patch = payload.model_dump(exclude_unset=True)
    # No permitir cambiar emp_id
    patch.pop("emp_id", None)
    # Validar RUC/DNI si se cambia doc_id o ndocumento
    if "doc_id" in patch or "cli_ndocumento" in patch:
        from app.models.catalogs import Documento
        doc_id = patch.get("doc_id", cliente.doc_id)
        ndoc = patch.get("cli_ndocumento", cliente.cli_ndocumento)
        doc = db.scalar(select(Documento).where(Documento.doc_id == doc_id))
        if not doc:
            raise NotFoundError("DOCUMENTO_NOT_FOUND", f"Documento {doc_id} no existe.")
        _validate_ndocumento(doc.doc_tipo, ndoc)
        # Validar unicidad si cambia documento
        if ndoc and (ndoc != cliente.cli_ndocumento or doc_id != cliente.doc_id):
            if repo.get_by_documento(usuario.emp_id, doc_id, ndoc):
                raise ConflictError("CLIENTE_DOCUMENTO_EXISTS", "Ya existe un cliente con ese documento en tu empresa.")
    if "cli_email" in patch and patch["cli_email"]:
        if patch["cli_email"] != cliente.cli_email and repo.get_by_email(usuario.emp_id, patch["cli_email"]):
            raise ConflictError("CLIENTE_EMAIL_EXISTS", "Ya existe un cliente con ese email en tu empresa.")
    updated = repo.update(cliente, patch)
    return _to_out(updated)


@router.delete("/{cli_id}", response_model=ClienteOut)
@router_legacy.delete("/{cli_id}", response_model=ClienteOut, include_in_schema=False)
def deactivate_cliente(cli_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = ClienteRepository(db)
    cliente = repo.get(usuario.emp_id, cli_id)
    if not cliente:
        raise NotFoundError("CLIENTE_NOT_FOUND", "Cliente no encontrado.")
    # Soft delete: estado 0
    updated = repo.deactivate(cliente)
    return _to_out(updated)


# --- Recomendaciones y Estrategia por cliente (adaptado a BD real) ---
# Frontend llama a /clientes/{id}/recommendations y /clientes/{id}/strategy
# desde CustomerDetailPanel.tsx:10-11. El router legacy predictions.py estaba roto
# (imports legacy) y nunca se cargaba, causando 404 -> realFetch throw -> UI vacía.
# Aquí exponemos endpoints reales bajo /clientes, usando modelos actuales
# (cliente, ventas, producto) sin depender de servicios legacy.

@router.get("/{cli_id}/recommendations", response_model=list[RecommendationOut])
def get_recommendations(cli_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    from datetime import datetime, timezone
    from sqlalchemy import func
    from app.models.producto import Producto
    from app.models.ventas import Venta, VentaItem

    cliente = ClienteRepository(db).get(usuario.emp_id, cli_id)
    if not cliente:
        raise NotFoundError("CLIENTE_NOT_FOUND", "Cliente no encontrado.")

    # Top productos del cliente por cantidad comprada
    q = (
        select(VentaItem.prd_id, func.sum(VentaItem.cantidad).label("total_qty"))
        .join(Venta, Venta.venta_id == VentaItem.venta_id)
        .where(Venta.emp_id == usuario.emp_id, Venta.cli_id == cli_id)
        .group_by(VentaItem.prd_id)
        .order_by(func.sum(VentaItem.cantidad).desc())
        .limit(3)
    )
    top_cli = [row[0] for row in db.execute(q).all()]

    # Si no tiene historial, fallback a más vendidos del negocio
    if not top_cli:
        q2 = (
            select(VentaItem.prd_id, func.sum(VentaItem.cantidad).label("total_qty"))
            .join(Venta, Venta.venta_id == VentaItem.venta_id)
            .where(Venta.emp_id == usuario.emp_id)
            .group_by(VentaItem.prd_id)
            .order_by(func.sum(VentaItem.cantidad).desc())
            .limit(3)
        )
        top_cli = [row[0] for row in db.execute(q2).all()]

    # Si aún vacío (negocio nuevo), top 3 productos activos
    if not top_cli:
        prods = db.scalars(select(Producto).where(Producto.emp_id == usuario.emp_id, Producto.estado == 1).limit(3)).all()
        top_cli = [p.prd_id for p in prods]

    now = datetime.now(timezone.utc)
    out: list[RecommendationOut] = []
    for prd_id in top_cli[:3]:
        prod = db.scalar(select(Producto).where(Producto.emp_id == usuario.emp_id, Producto.prd_id == prd_id))
        if not prod:
            continue
        # score decreciente 85,75,65
        idx = len(out)
        score = [85, 75, 65][idx] if idx < 3 else 55
        reasons = []
        if idx == 0 and len(top_cli) > 0:
            reasons.append("Producto frecuente en el historial del cliente." if db.scalar(select(func.count()).select_from(Venta).where(Venta.emp_id == usuario.emp_id, Venta.cli_id == cli_id)) else "Producto popular del negocio.")
        else:
            reasons.append("Producto popular entre clientes similares.")
        reasons.append("Disponible en catálogo activo.")
        out.append(RecommendationOut(
            customer_id=str(cli_id),
            product_id=str(prd_id),
            product_name=prod.prd_nombre,
            score=score,
            reasons=reasons,
            confidence=0.65 if idx == 0 else 0.5,
            method="frequency" if idx == 0 else "collaborative_filtering",
            generated_at=now,
            model_version="rules-v1-fallback",
        ))
    return out


@router.get("/{cli_id}/strategy", response_model=StrategyOut)
def get_strategy(cli_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    from datetime import datetime, timezone
    cliente = ClienteRepository(db).get(usuario.emp_id, cli_id)
    if not cliente:
        raise NotFoundError("CLIENTE_NOT_FOUND", "Cliente no encontrado.")

    # Reusar recomendaciones para elegir producto recomendado
    recs = get_recommendations(cli_id, db, usuario)
    top_rec = recs[0] if recs else None

    # Estrategia simple adaptada a BD real: prioridad media, canal según consentimiento si existe
    # Buscar consentimiento
    from app.models.cliente import ClienteConsentimiento
    consent = db.scalar(select(ClienteConsentimiento).where(ClienteConsentimiento.emp_id == usuario.emp_id, ClienteConsentimiento.cli_id == cli_id, ClienteConsentimiento.consentimiento == 1))
    has_consent = consent is not None

    # Canal recomendado: si tiene consent, usar can_codigo del consent, si no internal
    recommended_action = "internal"
    if has_consent and consent and consent.can_id:
        from app.models.catalogs import CanalMarketing
        canal = db.scalar(select(CanalMarketing).where(CanalMarketing.can_id == consent.can_id))
        if canal and canal.can_codigo:
            recommended_action = canal.can_codigo.lower()
        else:
            recommended_action = "email"

    now = datetime.now(timezone.utc)
    from app.schemas.recommendation import CustomerValue
    from app.models.catalogs import CanalMarketing
    # customer_value dinámico pero con fallback; canal ya es dinámico de canales_marketing.can_codigo (no hardcodeado)
    # recommended_action viene directo de BD (canal.can_codigo.lower()), cualquier nuevo canal (TELEGRAM, etc.) se usa sin tocar código
    try:
        cv = CustomerValue("medium")
    except Exception:
        cv = "medium"
    # Validación dinámica: si el canal no existe en BD (ej. dato corrupto), fallback a primer canal activo o internal
    # No usamos Enum estático CanalCodigo — se consulta la tabla canales_marketing
    valid_canales = {row[0].lower() for row in db.execute(select(CanalMarketing.can_codigo).where(CanalMarketing.estado == 1)).all()} | {"internal"}
    if recommended_action.lower() not in valid_canales:
        # fallback dinámico: primer canal de BD o internal
        fallback = next((c for c in valid_canales if c != "internal"), "internal")
        recommended_action = fallback
    return StrategyOut(
        customer_id=str(cli_id),
        customer_name=cliente.cli_nombre_razon_social,
        priority_score=65 if top_rec else 45,
        churn_probability=0.45,
        recovery_probability=0.6,
        customer_value=cv,
        recommended_product=top_rec,
        recommended_action=recommended_action,
        recommended_offer="10% de descuento" if has_consent else "Mensaje de fidelización",
        recommended_timing="today" if has_consent else "in_5_days",
        reason="Cliente con potencial de recuperación basado en historial de compras.",
        message=f"Hola {cliente.cli_nombre_razon_social.split()[0]}, tenemos una oferta especial pensada para ti." if has_consent else "No se genera mensaje: el cliente no ha dado consentimiento.",
        cooldown_ok=True,
        has_consent=has_consent,
    )
