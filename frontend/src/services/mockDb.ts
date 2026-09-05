import { generateCustomersAndSales, generateProducts, TODAY } from "./seedData";
import {
  buildRecoveryStrategy,
  computeActivityStatus,
  computeChurn,
  computeNextPurchase,
  computeRFM,
  customerValueFromRFM,
  recommendProducts,
  segmentFromRFM,
} from "./analyticsEngine";
import { daysBetween } from "@/lib/format";
import type {
  BusinessSettings,
  Campaign,
  Customer,
  ImportSummary,
  ModelVersion,
  Product,
  RecoveryStrategy,
  Sale,
} from "@/types";

/**
 * "Base de datos" en memoria para el modo demo (VITE_USE_MOCK=true).
 *
 * Esto reemplaza temporalmente a PostgreSQL mientras el backend (FastAPI)
 * no está conectado. Todas las funciones son async para que el resto de
 * la aplicación (services/api.ts, hooks, páginas) ya esté escrita contra
 * la misma forma que tendrá la API real — cambiar de mock a backend real
 * es, en el resto del código, solo un cambio de configuración.
 */

let products: Product[] = [];
let sales: Sale[] = [];
let customers: Customer[] = [];
let campaigns: Campaign[] = [];
let imports: ImportSummary[] = [];
let modelVersions: ModelVersion[] = [];
let settings: BusinessSettings = {
  businessName: "Café La Espiga",
  currency: "PEN",
  timezone: "America/Lima",
  analysisWindowDays: 365,
  churnThresholds: { medium: 30, high: 60, critical: 80 },
  campaignCooldownDays: 7,
  availableChannels: ["email", "whatsapp", "sms", "internal"],
  discountRules: [
    { segment: "vip", maxDiscountPct: 15 },
    { segment: "at_risk", maxDiscountPct: 10 },
    { segment: "dormant", maxDiscountPct: 10 },
    { segment: "default", maxDiscountPct: 5 },
  ],
  language: "es",
};

let initialized = false;

function initialize() {
  if (initialized) return;
  products = generateProducts();
  const generated = generateCustomersAndSales(products, 1200);
  sales = generated.sales;

  // Top productos vendidos (para cold start / relleno de recomendaciones).
  const soldCount = new Map<string, number>();
  for (const sale of sales) {
    for (const item of sale.items) {
      soldCount.set(item.productId, (soldCount.get(item.productId) ?? 0) + item.quantity);
    }
  }
  const topSellingProductIds = [...soldCount.entries()]
    .sort((a, b) => b[1] - a[1])
    .map(([id]) => id);

  customers = generated.customers.map((c) => {
    const rfm = computeRFM(c, TODAY);
    const registeredDaysAgo = daysBetween(TODAY, new Date(c.registeredAt));
    const segment = segmentFromRFM(rfm, c.purchaseCount, registeredDaysAgo);
    const activityStatus = computeActivityStatus(c, rfm);
    const churn = computeChurn(c, rfm, activityStatus);
    const nextPurchase = computeNextPurchase(c, rfm);
    const customerValue = customerValueFromRFM(rfm);
    return { ...c, rfm, segment, activityStatus, churn, nextPurchase, customerValue };
  });

  modelVersions = [
    {
      id: "model_1",
      modelName: "churn_classifier",
      version: "0.1.0-rules",
      trainingDate: TODAY.toISOString(),
      datasetVersion: "synthetic-v1",
      features: [
        "recencia", "frecuencia", "gasto_total", "intervalo_promedio", "desviacion_intervalo",
      ],
      metrics: { accuracy: 0, precision: 0, recall: 0, f1: 0, rocAuc: 0, prAuc: 0 },
      status: "candidate",
    },
  ];

  seedCampaigns(topSellingProductIds);
  initialized = true;
}

