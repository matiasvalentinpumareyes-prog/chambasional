from datetime import datetime, timezone

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.cliente import Cliente
from app.models.ventas import Venta


def _quintile(value: float, thresholds: list[float]) -> int:
    score = 1
    for t in thresholds:
        if value >= t:
            score += 1
    return min(score, 5)


def compute_rfm_for_customer(customer: Customer, reference_date: datetime) -> dict:
    """Calcula R, F, M para un cliente a partir de sus métricas agregadas."""
    recency_days = (
        (reference_date - customer.last_purchase_at).days if customer.last_purchase_at else 9999
    )
    frequency = customer.purchase_count
    monetary = float(customer.total_spend)

    r = 6 - _quintile(recency_days, [15, 30, 60, 120])
    f = _quintile(frequency, [2, 4, 7, 12])
    m = _quintile(monetary, [50, 150, 400, 900])

    return {"recency_days": recency_days, "frequency": frequency, "monetary": monetary, "r": max(1, r), "f": f, "m": m}


def segment_from_rfm(rfm: dict, purchase_count: int, registered_days_ago: int) -> CustomerSegment:
    r, f, m = rfm["r"], rfm["f"], rfm["m"]
    if purchase_count == 0:
        return CustomerSegment.new
    if registered_days_ago <= 30 and purchase_count <= 2:
        return CustomerSegment.new
    if r <= 1 and f <= 2:
        return CustomerSegment.lost
    if r == 2 and f <= 3:
        return CustomerSegment.dormant
    if r <= 2 and f >= 3:
        return CustomerSegment.at_risk
    if r >= 4 and f >= 4 and m >= 4:
        return CustomerSegment.vip
    if m >= 4 and f <= 3:
        return CustomerSegment.high_value
    if f >= 4 and r >= 3:
        return CustomerSegment.loyal
    if f >= 3:
        return CustomerSegment.frequent
    if m <= 2 and f <= 2:
        return CustomerSegment.low_value
    return CustomerSegment.potential


def customer_value_from_rfm(rfm: dict) -> CustomerValue:
    score = rfm["m"] + rfm["f"]
    if score >= 7:
        return CustomerValue.high
    if score >= 4:
        return CustomerValue.medium
    return CustomerValue.low


def compute_activity_status(customer: Customer, rfm: dict) -> ActivityStatus:
    """
    Clasifica al cliente usando SU PROPIO intervalo promedio de compra
    (sección 12), no un umbral fijo como "30 días = perdido".
    """
    if customer.purchase_count == 0:
        return ActivityStatus.active
    if customer.purchase_count == 1 or not customer.avg_interval_days:
        # Cold start (sección 46): sin intervalo individual confiable, regla general conservadora.
        if rfm["recency_days"] > 90:
            return ActivityStatus.lost
        if rfm["recency_days"] > 45:
            return ActivityStatus.at_risk
        return ActivityStatus.active

    ratio = rfm["recency_days"] / customer.avg_interval_days
    if ratio <= 1.3:
        return ActivityStatus.active
    if ratio <= 2.2:
        return ActivityStatus.at_risk
    if ratio <= 4:
        return ActivityStatus.dormant
    return ActivityStatus.lost


def recalculate_customer_aggregates(db: Session, customer: Customer, reference_date: datetime | None = None) -> Customer:
    """
    Recalcula purchase_count, total_spend, avg_ticket, avg_interval_days,
    RFM, segmento, valor y estado de actividad de UN cliente, a partir de
    su historial real de ventas. Se llama después de registrar una venta
    nueva y también desde el job diario (sección 25).
    """
    reference_date = reference_date or datetime.now(timezone.utc)

    sales = list(
        db.scalars(
            select(Sale).where(Sale.customer_id == customer.id).order_by(Sale.date.asc())
        )
    )

    purchase_count = len(sales)
    total_spend = round(sum(float(s.total) for s in sales), 2)
    avg_ticket = round(total_spend / purchase_count, 2) if purchase_count else 0.0
    last_purchase_at = sales[-1].date if sales else None

    avg_interval_days = None
    if purchase_count > 1:
        dates = [s.date for s in sales]
        gaps = [(dates[i] - dates[i - 1]).days for i in range(1, len(dates))]
        gaps = [g for g in gaps if g > 0]
        if gaps:
            avg_interval_days = round(sum(gaps) / len(gaps))

    customer.purchase_count = purchase_count
    customer.total_spend = total_spend
    customer.avg_ticket = avg_ticket
    customer.last_purchase_at = last_purchase_at
    customer.avg_interval_days = avg_interval_days

    rfm = compute_rfm_for_customer(customer, reference_date)
    registered_days_ago = (reference_date - customer.registered_at).days

    customer.rfm_recency_days = rfm["recency_days"]
    customer.rfm_frequency = rfm["frequency"]
    customer.rfm_monetary = rfm["monetary"]
    customer.rfm_r = rfm["r"]
    customer.rfm_f = rfm["f"]
    customer.rfm_m = rfm["m"]
    customer.segment = segment_from_rfm(rfm, purchase_count, registered_days_ago)
    customer.customer_value = customer_value_from_rfm(rfm)
    customer.activity_status = compute_activity_status(customer, rfm)

    db.commit()
    db.refresh(customer)
    return customer
