from datetime import datetime, timedelta, timezone

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.models.empresa import Empresa
from app.models.campanas import Campaign
from app.models.cliente import Cliente
from app.models.ia import Prediccion
from app.models.comercio import Producto
from app.models.ventas import Venta, VentaItem


def compute_dashboard_metrics(db: Session, business: Business) -> dict:
    customers = list(db.scalars(select(Customer).where(Customer.business_id == business.id)))
    sales = list(db.scalars(select(Sale).where(Sale.business_id == business.id)))
    campaigns = list(db.scalars(select(Campaign).where(Campaign.business_id == business.id)))

    total_sales = round(sum(float(s.total) for s in sales), 2)
    active_customers = sum(1 for c in customers if c.activity_status == ActivityStatus.active)
    at_risk_customers = sum(1 for c in customers if c.activity_status == ActivityStatus.at_risk)
    lost_customers = sum(1 for c in customers if c.activity_status == ActivityStatus.lost)
    inactive_customers = sum(1 for c in customers if c.status.value == "inactive")

    latest_predictions: dict[str, Prediction] = {}
    stmt = select(Prediction).order_by(Prediction.prediction_date.desc())
    for p in db.scalars(stmt.where(Prediction.business_id == business.id)):
        latest_predictions.setdefault(p.customer_id, p)

    critical_customers = sum(1 for p in latest_predictions.values() if p.risk_level == RiskLevel.critical)
    high_or_critical = sum(1 for p in latest_predictions.values() if p.risk_level in (RiskLevel.high, RiskLevel.critical))
    estimated_churn_rate = high_or_critical / len(latest_predictions) if latest_predictions else 0.0

    recoverable_customers = sum(
        1 for c in customers if c.activity_status in (ActivityStatus.at_risk, ActivityStatus.dormant) and c.consent
    )
    total_customer_value = round(sum(float(c.total_spend) for c in customers), 2)
    purchases = sum(c.purchase_count for c in customers)
    avg_ticket = round(total_customer_value / purchases, 2) if purchases else 0.0
    intervals = [c.avg_interval_days for c in customers if c.avg_interval_days]
    avg_purchase_frequency_days = round(sum(intervals) / len(intervals), 1) if intervals else 0.0

    finished_campaigns = sum(1 for c in campaigns if c.status == CampaignStatus.finished)
    active_campaigns = sum(1 for c in campaigns if c.status == CampaignStatus.active)

    without_email = sum(1 for c in customers if not c.email)
    data_quality_score = 100.0
    if customers:
        data_quality_score = max(0.0, min(100.0, 100 - (without_email / len(customers)) * 15))

    return {
        "total_sales": total_sales,
        "total_customers": len(customers),
        "active_customers": active_customers,
        "inactive_customers": inactive_customers,
        "at_risk_customers": at_risk_customers,
        "lost_customers": lost_customers,
        "critical_customers": critical_customers,
        "estimated_churn_rate": round(estimated_churn_rate, 3),
        "recoverable_customers": recoverable_customers,
        "total_customer_value": total_customer_value,
        "avg_ticket": avg_ticket,
        "avg_purchase_frequency_days": avg_purchase_frequency_days,
        "recovered_revenue": 0.0,  # se completa cuando existen campañas finalizadas con recuperación registrada
        "active_campaigns": active_campaigns,
        "finished_campaigns": finished_campaigns,
        "conversion_rate": 0.0,
        "campaign_roi": None,
        "data_quality_score": round(data_quality_score, 1),
        "currency": business.currency,
    }


def compute_dashboard_series(db: Session, business: Business) -> dict:
    sales = list(db.scalars(select(Sale).where(Sale.business_id == business.id)))
    customers = list(db.scalars(select(Customer).where(Customer.business_id == business.id)))

    now = datetime.now(timezone.utc)
    cutoff_30 = now - timedelta(days=30)

    sales_by_day: dict[str, float] = {}
    sales_by_month: dict[str, float] = {}
    for s in sales:
        if s.date >= cutoff_30:
            key = s.date.strftime("%m-%d")
            sales_by_day[key] = sales_by_day.get(key, 0) + float(s.total)
        month_key = s.date.strftime("%Y-%m")
        sales_by_month[month_key] = sales_by_month.get(month_key, 0) + float(s.total)

    new_by_month: dict[str, int] = {}
    for c in customers:
        key = c.registered_at.strftime("%Y-%m")
        new_by_month[key] = new_by_month.get(key, 0) + 1

    top_products_stmt = (
        select(SaleItem.product_id, func.sum(SaleItem.quantity))
        .join(Sale, Sale.id == SaleItem.sale_id)
        .where(Sale.business_id == business.id)
        .group_by(SaleItem.product_id)
        .order_by(func.sum(SaleItem.quantity).desc())
        .limit(8)
    )
    top_products = []
    for product_id, qty in db.execute(top_products_stmt):
        product = db.get(Product, product_id)
        if product:
            top_products.append({"label": product.name, "value": float(qty)})

    segment_counts: dict[str, int] = {}
    revenue_by_segment: dict[str, float] = {}
    for c in customers:
        seg = c.segment.value
        segment_counts[seg] = segment_counts.get(seg, 0) + 1
        revenue_by_segment[seg] = revenue_by_segment.get(seg, 0) + float(c.total_spend)

    return {
        "sales_by_day": [{"label": k, "value": round(v, 2)} for k, v in sorted(sales_by_day.items())],
        "sales_by_month": [{"label": k, "value": round(v, 2)} for k, v in sorted(sales_by_month.items())][-12:],
        "new_customers_by_month": [{"label": k, "value": v} for k, v in sorted(new_by_month.items())][-12:],
        "top_products": top_products,
        "segment_distribution": [{"label": k, "value": v} for k, v in segment_counts.items()],
        "revenue_by_segment": sorted(
            [{"label": k, "value": round(v, 2)} for k, v in revenue_by_segment.items()], key=lambda x: -x["value"]
        ),
    }
