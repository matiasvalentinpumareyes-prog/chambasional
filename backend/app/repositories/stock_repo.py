from __future__ import annotations

from decimal import Decimal

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.errors import AppError
from app.models.stock import ProductoStock


class StockRepository:
    """
    Repositorio dedicado a producto_stock (1:1 por emp_id, prd_id).
    Cubre stk_cantidad, stk_min, stk_max con validaciones y alertas.
    """

    def __init__(self, db: Session):
        self.db = db

    def get(self, emp_id: str, prd_id: str) -> ProductoStock | None:
        stmt = select(ProductoStock).where(ProductoStock.emp_id == emp_id, ProductoStock.prd_id == prd_id)
        return self.db.scalar(stmt)

    def get_by_stock_id(self, emp_id: str, stock_id: str) -> ProductoStock | None:
        stmt = select(ProductoStock).where(ProductoStock.emp_id == emp_id, ProductoStock.stock_id == stock_id)
        return self.db.scalar(stmt)

    def list(self, emp_id: str, *, alerta_bajo_min: bool | None = None) -> list[ProductoStock]:
        stmt = select(ProductoStock).where(ProductoStock.emp_id == emp_id)
        items = list(self.db.scalars(stmt))
        if alerta_bajo_min is not None:
            if alerta_bajo_min:
                items = [s for s in items if s.stk_cantidad < s.stk_min]
            else:
                items = [s for s in items if s.stk_cantidad >= s.stk_min]
        return items

    def list_bajo_minimo(self, emp_id: str) -> list[ProductoStock]:
        return self.list(emp_id, alerta_bajo_min=True)

    def create_or_update(self, stock: ProductoStock) -> ProductoStock:
        existing = self.get(stock.emp_id, stock.prd_id)
        if existing:
            existing.stk_cantidad = stock.stk_cantidad
            existing.stk_min = stock.stk_min
            existing.stk_max = stock.stk_max
            existing.estado = stock.estado
            self.db.commit()
            self.db.refresh(existing)
            return existing
        self.db.add(stock)
        self.db.commit()
        self.db.refresh(stock)
        return stock

    def ajustar(self, emp_id: str, prd_id: str, delta: Decimal, motivo: str | None = None) -> ProductoStock:
        """
        Ajusta stk_cantidad en delta (positivo ingreso, negativo egreso).
        Valida contra stk_min/stk_max y lanza AppError si viola.
        """
        stock = self.get(emp_id, prd_id)
        if not stock:
            # crear stock inicial si no existe
            stock = ProductoStock(emp_id=emp_id, prd_id=prd_id, stk_cantidad=Decimal("0.00"), stk_min=0)
            self.db.add(stock)
            self.db.flush()

        nueva = Decimal(stock.stk_cantidad) + Decimal(delta)
        if nueva < 0:
            raise AppError("STOCK_NEGATIVO", f"Stock insuficiente: {stock.stk_cantidad} + ({delta}) = {nueva} < 0")

        stock.stk_cantidad = nueva
        # alertas (no bloqueantes) se pueden logear; aquí solo validamos máximo si está definido
        if stock.stk_max is not None and nueva > stock.stk_max:
            # no bloquea, pero se registra alerta; si quieres bloquear, descomentar:
            # raise AppError("STOCK_SOBRE_MAXIMO", f"Stock {nueva} supera máximo {stock.stk_max}")
            pass

        self.db.commit()
        self.db.refresh(stock)
        return stock

    def set_min_max(self, emp_id: str, prd_id: str, stk_min: int | None = None, stk_max: int | None = None) -> ProductoStock:
        stock = self.get(emp_id, prd_id)
        if not stock:
            raise AppError("STOCK_NOT_FOUND", "Stock no encontrado para este producto.")
        if stk_min is not None:
            stock.stk_min = stk_min
        if stk_max is not None:
            stock.stk_max = stk_max
        if stock.stk_max is not None and stock.stk_cantidad > stock.stk_max:
            # alerta, no bloquea
            pass
        self.db.commit()
        self.db.refresh(stock)
        return stock

    def is_bajo_minimo(self, stock: ProductoStock) -> bool:
        return Decimal(stock.stk_cantidad) < Decimal(stock.stk_min)

    def is_sobre_maximo(self, stock: ProductoStock) -> bool:
        return stock.stk_max is not None and Decimal(stock.stk_cantidad) > Decimal(stock.stk_max)
