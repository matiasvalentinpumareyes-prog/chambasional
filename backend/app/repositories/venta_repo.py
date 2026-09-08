from __future__ import annotations

from datetime import datetime
from decimal import Decimal

from sqlalchemy import func, select
from sqlalchemy.orm import Session, selectinload

from app.core.errors import AppError
from app.models.comercio import Producto
from app.models.ventas import Venta, VentaItem
from app.models.cliente import Cliente
from app.repositories.stock_repo import StockRepository


class VentaRepository:
    """
    Repositorio ventas — aislamiento por emp_id, transacciones atómicas con stock.
    """

    def __init__(self, db: Session):
        self.db = db
        self.stock_repo = StockRepository(db)

    def list(self, emp_id: str, *, page: int, page_size: int, cli_id: str | None = None) -> tuple[list[Venta], int]:
        stmt = select(Venta).where(Venta.emp_id == emp_id).options(selectinload(Venta.items))
        if cli_id:
            stmt = stmt.where(Venta.cli_id == cli_id)
        total = self.db.scalar(select(func.count()).select_from(stmt.subquery())) or 0
        stmt = stmt.order_by(Venta.created_at.desc()).offset((page - 1) * page_size).limit(page_size)
        items = list(self.db.scalars(stmt))
        return items, total

    def list_for_cliente(self, emp_id: str, cli_id: str) -> list[Venta]:
        stmt = select(Venta).where(Venta.emp_id == emp_id, Venta.cli_id == cli_id).options(selectinload(Venta.items)).order_by(Venta.created_at.desc())
        return list(self.db.scalars(stmt))

    def get(self, emp_id: str, venta_id: str) -> Venta | None:
        stmt = select(Venta).where(Venta.emp_id == emp_id, Venta.venta_id == venta_id).options(selectinload(Venta.items))
        return self.db.scalar(stmt)

    def create_venta_with_items(
        self,
        emp_id: str,
        cliente: Cliente,
        items_input: list[dict],
        mtp_id: str | None,
        cupon_id: str | None,
        venta_origen: str | None,
        venta_fecha: datetime | None = None,
    ) -> Venta:
        """
        Crea ventas + venta_items en una transacción y descuenta stock.
        items_input: [{prd_id, cantidad, precio_unitario?, descuento?}]
        Si algo falla, rollback total (no queda venta huérfana).
        """
        if not items_input:
            raise AppError("VENTA_SIN_ITEMS", "La venta debe tener al menos un item.")

        venta_items: list[VentaItem] = []
        ven_descuento = Decimal("0.00")
        ven_total = Decimal("0.00")

        for it in items_input:
            prd_id = it["prd_id"]
            cantidad = Decimal(str(it["cantidad"]))
            if cantidad <= 0:
                raise AppError("CANTIDAD_INVALIDA", f"Cantidad debe ser >0 para prd_id {prd_id}")

            producto: Producto | None = self.db.scalar(select(Producto).where(Producto.emp_id == emp_id, Producto.prd_id == prd_id))
            if not producto or producto.emp_id != emp_id:
                raise AppError("PRODUCTO_NOT_FOUND", f"Producto {prd_id} no existe en emp_id {emp_id}")
            if producto.estado != 1:
                raise AppError("PRODUCTO_INACTIVO", f"Producto '{producto.prd_nombre}' está inactivo (estado={producto.estado})")

            # Validar stock
            stock = self.stock_repo.get(emp_id, prd_id)
            stock_cantidad = Decimal(stock.stk_cantidad) if stock else Decimal("0.00")
            if stock and stock_cantidad < cantidad:
                raise AppError("STOCK_INSUFICIENTE", f"Stock insuficiente para '{producto.prd_nombre}': disponible {stock_cantidad}, solicitado {cantidad}")

            # Precio: si no viene precio_unitario, buscar en producto_precios vigente (fecha_fin IS NULL)
            precio_unitario = it.get("precio_unitario")
            if precio_unitario is None:
                from app.models.comercio import ProductoPrecio
                precio_row = self.db.scalar(select(ProductoPrecio).where(ProductoPrecio.emp_id == emp_id, ProductoPrecio.prd_id == prd_id, ProductoPrecio.fecha_fin.is_(None), ProductoPrecio.estado == 1))
                precio_unitario = Decimal(precio_row.prd_precios) if precio_row else Decimal("0.00")
            else:
                precio_unitario = Decimal(str(precio_unitario))

            descuento = Decimal(str(it.get("descuento", "0.00")))
            subtotal = (precio_unitario * cantidad) - descuento
            if subtotal < 0:
                subtotal = Decimal("0.00")

            # Costo unitario para margen (opcional)
            costo_unitario = it.get("costo_unitario")
            costo_unitario = Decimal(str(costo_unitario)) if costo_unitario is not None else None

            venta_items.append(
                VentaItem(
                    emp_id=emp_id,
                    prd_id=prd_id,
                    cantidad=cantidad,
                    precio_unitario=precio_unitario,
                    descuento=descuento,
                    subtotal=subtotal,
                    costo_unitario=costo_unitario,
                )
            )
            ven_descuento += descuento
            ven_total += subtotal

        venta = Venta(
            emp_id=emp_id,
            cli_id=cliente.cli_id,
            ven_descuento=ven_descuento,
            ven_total=ven_total,
            mtp_id=mtp_id,
            cupon_id=cupon_id,
            venta_origen=venta_origen or "internal",
        )
        # Asignar items antes de flush para cascada
        venta.items = venta_items

        try:
            self.db.add(venta)
            self.db.flush()  # genera venta_id para FKs
            # Descontar stock después de validar, dentro de la misma transacción
            for vi in venta_items:
                self.stock_repo.ajustar(emp_id, vi.prd_id, Decimal(vi.cantidad) * Decimal("-1"), motivo=f"venta {venta.venta_id}")
            self.db.commit()
        except AppError:
            self.db.rollback()
            raise
        except Exception as e:
            self.db.rollback()
            raise AppError("VENTA_ERROR", f"Error creando venta: {e}")

        self.db.refresh(venta)
        return venta
