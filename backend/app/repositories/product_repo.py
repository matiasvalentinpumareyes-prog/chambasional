from __future__ import annotations

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.models.product import Product, ProductStatus


class ProductRepository:
    def __init__(self, db: Session):
        self.db = db

    def list(
        self,
        business_id: str,
        *,
        page: int,
        page_size: int,
        search: str | None = None,
        category: str | None = None,
        status: ProductStatus | None = None,
    ) -> tuple[list[Product], int]:
        stmt = select(Product).where(Product.business_id == business_id)
        if search:
            like = f"%{search.lower()}%"
            stmt = stmt.where(func.lower(Product.name).like(like) | func.lower(Product.sku).like(like))
        if category:
            stmt = stmt.where(Product.category_id.isnot(None))  # el filtro real por nombre se resuelve en el service
        if status:
            stmt = stmt.where(Product.status == status)

        total = self.db.scalar(select(func.count()).select_from(stmt.subquery())) or 0
        stmt = stmt.order_by(Product.name.asc()).offset((page - 1) * page_size).limit(page_size)
        items = list(self.db.scalars(stmt))
        return items, total

    def get(self, business_id: str, product_id: str) -> Product | None:
        stmt = select(Product).where(Product.business_id == business_id, Product.id == product_id)
        return self.db.scalar(stmt)

    def get_by_sku(self, business_id: str, sku: str) -> Product | None:
        stmt = select(Product).where(Product.business_id == business_id, Product.sku == sku)
        return self.db.scalar(stmt)

    def all_active(self, business_id: str) -> list[Product]:
        stmt = select(Product).where(Product.business_id == business_id, Product.status == ProductStatus.active)
        return list(self.db.scalars(stmt))

    def create(self, product: Product) -> Product:
        self.db.add(product)
        self.db.commit()
        self.db.refresh(product)
        return product

    def update(self, product: Product, patch: dict) -> Product:
        for key, value in patch.items():
            setattr(product, key, value)
        self.db.commit()
        self.db.refresh(product)
        return product
