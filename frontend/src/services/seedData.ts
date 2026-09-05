import { mulberry32, pick, randInt, randFloat, weightedPick } from "@/lib/prng";
import type { Channel, Customer, Product, Sale, SaleItem } from "@/types";

// Genera un dataset sintético (sección 45 del brief): mínimo 1000 clientes,
// 30 productos y varios miles de ventas, con distintos comportamientos de
// compra (activos, en riesgo, dormidos, perdidos) para poder probar la
// segmentación y el churn de forma realista. No usa datos personales reales.

const SEED = 20260101;
const BUSINESS_ID = "biz_demo_1";
export const TODAY = new Date("2026-09-03T00:00:00Z");

const FIRST_NAMES = [
  "Carlos", "María", "Juan", "Ana", "Luis", "Rosa", "Jorge", "Carmen", "Pedro", "Lucía",
  "Miguel", "Elena", "Diego", "Paola", "Andrés", "Valeria", "Fernando", "Camila", "Ricardo",
  "Daniela", "Javier", "Gabriela", "Raúl", "Fiorella", "Alberto", "Milagros", "Sergio",
  "Patricia", "Manuel", "Karen", "Eduardo", "Diana", "Óscar", "Vanessa", "Martín", "Claudia",
];
const LAST_NAMES = [
  "García", "Rodríguez", "Pérez", "López", "Sánchez", "Ramírez", "Flores", "Vargas",
  "Castillo", "Torres", "Rojas", "Chávez", "Mendoza", "Cruz", "Reyes", "Gutiérrez",
  "Ortiz", "Silva", "Romero", "Herrera", "Medina", "Aguilar", "Campos", "Vega",
];
const CITIES = ["Lima", "Arequipa", "Trujillo", "Cusco", "Piura", "Chiclayo", "Huancayo", null];
const CHANNELS: Channel[] = ["email", "whatsapp", "sms", "internal"];

const CATEGORIES = [
  "Café y bebidas", "Panadería", "Repostería", "Snacks", "Desayunos", "Almuerzos",
  "Bebidas frías", "Combos", "Merchandising",
];

const PRODUCT_NAMES: Record<string, string[]> = {
  "Café y bebidas": ["Café Americano", "Café Premium", "Cappuccino", "Latte Vainilla", "Té Verde", "Chocolate Caliente"],
  "Panadería": ["Croissant", "Pan Integral", "Baguette", "Pan de Yema", "Rosca Dulce"],
  "Repostería": ["Cheesecake", "Brownie", "Alfajor", "Torta de Chocolate", "Muffin de Arándanos"],
  "Snacks": ["Mix de Frutos Secos", "Papas Artesanales", "Galletas de Avena", "Barra Energética"],
  "Desayunos": ["Desayuno Andino", "Sandwich de Pollo", "Tostadas Francesas", "Bowl de Frutas"],
  "Almuerzos": ["Menú Ejecutivo", "Ensalada César", "Wrap de Pollo", "Bowl Proteico"],
  "Bebidas frías": ["Limonada", "Frappé de Café", "Jugo Natural", "Smoothie de Fresa"],
  "Combos": ["Combo Desayuno", "Combo Tarde de Café", "Combo Oficina"],
  "Merchandising": ["Taza de la Casa", "Bolsa de Café en Grano 250g"],
};

export function generateProducts(): Product[] {
  const rand = mulberry32(SEED + 1);
  const products: Product[] = [];
  let idx = 1;
  for (const category of CATEGORIES) {
    for (const name of PRODUCT_NAMES[category]) {
      const cost = randFloat(rand, 1.5, 12, 2);
      const price = Math.round((cost * randFloat(rand, 1.6, 2.6, 2)) * 100) / 100;
      products.push({
        id: `prod_${idx}`,
        businessId: BUSINESS_ID,
        sku: `SKU-${String(idx).padStart(4, "0")}`,
        name,
        description: `${name} — categoría ${category}`,
        category,
        price,
        cost,
        margin: Math.round(((price - cost) / price) * 1000) / 10,
        stock: randInt(rand, 10, 200),
        status: rand() < 0.05 ? "inactive" : "active",
      });
      idx += 1;
    }
  }
  return products;
}

type BehaviorProfile = "vip_active" | "loyal_active" | "new" | "at_risk" | "dormant" | "lost" | "one_time";

interface CustomerSeed {
  customer: Customer;
  profile: BehaviorProfile;
  avgIntervalDays: number;
  favoriteCategory: string;
}

const PROFILE_WEIGHTS: Array<[BehaviorProfile, number]> = [
  ["vip_active", 6],
  ["loyal_active", 18],
  ["new", 14],
  ["at_risk", 16],
  ["dormant", 14],
  ["lost", 18],
  ["one_time", 14],
];

const PROFILE_INTERVAL_RANGE: Record<BehaviorProfile, [number, number]> = {
  vip_active: [7, 15],
  loyal_active: [14, 30],
  new: [15, 40],
  at_risk: [20, 45],
  dormant: [25, 60],
  lost: [15, 35],
  one_time: [9999, 9999],
};

