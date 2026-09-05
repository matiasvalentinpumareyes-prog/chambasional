from datetime import datetime, timezone

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.api.pagination import PageParams
from app.core.deps import get_current_user
from app.core.errors import NotFoundError
from app.db.session import get_db
from app.models.business import User
from app.models.customer import ActivityStatus, Customer, CustomerSegment
from app.models.prediction import RiskLevel
from app.repositories.customer_repo import CustomerRepository
from app.repositories.sale_repo import SaleRepository
from app.schemas.common import Paginated
from app.schemas.customer import CustomerCreate, CustomerOut, CustomerUpdate
from app.schemas.recommendation import RecommendationOut, StrategyOut
from app.schemas.sale import SaleOut
from app.services import recommendations as recommendations_service
from app.services import strategies as strategies_service
from app.services.customer_view import get_latest_prediction, to_customer_out

router = APIRouter(prefix="/customers", tags=["customers"])


@router.get("", response_model=Paginated[CustomerOut])
def list_customers(
    page_params: PageParams = Depends(),
    search: str | None = None,
    segment: CustomerSegment | None = None,
    activity_status: ActivityStatus | None = None,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    repo = CustomerRepository(db)
    items, total = repo.list(
        user.business_id, page=page_params.page, page_size=page_params.page_size,
        search=search, segment=segment, activity_status=activity_status,
    )
    return Paginated(items=[to_customer_out(db, c) for c in items], page=page_params.page, page_size=page_params.page_size, total=total)


@router.get("/{customer_id}", response_model=CustomerOut)
def get_customer(customer_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    customer = CustomerRepository(db).get(user.business_id, customer_id)
    if not customer:
        raise NotFoundError("CUSTOMER_NOT_FOUND", "Cliente no encontrado.")
    return to_customer_out(db, customer)


@router.post("", response_model=CustomerOut, status_code=201)
def create_customer(payload: CustomerCreate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    customer = Customer(
        business_id=user.business_id,
        first_name=payload.first_name,
        last_name=payload.last_name,
        email=payload.email,
        phone=payload.phone,
        birth_date=payload.birth_date,
        city=payload.city,
        preferred_channel=payload.preferred_channel,
        consent=payload.consent,
        registered_at=datetime.now(timezone.utc),
    )
    created = CustomerRepository(db).create(customer)
    return to_customer_out(db, created)


@router.put("/{customer_id}", response_model=CustomerOut)
def update_customer(customer_id: str, payload: CustomerUpdate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    repo = CustomerRepository(db)
    customer = repo.get(user.business_id, customer_id)
    if not customer:
        raise NotFoundError("CUSTOMER_NOT_FOUND", "Cliente no encontrado.")
    patch = {k: v for k, v in payload.model_dump(exclude_unset=True).items()}
    updated = repo.update(customer, patch)
    return to_customer_out(db, updated)


@router.delete("/{customer_id}", response_model=CustomerOut)
def deactivate_customer(customer_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    repo = CustomerRepository(db)
    customer = repo.get(user.business_id, customer_id)
    if not customer:
        raise NotFoundError("CUSTOMER_NOT_FOUND", "Cliente no encontrado.")
    updated = repo.update(customer, {"status": "inactive"})
    return to_customer_out(db, updated)


@router.get("/{customer_id}/sales", response_model=list[SaleOut])
def get_customer_sales(customer_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    customer = CustomerRepository(db).get(user.business_id, customer_id)
    if not customer:
        raise NotFoundError("CUSTOMER_NOT_FOUND", "Cliente no encontrado.")
    sales = SaleRepository(db).list_for_customer(user.business_id, customer_id)
    return [
        SaleOut(
            id=s.id, business_id=s.business_id, customer_id=s.customer_id,
            customer_name=f"{customer.first_name} {customer.last_name}", date=s.date,
            items=[{
                "product_id": i.product_id, "product_name": i.product.name, "quantity": i.quantity,
                "unit_price": float(i.unit_price), "discount": float(i.discount), "subtotal": float(i.subtotal),
            } for i in s.items],
            discount_total=float(s.discount_total), total=float(s.total), channel=s.channel, payment_method=s.payment_method,
        )
        for s in sales
    ]


@router.get("/{customer_id}/recommendations", response_model=list[RecommendationOut])
def get_customer_recommendations(customer_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    customer = CustomerRepository(db).get(user.business_id, customer_id)
    if not customer:
        raise NotFoundError("CUSTOMER_NOT_FOUND", "Cliente no encontrado.")
    from app.models.product import Product
    recs = recommendations_service.generate_recommendations(db, customer, user.business_id)
    return [
        RecommendationOut(
            customer_id=r.customer_id, product_id=r.product_id,
            product_name=(db.get(Product, r.product_id).name if db.get(Product, r.product_id) else ""),
            score=r.score, reasons=r.reasons, confidence=r.confidence, method=r.method,
            generated_at=r.generated_at, model_version=r.model_version,
        )
        for r in recs
    ]


@router.get("/{customer_id}/strategy", response_model=StrategyOut | None)
def get_customer_strategy(customer_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    customer = CustomerRepository(db).get(user.business_id, customer_id)
    if not customer:
        raise NotFoundError("CUSTOMER_NOT_FOUND", "Cliente no encontrado.")
    prediction = get_latest_prediction(db, customer.id)
    if not prediction:
        return None

    recs = recommendations_service.generate_recommendations(db, customer, user.business_id, limit=1)
    top_rec = recs[0] if recs else None

    strategy = strategies_service.build_strategy(db, customer, user.business, prediction, top_rec)
    product_name = ""
    if strategy.recommended_product_id:
        from app.models.product import Product
        product = db.get(Product, strategy.recommended_product_id)
        product_name = product.name if product else ""

    return StrategyOut(
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
