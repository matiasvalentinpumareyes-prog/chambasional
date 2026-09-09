"""API subcategorias — módulo separado para control de subcategorias.

Tabla: subcategorias (subcat_id, emp_id, cat_id, subcat_nombre, subcat_descripcion)
Separado de categorias y producto para control independiente (producto principal).
Nombres exactos BD: subcat_id, cat_id, emp_id.
"""
from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.pagination import PageParams
from app.core.deps import get_current_user
from app.core.errors import ConflictError, NotFoundError
from app.db.session import get_db
from app.models.empresa import Usuario
from app.models.subcategoria import Subcategoria
from app.schemas.common import Paginated
from app.schemas.subcategoria import SubcategoriaCreate, SubcategoriaOut, SubcategoriaUpdate
from app.repositories.producto_repo import ProductoRepository

router = APIRouter(prefix="/subcategorias", tags=["subcategorias"])


def _to_out(sub: Subcategoria, cat_nombre: str | None = None) -> SubcategoriaOut:
    return SubcategoriaOut(
        emp_id=str(sub.emp_id) if sub.emp_id else None,
        cat_id=str(sub.cat_id) if sub.cat_id else None,
        subcat_nombre=sub.subcat_nombre,
        subcat_descripcion=sub.subcat_descripcion,
        subcat_id=str(sub.subcat_id) if sub.subcat_id else None,
        estado=sub.estado,
        created_at=sub.created_at,
        updated_at=sub.updated_at,
        categoria_nombre=cat_nombre,
    )


@router.get("", response_model=Paginated[SubcategoriaOut])
def list_subcategorias(
    page_params: PageParams = Depends(),
    cat_id: str | None = Query(None, description="Filtrar por categorias.cat_id"),
    search: str | None = Query(None, description="Buscar por subcat_nombre"),
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
):
    stmt = select(Subcategoria).where(Subcategoria.emp_id == usuario.emp_id)
    if cat_id:
        # Validar UUID para no lanzar 500 si cat_id es "xxx"
        try:
            import uuid

            uuid.UUID(cat_id)
        except Exception:
            # cat_id inválido -> retornar vacío en vez de 500
            return Paginated(items=[], page=page_params.page, page_size=page_params.page_size, total=0)
        stmt = stmt.where(Subcategoria.cat_id == cat_id)
    if search:
        from sqlalchemy import func
        like = f"%{search.lower()}%"
        stmt = stmt.where(func.lower(Subcategoria.subcat_nombre).like(like))

    # Conteo
    from sqlalchemy import func as _func
    total = db.scalar(select(_func.count()).select_from(stmt.subquery())) or 0
    stmt = stmt.order_by(Subcategoria.subcat_nombre.asc()).offset((page_params.page - 1) * page_params.page_size).limit(page_params.page_size)
    items = list(db.scalars(stmt))

    # Resolver categoria_nombre
    out = []
    for s in items:
        cat_nombre = None
        if s.cat_id:
            from app.models.producto import Categoria
            cat = db.scalar(select(Categoria).where(Categoria.emp_id == s.emp_id, Categoria.cat_id == s.cat_id))
            if cat:
                cat_nombre = cat.cat_nombre
        out.append(_to_out(s, cat_nombre))
    return Paginated(items=out, page=page_params.page, page_size=page_params.page_size, total=total)


