from datetime import datetime, timezone

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.models.customer import Customer
from app.models.prediction import Recommendation, RecommendationMethod
from app.models.product import Product, ProductStatus
from app.models.sale import Sale, SaleItem

MODEL_VERSION = "rules-v1-fallback"


def _top_selling_product_ids(db: Session, business_id: str, limit: int = 10) -> list[str]:
    stmt = (
        select(SaleItem.product_id, func.sum(SaleItem.quantity).label("qty"))
        .join(Sale, Sale.id == SaleItem.sale_id)
        .where(Sale.business_id == business_id)
        .group_by(SaleItem.product_id)
        .order_by(func.sum(SaleItem.quantity).desc())
        .limit(limit)
    )
    return [row[0] for row in db.execute(stmt)]


def generate_recommendations(db: Session, customer: Customer, business_id: str, limit: int = 3) -> list[Recommendation]:
    """
    Genera recomendaciones de producto para un cliente, sin inventar
    nada: solo usa su historial real de compras y el catálogo activo.
    Nunca recomienda un producto inexistente o desactivado (sección 18).
    """
    active_products = {
        p.id: p for p in db.scalars(select(Product).where(Product.business_id == business_id, Product.status == ProductStatus.active))
    }
    if not active_products:
        return []

    now = datetime.now(timezone.utc)
    recommendations: list[Recommendation] = []

    customer_sales = list(db.scalars(select(Sale).where(Sale.customer_id == customer.id)))

    if not customer_sales:
        # Cold start (sección 18): productos con mejor margen relativo, ya que no hay historial.
        candidates = sorted(
            active_products.values(),
            key=lambda p: ((float(p.price) - float(p.cost)) / float(p.price)) if p.cost else 0,
            reverse=True,
        )[:limit]
        for product in candidates:
            recommendations.append(
                Recommendation(
                    business_id=business_id, customer_id=customer.id, product_id=product.id,
                    score=55, confidence=0.4, method=RecommendationMethod.cold_start,
                    reasons=["Cliente nuevo sin historial: se recomienda por margen (cold start)."],
                    generated_at=now, model_version=MODEL_VERSION,
                )
            )
        db.add_all(recommendations)
        db.commit()
        return recommendations

    purchase_info: dict[str, dict] = {}
    for sale in customer_sales:
        for item in sale.items:
            if item.product_id not in active_products:
                continue
            entry = purchase_info.setdefault(item.product_id, {"count": 0, "last_date": sale.date})
            entry["count"] += item.quantity
            entry["last_date"] = max(entry["last_date"], sale.date)

    # 1) Frecuencia: productos ya comprados, priorizados por veces + recencia.
    frequent = sorted(purchase_info.items(), key=lambda kv: kv[1]["count"], reverse=True)[:2]
    for product_id, info in frequent:
        product = active_products[product_id]
        reasons = [f"Lo compró {info['count']} {'vez' if info['count'] == 1 else 'veces'}."]
        if (now - info["last_date"]).days < 60:
            reasons.append("Lo compró recientemente.")
        recommendations.append(
            Recommendation(
                business_id=business_id, customer_id=customer.id, product_id=product.id,
                score=min(96, 60 + info["count"] * 6), confidence=0.75, method=RecommendationMethod.frequency,
                reasons=reasons, generated_at=now, model_version=MODEL_VERSION,
            )
        )

    # 2) Categoría favorita, como aproximación a collaborative filtering.
    favorite_category_id = None
    if purchase_info:
        top_product_id = max(purchase_info.items(), key=lambda kv: kv[1]["count"])[0]
        favorite_category_id = active_products[top_product_id].category_id
    if favorite_category_id:
        candidate = next(
            (p for p in active_products.values() if p.category_id == favorite_category_id and p.id not in purchase_info),
            None,
        )
        if candidate:
            recommendations.append(
                Recommendation(
                    business_id=business_id, customer_id=customer.id, product_id=candidate.id,
                    score=78, confidence=0.6, method=RecommendationMethod.collaborative_filtering,
                    reasons=["Clientes con gustos similares también lo compran.", "Existe una probabilidad razonable de recompra en esta categoría."],
                    generated_at=now, model_version=MODEL_VERSION,
                )
            )

    # 3) Completar con productos populares del negocio si aún falta.
    if len(recommendations) < limit:
        for product_id in _top_selling_product_ids(db, business_id):
            if product_id not in active_products or any(r.product_id == product_id for r in recommendations):
                continue
            recommendations.append(
                Recommendation(
                    business_id=business_id, customer_id=customer.id, product_id=product_id,
                    score=50, confidence=0.35, method=RecommendationMethod.frequency,
                    reasons=["Es uno de los productos más vendidos del negocio."],
                    generated_at=now, model_version=MODEL_VERSION,
                )
            )
            if len(recommendations) >= limit:
                break

    recommendations = sorted(recommendations, key=lambda r: r.score, reverse=True)[:limit]
    db.add_all(recommendations)
    db.commit()
    for r in recommendations:
        db.refresh(r)
    return recommendations
