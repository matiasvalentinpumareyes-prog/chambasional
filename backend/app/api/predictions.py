from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.api.pagination import PageParams
from app.core.deps import get_current_user
from app.db.session import get_db
from app.models.empresa import Usuario
from app.models.cliente import Cliente
from app.models.ia import Prediccion
from app.repositories.customer_repo import CustomerRepository
from app.schemas.common import Paginated
from app.schemas.customer import CustomerOut
from app.schemas.recommendation import RecommendationOut, StrategyOut
from app.services import recommendations as recommendations_service
from app.services import strategies as strategies_service
from app.services.customer_view import get_latest_prediction, to_customer_out

router = APIRouter(tags=["predictions"])


@router.get("/predictions/churn", response_model=Paginated[CustomerOut])
def list_at_risk_customers(
    page_params: PageParams = Depends(),
    risk_level: RiskLevel | None = None,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    repo = CustomerRepository(db)
    items, total = repo.list(
        user.business_id, page=page_params.page, page_size=page_params.page_size,
        only_at_risk_group=True, risk_level=risk_level, sort_by="rfm_recency_days", sort_dir="desc",
    )
    return Paginated(items=[to_customer_out(db, c) for c in items], page=page_params.page, page_size=page_params.page_size, total=total)


@router.get("/strategies/today", response_model=list[StrategyOut])
def today_actions(limit: int = Query(default=20, ge=1, le=100), db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    """
    Pantalla '¿A quién contactar hoy?' (sección 39): toma a los clientes
    con predicción de riesgo medio/alto/crítico y consentimiento, genera
    su estrategia y los devuelve priorizados por Recovery Priority Score.
    """
    repo = CustomerRepository(db)
    at_risk_customers, _ = repo.list(
        user.business_id, page=1, page_size=200, only_at_risk_group=True, sort_by="rfm_recency_days", sort_dir="desc",
    )

    strategies_out: list[StrategyOut] = []
    for customer in at_risk_customers:
        if not customer.consent:
            continue
        prediction = get_latest_prediction(db, customer.id)
        if not prediction or prediction.risk_level == RiskLevel.low:
            continue

        recs = recommendations_service.generate_recommendations(db, customer, user.business_id, limit=1)
        top_rec = recs[0] if recs else None
        strategy = strategies_service.build_strategy(db, customer, user.business, prediction, top_rec)

        product_name = ""
        if strategy.recommended_product_id:
            from app.models.comercio import Producto
            product = db.get(Product, strategy.recommended_product_id)
            product_name = product.name if product else ""

        strategies_out.append(
            StrategyOut(
                customer_id=customer.id,
                customer_name=f"{customer.first_name} {customer.last_name}",
                priority_score=strategy.priority_score,
                churn_probability=float(prediction.churn_probability),
                recovery_probability=float(strategy.recovery_probability),
                customer_value=customer.customer_value,
                recommended_product=RecommendationOut(
                    customer_id=customer.id, product_id=top_rec.product_id, product_name=product_name,
                    score=top_rec.score, reasons=top_rec.reasons, confidence=top_rec.confidence,
                    method=top_rec.method, generated_at=top_rec.generated_at, model_version=top_rec.model_version,
                ) if top_rec else None,
                recommended_action=customer.preferred_channel,
                recommended_offer=strategy.recommended_offer,
                recommended_timing=strategy.recommended_timing,
                reason=strategy.reason,
                message=strategy.message,
                cooldown_ok=strategy.cooldown_ok,
                has_consent=customer.consent,
            )
        )

    strategies_out.sort(key=lambda s: s.priority_score, reverse=True)
    return strategies_out[:limit]