function seedCampaigns(topSellingProductIds: string[]) {
  const atRisk = customers.filter((c) => c.activityStatus === "at_risk").slice(0, 40).map((c) => c.id);
  const dormant = customers.filter((c) => c.activityStatus === "dormant").slice(0, 25).map((c) => c.id);
  campaigns = [
    {
      id: "camp_1",
      businessId: "biz_demo_1",
      name: "Reactivación clientes en riesgo — Septiembre",
      description: "Campaña de recuperación con 10% de descuento para clientes en riesgo de alto valor.",
      segment: "at_risk",
      targetCustomerIds: atRisk,
      productId: topSellingProductIds[0] ?? null,
      offer: "10% de descuento",
      channel: "whatsapp",
      startDate: TODAY.toISOString(),
      endDate: null,
      message: "Hola {{customer_name}}, hace un tiempo que no te vemos. Tenemos 10% de descuento especial para ti esta semana.",
      status: "active",
      metrics: {
        targeted: atRisk.length,
        withConsent: Math.round(atRisk.length * 0.85),
        withoutConsent: Math.round(atRisk.length * 0.15),
        estimatedCost: atRisk.length * 0.5,
        potentialRevenue: atRisk.length * 35,
        sent: Math.round(atRisk.length * 0.85),
        opened: Math.round(atRisk.length * 0.5),
        responded: Math.round(atRisk.length * 0.22),
        converted: Math.round(atRisk.length * 0.14),
        recoveredCustomers: Math.round(atRisk.length * 0.14),
        recoveredRevenue: Math.round(atRisk.length * 0.14 * 32),
        roi: 3.1,
      },
    },
    {
      id: "camp_2",
      businessId: "biz_demo_1",
      name: "Despertar clientes dormidos — Café Premium",
      description: "Oferta dirigida a clientes dormidos con alto historial de compra de café.",
      segment: "dormant",
      targetCustomerIds: dormant,
      productId: topSellingProductIds[1] ?? null,
      offer: "5% de descuento",
      channel: "email",
      startDate: TODAY.toISOString(),
      endDate: null,
      message: "Hola {{customer_name}}, vimos que normalmente compras {{product_name}} y tenemos una oferta especial para ti.",
      status: "draft",
      metrics: null,
    },
  ];
}

// ---------------- Helpers de paginación/orden/filtro ----------------

export interface QueryOptions {
  page?: number;
  pageSize?: number;
  search?: string;
  sortBy?: string;
  sortDir?: "asc" | "desc";
  filters?: Record<string, string | undefined>;
}

function paginate<T>(items: T[], { page = 1, pageSize = 20 }: QueryOptions) {
  const total = items.length;
  const start = (page - 1) * pageSize;
  return { items: items.slice(start, start + pageSize), page, pageSize, total };
}

// ---------------- API interna (usada por services/api.ts) ----------------

