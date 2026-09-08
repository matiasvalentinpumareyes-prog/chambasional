from datetime import datetime, timezone
from decimal import Decimal

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.pagination import PageParams
from app.core.deps import get_current_user
from app.core.errors import NotFoundError
from app.db.session import get_db
from app.models.cliente import Cliente
from app.models.empresa import Usuario
from app.models.comercio import Producto
from app.repositories.cliente_repo import ClienteRepository
from app.repositories.venta_repo import VentaRepository
from pydantic import BaseModel, Field
from decimal import Decimal

from app.schemas.ventas import VentaCompletaOut, VentaOut, VentaItemOut
from app.schemas.common import Paginated

router = APIRouter(prefix="/ventas", tags=["ventas"])
router_legacy = APIRouter(prefix="/sales", tags=["sales"])


class VentaItemInput(BaseModel):
    prd_id: str = Field(..., description="FK producto.prd_id")
    cantidad: Decimal = Field(..., gt=0, description="DECIMAL(12,3)")
    precio_unitario: Decimal | None = Field(None, description="Si no se envía, se toma de producto_precios vigente")
    descuento: Decimal = Field(default=Decimal("0.00"))
    costo_unitario: Decimal | None = None

    model_config = {"from_attributes": True}


class VentaCreatePayload(BaseModel):
    cli_id: str = Field(..., description="FK cliente.cli_id")
    mtp_id: str | None = Field(None, description="FK metodos_pago.mtp_id")
    cupon_id: str | None = Field(None, description="FK cupones.cup_id")
    venta_origen: str | None = Field(None, max_length=50)
    items: list[VentaItemInput] = Field(..., min_length=1)

    model_config = {"from_attributes": True}


def _to_out(db: Session, venta) -> VentaCompletaOut:
    # Resolver cliente nombre
    cli = db.scalar(select(Cliente).where(Cliente.emp_id == venta.emp_id, Cliente.cli_id == venta.cli_id))
    cli_nombre = cli.cli_nombre_razon_social if cli else ""
    items_out = []
    for it in venta.items:
        prod = db.scalar(select(Producto).where(Producto.emp_id == it.emp_id, Producto.prd_id == it.prd_id))
        prod_nombre = prod.prd_nombre if prod else ""
        items_out.append(VentaItemOut(
            emp_id=it.emp_id,
            venta_id=it.venta_id,
            prd_id=it.prd_id,
            cantidad=it.cantidad,
            precio_unitario=it.precio_unitario,
            descuento=it.descuento,
            subtotal=it.subtotal,
            costo_unitario=it.costo_unitario,
            ven_item_id=it.ven_item_id,
            created_at=it.created_at,
            updated_at=it.updated_at,
            producto_nombre=prod_nombre,
        ))
    return VentaCompletaOut(
        emp_id=venta.emp_id,
        cli_id=venta.cli_id,
        ven_descuento=venta.ven_descuento,
        ven_total=venta.ven_total,
        mtp_id=venta.mtp_id,
        cupon_id=venta.cupon_id,
        venta_origen=venta.venta_origen,
        venta_id=venta.venta_id,
        estado=venta.estado,
        created_at=venta.created_at,
        updated_at=venta.updated_at,
        cliente_nombre=cli_nombre,
        items=items_out,
    )


@router.get("", response_model=Paginated[VentaCompletaOut])
@router_legacy.get("", response_model=Paginated[VentaCompletaOut], include_in_schema=False)
def list_ventas(
    page_params: PageParams = Depends(),
    cli_id: str | None = None,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
):
    repo = VentaRepository(db)
    items, total = repo.list(usuario.emp_id, page=page_params.page, page_size=page_params.page_size, cli_id=cli_id)
    return Paginated(items=[_to_out(db, v) for v in items], page=page_params.page, page_size=page_params.page_size, total=total)


@router.get("/{venta_id}", response_model=VentaCompletaOut)
@router_legacy.get("/{venta_id}", response_model=VentaCompletaOut, include_in_schema=False)
def get_venta(venta_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = VentaRepository(db)
    venta = repo.get(usuario.emp_id, venta_id)
    if not venta:
        raise NotFoundError("VENTA_NOT_FOUND", "Venta no encontrada.")
    return _to_out(db, venta)


@router.post("", response_model=VentaCompletaOut, status_code=201)
@router_legacy.post("", response_model=VentaCompletaOut, status_code=201, include_in_schema=False)
def create_venta(payload: VentaCreatePayload, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    # Validar cliente existe
    cliente = ClienteRepository(db).get(usuario.emp_id, payload.cli_id)
    if not cliente:
        raise NotFoundError("CLIENTE_NOT_FOUND", "Cliente no encontrado.")

    items_input = []
    for it in payload.items:
        items_input.append({
            "prd_id": it.prd_id,
            "cantidad": it.cantidad,
            "precio_unitario": it.precio_unitario,
            "descuento": it.descuento,
            "costo_unitario": it.costo_unitario,
        })

    repo = VentaRepository(db)
    venta = repo.create_venta_with_items(
        emp_id=usuario.emp_id,
        cliente=cliente,
        items_input=items_input,
        mtp_id=payload.mtp_id,
        cupon_id=payload.cupon_id,
        venta_origen=payload.venta_origen,
        venta_fecha=datetime.now(timezone.utc),
    )
    return _to_out(db, venta)
