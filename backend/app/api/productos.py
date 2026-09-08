from decimal import Decimal

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.pagination import PageParams
from app.core.deps import get_current_user
from app.core.errors import ConflictError, NotFoundError
from app.db.session import get_db
from app.models.producto import Categoria, Producto, ProductoPrecio
from app.models.stock import ProductoStock
from app.models.empresa import Usuario
from app.repositories.producto_repo import ProductoRepository
from app.repositories.stock_repo import StockRepository
from app.schemas.producto import ProductoCreate, ProductoOut, ProductoUpdate
from app.schemas.common import Paginated

router = APIRouter(prefix="/products", tags=["products"])


def _get_or_create_categoria(db: Session, emp_id: str, cat_nombre: str) -> Categoria:
    repo = ProductoRepository(db)
    return repo.get_or_create_categoria(emp_id, cat_nombre)


def _to_out(db: Session, producto: Producto) -> ProductoOut:
    # Resolver categoria/marca nombres
    cat_nombre = ""
    marca_nombre = None
    if producto.cat_id:
        cat = db.scalar(select(Categoria).where(Categoria.emp_id == producto.emp_id, Categoria.cat_id == producto.cat_id))
        if cat:
            cat_nombre = cat.cat_nombre
    if producto.prd_marca_id:
        from app.models.producto import ProductoMarca
        marca = db.scalar(select(ProductoMarca).where(ProductoMarca.emp_id == producto.emp_id, ProductoMarca.prd_marca_id == producto.prd_marca_id))
        if marca:
            marca_nombre = marca.prd_marca_nombre

    # Precio vigente (fecha_fin IS NULL)
    precio_vigente = None
    costo_vigente = None
    pp = db.scalar(select(ProductoPrecio).where(ProductoPrecio.emp_id == producto.emp_id, ProductoPrecio.prd_id == producto.prd_id, ProductoPrecio.fecha_fin.is_(None), ProductoPrecio.estado == 1))
    if pp:
        precio_vigente = pp.prd_precios
        costo_vigente = pp.prd_precios_costo

    # Stock
    stock = db.scalar(select(ProductoStock).where(ProductoStock.emp_id == producto.emp_id, ProductoStock.prd_id == producto.prd_id))
    stk_cantidad = stock.stk_cantidad if stock else None

    return ProductoOut(
        emp_id=producto.emp_id,
        cat_id=producto.cat_id,
        prd_marca_id=producto.prd_marca_id,
        prd_sku=producto.prd_sku,
        prd_codbarra=producto.prd_codbarra,
        prd_nombre=producto.prd_nombre,
        prd_descripcion=producto.prd_descripcion,
        prd_id=producto.prd_id,
        estado=producto.estado,
        created_at=producto.created_at,
        updated_at=producto.updated_at,
        categoria_nombre=cat_nombre,
        marca_nombre=marca_nombre,
        precio_vigente=precio_vigente,
        costo_vigente=costo_vigente,
        stk_cantidad=stk_cantidad,
    )


@router.get("", response_model=Paginated[ProductoOut])
def list_productos(
    page_params: PageParams = Depends(),
    search: str | None = None,
    estado: int | None = None,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
):
    repo = ProductoRepository(db)
    items, total = repo.list(usuario.emp_id, page=page_params.page, page_size=page_params.page_size, search=search, estado=estado)
    return Paginated(items=[_to_out(db, p) for p in items], page=page_params.page, page_size=page_params.page_size, total=total)