export function generateCustomersAndSales(products: Product[], count = 1200) {
  const rand = mulberry32(SEED + 2);
  const activeProducts = products.filter((p) => p.status === "active");
  const customers: Customer[] = [];
  const sales: Sale[] = [];
  let saleIdx = 1;

  for (let i = 1; i <= count; i++) {
    const first = pick(rand, FIRST_NAMES);
    const last = pick(rand, LAST_NAMES);
    const registeredDaysAgo = randInt(rand, 60, 730);
    const registeredAt = new Date(TODAY);
    registeredAt.setDate(registeredAt.getDate() - registeredDaysAgo);

    const profile = weightedPick(rand, PROFILE_WEIGHTS);
    const [minInt, maxInt] = PROFILE_INTERVAL_RANGE[profile];
    const avgIntervalDays = profile === "one_time" ? 0 : randInt(rand, minInt, maxInt);
    const favoriteCategory = pick(rand, CATEGORIES);
    const favoriteProducts = activeProducts.filter((p) => p.category === favoriteCategory);

    // Generar historial de compras según el perfil de comportamiento.
    const purchaseDates: Date[] = [];
    if (profile === "one_time") {
      const daysAgo = randInt(rand, 5, Math.min(registeredDaysAgo, 400));
      const d = new Date(TODAY);
      d.setDate(d.getDate() - daysAgo);
      purchaseDates.push(d);
    } else {
      // Última compra: según perfil, definimos hace cuánto fue.
      let lastGapMultiplier = 1;
      if (profile === "vip_active" || profile === "loyal_active" || profile === "new") lastGapMultiplier = randFloat(rand, 0.3, 1.1, 2);
      if (profile === "at_risk") lastGapMultiplier = randFloat(rand, 1.3, 2.2, 2);
      if (profile === "dormant") lastGapMultiplier = randFloat(rand, 2.5, 5, 2);
      if (profile === "lost") lastGapMultiplier = randFloat(rand, 5, 12, 2);

      const daysSinceLast = Math.min(Math.round(avgIntervalDays * lastGapMultiplier), registeredDaysAgo - 1 || 1);
      let cursor = new Date(TODAY);
      cursor.setDate(cursor.getDate() - Math.max(daysSinceLast, 1));
      purchaseDates.push(new Date(cursor));

      // Retroceder generando compras previas separadas ~avgIntervalDays con variación.
      const maxHistory = randInt(rand, 3, 40);
      for (let h = 0; h < maxHistory; h++) {
        const jitter = randFloat(rand, 0.6, 1.4, 2);
        const gap = Math.max(3, Math.round(avgIntervalDays * jitter));
        cursor = new Date(cursor);
        cursor.setDate(cursor.getDate() - gap);
        if (cursor < registeredAt) break;
        purchaseDates.push(new Date(cursor));
      }
    }
    purchaseDates.sort((a, b) => a.getTime() - b.getTime());

    const customerId = `cust_${i}`;
    let totalSpend = 0;
    const customerSales: Sale[] = [];

    for (const date of purchaseDates) {
      const nItems = randInt(rand, 1, 3);
      const items: SaleItem[] = [];
      for (let k = 0; k < nItems; k++) {
        const useFavorite = favoriteProducts.length > 0 && rand() < 0.6;
        const product = useFavorite ? pick(rand, favoriteProducts) : pick(rand, activeProducts);
        const quantity = randInt(rand, 1, 3);
        const discountPct = rand() < 0.2 ? randFloat(rand, 0.05, 0.15, 2) : 0;
        const subtotal = Math.round(product.price * quantity * (1 - discountPct) * 100) / 100;
        items.push({
          productId: product.id,
          productName: product.name,
          quantity,
          unitPrice: product.price,
          discount: Math.round(product.price * quantity * discountPct * 100) / 100,
          subtotal,
        });
      }
      const discountTotal = Math.round(items.reduce((s, it) => s + it.discount, 0) * 100) / 100;
      const total = Math.round(items.reduce((s, it) => s + it.subtotal, 0) * 100) / 100;
      totalSpend += total;
      const sale: Sale = {
        id: `sale_${saleIdx++}`,
        businessId: BUSINESS_ID,
        customerId,
        customerName: `${first} ${last}`,
        date: date.toISOString(),
        items,
        discountTotal,
        total,
        channel: pick(rand, CHANNELS),
        paymentMethod: pick(rand, ["Efectivo", "Tarjeta", "Yape/Plin", null]),
      };
      customerSales.push(sale);
    }
    sales.push(...customerSales);

    const purchaseCount = customerSales.length;
    const avgTicket = purchaseCount > 0 ? Math.round((totalSpend / purchaseCount) * 100) / 100 : 0;
    const lastPurchaseAt = customerSales.length
      ? customerSales[customerSales.length - 1].date
      : null;

    const email = rand() < 0.12 ? null : `${first.toLowerCase()}.${last.toLowerCase()}${i}@correo.com`;
    const consent = rand() < 0.88;

    const customer: Customer = {
      id: customerId,
      businessId: BUSINESS_ID,
      firstName: first,
      lastName: last,
      email,
      phone: rand() < 0.05 ? null : `9${randInt(rand, 10000000, 99999999)}`,
      city: pick(rand, CITIES),
      registeredAt: registeredAt.toISOString(),
      preferredChannel: pick(rand, CHANNELS),
      consent,
      status: profile === "lost" && rand() < 0.15 ? "inactive" : "active",
      lastPurchaseAt,
      purchaseCount,
      totalSpend: Math.round(totalSpend * 100) / 100,
      avgTicket,
      avgIntervalDays: purchaseCount > 1 ? avgIntervalDays : null,
      // Estos campos derivados (segment, rfm, churn, etc.) se calculan
      // en analytics.ts a partir del historial real de ventas.
      segment: "new",
      customerValue: "low",
      rfm: { recencyDays: 0, frequency: 0, monetary: 0, r: 0, f: 0, m: 0, rfmScore: "000" },
      churn: null,
      activityStatus: "active",
      nextPurchase: null,
    };
    customers.push(customer);
  }

  return { customers, sales };
}
