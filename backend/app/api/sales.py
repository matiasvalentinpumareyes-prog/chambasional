from datetime import datetime, timezone

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.pagination import PageParams
from app.core.deps import get_current_user
from app.core.errors import NotFoundError
from app.db.session import get_db
from app.models.business import User
from app.repositories.customer_repo import CustomerRepository
from app.repositories.sale_repo import SaleRepository
from app.schemas.common import Paginated
from app.schemas.sale import SaleCreate, SaleItemOut, SaleOut
from app.services.churn import predict_churn
from app.services.rfm import recalculate_customer_aggregates

router = APIRouter(prefix="/sales", tags=["sales"])


def _to_out(sale) -> SaleOut:
    return SaleOut(
        id=sale.id, business_id=sale.business_id, customer_id=sale.customer_id,
        customer_name=f"{sale.customer.first_name} {sale.customer.last_name}" if hasattr(sale, "customer") and sale.customer else "",
        date=sale.date,
        items=[
            SaleItemOut(product_id=i.product_id, product_name=i.product.name, quantity=i.quantity,
                        unit_price=float(i.unit_price), discount=float(i.discount), subtotal=float(i.subtotal))
            for i in sale.items
        ],
        discount_total=float(sale.discount_total), total=float(sale.total),
        channel=sale.channel, payment_method=sale.payment_method,
    )


@router.get("", response_model=Paginated[SaleOut])
def list_sales(page_params: PageParams = Depends(), customer_id: str | None = None, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    repo = SaleRepository(db)
    items, total = repo.list(user.business_id, page=page_params.page, page_size=page_params.page_size, customer_id=customer_id)
    customer_repo = CustomerRepository(db)
    out = []
    for s in items:
        customer = customer_repo.get(user.business_id, s.customer_id)
        out.append(SaleOut(
            id=s.id, business_id=s.business_id, customer_id=s.customer_id,
            customer_name=f"{customer.first_name} {customer.last_name}" if customer else "",
            date=s.date,
            items=[SaleItemOut(product_id=i.product_id, product_name=i.product.name, quantity=i.quantity,
                                unit_price=float(i.unit_price), discount=float(i.discount), subtotal=float(i.subtotal)) for i in s.items],
            discount_total=float(s.discount_total), total=float(s.total), channel=s.channel, payment_method=s.payment_method,
        ))
    return Paginated(items=out, page=page_params.page, page_size=page_params.page_size, total=total)


@router.post("", response_model=SaleOut, status_code=201)
def create_sale(payload: SaleCreate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    customer_repo = CustomerRepository(db)
    customer = customer_repo.get(user.business_id, payload.customer_id)
    if not customer:
        raise NotFoundError("CUSTOMER_NOT_FOUND", "Cliente no encontrado.")

    sale_repo = SaleRepository(db)
    sale = sale_repo.create_sale_with_items(
        business_id=user.business_id,
        customer=customer,
        items_input=[{"product_id": i.product_id, "quantity": i.quantity, "discount_pct": i.discount_pct} for i in payload.items],
        channel=payload.channel,
        payment_method=payload.payment_method,
        sale_date=datetime.now(timezone.utc),
    )

    # Recalcular métricas del cliente y su predicción de churn inmediatamente
    # (no esperar al job diario, para que el frontend vea el efecto al instante).
    updated_customer = recalculate_customer_aggregates(db, customer)
    predict_churn(db, updated_customer, user.business)

    return SaleOut(
        id=sale.id, business_id=sale.business_id, customer_id=sale.customer_id,
        customer_name=f"{customer.first_name} {customer.last_name}", date=sale.date,
        items=[SaleItemOut(product_id=i.product_id, product_name=i.product.name, quantity=i.quantity,
                            unit_price=float(i.unit_price), discount=float(i.discount), subtotal=float(i.subtotal)) for i in sale.items],
        discount_total=float(sale.discount_total), total=float(sale.total), channel=sale.channel, payment_method=sale.payment_method,
    )
