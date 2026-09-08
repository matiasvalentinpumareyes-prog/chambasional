import random
from datetime import datetime, timedelta, timezone

from app.core.security import hash_password
from app.db.session import SessionLocal
from app.models.business import Business, User, UserRole
from app.models.customer import ActivityStatus, Channel, Customer, CustomerSegment, CustomerValue
from app.models.product import Category, Product, ProductStatus
from app.models.sale import PaymentMethod, Sale, SaleItem
from app.services.churn import predict_churn_batch, train_churn_model
from app.services.rfm import recalculate_customer_aggregates

SEED = 20260101
random.seed(SEED)

TODAY = datetime(2026, 9, 3, tzinfo=timezone.utc)

FIRST_NAMES = [
    "Carlos", "Maria", "Juan", "Ana", "Luis", "Rosa", "Jorge", "Carmen", "Pedro", "Lucia",
    "Miguel", "Elena", "Diego", "Paola", "Andres", "Valeria", "Fernando", "Camila", "Ricardo",
    "Daniela", "Javier", "Gabriela", "Raul", "Fiorella", "Alberto", "Milagros", "Sergio",
    "Patricia", "Manuel", "Karen", "Eduardo", "Diana", "Oscar", "Vanessa", "Martin", "Claudia",
]
LAST_NAMES = [
    "Garcia", "Rodriguez", "Perez", "Lopez", "Sanchez", "Ramirez", "Flores", "Vargas",
    "Castillo", "Torres", "Rojas", "Chavez", "Mendoza", "Cruz", "Reyes", "Gutierrez",
    "Ortiz", "Silva", "Romero", "Herrera", "Medina", "Aguilar", "Campos", "Vega",
]
CITIES = ["Lima", "Arequipa", "Trujillo", "Cusco", "Piura", "Chiclayo", "Huancayo", None]
CHANNELS = list(Channel)

CATEGORIES_PRODUCTS = {
    "Cafe y bebidas": ["Cafe Americano", "Cafe Premium", "Cappuccino", "Latte Vainilla", "Te Verde", "Chocolate Caliente"],
    "Panaderia": ["Croissant", "Pan Integral", "Baguette", "Pan de Yema", "Rosca Dulce"],
    "Reposteria": ["Cheesecake", "Brownie", "Alfajor", "Torta de Chocolate", "Muffin de Arandanos"],
    "Snacks": ["Mix de Frutos Secos", "Papas Artesanales", "Galletas de Avena", "Barra Energetica"],
    "Desayunos": ["Desayuno Andino", "Sandwich de Pollo", "Tostadas Francesas", "Bowl de Frutas"],
    "Almuerzos": ["Menu Ejecutivo", "Ensalada Cesar", "Wrap de Pollo", "Bowl Proteico"],
    "Bebidas frias": ["Limonada", "Frappe de Cafe", "Jugo Natural", "Smoothie de Fresa"],
    "Combos": ["Combo Desayuno", "Combo Tarde de Cafe", "Combo Oficina"],
    "Merchandising": ["Taza de la Casa", "Bolsa de Cafe en Grano 250g"],
}

PROFILE_WEIGHTS = [
    ("vip_active", 6), ("loyal_active", 18), ("new", 14), ("at_risk", 16),
    ("dormant", 14), ("lost", 18), ("one_time", 14),
]
PROFILE_INTERVAL_RANGE = {
    "vip_active": (7, 15), "loyal_active": (14, 30), "new": (15, 40), "at_risk": (20, 45),
    "dormant": (25, 60), "lost": (15, 35), "one_time": (9999, 9999),
}


def weighted_choice(items):
    total = sum(w for _, w in items)
    r = random.uniform(0, total)
    upto = 0
    for item, w in items:
        upto += w
        if upto >= r:
            return item
    return items[-1][0]


def create_business_and_admin(db) -> Business:
    business = Business(name="Cafe La Espiga (Demo)", currency="PEN", timezone="America/Lima")
    db.add(business)
    db.flush()

    admin = User(
        business_id=business.id, name="Administrador Demo", email="admin@demo.com",
        hashed_password=hash_password("Demo12345"), role=UserRole.admin,
    )
    db.add(admin)
    db.commit()
    db.refresh(business)
    print(f"Negocio creado: {business.name} (id={business.id})")
    print("Usuario admin: admin@demo.com / Demo12345")
    return business


def create_products(db, business_id: str) -> list[Product]:
    products = []
    for category_name, product_names in CATEGORIES_PRODUCTS.items():
        category = Category(business_id=business_id, name=category_name)
        db.add(category)
        db.flush()
        for idx, name in enumerate(product_names):
            cost = round(random.uniform(1.5, 12), 2)
            price = round(cost * random.uniform(1.6, 2.6), 2)
            product = Product(
                business_id=business_id, category_id=category.id,
                sku=f"SKU-{category_name[:3].upper()}-{idx}", name=name,
                description=f"{name} - categoria {category_name}", price=price, cost=cost,
                stock=random.randint(10, 200),
                status=ProductStatus.inactive if random.random() < 0.05 else ProductStatus.active,
            )
            db.add(product)
            products.append(product)
    db.commit()
    for p in products:
        db.refresh(p)
    print(f"Productos creados: {len(products)}")
    return products