export const db = {
  init: initialize,

  getSettings: () => structuredClone(settings),
  updateSettings: (partial: Partial<BusinessSettings>) => {
    settings = { ...settings, ...partial };
    return structuredClone(settings);
  },

  listCustomers: (opts: QueryOptions) => {
    initialize();
    let list = customers;
    if (opts.search) {
      const q = opts.search.toLowerCase();
      list = list.filter(
        (c) =>
          `${c.firstName} ${c.lastName}`.toLowerCase().includes(q) ||
          (c.email ?? "").toLowerCase().includes(q)
      );
    }
    if (opts.filters?.segment) list = list.filter((c) => c.segment === opts.filters!.segment);
    if (opts.filters?.activityStatus) list = list.filter((c) => c.activityStatus === opts.filters!.activityStatus);
    if (opts.filters?.riskLevel) list = list.filter((c) => c.churn?.riskLevel === opts.filters!.riskLevel);

    const sortBy = opts.sortBy ?? "totalSpend";
    const dir = opts.sortDir === "asc" ? 1 : -1;
    list = [...list].sort((a: any, b: any) => {
      const av = sortBy === "priority" ? (a.churn?.churnScore ?? 0) : a[sortBy];
      const bv = sortBy === "priority" ? (b.churn?.churnScore ?? 0) : b[sortBy];
      if (av === bv) return 0;
      return av > bv ? dir : -dir;
    });
    return paginate(list, opts);
  },

  getCustomer: (id: string) => {
    initialize();
    return customers.find((c) => c.id === id) ?? null;
  },

  createCustomer: (input: Partial<Customer>) => {
    initialize();
    const id = `cust_${customers.length + 1}_${Date.now()}`;
    const base: Customer = {
      id,
      businessId: "biz_demo_1",
      firstName: input.firstName ?? "",
      lastName: input.lastName ?? "",
      email: input.email ?? null,
      phone: input.phone ?? null,
      city: input.city ?? null,
      registeredAt: new Date().toISOString(),
      preferredChannel: input.preferredChannel ?? "email",
      consent: input.consent ?? false,
      status: "active",
      lastPurchaseAt: null,
      purchaseCount: 0,
      totalSpend: 0,
      avgTicket: 0,
      avgIntervalDays: null,
      segment: "new",
      customerValue: "low",
      rfm: computeRFM({ ...input, purchaseCount: 0, totalSpend: 0, lastPurchaseAt: null } as Customer, TODAY),
      churn: null,
      activityStatus: "active",
      nextPurchase: null,
    };
    customers = [base, ...customers];
    return base;
  },

  updateCustomer: (id: string, patch: Partial<Customer>) => {
    initialize();
    customers = customers.map((c) => (c.id === id ? { ...c, ...patch } : c));
    return customers.find((c) => c.id === id) ?? null;
  },

  deactivateCustomer: (id: string) => {
    initialize();
    customers = customers.map((c) => (c.id === id ? { ...c, status: "inactive" } : c));
    return customers.find((c) => c.id === id) ?? null;
  },

  getCustomerSales: (id: string) => {
    initialize();
    return sales.filter((s) => s.customerId === id).sort((a, b) => (a.date < b.date ? 1 : -1));
  },

  getCustomerRecommendations: (id: string) => {
    initialize();
    const customer = customers.find((c) => c.id === id);
    if (!customer) return [];
    const customerSales = sales.filter((s) => s.customerId === id);
    const soldCount = new Map<string, number>();
    for (const sale of sales) {
      for (const item of sale.items) soldCount.set(item.productId, (soldCount.get(item.productId) ?? 0) + item.quantity);
    }
    const topSellingProductIds = [...soldCount.entries()].sort((a, b) => b[1] - a[1]).map(([pid]) => pid);
    return recommendProducts(customer, customerSales, products, topSellingProductIds);
  },

  getCustomerStrategy: (id: string): RecoveryStrategy | null => {
    initialize();
    const customer = customers.find((c) => c.id === id);
    if (!customer || !customer.churn) return null;
    const recs = db.getCustomerRecommendations(id);
    return buildRecoveryStrategy(customer, customer.churn, recs[0] ?? null, null, settings.campaignCooldownDays);
  },

  listAtRiskCustomers: (opts: QueryOptions) => {
    initialize();
    let list = customers.filter((c) => c.activityStatus === "at_risk" || c.activityStatus === "dormant" || c.activityStatus === "lost");
    if (opts.filters?.riskLevel) list = list.filter((c) => c.churn?.riskLevel === opts.filters!.riskLevel);
    list = [...list].sort((a, b) => (b.churn?.churnScore ?? 0) - (a.churn?.churnScore ?? 0));
    return paginate(list, opts);
  },

  listTodayActions: (limit = 20): RecoveryStrategy[] => {
    initialize();
    const candidates = customers.filter((c) => c.churn && c.churn.riskLevel !== "low" && c.consent);
    const strategies = candidates.map((c) => {
      const recs = db.getCustomerRecommendations(c.id);
      return buildRecoveryStrategy(c, c.churn!, recs[0] ?? null, null, settings.campaignCooldownDays);
    });
    return strategies.sort((a, b) => b.priorityScore - a.priorityScore).slice(0, limit);
  },

  // ---------------- Productos ----------------
  listProducts: (opts: QueryOptions) => {
    initialize();
    let list = products;
    if (opts.search) {
      const q = opts.search.toLowerCase();
      list = list.filter((p) => p.name.toLowerCase().includes(q) || p.sku.toLowerCase().includes(q));
    }
    if (opts.filters?.category) list = list.filter((p) => p.category === opts.filters!.category);
    if (opts.filters?.status) list = list.filter((p) => p.status === opts.filters!.status);
    return paginate(list, opts);
  },
  createProduct: (input: Omit<Product, "id" | "businessId" | "margin">) => {
    initialize();
    const margin = input.cost ? Math.round(((input.price - input.cost) / input.price) * 1000) / 10 : null;
    const product: Product = { ...input, id: `prod_${products.length + 1}_${Date.now()}`, businessId: "biz_demo_1", margin };
    products = [product, ...products];
    return product;
  },
  updateProduct: (id: string, patch: Partial<Product>) => {
    initialize();
    products = products.map((p) => (p.id === id ? { ...p, ...patch } : p));
    return products.find((p) => p.id === id) ?? null;
  },
  deactivateProduct: (id: string) => {
    initialize();
    products = products.map((p) => (p.id === id ? { ...p, status: "inactive" } : p));
    return products.find((p) => p.id === id) ?? null;
  },
  categories: () => {
    initialize();
    return [...new Set(products.map((p) => p.category))];
  },

  // ---------------- Ventas ----------------
  listSales: (opts: QueryOptions) => {
    initialize();
    let list = [...sales].sort((a, b) => (a.date < b.date ? 1 : -1));
    if (opts.search) {
      const q = opts.search.toLowerCase();
      list = list.filter((s) => s.customerName.toLowerCase().includes(q));
    }
    return paginate(list, opts);
  },
  createSale: (input: { customerId: string; items: { productId: string; quantity: number; discountPct?: number }[]; channel: Sale["channel"]; paymentMethod?: string }) => {
    initialize();
    const customer = customers.find((c) => c.id === input.customerId);
    if (!customer) throw new Error("CUSTOMER_NOT_FOUND");
    const items = input.items.map((it) => {
      const product = products.find((p) => p.id === it.productId);
      if (!product) throw new Error("PRODUCT_NOT_FOUND");
      const discountPct = it.discountPct ?? 0;
      const subtotal = Math.round(product.price * it.quantity * (1 - discountPct) * 100) / 100;
      const discount = Math.round(product.price * it.quantity * discountPct * 100) / 100;
      return { productId: product.id, productName: product.name, quantity: it.quantity, unitPrice: product.price, discount, subtotal };
    });
    const total = Math.round(items.reduce((s, i) => s + i.subtotal, 0) * 100) / 100;
    const discountTotal = Math.round(items.reduce((s, i) => s + i.discount, 0) * 100) / 100;
    const sale: Sale = {
      id: `sale_${sales.length + 1}_${Date.now()}`,
      businessId: "biz_demo_1",
      customerId: customer.id,
      customerName: `${customer.firstName} ${customer.lastName}`,
      date: new Date().toISOString(),
      items,
      discountTotal,
      total,
      channel: input.channel,
      paymentMethod: input.paymentMethod ?? null,
    };
    sales = [sale, ...sales];

    // Recalcular métricas del cliente (transacción simulada: sale + recálculo).
    const custSales = sales.filter((s) => s.customerId === customer.id);
    const totalSpend = Math.round(custSales.reduce((s, sa) => s + sa.total, 0) * 100) / 100;
    const purchaseCount = custSales.length;
    const avgTicket = Math.round((totalSpend / purchaseCount) * 100) / 100;
    const updated: Customer = { ...customer, purchaseCount, totalSpend, avgTicket, lastPurchaseAt: sale.date };
    const rfm = computeRFM(updated, TODAY);
    const registeredDaysAgo = daysBetween(TODAY, new Date(updated.registeredAt));
    const segment = segmentFromRFM(rfm, purchaseCount, registeredDaysAgo);
    const activityStatus = computeActivityStatus(updated, rfm);
    const churn = computeChurn(updated, rfm, activityStatus);
    const nextPurchase = computeNextPurchase(updated, rfm);
    customers = customers.map((c) => (c.id === customer.id ? { ...updated, rfm, segment, activityStatus, churn, nextPurchase } : c));

    return sale;
  },

  // ---------------- Campañas ----------------
  listCampaigns: (opts: QueryOptions) => {
    initialize();
    let list = campaigns;
    if (opts.filters?.status) list = list.filter((c) => c.status === opts.filters!.status);
    return paginate(list, opts);
  },
  getCampaign: (id: string) => {
    initialize();
    return campaigns.find((c) => c.id === id) ?? null;
  },
  createCampaign: (input: Omit<Campaign, "id" | "businessId" | "metrics" | "status">) => {
    initialize();
    const targeted = input.targetCustomerIds.length;
    const withConsent = input.targetCustomerIds.filter((id) => customers.find((c) => c.id === id)?.consent).length;
    const campaign: Campaign = {
      ...input,
      id: `camp_${campaigns.length + 1}_${Date.now()}`,
      businessId: "biz_demo_1",
      status: "draft",
      metrics: {
        targeted,
        withConsent,
        withoutConsent: targeted - withConsent,
        estimatedCost: targeted * 0.5,
        potentialRevenue: targeted * 30,
        sent: 0,
        opened: 0,
        responded: 0,
        converted: 0,
        recoveredCustomers: 0,
        recoveredRevenue: 0,
        roi: null,
      },
    };
    campaigns = [campaign, ...campaigns];
    return campaign;
  },
  updateCampaignStatus: (id: string, status: Campaign["status"]) => {
    initialize();
    campaigns = campaigns.map((c) => (c.id === id ? { ...c, status } : c));
    return campaigns.find((c) => c.id === id) ?? null;
  },
  simulateCampaign: (id: string) => {
    initialize();
    const campaign = campaigns.find((c) => c.id === id);
    if (!campaign) return null;
    const targeted = campaign.targetCustomerIds.length || 1;
    const conversionRate = 0.12 + Math.random() * 0.06; // simulación explícita, no un envío real
    const converted = Math.round(targeted * conversionRate);
    const recoveredRevenue = converted * 32;
    const estimatedCost = targeted * 0.5;
    const roi = estimatedCost > 0 ? Math.round(((recoveredRevenue - estimatedCost) / estimatedCost) * 100) / 100 : null;
    return {
      targeted,
      estimatedConversionRate: Math.round(conversionRate * 100) / 100,
      estimatedConverted: converted,
      estimatedRecoveredRevenue: recoveredRevenue,
      estimatedCost,
      estimatedRoi: roi,
      isSimulation: true as const,
    };
  },

  // ---------------- Importaciones ----------------
  listImports: () => {
    initialize();
    return [...imports].sort((a, b) => (a.createdAt < b.createdAt ? 1 : -1));
  },
  registerImport: (summary: ImportSummary) => {
    initialize();
    imports = [summary, ...imports];
    return summary;
  },

  // ---------------- Modelos ----------------
  listModelVersions: () => {
    initialize();
    return modelVersions;
  },

  // ---------------- Dashboard / analítica ----------------
  allCustomers: () => {
    initialize();
    return customers;
  },
  allProducts: () => {
    initialize();
    return products;
  },
  allSales: () => {
    initialize();
    return sales;
  },
  allCampaigns: () => {
    initialize();
    return campaigns;
  },
};
