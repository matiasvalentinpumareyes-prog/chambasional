from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models.customer import Customer
from app.models.prediction import Prediction
from app.schemas.customer import ChurnOut, CustomerOut, NextPurchaseOut, RFMOut


def get_latest_prediction(db: Session, customer_id: str) -> Prediction | None:
    stmt = select(Prediction).where(Prediction.customer_id == customer_id).order_by(Prediction.prediction_date.desc()).limit(1)
    return db.scalar(stmt)


def to_customer_out(db: Session, customer: Customer) -> CustomerOut:
    prediction = get_latest_prediction(db, customer.id)

    churn = None
    next_purchase = None
    if prediction:
        churn = ChurnOut(
            customer_id=customer.id,
            churn_probability=float(prediction.churn_probability),
            churn_score=prediction.churn_score,
            risk_level=prediction.risk_level,
            prediction_date=prediction.prediction_date,
            model_version=prediction.model_version,
            reasons=prediction.reasons,
            confidence=prediction.confidence,
        )
        next_purchase = NextPurchaseOut(
            expected_next_purchase_date=prediction.expected_next_purchase_date,
            days_until_expected_purchase=prediction.days_until_expected_purchase,
            purchase_probability=prediction.purchase_probability,
            confidence=prediction.confidence,
        )

    rfm = RFMOut(
        recency_days=customer.rfm_recency_days,
        frequency=customer.rfm_frequency,
        monetary=float(customer.rfm_monetary),
        r=customer.rfm_r,
        f=customer.rfm_f,
        m=customer.rfm_m,
    )

    return CustomerOut(
        id=customer.id,
        business_id=customer.business_id,
        first_name=customer.first_name,
        last_name=customer.last_name,
        email=customer.email,
        phone=customer.phone,
        birth_date=customer.birth_date,
        city=customer.city,
        preferred_channel=customer.preferred_channel,
        consent=customer.consent,
        status=customer.status,
        registered_at=customer.registered_at,
        last_purchase_at=customer.last_purchase_at,
        purchase_count=customer.purchase_count,
        total_spend=float(customer.total_spend),
        avg_ticket=float(customer.avg_ticket),
        avg_interval_days=customer.avg_interval_days,
        segment=customer.segment,
        customer_value=customer.customer_value,
        activity_status=customer.activity_status,
        rfm=rfm,
        churn=churn,
        next_purchase=next_purchase,
    )
