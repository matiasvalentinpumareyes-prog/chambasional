"""Endpoints dinámicos para catálogos base — leen directamente de la BD.

Tablas: metodos_pago, canales_marketing, segmentos, roles, documento, patrones_compra, etc.
Cualquier INSERT en estas tablas se refleja inmediatamente sin cambiar código.
"""
from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.catalogs import CanalMarketing, Documento, MetodoPago, PatronCompra, Rol, Segmento
from app.models.empresa import Usuario

router = APIRouter(prefix="/catalogos", tags=["catalogos"])


@router.get("/metodos-pago", summary="Lista metodos_pago dinámicos (no hardcodeado)")
def list_metodos_pago(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    rows = db.scalars(select(MetodoPago).where(MetodoPago.estado == 1).order_by(MetodoPago.mtp_nombre)).all()
    return [{"mtp_id": r.mtp_id, "mtp_nombre": r.mtp_nombre, "estado": r.estado} for r in rows]


@router.post("/metodos-pago", summary="Crear nuevo método de pago sin cambiar código")
def create_metodo_pago(payload: dict, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    # payload: {"mtp_nombre": "Nuevo Metodo"}
    nombre = (payload.get("mtp_nombre") or "").strip()
    if not nombre:
        from fastapi import HTTPException
        raise HTTPException(status_code=400, detail="mtp_nombre requerido")
    # validar único
    existing = db.scalar(select(MetodoPago).where(MetodoPago.mtp_nombre == nombre))
    if existing:
        from fastapi import HTTPException
        raise HTTPException(status_code=409, detail="Método ya existe")
    row = MetodoPago(mtp_nombre=nombre, estado=1)
    db.add(row)
    db.commit()
    db.refresh(row)
    return {"mtp_id": row.mtp_id, "mtp_nombre": row.mtp_nombre}


@router.get("/canales", summary="Lista canales_marketing dinámicos")
def list_canales(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    rows = db.scalars(select(CanalMarketing).where(CanalMarketing.estado == 1).order_by(CanalMarketing.can_codigo)).all()
    return [{"can_id": r.can_id, "can_codigo": r.can_codigo, "can_nombre": r.can_nombre, "requiere_consentimiento": r.requiere_consentimiento} for r in rows]


@router.get("/segmentos", summary="Lista segmentos dinámicos")
def list_segmentos(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    rows = db.scalars(select(Segmento).where(Segmento.estado == 1).order_by(Segmento.seg_codigo)).all()
    return [{"seg_id": r.seg_id, "seg_codigo": r.seg_codigo, "seg_nombre": r.seg_nombre, "seg_tipo": r.seg_tipo} for r in rows]


@router.get("/roles", summary="Lista roles dinámicos")
def list_roles(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    rows = db.scalars(select(Rol).where(Rol.estado == 1).order_by(Rol.rol_codigo)).all()
    return [{"rol_id": r.rol_id, "rol_codigo": r.rol_codigo, "rol_nombre": r.rol_nombre} for r in rows]


@router.get("/documentos", summary="Lista documento tipos dinámicos")
def list_documentos(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    rows = db.scalars(select(Documento).where(Documento.estado == 1).order_by(Documento.doc_tipo)).all()
    return [{"doc_id": r.doc_id, "doc_tipo": r.doc_tipo, "doc_descripcion": r.doc_descripcion} for r in rows]


@router.get("/patrones-compra", summary="Lista patrones_compra dinámicos")
def list_patrones(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    rows = db.scalars(select(PatronCompra).where(PatronCompra.estado == 1).order_by(PatronCompra.pat_codigo)).all()
    return [{"pat_id": r.pat_id, "pat_codigo": r.pat_codigo, "pat_nombre": r.pat_nombre} for r in rows]
