from datetime import datetime, timedelta, timezone

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.models.campanas import Campaign
from app.models.cliente import Cliente
from app.models.empresa import Usuario
from app.models.producto import Producto
from app.models.ventas import Venta, VentaItem


def compute_dashboard_metrics(db: Session, usuario: Usuario) -> dict:
    emp_id = usuario.emp_id
    # Conteos reales desde BD 44 tablas
    total_customers = db.scalar(select(func.count()).select_from(Cliente).where(Cliente.emp_id == emp_id, Cliente.estado == 1)) or 0
    total_sales_val = db.scalar(select(func.coalesce(func.sum(Venta.ven_total), 0)).where(Venta.emp_id == emp_id)) or 0
    total_sales = round(float(total_sales_val), 2)
    # Campañas si existen
    try:
        active_campaigns = db.scalar(select(func.count()).select_from(Campaign).where(Campaign.emp_id == emp_id, Campaign.estado == 1)) or 0
        finished_campaigns = db.scalar(select(func.count()).select_from(Campaign).where(Campaign.emp_id == emp_id, Campaign.estado == 2)) or 0
    except Exception:
        active_campaigns = 0
        finished_campaigns = 0
    # Métricas simplificadas para no bloquear UI — churn/predicción se calculan en jobs ML aparte
    # Usar clientes como base para data_quality
    without_email = db.scalar(select(func.count()).select_from(Cliente).where(Cliente.emp_id == emp_id, Cliente.cli_email.is_(None))) or 0
    data_quality_score = 100.0
    if total_customers:
        data_quality_score = max(0.0, min(100.0, 100 - (without_email / total_customers) * 15))
    # Intentar contar inactivos (estado 0)
    inactive_customers = db.scalar(select(func.count()).select_from(Cliente).where(Cliente.emp_id == emp_id, Cliente.estado == 0)) or 0
    # Valores placeholder que no rompen frontend — se llenan cuando ML genere predicciones
    return {
        "total_sales": total_sales,
        "total_customers": int(total_customers),
        "active_customers": int(total_customers) - int(inactive_customers),
        "inactive_customers": int(inactive_customers),
        "at_risk_customers": 0,
        "lost_customers": 0,
        "critical_customers": 0,
        "estimated_churn_rate": 0.0,
        "recoverable_customers": 0,
        "total_customer_value": total_sales,
        "avg_ticket": round(total_sales / total_customers, 2) if total_customers else 0.0,
        "avg_purchase_frequency_days": 0.0,
        "recovered_revenue": 0.0,
        "active_campaigns": int(active_campaigns),
        "finished_campaigns": int(finished_campaigns),
        "conversion_rate": 0.0,
        "campaign_roi": None,
        "data_quality_score": round(data_quality_score, 1),
        "currency": "PEN",
    }


def compute_dashboard_series(db: Session, usuario: Usuario) -> dict:
    emp_id = usuario.emp_id
    now = datetime.now(timezone.utc)
    cutoff_30 = now - timedelta(days=30)
    # Ventas últimos 30d y por mes
    ventas = list(db.scalars(select(Venta).where(Venta.emp_id == emp_id)).all())
    clientes = list(db.scalars(select(Cliente).where(Cliente.emp_id == emp_id)).all())
    sales_by_day: dict[str, float] = {}
    sales_by_month: dict[str, float] = {}
    for v in ventas:
        dt = v.created_at or v.updated_at or now
        # asegurar tz aware
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        month_key = dt.strftime("%Y-%m")
        sales_by_month[month_key] = sales_by_month.get(month_key, 0) + float(v.ven_total or 0)
        if dt >= cutoff_30:
            key = dt.strftime("%m-%d")
            sales_by_day[key] = sales_by_day.get(key, 0) + float(v.ven_total or 0)
    new_by_month: dict[str, int] = {}
    for c in clientes:
        dt = c.created_at or now
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        key = dt.strftime("%Y-%m")
        new_by_month[key] = new_by_month.get(key, 0) + 1
    # Top productos por cantidad vendida
    top_products = []
    try:
        top_stmt = (
            select(VentaItem.prd_id, func.sum(VentaItem.cantidad))
            .join(Venta, Venta.ven_id == VentaItem.ven_id)
            .where(Venta.emp_id == emp_id)
            .group_by(VentaItem.prd_id)
            .order_by(func.sum(VentaItem.cantidad).desc())
            .limit(8)
        )
        for prd_id, qty in db.execute(top_stmt):
            prod = db.scalar(select(Producto).where(Producto.emp_id == emp_id, Producto.prd_id == prd_id))
            label = prod.prd_nombre if prod else str(prd_id)[:8]
            top_products.append({"label": label, "value": float(qty)})
    except Exception:
        top_products = []
    # Acorde al backend: devolver todas las series que espera el schema, vacías si no hay datos
    return {
        "sales_by_day": [{"label": k, "value": round(v, 2)} for k, v in sorted(sales_by_day.items())],
        "sales_by_month": [{"label": k, "value": round(v, 2)} for k, v in sorted(sales_by_month.items())][-12:],
        "new_customers_by_month": [{"label": k, "value": v} for k, v in sorted(new_by_month.items())][-12:],
        "lost_customers_by_month": [],
        "recovered_customers_by_month": [],
        "churn_evolution": [],
        "top_products": top_products,
        "segment_distribution": [],
        "revenue_by_segment": [],
    }