@router.get("/categorias", response_model=list[str])
def list_categorias(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    categorias = db.scalars(select(Categoria).where(Categoria.emp_id == usuario.emp_id))
    return sorted({c.cat_nombre for c in categorias})


@router.get("/{prd_id}", response_model=ProductoOut)
def get_producto(prd_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = ProductoRepository(db)
    producto = repo.get(usuario.emp_id, prd_id)
    if not producto:
        raise NotFoundError("PRODUCTO_NOT_FOUND", "Producto no encontrado.")
    return _to_out(db, producto)


@router.post("", response_model=ProductoOut, status_code=201)
def create_producto(payload: ProductoCreate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = ProductoRepository(db)
    if payload.prd_sku and repo.get_by_sku(usuario.emp_id, payload.prd_sku):
        raise ConflictError("SKU_ALREADY_EXISTS", "Ya existe un producto con este SKU en tu empresa.")
    if payload.prd_codbarra and repo.get_by_codbarra(usuario.emp_id, payload.prd_codbarra):
        raise ConflictError("CODBARRA_ALREADY_EXISTS", "Ya existe un producto con este código de barras.")

    # Resolver categoria/marca si vienen como IDs o nombres: payload.cat_id puede ser nombre
    cat_id = payload.cat_id
    # Si payload contiene cat_nombre vía prd? En ProductoCreate cat_id es UUID, pero si frontend envía nombre, creamos
    # Para compat, si cat_id no es UUID válido y parece nombre, crear
    if cat_id and len(cat_id) < 36:
        cat = _get_or_create_categoria(db, usuario.emp_id, cat_id)
        cat_id = cat.cat_id

    producto = Producto(
        emp_id=usuario.emp_id,
        cat_id=cat_id,
        prd_marca_id=payload.prd_marca_id,
        prd_sku=payload.prd_sku,
        prd_codbarra=payload.prd_codbarra,
        prd_nombre=payload.prd_nombre,
        prd_descripcion=payload.prd_descripcion,
        estado=payload.estado,
    )
    created = repo.create(producto)

    # Crear stock inicial si se provee via payload? ProductoCreate no trae stock, pero si viene en request extendido
    # Buscar stock en payload dict (compat con frontend que envía stock)
    payload_dict = payload.model_dump()
    # Si frontend envía stock como int, crear producto_stock
    stock_val = payload_dict.get("stk_cantidad") or payload_dict.get("stock")
    if stock_val is not None:
        stock_repo = StockRepository(db)
        stock = ProductoStock(emp_id=usuario.emp_id, prd_id=created.prd_id, stk_cantidad=Decimal(str(stock_val)), stk_min=0)
        stock_repo.create_or_update(stock)

    # Precio inicial si viene precio_vigente
    precio_val = payload_dict.get("precio_vigente") or payload_dict.get("price") or payload_dict.get("prd_precios")
    if precio_val is not None:
        from datetime import datetime, timezone
        pp = ProductoPrecio(emp_id=usuario.emp_id, prd_id=created.prd_id, prd_precios=Decimal(str(precio_val)), fecha_inicio=datetime.now(timezone.utc))
        # costo si viene
        costo_val = payload_dict.get("costo_vigente") or payload_dict.get("cost") or payload_dict.get("prd_precios_costo")
        if costo_val is not None:
            pp.prd_precios_costo = Decimal(str(costo_val))
        db.add(pp)
        db.commit()

    db.refresh(created)
    return _to_out(db, created)


@router.put("/{prd_id}", response_model=ProductoOut)
def update_producto(prd_id: str, payload: ProductoUpdate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = ProductoRepository(db)
    producto = repo.get(usuario.emp_id, prd_id)
    if not producto:
        raise NotFoundError("PRODUCTO_NOT_FOUND", "Producto no encontrado.")

    patch = payload.model_dump(exclude_unset=True)
    # Si prd_sku cambia, validar único
    if "prd_sku" in patch and patch["prd_sku"]:
        existing = repo.get_by_sku(usuario.emp_id, patch["prd_sku"])
        if existing and existing.prd_id != prd_id:
            raise ConflictError("SKU_ALREADY_EXISTS", "SKU ya existe en otro producto.")

    # Manejar categoria nombre
    if "cat_id" in patch and patch["cat_id"] and len(patch["cat_id"]) < 36:
        cat = _get_or_create_categoria(db, usuario.emp_id, patch["cat_id"])
        patch["cat_id"] = cat.cat_id

    updated = repo.update(producto, patch)
    return _to_out(db, updated)


@router.delete("/{prd_id}", response_model=ProductoOut)
def deactivate_producto(prd_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = ProductoRepository(db)
    producto = repo.get(usuario.emp_id, prd_id)
    if not producto:
        raise NotFoundError("PRODUCTO_NOT_FOUND", "Producto no encontrado.")
    updated = repo.update(producto, {"estado": 0})
    return _to_out(db, updated)