def create_customers_and_sales(db, business_id: str, products: list[Product], count: int = 1200):
    active_products = [p for p in products if p.status == ProductStatus.active]
    total_sales = 0

    for i in range(1, count + 1):
        first = random.choice(FIRST_NAMES)
        last = random.choice(LAST_NAMES)
        registered_days_ago = random.randint(60, 730)
        registered_at = TODAY - timedelta(days=registered_days_ago)

        profile = weighted_choice(PROFILE_WEIGHTS)
        min_int, max_int = PROFILE_INTERVAL_RANGE[profile]
        avg_interval = 0 if profile == "one_time" else random.randint(min_int, max_int)
        favorite_category_id = random.choice(products).category_id
        favorite_products = [p for p in active_products if p.category_id == favorite_category_id] or active_products

        purchase_dates = []
        if profile == "one_time":
            days_ago = random.randint(5, min(registered_days_ago, 400))
            purchase_dates.append(TODAY - timedelta(days=days_ago))
        else:
            multiplier = {
                "vip_active": (0.3, 1.1), "loyal_active": (0.3, 1.1), "new": (0.3, 1.1),
                "at_risk": (1.3, 2.2), "dormant": (2.5, 5), "lost": (5, 12),
            }[profile]
            last_gap_mult = random.uniform(*multiplier)
            days_since_last = min(round(avg_interval * last_gap_mult), max(registered_days_ago - 1, 1))
            cursor = TODAY - timedelta(days=max(days_since_last, 1))
            purchase_dates.append(cursor)

            max_history = random.randint(3, 40)
            for _ in range(max_history):
                jitter = random.uniform(0.6, 1.4)
                gap = max(3, round(avg_interval * jitter))
                cursor = cursor - timedelta(days=gap)
                if cursor < registered_at:
                    break
                purchase_dates.append(cursor)

        purchase_dates.sort()

        email = None if random.random() < 0.12 else f"{first.lower()}.{last.lower()}{i}@correo.com"
        consent = random.random() < 0.88

        customer = Customer(
            business_id=business_id, first_name=first, last_name=last, email=email,
            phone=None if random.random() < 0.05 else f"9{random.randint(10000000, 99999999)}",
            city=random.choice(CITIES), registered_at=registered_at,
            preferred_channel=random.choice(CHANNELS), consent=consent,
        )
        db.add(customer)
        db.flush()

        for date in purchase_dates:
            n_items = random.randint(1, 3)
            items = []
            discount_total = 0.0
            total = 0.0
            for _ in range(n_items):
                use_favorite = favorite_products and random.random() < 0.6
                product = random.choice(favorite_products if use_favorite else active_products)
                quantity = random.randint(1, 3)
                discount_pct = random.uniform(0.05, 0.15) if random.random() < 0.2 else 0
                subtotal = round(float(product.price) * quantity * (1 - discount_pct), 2)
                discount = round(float(product.price) * quantity * discount_pct, 2)
                items.append(SaleItem(product_id=product.id, quantity=quantity, unit_price=product.price, discount=discount, subtotal=subtotal))
                discount_total += discount
                total += subtotal

            sale = Sale(
                business_id=business_id, customer_id=customer.id, date=date,
                channel=random.choice(CHANNELS), payment_method=random.choice(list(PaymentMethod) + [None]),
                discount_total=round(discount_total, 2), total=round(total, 2), items=items,
            )
            db.add(sale)
            total_sales += 1

        if i % 200 == 0:
            db.commit()
            print(f"  {i}/{count} clientes procesados...")

    db.commit()
    print(f"Clientes creados: {count}, ventas creadas: {total_sales}")


def recalculate_all_metrics(db, business):
    customers = db.query(Customer).filter(Customer.business_id == business.id).all()
    for idx, customer in enumerate(customers, 1):
        recalculate_customer_aggregates(db, customer, reference_date=TODAY)
        if idx % 200 == 0:
            print(f"  RFM recalculado para {idx}/{len(customers)} clientes...")
    print("RFM y segmentación recalculados para todos los clientes.")


def train_and_predict(db, business):
    model_version = train_churn_model(db, business.id, reference_date=TODAY)
    print(f"Modelo de churn: {model_version.model_name} v{model_version.version} (status={model_version.status.value})")

    customers = db.query(Customer).filter(Customer.business_id == business.id).all()
    predictions = predict_churn_batch(db, business, customers, reference_date=TODAY)
    print(f"Predicciones de churn generadas para {len(predictions)} clientes.")


def main():
    db = SessionLocal()
    try:
        existing = db.query(Business).filter(Business.name == "Cafe La Espiga (Demo)").first()
        if existing:
            print("El negocio demo ya existe. Elimina la base de datos o cambia el nombre si quieres regenerarlo.")
            return

        business = create_business_and_admin(db)
        products = create_products(db, business.id)
        create_customers_and_sales(db, business.id, products, count=1200)
        recalculate_all_metrics(db, business)
        train_and_predict(db, business)
        print("\nSeed completado con éxito.")
    finally:
        db.close()


if __name__ == "__main__":
    main()
