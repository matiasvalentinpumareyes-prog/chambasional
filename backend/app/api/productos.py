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
from app.models.subcategoria import Subcategoria
from app.repositories.producto_repo import ProductoRepository
from app.repositories.stock_repo import StockRepository
from app.schemas.producto import ProductoCreate, ProductoOut, ProductoUpdate
from app.schemas.common import Paginated

router = APIRouter(prefix="/productos", tags=["productos"])
router_legacy = APIRouter(prefix="/products", tags=["products"])


def _get_or_create_categoria(db: Session, emp_id: str, cat_nombre: str) -> Categoria:
    repo = ProductoRepository(db)
    return repo.get_or_create_categoria(emp_id, cat_nombre)


def _to_out(db: Session, producto: Producto) -> ProductoOut:
    # Resolver categoria/subcategoria/marca nombres — DB real: producto solo tiene subcat_id (no cat_id directo), cat via subcategoria
    cat_nombre = ""
    subcat_nombre = None
    marca_nombre = None
    if producto.subcat_id:
        from app.models.subcategoria import Subcategoria
        sub = db.scalar(select(Subcategoria).where(Subcategoria.emp_id == producto.emp_id, Subcategoria.subcat_id == producto.subcat_id))
        if sub:
            subcat_nombre = sub.subcat_nombre
            # cat_nombre via subcategoria.cat_id
            cat = db.scalar(select(Categoria).where(Categoria.emp_id == sub.emp_id, Categoria.cat_id == sub.cat_id))
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
        emp_id=str(producto.emp_id) if producto.emp_id else None,
        cat_id=None,
        subcat_id=str(producto.subcat_id) if producto.subcat_id else None,
        prd_marca_id=str(producto.prd_marca_id) if producto.prd_marca_id else None,
        prd_sku=producto.prd_sku,
        prd_codbarra=producto.prd_codbarra,
        prd_nombre=producto.prd_nombre,
        prd_descripcion=producto.prd_descripcion,
        prd_id=str(producto.prd_id) if producto.prd_id else None,
        estado=producto.estado,
        created_at=producto.created_at,
        updated_at=producto.updated_at,
        categoria_nombre=cat_nombre,
        subcategoria_nombre=subcat_nombre,
        marca_nombre=marca_nombre,
        precio_vigente=precio_vigente,
        costo_vigente=costo_vigente,
        stk_cantidad=stk_cantidad,
    )


@router.get("", response_model=Paginated[ProductoOut])
@router_legacy.get("", response_model=Paginated[ProductoOut], include_in_schema=False)
def list_productos(
    page_params: PageParams = Depends(),
    search: str | None = None,
    cat_id: str | None = None,
    subcat_id: str | None = None,
    estado: int | None = None,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
):
    repo = ProductoRepository(db)
    items, total = repo.list(usuario.emp_id, page=page_params.page, page_size=page_params.page_size, search=search, cat_id=cat_id, subcat_id=subcat_id, estado=estado)
    return Paginated(items=[_to_out(db, p) for p in items], page=page_params.page, page_size=page_params.page_size, total=total)


