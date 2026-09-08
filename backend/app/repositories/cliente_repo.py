from __future__ import annotations

from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session

from app.models.cliente import Cliente


class ClienteRepository:
    """
    Repositorio para cliente — aislamiento multi-tenant obligatorio por emp_id (DATABASE.md:187).
    Toda consulta filtra WHERE emp_id = :emp_id.
    """

    def __init__(self, db: Session):
        self.db = db

    def list(
        self,
        emp_id: str,
        *,
        page: int,
        page_size: int,
        search: str | None = None,
        doc_id: str | None = None,
        estado: int | None = None,
    ) -> tuple[list[Cliente], int]:
        stmt = select(Cliente).where(Cliente.emp_id == emp_id)
        if search:
            like = f"%{search.lower()}%"
            stmt = stmt.where(
                or_(
                    func.lower(Cliente.cli_nombre_razon_social).like(like),
                    func.lower(Cliente.cli_email).like(like),
                    func.lower(Cliente.cli_ndocumento).like(like),
                )
            )
        if doc_id:
            stmt = stmt.where(Cliente.doc_id == doc_id)
        if estado is not None:
            stmt = stmt.where(Cliente.estado == estado)

        total = self.db.scalar(select(func.count()).select_from(stmt.subquery())) or 0
        stmt = stmt.order_by(Cliente.created_at.desc()).offset((page - 1) * page_size).limit(page_size)
        items = list(self.db.scalars(stmt))
        return items, total

    def get(self, emp_id: str, cli_id: str) -> Cliente | None:
        stmt = select(Cliente).where(Cliente.emp_id == emp_id, Cliente.cli_id == cli_id)
        return self.db.scalar(stmt)

    def get_by_email(self, emp_id: str, cli_email: str) -> Cliente | None:
        stmt = select(Cliente).where(Cliente.emp_id == emp_id, Cliente.cli_email == cli_email)
        return self.db.scalar(stmt)

    def get_by_documento(self, emp_id: str, doc_id: str, cli_ndocumento: str) -> Cliente | None:
        stmt = select(Cliente).where(Cliente.emp_id == emp_id, Cliente.doc_id == doc_id, Cliente.cli_ndocumento == cli_ndocumento)
        return self.db.scalar(stmt)

    def all_for_empresa(self, emp_id: str) -> list[Cliente]:
        stmt = select(Cliente).where(Cliente.emp_id == emp_id)
        return list(self.db.scalars(stmt))

    def create(self, cliente: Cliente) -> Cliente:
        self.db.add(cliente)
        self.db.commit()
        self.db.refresh(cliente)
        return cliente

    def update(self, cliente: Cliente, patch: dict) -> Cliente:
        for key, value in patch.items():
            setattr(cliente, key, value)
        self.db.commit()
        self.db.refresh(cliente)
        return cliente

    def deactivate(self, cliente: Cliente) -> Cliente:
        cliente.estado = 0
        self.db.commit()
        self.db.refresh(cliente)
        return cliente
