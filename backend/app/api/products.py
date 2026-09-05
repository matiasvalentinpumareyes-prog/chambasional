from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.api.pagination import PageParams
from app.core.deps import get_current_user
from app.core.errors import ConflictError, NotFoundError
from app.db.session import get_db
from app.models.business import User
from app.models.product import Category, Product, ProductStatus
from app.repositories.product_repo import ProductRepository
from app.schemas.common import Paginated
from app.schemas.product import ProductCreate, ProductOut, ProductUpdate

router = APIRouter(prefix="/products", tags=["products"])


def _get_or_create_category(db: Session, business_id: str, name: str) -> Category:
    category = db.scalar(select(Category).where(Category.business_id == business_id, Category.name == name))
    if category:
        return category
    category = Category(business_id=business_id, name=name)
    db.add(category)
    db.flush()
    return category


def _to_out(product: Product) -> ProductOut:
    return ProductOut(
        id=product.id, business_id=product.business_id, sku=product.sku, name=product.name,
        description=product.description, category=product.category_rel.name if product.category_rel else "",
        price=float(product.price), cost=float(product.cost) if product.cost is not None else None,
        stock=product.stock, margin=product.margin_pct, status=product.status,
    )


@router.get("", response_model=Paginated[ProductOut])
def list_products(
    page_params: PageParams = Depends(),
    search: str | None = None,
    status: ProductStatus | None = None,
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    repo = ProductRepository(db)
    items, total = repo.list(user.business_id, page=page_params.page, page_size=page_params.page_size, search=search, status=status)
    return Paginated(items=[_to_out(p) for p in items], page=page_params.page, page_size=page_params.page_size, total=total)


@router.get("/categories", response_model=list[str])
def list_categories(db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    categories = db.scalars(select(Category).where(Category.business_id == user.business_id))
    return sorted({c.name for c in categories})


@router.post("", response_model=ProductOut, status_code=201)
def create_product(payload: ProductCreate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    repo = ProductRepository(db)
    if repo.get_by_sku(user.business_id, payload.sku):
        raise ConflictError("SKU_ALREADY_EXISTS", "Ya existe un producto con este SKU en tu negocio.")

    category = _get_or_create_category(db, user.business_id, payload.category)
    product = Product(
        business_id=user.business_id, category_id=category.id, sku=payload.sku, name=payload.name,
        description=payload.description, price=payload.price, cost=payload.cost, stock=payload.stock, status=payload.status,
    )
    created = repo.create(product)
    return _to_out(created)


@router.put("/{product_id}", response_model=ProductOut)
def update_product(product_id: str, payload: ProductUpdate, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    repo = ProductRepository(db)
    product = repo.get(user.business_id, product_id)
    if not product:
        raise NotFoundError("PRODUCT_NOT_FOUND", "Producto no encontrado.")

    patch = payload.model_dump(exclude_unset=True)
    if "category" in patch:
        category_name = patch.pop("category")
        category = _get_or_create_category(db, user.business_id, category_name)
        patch["category_id"] = category.id

    updated = repo.update(product, patch)
    return _to_out(updated)


@router.delete("/{product_id}", response_model=ProductOut)
def deactivate_product(product_id: str, db: Session = Depends(get_db), user: User = Depends(get_current_user)):
    repo = ProductRepository(db)
    product = repo.get(user.business_id, product_id)
    if not product:
        raise NotFoundError("PRODUCT_NOT_FOUND", "Producto no encontrado.")
    updated = repo.update(product, {"status": ProductStatus.inactive})
    return _to_out(updated)
