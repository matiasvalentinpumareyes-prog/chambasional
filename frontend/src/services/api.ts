import { db, type QueryOptions } from "./mockDb";
import { computeDashboardMetrics, computeDashboardSeries } from "./dashboard";
import type {
  AuthUser,
  Campaign,
  Customer,
  DashboardMetrics,
  DashboardSeries,
  ImportError,
  ImportSummary,
  ModelVersion,
  Paginated,
  Product,
  ProductRecommendation,
  RecoveryStrategy,
  Sale,
  BusinessSettings,
} from "@/types";

/**
 * Adapter de API.
 *
 * VITE_USE_MOCK=true (valor por defecto en desarrollo/demo): todas las
 * funciones leen/escriben sobre la base de datos en memoria (services/mockDb.ts).
 *
 * VITE_USE_MOCK=false: las mismas funciones deberían hacer fetch() contra
 * VITE_API_URL, hacia los endpoints reales descritos en la sección 34 del
 * brief (/api/customers, /api/products, /api/sales, etc.). La forma de los
 * datos devueltos (los tipos de src/types) es la que ya expone FastAPI en
 * su documentación Swagger, así que el resto de la aplicación no cambia.
 *
 * Esto es exactamente el patrón "adapter" pedido en el brief para los
 * canales de notificación (sección 23), aplicado aquí también a la propia
 * capa de datos.
 */

const USE_MOCK = import.meta.env.VITE_USE_MOCK !== "false";
const API_URL = import.meta.env.VITE_API_URL ?? "http://localhost:8000/api";

// Simula latencia de red realista en modo mock, para que los estados de
// carga de la interfaz (loading, skeletons) se comporten como con un
// backend real y no den una falsa sensación de instantaneidad.
function delay<T>(value: T, ms = 220): Promise<T> {
  return new Promise((resolve) => setTimeout(() => resolve(value), ms));
}

