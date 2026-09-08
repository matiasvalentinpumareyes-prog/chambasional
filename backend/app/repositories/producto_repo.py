from __future__ import annotations

from sqlalchemy import func, select
from sqlalchemy.orm import Session, selectinload

from app.models.comercio import Categoria, Producto, ProductoMarca, ProductoPrecio, ProductoStock


class ProductoRepository:
    """
    Repositorio comercial — todas las consultas filtran por emp_id (tenant).
    Cubre producto, categoria, marca, precios y stock via relaciones.
    """

    def __init__(self, db: Session):
        self.db = db

    # ---- Categorias ----
    def get_or_create_categoria(self, emp_id: str, cat_nombre: str) -> Categoria:
        categoria = self.db.scalar(select(Categoria).where(Categoria.emp_id == emp_id, Categoria.cat_nombre == cat_nombre))
        if categoria:
            return categoria
        categoria = Categoria(emp_id=emp_id, cat_nombre=cat_nombre)
        self.db.add(categoria)
        self.db.flush()
        return categoria

    def list_categorias(self, emp_id: str) -> list[Categoria]:
        return list(self.db.scalars(select(Categoria).where(Categoria.emp_id == emp_id)))

    # ---- Marcas ----
    def get_or_create_marca(self, emp_id: str, prd_marca_nombre: str) -> ProductoMarca:
        marca = self.db.scalar(select(ProductoMarca).where(ProductoMarca.emp_id == emp_id, ProductoMarca.prd_marca_nombre == prd_marca_nombre))
        if marca:
            return marca
        marca = ProductoMarca(emp_id=emp_id, prd_marca_nombre=prd_marca_nombre)
        self.db.add(marca)
        self.db.flush()
        return marca

    # ---- Productos ----
    def list(
        self,
        emp_id: str,
        *,
        page: int,
        page_size: int,
        search: str | None = None,
        cat_id: str | None = None,
        prd_marca_id: str | None = None,
        estado: int | None = None,
    ) -> tuple[list[Producto], int]:
        stmt = select(Producto).where(Producto.emp_id == emp_id)
        if search:
            like = f"%{search.lower()}%"
            stmt = stmt.where(func.lower(Producto.prd_nombre).like(like) | func.lower(Producto.prd_sku).like(like))
        if cat_id:
            stmt = stmt.where(Producto.cat_id == cat_id)
        if prd_marca_id:
            stmt = stmt.where(Producto.prd_marca_id == prd_marca_id)
        if estado is not None:
            stmt = stmt.where(Producto.estado == estado)

        total = self.db.scalar(select(func.count()).select_from(stmt.subquery())) or 0
        stmt = stmt.order_by(Producto.prd_nombre.asc()).offset((page - 1) * page_size).limit(page_size)
        items = list(self.db.scalars(stmt))
        return items, total

    def get(self, emp_id: str, prd_id: str) -> Producto | None:
        stmt = select(Producto).where(Producto.emp_id == emp_id, Producto.prd_id == prd_id)
        return self.db.scalar(stmt)

    def get_by_sku(self, emp_id: str, prd_sku: str) -> Producto | None:
        if not prd_sku:
            return None
        stmt = select(Producto).where(Producto.emp_id == emp_id, Producto.prd_sku == prd_sku)
        return self.db.scalar(stmt)

    def get_by_codbarra(self, emp_id: str, prd_codbarra: str) -> Producto | None:
        if not prd_codbarra:
            return None
        stmt = select(Producto).where(Producto.emp_id == emp_id, Producto.prd_codbarra == prd_codbarra)
        return self.db.scalar(stmt)

    def create(self, producto: Producto) -> Producto:
        self.db.add(producto)
        self.db.commit()
        self.db.refresh(producto)
        return producto

    def update(self, producto: Producto, patch: dict) -> Producto:
        for key, value in patch.items():
            setattr(producto, key, value)
        self.db.commit()
        self.db.refresh(producto)
        return producto

    def all_active(self, emp_id: str) -> list[Producto]:
        stmt = select(Producto).where(Producto.emp_id == emp_id, Producto.estado == 1)
        return list(self.db.scalars(stmt))
