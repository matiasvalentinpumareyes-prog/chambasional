from decimal import Decimal

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.core.errors import NotFoundError
from app.db.session import get_db
from app.models.empresa import Usuario
from app.repositories.stock_repo import StockRepository
from app.schemas.comercio import ProductoStockCreate, ProductoStockMovimiento, ProductoStockOut, ProductoStockUpdate

router = APIRouter(prefix="/stock", tags=["stock"])


def _to_out(stock) -> ProductoStockOut:
    # stock es ProductoStock ORM
    # Necesita resolver prd_nombre/prd_sku
    # Pero stock ya tiene relación producto? No, pero podemos buscar
    return ProductoStockOut(
        emp_id=stock.emp_id,
        prd_id=stock.prd_id,
        stk_cantidad=stock.stk_cantidad,
        stk_min=stock.stk_min,
        stk_max=stock.stk_max,
        stock_id=stock.stock_id,
        estado=stock.estado,
        created_at=stock.created_at,
        updated_at=stock.updated_at,
        alerta_bajo_minimo=stock.stk_cantidad < stock.stk_min if stock.stk_min is not None else False,
        alerta_sobre_maximo=stock.stk_max is not None and stock.stk_cantidad > stock.stk_max if stock.stk_max else False,
    )


@router.get("", response_model=list[ProductoStockOut])
def list_stock(
    alerta_bajo_minimo: bool | None = None,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
):
    repo = StockRepository(db)
    items = repo.list(usuario.emp_id, alerta_bajo_min=alerta_bajo_minimo)
    # Enriquecer con prd_nombre
    out = []
    for s in items:
        o = _to_out(s)
        # resolver nombre producto
        from sqlalchemy import select
        from app.models.comercio import Producto
        prod = db.scalar(select(Producto).where(Producto.emp_id == s.emp_id, Producto.prd_id == s.prd_id))
        if prod:
            o.prd_nombre = prod.prd_nombre
            o.prd_sku = prod.prd_sku
        out.append(o)
    return out


@router.get("/{prd_id}", response_model=ProductoStockOut)
def get_stock(prd_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = StockRepository(db)
    stock = repo.get(usuario.emp_id, prd_id)
    if not stock:
        raise NotFoundError("STOCK_NOT_FOUND", "Stock no encontrado para este producto. Crea primero el producto.")
    out = _to_out(stock)
    from sqlalchemy import select
    from app.models.comercio import Producto
    prod = db.scalar(select(Producto).where(Producto.emp_id == usuario.emp_id, Producto.prd_id == prd_id))
    if prod:
        out.prd_nombre = prod.prd_nombre
        out.prd_sku = prod.prd_sku
    return out


@router.post("", response_model=ProductoStockOut, status_code=201)
def create_stock(payload: ProductoStockCreate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    # Forzar emp_id del token
    payload.emp_id = usuario.emp_id
    repo = StockRepository(db)
    from app.models.comercio import ProductoStock
    stock = ProductoStock(
        emp_id=payload.emp_id,
        prd_id=payload.prd_id,
        stk_cantidad=payload.stk_cantidad,
        stk_min=payload.stk_min,
        stk_max=payload.stk_max,
        estado=payload.estado,
    )
    created = repo.create_or_update(stock)
    return _to_out(created)


@router.put("/{prd_id}", response_model=ProductoStockOut)
def update_stock(prd_id: str, payload: ProductoStockUpdate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = StockRepository(db)
    stock = repo.get(usuario.emp_id, prd_id)
    if not stock:
        raise NotFoundError("STOCK_NOT_FOUND", "Stock no encontrado.")
    patch = payload.model_dump(exclude_unset=True)
    for k, v in patch.items():
        setattr(stock, k, v)
    db.commit()
    db.refresh(stock)
    return _to_out(stock)


@router.post("/movimiento", response_model=ProductoStockOut)
def movimiento_stock(payload: ProductoStockMovimiento, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    # Forzar emp_id del token
    payload.emp_id = usuario.emp_id
    repo = StockRepository(db)
    stock = repo.ajustar(payload.emp_id, payload.prd_id, payload.delta, motivo=payload.motivo)
    return _to_out(stock)


@router.get("/alertas/bajo-minimo", response_model=list[ProductoStockOut])
def alertas_bajo_minimo(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = StockRepository(db)
    items = repo.list_bajo_minimo(usuario.emp_id)
    out = []
    for s in items:
        o = _to_out(s)
        from sqlalchemy import select
        from app.models.comercio import Producto
        prod = db.scalar(select(Producto).where(Producto.emp_id == s.emp_id, Producto.prd_id == s.prd_id))
        if prod:
            o.prd_nombre = prod.prd_nombre
            o.prd_sku = prod.prd_sku
        out.append(o)
    return out
