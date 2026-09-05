from __future__ import annotations

from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session

from app.models.customer import ActivityStatus, Customer, CustomerSegment
from app.models.prediction import Prediction, RiskLevel


class CustomerRepository:
    """
    Todas las consultas de este repositorio reciben business_id como
    parámetro OBLIGATORIO y lo aplican como filtro WHERE. Esto es lo que
    garantiza el aislamiento multi-tenant desde el backend (sección 33):
    un negocio jamás puede leer datos de otro, sin importar lo que pida
    el frontend.
    """

    def __init__(self, db: Session):
        self.db = db

    def list(
        self,
        business_id: str,
        *,
        page: int,
        page_size: int,
        search: str | None = None,
        segment: CustomerSegment | None = None,
        activity_status: ActivityStatus | None = None,
        risk_level: RiskLevel | None = None,
        only_at_risk_group: bool = False,
        sort_by: str = "total_spend",
        sort_dir: str = "desc",
    ) -> tuple[list[Customer], int]:
        stmt = select(Customer).where(Customer.business_id == business_id)

        if search:
            like = f"%{search.lower()}%"
            stmt = stmt.where(
                or_(
                    func.lower(Customer.first_name + " " + Customer.last_name).like(like),
                    func.lower(Customer.email).like(like),
                )
            )
        if segment:
            stmt = stmt.where(Customer.segment == segment)
        if activity_status:
            stmt = stmt.where(Customer.activity_status == activity_status)
        if only_at_risk_group:
            stmt = stmt.where(
                Customer.activity_status.in_([ActivityStatus.at_risk, ActivityStatus.dormant, ActivityStatus.lost])
            )

        if risk_level:
            # El riesgo vive en la última predicción del cliente; se filtra con un subquery correlacionado.
            latest_pred = (
                select(Prediction.risk_level)
                .where(Prediction.customer_id == Customer.id)
                .order_by(Prediction.prediction_date.desc())
                .limit(1)
                .correlate(Customer)
                .scalar_subquery()
            )
            stmt = stmt.where(latest_pred == risk_level)

        total = self.db.scalar(select(func.count()).select_from(stmt.subquery())) or 0

        sort_column = getattr(Customer, sort_by, Customer.total_spend)
        stmt = stmt.order_by(sort_column.desc() if sort_dir == "desc" else sort_column.asc())
        stmt = stmt.offset((page - 1) * page_size).limit(page_size)

        items = list(self.db.scalars(stmt))
        return items, total

    def get(self, business_id: str, customer_id: str) -> Customer | None:
        stmt = select(Customer).where(Customer.business_id == business_id, Customer.id == customer_id)
        return self.db.scalar(stmt)

    def get_by_email(self, business_id: str, email: str) -> Customer | None:
        stmt = select(Customer).where(Customer.business_id == business_id, Customer.email == email)
        return self.db.scalar(stmt)

    def all_for_business(self, business_id: str) -> list[Customer]:
        stmt = select(Customer).where(Customer.business_id == business_id)
        return list(self.db.scalars(stmt))

    def create(self, customer: Customer) -> Customer:
        self.db.add(customer)
        self.db.commit()
        self.db.refresh(customer)
        return customer

    def update(self, customer: Customer, patch: dict) -> Customer:
        for key, value in patch.items():
            setattr(customer, key, value)
        self.db.commit()
        self.db.refresh(customer)
        return customer
