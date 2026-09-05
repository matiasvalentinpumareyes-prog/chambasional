from __future__ import annotations

from sqlalchemy import func, select
from sqlalchemy.orm import Session, selectinload

from app.core.errors import AppError
from app.models.customer import Customer
from app.models.product import Product, ProductStatus
from app.models.sale import Sale, SaleItem


class SaleRepository:
    def __init__(self, db: Session):
        self.db = db

    def list(self, business_id: str, *, page: int, page_size: int, customer_id: str | None = None) -> tuple[list[Sale], int]:
        stmt = select(Sale).where(Sale.business_id == business_id).options(selectinload(Sale.items))
        if customer_id:
            stmt = stmt.where(Sale.customer_id == customer_id)
        total = self.db.scalar(select(func.count()).select_from(stmt.subquery())) or 0
        stmt = stmt.order_by(Sale.date.desc()).offset((page - 1) * page_size).limit(page_size)
        items = list(self.db.scalars(stmt))
        return items, total

    def list_for_customer(self, business_id: str, customer_id: str) -> list[Sale]:
        stmt = (
            select(Sale)
            .where(Sale.business_id == business_id, Sale.customer_id == customer_id)
            .options(selectinload(Sale.items))
            .order_by(Sale.date.desc())
        )
        return list(self.db.scalars(stmt))

    def create_sale_with_items(
        self,
        business_id: str,
        customer: Customer,
        items_input: list[dict],
        channel: str,
        payment_method: str | None,
        sale_date,
    ) -> Sale:
        """
        Crea una venta y sus items dentro de una única transacción
        (sección 55): si algo falla, no debe quedar una venta sin items
        o con totales inconsistentes.
        """
        sale_items: list[SaleItem] = []
        discount_total = 0.0
        total = 0.0

        for item_input in items_input:
            product: Product | None = self.db.get(Product, item_input["product_id"])
            if not product or product.business_id != business_id:
                raise AppError("PRODUCT_NOT_FOUND", "Uno de los productos no existe en este negocio.")
            if product.status != ProductStatus.active:
                raise AppError("PRODUCT_INACTIVE", f"El producto '{product.name}' está inactivo y no puede venderse.")

            quantity = item_input["quantity"]
            discount_pct = item_input.get("discount_pct", 0)
            unit_price = float(product.price)
            subtotal = round(unit_price * quantity * (1 - discount_pct), 2)
            discount = round(unit_price * quantity * discount_pct, 2)

            sale_items.append(
                SaleItem(product_id=product.id, quantity=quantity, unit_price=unit_price, discount=discount, subtotal=subtotal)
            )
            discount_total += discount
            total += subtotal

        sale = Sale(
            business_id=business_id,
            customer_id=customer.id,
            date=sale_date,
            channel=channel,
            payment_method=payment_method,
            discount_total=round(discount_total, 2),
            total=round(total, 2),
            items=sale_items,
        )

        try:
            self.db.add(sale)
            self.db.flush()  # asegura que sale.id exista antes de continuar, dentro de la misma transacción
            self.db.commit()
        except Exception:
            self.db.rollback()
            raise

        self.db.refresh(sale)
        return sale
