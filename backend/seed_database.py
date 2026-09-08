"""Seed dinámico

Usa tablas reales: empresa, cliente, producto, ventas, metodos_pago, canales_marketing, documento, etc.
No hardcodea enums: cualquier nuevo método de pago/canal/segmento añadido en BD se usa automáticamente.
"""
import random
from datetime import datetime, timedelta, timezone

from sqlalchemy import select

from app.core.security import hash_password
from app.db.session import SessionLocal
from app.models.catalogs import CanalMarketing, Documento, MetodoPago, Segmento
from app.models.cliente import Cliente
from app.models.comercio import Categoria, Producto, ProductoPrecio, ProductoStock
from app.models.empresa import Empresa, Usuario, UsuarioPersonal
from app.models.ventas import Venta, VentaItem

SEED = 20260101
random.seed(SEED)
TODAY = datetime(2026, 9, 3, tzinfo=timezone.utc)

FIRST_NAMES = ["Carlos", "Maria", "Juan", "Ana", "Luis", "Rosa", "Jorge", "Carmen", "Pedro", "Lucia", "Miguel", "Elena", "Diego", "Paola", "Andres", "Valeria", "Fernando", "Camila", "Ricardo", "Daniela", "Javier", "Gabriela", "Raul", "Fiorella", "Alberto", "Milagros", "Sergio", "Patricia", "Manuel", "Karen", "Eduardo", "Diana", "Oscar", "Vanessa", "Martin", "Claudia"]
LAST_NAMES = ["Garcia", "Rodriguez", "Perez", "Lopez", "Sanchez", "Ramirez", "Flores", "Vargas", "Castillo", "Torres", "Rojas", "Chavez", "Mendoza", "Cruz", "Reyes", "Gutierrez", "Ortiz", "Silva", "Romero", "Herrera", "Medina", "Aguilar", "Campos", "Vega"]
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


def get_or_create_documento(db, doc_tipo="DNI"):
    doc = db.scalar(select(Documento).where(Documento.doc_tipo == doc_tipo))
    if doc:
        return doc
    doc = Documento(doc_tipo=doc_tipo, doc_descripcion=doc_tipo, estado=1)
    db.add(doc)
    db.commit()
    db.refresh(doc)
    return doc


def create_empresa_and_admin(db) -> Empresa:
    # Buscar o crear empresa demo
    emp = db.scalar(select(Empresa).where(Empresa.emp_ruc == "20123456789"))
    if emp:
        print(f"Empresa demo ya existe: {emp.emp_nombre_comercial} ({emp.emp_id})")
        return emp

    emp = Empresa(emp_ruc="20123456789", emp_razon_social="Cafe La Espiga Demo SA", emp_nombre_comercial="Cafe La Espiga (Demo)", emp_email="demo@regresape.com", estado=1)
    db.add(emp)
    db.commit()
    db.refresh(emp)

    # Rol
    from app.models.catalogs import Rol
    rol = db.scalar(select(Rol).where(Rol.rol_codigo == "ADMIN_EMPRESA"))
    if not rol:
        rol = Rol(rol_codigo="ADMIN_EMPRESA", rol_nombre="Administrador", estado=1)
        db.add(rol)
        db.commit()
        db.refresh(rol)

    usp = UsuarioPersonal(emp_id=emp.emp_id, usp_nombres="Administrador Demo", usp_dni="00000001", estado=1)
    db.add(usp)
    db.commit()
    db.refresh(usp)

    existente = db.scalar(select(Usuario).where(Usuario.emp_id == emp.emp_id, Usuario.usu_email == "admin@demo.com"))
    if existente:
        print("Usuario admin ya existe")
        return emp

    admin = Usuario(emp_id=emp.emp_id, usu_usuario="admin_demo", usu_email="admin@demo.com", usu_password_hash=hash_password("Demo12345"), rol_id=rol.rol_id, usp_id=usp.usp_id, estado=1)
    db.add(admin)
    db.commit()
    print(f"Empresa creada: {emp.emp_nombre_comercial} ({emp.emp_id})")
    print("Usuario admin: admin@demo.com / Demo12345 (usu_usuario=admin_demo)")
    return emp


