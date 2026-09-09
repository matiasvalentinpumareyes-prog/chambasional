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

router = APIRouter(prefix="/clientes", tags=["clientes"])
# Alias legacy /customers para compatibilidad frontend
router_legacy = APIRouter(prefix="/customers", tags=["customers"])


def _to_out(cliente: Cliente) -> ClienteOut:
    return ClienteOut(
        emp_id=cliente.emp_id,
        doc_id=cliente.doc_id,
        cli_ndocumento=cliente.cli_ndocumento,
        cli_nombre_razon_social=cliente.cli_nombre_razon_social,
        cli_direccion=cliente.cli_direccion,
        cli_email=cliente.cli_email,
        cli_celular=cliente.cli_celular,
        cli_birthday=cliente.cli_birthday,
        cli_genero=cliente.cli_genero,
        dep_id=cliente.dep_id,
        prv_id=cliente.prv_id,
        dis_id=cliente.dis_id,
        cli_id=cliente.cli_id,
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
