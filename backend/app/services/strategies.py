from datetime import datetime, timezone

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.business import Business
from app.models.campaign import Communication
from app.models.customer import Customer, CustomerValue
from app.models.prediction import Prediction, Recommendation, RiskLevel, Strategy
from app.models.product import Product

CONFIDENCE_THRESHOLD = 0.3  # sección 75: no recomendar acciones agresivas con baja confianza


def _last_communication_days_ago(db: Session, customer_id: str, reference_date: datetime) -> int | None:
    stmt = (
        select(Communication.sent_at)
        .where(Communication.customer_id == customer_id)
        .order_by(Communication.sent_at.desc())
        .limit(1)
    )
    last_sent = db.scalar(stmt)
    if not last_sent:
        return None
    return (reference_date - last_sent).days


def build_strategy(
    db: Session,
    customer: Customer,
    business: Business,
    prediction: Prediction,
    top_recommendation: Recommendation | None,
    reference_date: datetime | None = None,
) -> Strategy:
    """
    Genera la estrategia de recuperación de un cliente (secciones 20, 21,
    26, 27), incluyendo el Recovery Priority Score y el mensaje
    personalizado, respetando SIEMPRE el consentimiento y el cooldown de
    comunicaciones (secciones 30-31).
    """
    reference_date = reference_date or datetime.now(timezone.utc)

    last_comm_days_ago = _last_communication_days_ago(db, customer.id, reference_date)
    cooldown_ok = last_comm_days_ago is None or last_comm_days_ago >= business.campaign_cooldown_days

    recovery_probability = max(0.05, min(0.95, 1 - float(prediction.churn_probability) * 0.4))
    value_weight = {CustomerValue.high: 1.0, CustomerValue.medium: 0.6, CustomerValue.low: 0.3}[customer.customer_value]
    margin_weight = 0.8 if top_recommendation else 0.5

    priority_raw = float(prediction.churn_probability) * value_weight * recovery_probability * margin_weight
    priority_score = round(min(1.0, priority_raw / 0.4) * 100)

    offer = "Sin oferta (confianza insuficiente)"
    timing = "in_5_days"
    if prediction.confidence >= CONFIDENCE_THRESHOLD:
        if prediction.risk_level == RiskLevel.critical:
            offer = "15% de descuento" if customer.customer_value == CustomerValue.high else "10% de descuento"
            timing = "now"
        elif prediction.risk_level == RiskLevel.high:
            offer = "10% de descuento"
            timing = "today"
        elif prediction.risk_level == RiskLevel.medium:
            offer = "5% de descuento"
            timing = "in_2_days"
        else:
            offer = "Mensaje de agradecimiento, sin descuento"
            timing = "in_5_days"

    if not cooldown_ok:
        timing = "in_5_days"

    recommended_product: Product | None = None
    if top_recommendation:
        recommended_product = db.get(Product, top_recommendation.product_id)

    reasons = list(prediction.reasons)
    if recommended_product:
        reasons.append(f"Ha mostrado interés en {recommended_product.name}.")
    reason_text = " ".join(reasons)

    if customer.consent:
        message = _build_message(customer, recommended_product, offer)
    else:
        message = "No se genera mensaje: el cliente no ha dado consentimiento de comunicaciones."

    strategy = Strategy(
        business_id=business.id,
        customer_id=customer.id,
        prediction_id=prediction.id,
        recommended_product_id=recommended_product.id if recommended_product else None,
        priority_score=priority_score,
        recovery_probability=round(recovery_probability, 2),
        recommended_action=customer.preferred_channel.value,
        recommended_offer=offer,
        recommended_timing=timing,
        reason=reason_text,
        message=message,
        cooldown_ok=cooldown_ok,
        generated_at=reference_date,
        model_version=prediction.model_version,
    )
    db.add(strategy)
    db.commit()
    db.refresh(strategy)
    return strategy


def _build_message(customer: Customer, product: Product | None, offer: str) -> str:
    name = customer.first_name
    if product:
        return (
            f"Hola {name}, hace un tiempo que no te vemos. Sabemos que te gusta {product.name} "
            f"y tenemos {offer.lower()} especial para ti esta semana."
        )
    return f"Hola {name}, hace un tiempo que no te vemos. Tenemos {offer.lower()} especial para ti esta semana."