async function realFetch<T>(path: string, options?: RequestInit): Promise<T> {
  const token = localStorage.getItem("auth_token");
  const res = await fetch(`${API_URL}${path}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options?.headers,
    },
  });
  if (!res.ok) {
    const body = await res.json().catch(() => null);
    throw new Error(body?.error?.message ?? `Error de red (${res.status})`);
  }
  return res.json();
}

// ---------------- Auth ----------------

const MOCK_USER: AuthUser = {
  id: "user_1",
  name: "Administrador Demo",
  email: "admin@demo.com",
  role: "admin",
  businessId: "biz_demo_1",
  businessName: "Café La Espiga",
};

export const authApi = {
  login: async (email: string, _password: string): Promise<AuthUser> => {
    if (USE_MOCK) {
      db.init();
      const user = { ...MOCK_USER, email };
      localStorage.setItem("auth_token", "mock-jwt-token");
      localStorage.setItem("auth_user", JSON.stringify(user));
      return delay(user, 400);
    }
    const data = await realFetch<{ token: string; user: AuthUser }>("/auth/login", {
      method: "POST",
      body: JSON.stringify({ email, password: _password }),
    });
    localStorage.setItem("auth_token", data.token);
    localStorage.setItem("auth_user", JSON.stringify(data.user));
    return data.user;
  },
  logout: () => {
    localStorage.removeItem("auth_token");
    localStorage.removeItem("auth_user");
  },
  currentUser: (): AuthUser | null => {
    const raw = localStorage.getItem("auth_user");
    return raw ? JSON.parse(raw) : null;
  },
};

// ---------------- Dashboard ----------------

export const dashboardApi = {
  getMetrics: async (): Promise<DashboardMetrics> => {
    if (USE_MOCK) return delay(computeDashboardMetrics());
    return realFetch<DashboardMetrics>("/dashboard");
  },
  getSeries: async (): Promise<DashboardSeries> => {
    if (USE_MOCK) return delay(computeDashboardSeries());
    return realFetch<DashboardSeries>("/dashboard/series");
  },
};

// ---------------- Clientes ----------------

export const customersApi = {
  list: async (opts: QueryOptions): Promise<Paginated<Customer>> => {
    if (USE_MOCK) return delay(db.listCustomers(opts));
    const qs = new URLSearchParams(opts as any).toString();
    return realFetch<Paginated<Customer>>(`/customers?${qs}`);
  },
  get: async (id: string): Promise<Customer | null> => {
    if (USE_MOCK) return delay(db.getCustomer(id));
    return realFetch<Customer | null>(`/customers/${id}`);
  },
  create: async (input: Partial<Customer>): Promise<Customer> => {
    if (USE_MOCK) return delay(db.createCustomer(input));
    return realFetch<Customer>(`/customers`, { method: "POST", body: JSON.stringify(input) });
  },
  update: async (id: string, patch: Partial<Customer>): Promise<Customer | null> => {
    if (USE_MOCK) return delay(db.updateCustomer(id, patch));
    return realFetch<Customer | null>(`/customers/${id}`, { method: "PUT", body: JSON.stringify(patch) });
  },
  deactivate: async (id: string): Promise<Customer | null> => {
    if (USE_MOCK) return delay(db.deactivateCustomer(id));
    return realFetch<Customer | null>(`/customers/${id}`, { method: "DELETE" });
  },
  sales: async (id: string): Promise<Sale[]> => {
    if (USE_MOCK) return delay(db.getCustomerSales(id));
    return realFetch<Sale[]>(`/customers/${id}/sales`);
  },
  recommendations: async (id: string): Promise<ProductRecommendation[]> => {
    if (USE_MOCK) return delay(db.getCustomerRecommendations(id));
    return realFetch<ProductRecommendation[]>(`/recommendations?customer_id=${id}`);
  },
  strategy: async (id: string): Promise<RecoveryStrategy | null> => {
    if (USE_MOCK) return delay(db.getCustomerStrategy(id));
    return realFetch<RecoveryStrategy | null>(`/strategies?customer_id=${id}`);
  },
};

export const atRiskApi = {
  list: async (opts: QueryOptions): Promise<Paginated<Customer>> => {
    if (USE_MOCK) return delay(db.listAtRiskCustomers(opts));
    const qs = new URLSearchParams(opts as any).toString();
    return realFetch<Paginated<Customer>>(`/predictions/churn?${qs}`);
  },
  todayActions: async (limit = 20): Promise<RecoveryStrategy[]> => {
    if (USE_MOCK) return delay(db.listTodayActions(limit));
    return realFetch<RecoveryStrategy[]>(`/strategies/today?limit=${limit}`);
  },
};

// ---------------- Productos ----------------

export const productsApi = {
  list: async (opts: QueryOptions): Promise<Paginated<Product>> => {
    if (USE_MOCK) return delay(db.listProducts(opts));
    const qs = new URLSearchParams(opts as any).toString();
    return realFetch<Paginated<Product>>(`/products?${qs}`);
  },
  create: async (input: Omit<Product, "id" | "businessId" | "margin">): Promise<Product> => {
    if (USE_MOCK) return delay(db.createProduct(input));
    return realFetch<Product>(`/products`, { method: "POST", body: JSON.stringify(input) });
  },
  update: async (id: string, patch: Partial<Product>): Promise<Product | null> => {
    if (USE_MOCK) return delay(db.updateProduct(id, patch));
    return realFetch<Product | null>(`/products/${id}`, { method: "PUT", body: JSON.stringify(patch) });
  },
  deactivate: async (id: string): Promise<Product | null> => {
    if (USE_MOCK) return delay(db.deactivateProduct(id));
    return realFetch<Product | null>(`/products/${id}`, { method: "DELETE" });
  },
  categories: async (): Promise<string[]> => {
    if (USE_MOCK) return delay(db.categories());
    return realFetch<string[]>(`/products/categories`);
  },
};

// ---------------- Ventas ----------------

export const salesApi = {
  list: async (opts: QueryOptions): Promise<Paginated<Sale>> => {
    if (USE_MOCK) return delay(db.listSales(opts));
    const qs = new URLSearchParams(opts as any).toString();
    return realFetch<Paginated<Sale>>(`/sales?${qs}`);
  },
  create: async (input: Parameters<typeof db.createSale>[0]): Promise<Sale> => {
    if (USE_MOCK) return delay(db.createSale(input));
    return realFetch<Sale>(`/sales`, { method: "POST", body: JSON.stringify(input) });
  },
};

// ---------------- Campañas ----------------

export const campaignsApi = {
  list: async (opts: QueryOptions): Promise<Paginated<Campaign>> => {
    if (USE_MOCK) return delay(db.listCampaigns(opts));
    const qs = new URLSearchParams(opts as any).toString();
    return realFetch<Paginated<Campaign>>(`/campaigns?${qs}`);
  },
  get: async (id: string): Promise<Campaign | null> => {
    if (USE_MOCK) return delay(db.getCampaign(id));
    return realFetch<Campaign | null>(`/campaigns/${id}`);
  },
  create: async (input: Omit<Campaign, "id" | "businessId" | "metrics" | "status">): Promise<Campaign> => {
    if (USE_MOCK) return delay(db.createCampaign(input));
    return realFetch<Campaign>(`/campaigns`, { method: "POST", body: JSON.stringify(input) });
  },
  updateStatus: async (id: string, status: Campaign["status"]): Promise<Campaign | null> => {
    if (USE_MOCK) return delay(db.updateCampaignStatus(id, status));
    return realFetch<Campaign | null>(`/campaigns/${id}/status`, { method: "PATCH", body: JSON.stringify({ status }) });
  },
  simulate: async (id: string): Promise<ReturnType<typeof db.simulateCampaign>> => {
    if (USE_MOCK) return delay(db.simulateCampaign(id), 500);
    return realFetch<ReturnType<typeof db.simulateCampaign>>(`/campaigns/${id}/simulate`, { method: "POST" });
  },
};

// ---------------- Importaciones ----------------

function validateRows(
  type: ImportSummary["type"],
  rows: Record<string, string>[],
  existingCustomers: Customer[]
): { errors: ImportError[]; warnings: ImportError[]; accepted: Record<string, string>[] } {
  const errors: ImportError[] = [];
  const warnings: ImportError[] = [];
  const accepted: Record<string, string>[] = [];
  const seenEmails = new Set<string>();

  const requiredByType: Record<ImportSummary["type"], string[]> = {
    customers: ["firstName", "lastName"],
    products: ["name", "price"],
    sales: ["customerEmail", "productSku", "quantity", "date"],
  };

  rows.forEach((row, idx) => {
    const rowNumber = idx + 2; // +1 por índice base 0, +1 por fila de cabecera
    let rowHasError = false;

    for (const field of requiredByType[type]) {
      if (!row[field] || row[field].trim() === "") {
        errors.push({ row: rowNumber, field, message: `Falta el campo obligatorio "${field}".` });
        rowHasError = true;
      }
    }

    if (type === "customers") {
      if (row.email) {
        if (seenEmails.has(row.email)) {
          errors.push({ row: rowNumber, field: "email", message: "Email duplicado dentro del archivo." });
          rowHasError = true;
        }
        if (existingCustomers.some((c) => c.email === row.email)) {
          warnings.push({ row: rowNumber, field: "email", message: "Ya existe un cliente con este email; se omitirá." });
        }
        seenEmails.add(row.email);
      } else {
        warnings.push({ row: rowNumber, field: "email", message: "Cliente sin email: no podrá recibir campañas por ese canal." });
      }
    }

    if (type === "products" && row.price) {
      const price = Number(row.price);
      if (Number.isNaN(price) || price < 0) {
        errors.push({ row: rowNumber, field: "price", message: "El precio debe ser un número mayor o igual a 0." });
        rowHasError = true;
      }
    }

    if (type === "sales") {
      if (row.quantity) {
        const qty = Number(row.quantity);
        if (Number.isNaN(qty) || qty <= 0) {
          errors.push({ row: rowNumber, field: "quantity", message: "La cantidad debe ser un número mayor a 0." });
          rowHasError = true;
        }
      }
      if (row.date && Number.isNaN(Date.parse(row.date))) {
        errors.push({ row: rowNumber, field: "date", message: "Fecha inválida." });
        rowHasError = true;
      }
      if (row.customerEmail && !existingCustomers.some((c) => c.email === row.customerEmail)) {
        errors.push({ row: rowNumber, field: "customerEmail", message: "No existe un cliente con este email." });
        rowHasError = true;
      }
    }

    if (!rowHasError) accepted.push(row);
  });

  return { errors, warnings, accepted };
}

export const importsApi = {
  preview: async (
    type: ImportSummary["type"],
    fileName: string,
    rows: Record<string, string>[]
  ): Promise<ImportSummary> => {
    const existingCustomers = USE_MOCK ? db.allCustomers() : [];
    const { errors, warnings } = validateRows(type, rows, existingCustomers);
    const summary: ImportSummary = {
      id: `import_${Date.now()}`,
      fileName,
      type,
      totalRows: rows.length,
      acceptedRows: rows.length - errors.filter((e, i, arr) => arr.findIndex((x) => x.row === e.row) === i).length,
      rejectedRows: new Set(errors.map((e) => e.row)).size,
      errors,
      warnings,
      status: "pending_confirmation",
      createdAt: new Date().toISOString(),
    };
    return delay(summary, 400);
  },
  confirm: async (summary: ImportSummary): Promise<ImportSummary> => {
    const confirmed: ImportSummary = { ...summary, status: "confirmed" };
    if (USE_MOCK) db.registerImport(confirmed);
    return delay(confirmed, 500);
  },
  history: async (): Promise<ImportSummary[]> => {
    if (USE_MOCK) return delay(db.listImports());
    return realFetch<ImportSummary[]>(`/imports`);
  },
};

// ---------------- Modelos ----------------

export const modelsApi = {
  list: async (): Promise<ModelVersion[]> => {
    if (USE_MOCK) return delay(db.listModelVersions());
    return realFetch<ModelVersion[]>(`/models`);
  },
};

// ---------------- Configuración ----------------

export const settingsApi = {
  get: async (): Promise<BusinessSettings> => {
    if (USE_MOCK) return delay(db.getSettings());
    return realFetch<BusinessSettings>(`/settings`);
  },
  update: async (patch: Parameters<typeof db.updateSettings>[0]): Promise<BusinessSettings> => {
    if (USE_MOCK) return delay(db.updateSettings(patch));
    return realFetch<BusinessSettings>(`/settings`, { method: "PUT", body: JSON.stringify(patch) });
  },
};

export const IS_MOCK_MODE = USE_MOCK;