@router.get("/{subcat_id}", response_model=SubcategoriaOut)
def get_subcategoria(subcat_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    sub = db.scalar(select(Subcategoria).where(Subcategoria.emp_id == usuario.emp_id, Subcategoria.subcat_id == subcat_id))
    if not sub:
        raise NotFoundError("SUBCATEGORIA_NOT_FOUND", "Subcategoría no encontrada.")
    cat_nombre = None
    from app.models.producto import Categoria
    cat = db.scalar(select(Categoria).where(Categoria.emp_id == sub.emp_id, Categoria.cat_id == sub.cat_id))
    if cat:
        cat_nombre = cat.cat_nombre
    return _to_out(sub, cat_nombre)


@router.post("", response_model=SubcategoriaOut, status_code=201)
def create_subcategoria(payload: SubcategoriaCreate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    # Forzar emp_id del token
    payload.emp_id = usuario.emp_id
    # Validar cat_id pertenece a emp_id
    from app.models.producto import Categoria
    cat = db.scalar(select(Categoria).where(Categoria.emp_id == payload.emp_id, Categoria.cat_id == payload.cat_id))
    if not cat:
        raise NotFoundError("CATEGORIA_NOT_FOUND", f"Categoria cat_id {payload.cat_id} no existe para emp_id {payload.emp_id}")

    # Validar unicidad (cat_id, subcat_nombre)
    existing = db.scalar(select(Subcategoria).where(Subcategoria.cat_id == payload.cat_id, Subcategoria.subcat_nombre == payload.subcat_nombre))
    if existing:
        raise ConflictError("SUBCATEGORIA_EXISTS", f"Ya existe subcategoría '{payload.subcat_nombre}' en cat_id {payload.cat_id}")

    sub = Subcategoria(
        emp_id=payload.emp_id,
        cat_id=payload.cat_id,
        subcat_nombre=payload.subcat_nombre,
        subcat_descripcion=payload.subcat_descripcion,
        estado=payload.estado,
    )
    db.add(sub)
    db.commit()
    db.refresh(sub)
    return _to_out(sub, cat.cat_nombre)


@router.put("/{subcat_id}", response_model=SubcategoriaOut)
def update_subcategoria(subcat_id: str, payload: SubcategoriaUpdate, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    sub = db.scalar(select(Subcategoria).where(Subcategoria.emp_id == usuario.emp_id, Subcategoria.subcat_id == subcat_id))
    if not sub:
        raise NotFoundError("SUBCATEGORIA_NOT_FOUND", "Subcategoría no encontrada.")
    patch = payload.model_dump(exclude_unset=True)
    # Si cambia cat_id, validar que existe y que no viola UNIQUE
    if "cat_id" in patch and patch["cat_id"]:
        from app.models.producto import Categoria
        cat = db.scalar(select(Categoria).where(Categoria.emp_id == usuario.emp_id, Categoria.cat_id == patch["cat_id"]))
        if not cat:
            raise NotFoundError("CATEGORIA_NOT_FOUND", "Categoría no existe.")
    if "subcat_nombre" in patch and patch["subcat_nombre"]:
        # validar unicidad en nuevo cat_id (o actual)
        check_cat_id = patch.get("cat_id", sub.cat_id)
        existing = db.scalar(select(Subcategoria).where(Subcategoria.cat_id == check_cat_id, Subcategoria.subcat_nombre == patch["subcat_nombre"], Subcategoria.subcat_id != subcat_id))
        if existing:
            raise ConflictError("SUBCATEGORIA_EXISTS", "Nombre ya existe en esa categoría.")
    for k, v in patch.items():
        setattr(sub, k, v)
    db.commit()
    db.refresh(sub)
    from app.models.producto import Categoria
    cat = db.scalar(select(Categoria).where(Categoria.emp_id == sub.emp_id, Categoria.cat_id == sub.cat_id))
    return _to_out(sub, cat.cat_nombre if cat else None)


@router.delete("/{subcat_id}", response_model=SubcategoriaOut)
def delete_subcategoria(subcat_id: str, db: Session = Depends(get_db), usuario: Usuario = Depends(get_current_user)):
    sub = db.scalar(select(Subcategoria).where(Subcategoria.emp_id == usuario.emp_id, Subcategoria.subcat_id == subcat_id))
    if not sub:
        raise NotFoundError("SUBCATEGORIA_NOT_FOUND", "Subcategoría no encontrada.")
    # Verificar que no tenga productos asociados (evitar FK error)
    from app.models.producto import Producto
    prod = db.scalar(select(Producto).where(Producto.emp_id == usuario.emp_id, Producto.subcat_id == subcat_id).limit(1))
    if prod:
        from app.core.errors import ConflictError as CE
        raise CE("SUBCATEGORIA_EN_USO", f"No se puede eliminar: tiene productos asociados (ej. {prod.prd_nombre})")
    # Soft delete: estado 0
    sub.estado = 0
    db.commit()
    db.refresh(sub)
    from app.models.producto import Categoria
    cat = db.scalar(select(Categoria).where(Categoria.emp_id == sub.emp_id, Categoria.cat_id == sub.cat_id))
    return _to_out(sub, cat.cat_nombre if cat else None)