@router.get("/categorias", response_model=list[str])
@router_legacy.get("/categorias", response_model=list[str], include_in_schema=False)
def list_categorias(db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    categorias = db.scalars(select(Categoria).where(Categoria.emp_id == usuario.emp_id))
    return sorted({c.cat_nombre for c in categorias})


@router.get("/{prd_id}", response_model=ProductoOut)
@router_legacy.get("/{prd_id}", response_model=ProductoOut, include_in_schema=False)
def get_producto(prd_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = ProductoRepository(db)
    producto = repo.get(usuario.emp_id, prd_id)
    if not producto:
        raise NotFoundError("PRODUCTO_NOT_FOUND", "Producto no encontrado.")
    return _to_out(db, producto)


@router.post("", response_model=ProductoOut, status_code=201)
@router_legacy.post("", response_model=ProductoOut, status_code=201, include_in_schema=False)
def create_producto(payload: ProductoCreate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = ProductoRepository(db)
    if payload.prd_sku and repo.get_by_sku(usuario.emp_id, payload.prd_sku):
        raise ConflictError("SKU_ALREADY_EXISTS", "Ya existe un producto con este SKU en tu empresa.")
    if payload.prd_codbarra and repo.get_by_codbarra(usuario.emp_id, payload.prd_codbarra):
        raise ConflictError("CODBARRA_ALREADY_EXISTS", "Ya existe un producto con este código de barras.")

    # Resolver categoria/subcategoria si vienen como nombres
    cat_id = payload.cat_id
    subcat_id = payload.subcat_id
    if cat_id and len(cat_id) < 36:
        cat = _get_or_create_categoria(db, usuario.emp_id, cat_id)
        cat_id = cat.cat_id
    # Validar subcat requiere cat
    if subcat_id and not cat_id:
        raise ConflictError("SUBCAT_REQUIERE_CAT", "subcat_id requiere cat_id (CHECK chk_producto_subcat_requiere_cat)")
    if subcat_id and len(subcat_id) < 36:
        # subcat_nombre viene en lugar de UUID
        if not cat_id:
            raise ConflictError("SUBCAT_REQUIERE_CAT", "Para crear subcategoría por nombre se requiere cat_id")
        from app.repositories.producto_repo import ProductoRepository as PR
        repo_tmp = PR(db)
        sub = repo_tmp.get_or_create_subcategoria(usuario.emp_id, cat_id, subcat_id)
        subcat_id = sub.subcat_id

    producto = Producto(
        emp_id=usuario.emp_id,
        subcat_id=subcat_id,
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
@router_legacy.put("/{prd_id}", response_model=ProductoOut, include_in_schema=False)
def update_producto(prd_id: str, payload: ProductoUpdate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = ProductoRepository(db)
    producto = repo.get(usuario.emp_id, prd_id)
    if not producto:
        raise NotFoundError("PRODUCTO_NOT_FOUND", "Producto no encontrado.")

    patch = payload.model_dump(exclude_unset=True)
    # DB real producto no tiene cat_id; cat solo sirve para resolver subcat
    cat_for_sub = patch.get("cat_id") or (producto.subcat_id and db.scalar(select(Subcategoria.cat_id).where(Subcategoria.emp_id==usuario.emp_id, Subcategoria.subcat_id==producto.subcat_id)))
    # Si prd_sku cambia, validar único
    if "prd_sku" in patch and patch["prd_sku"]:
        existing = repo.get_by_sku(usuario.emp_id, patch["prd_sku"])
        if existing and existing.prd_id != prd_id:
            raise ConflictError("SKU_ALREADY_EXISTS", "SKU ya existe en otro producto.")

    # Manejar categoria/subcategoria nombre — cat solo para crear subcat
    if "cat_id" in patch:
        # cat_id no se guarda en producto, solo se usa para crear subcat si hace falta
        # si cat es nombre (<36), crear categoria
        if patch["cat_id"] and len(str(patch["cat_id"])) < 36:
            cat = _get_or_create_categoria(db, usuario.emp_id, patch["cat_id"])
            patch["cat_id"] = cat.cat_id
        # no persistir cat_id en producto (DB no tiene columna)
        cat_for_sub = patch.pop("cat_id")
    if "subcat_id" in patch and patch["subcat_id"]:
        if not cat_for_sub:
            raise ConflictError("SUBCAT_REQUIERE_CAT", "subcat_id requiere cat_id (DB: producto.subcat_id FK a subcategorias)")
        # Si subcat es nombre, crear
        if len(str(patch["subcat_id"])) < 36:
            from app.repositories.producto_repo import ProductoRepository as PR
            repo_tmp = PR(db)
            sub = repo_tmp.get_or_create_subcategoria(usuario.emp_id, cat_for_sub, patch["subcat_id"])
            patch["subcat_id"] = sub.subcat_id

    updated = repo.update(producto, patch)
    return _to_out(db, updated)


@router.delete("/{prd_id}", response_model=ProductoOut)
@router_legacy.delete("/{prd_id}", response_model=ProductoOut, include_in_schema=False)
def deactivate_producto(prd_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    repo = ProductoRepository(db)
    producto = repo.get(usuario.emp_id, prd_id)
    if not producto:
        raise NotFoundError("PRODUCTO_NOT_FOUND", "Producto no encontrado.")
    updated = repo.update(producto, {"estado": 0})
    return _to_out(db, updated)