def create_productos(db, emp_id: str):
    productos = []
    for cat_nombre, nombres in CATEGORIES_PRODUCTS.items():
        cat = db.scalar(select(Categoria).where(Categoria.emp_id == emp_id, Categoria.cat_nombre == cat_nombre))
        if not cat:
            cat = Categoria(emp_id=emp_id, cat_nombre=cat_nombre, estado=1)
            db.add(cat)
            db.commit()
            db.refresh(cat)
        for idx, nombre in enumerate(nombres):
            existing = db.scalar(select(Producto).where(Producto.emp_id == emp_id, Producto.prd_sku == f"SKU-{cat_nombre[:3].upper()}-{idx}"))
            if existing:
                productos.append(existing)
                continue
            prod = Producto(emp_id=emp_id, cat_id=cat.cat_id, prd_sku=f"SKU-{cat_nombre[:3].upper()}-{idx}", prd_nombre=nombre, prd_descripcion=f"{nombre} - {cat_nombre}", estado=1)
            db.add(prod)
            db.commit()
            db.refresh(prod)
            # precio vigente
            costo = round(random.uniform(1.5, 12), 2)
            precio = round(costo * random.uniform(1.6, 2.6), 2)
            pp = ProductoPrecio(emp_id=emp_id, prd_id=prod.prd_id, prd_precios=precio, prd_precios_costo=costo, prd_precios_undmedida="UND", fecha_inicio=datetime.now(timezone.utc), estado=1)
            db.add(pp)
            # stock
            stock = ProductoStock(emp_id=emp_id, prd_id=prod.prd_id, stk_cantidad=random.randint(10, 200), stk_min=5, stk_max=500, estado=1)
            db.add(stock)
            db.commit()
            productos.append(prod)
    print(f"Productos: {len(productos)}")
    return productos


def create_clientes_y_ventas(db, emp_id: str, productos, count=300):
    # Catálogos dinámicos — no hardcode
    canales = db.scalars(select(CanalMarketing).where(CanalMarketing.estado == 1)).all()
    metodos = db.scalars(select(MetodoPago).where(MetodoPago.estado == 1)).all()
    doc_dni = get_or_create_documento(db, "DNI")
    # fallback si no hay canales/metodos
    if not canales:
        print("WARN: no hay canales_marketing, crea uno generico")
        canales = [type("obj", (), {"can_id": None})()]
    if not metodos:
        print("WARN: no hay metodos_pago, ventas se crean sin mtp_id")

    total_ventas = 0
    for i in range(1, count + 1):
        first = random.choice(FIRST_NAMES)
        last = random.choice(LAST_NAMES)
        email = None if random.random() < 0.12 else f"{first.lower()}.{last.lower()}{i}@correo.com"
        cli = Cliente(
            emp_id=emp_id,
            doc_id=doc_dni.doc_id,
            cli_ndocumento=f"{random.randint(10000000, 99999999)}" if random.random() < 0.9 else None,
            cli_nombre_razon_social=f"{first} {last}",
            cli_email=email,
            cli_celular=f"9{random.randint(10000000, 99999999)}" if random.random() < 0.95 else None,
            estado=1,
        )
        db.add(cli)
        db.commit()
        db.refresh(cli)

        # 1-3 ventas por cliente
        for _ in range(random.randint(0, 3)):
            n_items = random.randint(1, 2)
            items = []
            ven_total = 0
            for _ in range(n_items):
                prod = random.choice(productos)
                cant = random.randint(1, 3)
                # precio vigente
                pp = db.scalar(select(ProductoPrecio).where(ProductoPrecio.emp_id == emp_id, ProductoPrecio.prd_id == prod.prd_id, ProductoPrecio.fecha_fin.is_(None)))
                precio = float(pp.prd_precios) if pp else 10.0
                descuento = round(precio * cant * 0.1, 2) if random.random() < 0.2 else 0
                subtotal = round(precio * cant - descuento, 2)
                items.append(VentaItem(emp_id=emp_id, prd_id=prod.prd_id, cantidad=cant, precio_unitario=precio, descuento=descuento, subtotal=subtotal))
                ven_total += subtotal

            mtp_id = random.choice(metodos).mtp_id if metodos and random.random() < 0.9 else None
            canal = random.choice(canales) if canales else None
            # venta_origen usa can_codigo si hay
            venta_origen = canal.can_codigo if canal and hasattr(canal, 'can_codigo') else "internal"

            venta = Venta(emp_id=emp_id, cli_id=cli.cli_id, ven_total=ven_total, ven_descuento=0, mtp_id=mtp_id, venta_origen=venta_origen, estado=1)
            venta.items = items
            db.add(venta)
            total_ventas += 1
            # descontar stock
            for it in items:
                stock = db.scalar(select(ProductoStock).where(ProductoStock.emp_id == emp_id, ProductoStock.prd_id == it.prd_id))
                if stock:
                    stock.stk_cantidad = max(0, float(stock.stk_cantidad) - float(it.cantidad))

        if i % 100 == 0:
            db.commit()
            print(f"  {i}/{count} clientes...")

    db.commit()
    print(f"Clientes: {count}, ventas: {total_ventas}")


def main():
    db = SessionLocal()
    try:
        emp = create_empresa_and_admin(db)
        productos = create_productos(db, emp.emp_id)
        create_clientes_y_ventas(db, emp.emp_id, productos, count=300)
        print("\nSeed dinámico completado. Añade nuevos metodos_pago/canal y se usarán automáticamente.")
    finally:
        db.close()


if __name__ == "__main__":
    main()
