import type {
  AuthUser,
  Campaign,
  Customer,
  DashboardMetrics,
  DashboardSeries,
  ImportSummary,
  ModelVersion,
  Paginated,
  Product,
  ProductRecommendation,
  RecoveryStrategy,
  Sale,
  BusinessSettings,
} from "@/types";

const API_URL = import.meta.env.VITE_API_URL ?? "http://localhost:8000/api";

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

function usuarioOutToAuthUser(u: any): AuthUser {
  // Backend UsuarioOut (ES) -> Frontend AuthUser (EN)
  // Mantiene emp_id 0471cf4c... para datos existentes
  return {
    id: u.usu_id,
    name: u.usp_nombres ?? u.usu_usuario ?? u.usu_email,
    email: u.usu_email,
    role: (u.rol_codigo === "SUPERADMIN" || u.rol_codigo === "ADMIN_EMPRESA" ? "admin" : "business_user") as AuthUser["role"],
    businessId: u.emp_id,
    businessName: u.emp_nombre_comercial ?? "",
  };
}

export const authApi = {
  login: async (email: string, _password: string): Promise<AuthUser> => {
    const data = await realFetch<{ token: string; user: any }>("/auth/login", {
      method: "POST",
      body: JSON.stringify({ usu_email: email, password: _password }),
    });
    const mapped = usuarioOutToAuthUser(data.user);
    localStorage.setItem("auth_token", data.token);
    localStorage.setItem("auth_user", JSON.stringify(mapped));
    // Guardar raw para debug si hace falta
    localStorage.setItem("auth_user_raw", JSON.stringify(data.user));
    return mapped;
  },
  register: async (payload: {
    emp_ruc: string;
    emp_razon_social: string;
    emp_nombre_comercial: string;
    emp_email?: string;
    usp_nombres: string;
    usp_dni?: string;
    usu_usuario: string;
    usu_email: string;
    password: string;
    rol_codigo?: string;
  }): Promise<AuthUser> => {
    const data = await realFetch<{ token: string; user: any }>("/auth/register", {
      method: "POST",
      body: JSON.stringify(payload),
    });
    const mapped = usuarioOutToAuthUser(data.user);
    localStorage.setItem("auth_token", data.token);
    localStorage.setItem("auth_user", JSON.stringify(mapped));
    localStorage.setItem("auth_user_raw", JSON.stringify(data.user));
    return mapped;
  },
  me: async (): Promise<AuthUser | null> => {
    try {
      const raw = await realFetch<any>("/auth/me");
      const mapped = usuarioOutToAuthUser(raw);
      localStorage.setItem("auth_user", JSON.stringify(mapped));
      localStorage.setItem("auth_user_raw", JSON.stringify(raw));
      return mapped;
    } catch {
      return null;
    }
  },
  logout: () => {
    localStorage.removeItem("auth_token");
    localStorage.removeItem("auth_user");
    localStorage.removeItem("auth_user_raw");
  },
  currentUser: (): AuthUser | null => {
    const raw = localStorage.getItem("auth_user");
    return raw ? JSON.parse(raw) : null;
  },
};

// ---------------- Dashboard ----------------

export const dashboardApi = {
  getMetrics: async (): Promise<DashboardMetrics> => {
    return realFetch<DashboardMetrics>("/dashboard");
  },
  getSeries: async (): Promise<DashboardSeries> => {
    return realFetch<DashboardSeries>("/dashboard/series");
  },
};

// ---------------- Clientes ----------------

export const customersApi = {
  list: async (opts: { page?: number; pageSize?: number; search?: string; [k: string]: any }): Promise<Paginated<Customer>> => {
    const qs = new URLSearchParams(opts as any).toString();
    return realFetch<Paginated<Customer>>(`/clientes?${qs}`);
  },
  get: async (id: string): Promise<Customer | null> => {
    return realFetch<Customer | null>(`/clientes/${id}`);
  },
  create: async (input: Partial<Customer>): Promise<Customer> => {
    // Adaptar frontend EN -> backend ES (cli_nombre_razon_social, cli_email, doc_id)
    const payload: any = {
      cli_nombre_razon_social: `${input.firstName ?? ""} ${input.lastName ?? ""}`.trim(),
      cli_email: input.email,
      cli_celular: input.phone,
      doc_id: (input as any).doc_id,
      cli_ndocumento: (input as any).cli_ndocumento,
    };
    return realFetch<Customer>(`/clientes`, { method: "POST", body: JSON.stringify(payload) });
  },
  update: async (id: string, patch: Partial<Customer>): Promise<Customer | null> => {
    const payload: any = {
      cli_nombre_razon_social: patch.firstName && patch.lastName ? `${patch.firstName} ${patch.lastName}` : undefined,
      cli_email: patch.email,
      cli_celular: patch.phone,
    };
    return realFetch<Customer | null>(`/clientes/${id}`, { method: "PUT", body: JSON.stringify(payload) });
  },
  deactivate: async (id: string): Promise<Customer | null> => {
    return realFetch<Customer | null>(`/clientes/${id}`, { method: "DELETE" });
  },
  sales: async (id: string): Promise<Sale[]> => {
    return realFetch<Sale[]>(`/ventas?cli_id=${id}`);
  },
  recommendations: async (id: string): Promise<ProductRecommendation[]> => {
    return realFetch<ProductRecommendation[]>(`/clientes/${id}/recommendations`);
  },
  strategy: async (id: string): Promise<RecoveryStrategy | null> => {
    return realFetch<RecoveryStrategy | null>(`/clientes/${id}/strategy`);
  },
};

export const atRiskApi = {
  list: async (opts: { page?: number; pageSize?: number; search?: string; [k: string]: any }): Promise<Paginated<Customer>> => {
    const qs = new URLSearchParams(opts as any).toString();
    return realFetch<Paginated<Customer>>(`/predictions/churn?${qs}`);
  },
  todayActions: async (limit = 20): Promise<RecoveryStrategy[]> => {
    return realFetch<RecoveryStrategy[]>(`/strategies/today?limit=${limit}`);
  },
};

// ---------------- Productos ----------------

export const productsApi = {
  list: async (opts: { page?: number; pageSize?: number; search?: string; [k: string]: any }): Promise<Paginated<Product>> => {
    const qs = new URLSearchParams(opts as any).toString();
    return realFetch<Paginated<Product>>(`/productos?${qs}`);
  },
  create: async (input: any): Promise<Product> => {
    return realFetch<Product>(`/productos`, { method: "POST", body: JSON.stringify(input) });
  },
  update: async (id: string, patch: Partial<Product>): Promise<Product | null> => {
    return realFetch<Product | null>(`/productos/${id}`, { method: "PUT", body: JSON.stringify(patch) });
  },
  deactivate: async (id: string): Promise<Product | null> => {
    return realFetch<Product | null>(`/productos/${id}`, { method: "DELETE" });
  },
  categories: async (): Promise<string[]> => {
    return realFetch<string[]>(`/productos/categorias`);
  },
};

// ---------------- Ventas ----------------

export const salesApi = {
  list: async (opts: { page?: number; pageSize?: number; [k: string]: any }): Promise<Paginated<Sale>> => {
    const qs = new URLSearchParams(opts as any).toString();
    return realFetch<Paginated<Sale>>(`/ventas?${qs}`);
  },
  create: async (input: { customerId: string; items: { productId: string; quantity: number }[]; channel?: string }): Promise<Sale> => {
    const payload: any = {
      cli_id: input.customerId,
      items: input.items.map((it) => ({ prd_id: it.productId, cantidad: it.quantity })),
      venta_origen: input.channel,
    };
    return realFetch<Sale>(`/ventas`, { method: "POST", body: JSON.stringify(payload) });
  },
};

// ---------------- Stock ----------------

export const stockApi = {
  list: async (): Promise<any[]> => {
    return realFetch<any[]>(`/stock`);
  },
  get: async (prd_id: string): Promise<any> => {
    return realFetch<any>(`/stock/${prd_id}`);
  },
  movimiento: async (prd_id: string, delta: number, motivo?: string): Promise<any> => {
    return realFetch<any>(`/stock/movimiento`, { method: "POST", body: JSON.stringify({ prd_id, delta, motivo }) });
  },
};

// ---------------- Campañas ----------------

export const campaignsApi = {
  list: async (opts: { page?: number; pageSize?: number; [k: string]: any }): Promise<Paginated<Campaign>> => {
    const qs = new URLSearchParams(opts as any).toString();
    return realFetch<Paginated<Campaign>>(`/campaigns?${qs}`);
  },
  get: async (id: string): Promise<Campaign | null> => {
    return realFetch<Campaign | null>(`/campaigns/${id}`);
  },
  create: async (input: any): Promise<Campaign> => {
    return realFetch<Campaign>(`/campaigns`, { method: "POST", body: JSON.stringify(input) });
  },
  updateStatus: async (id: string, status: Campaign["status"]): Promise<Campaign | null> => {
    return realFetch<Campaign | null>(`/campaigns/${id}/status`, { method: "PATCH", body: JSON.stringify({ status }) });
  },
  simulate: async (id: string): Promise<any> => {
    return realFetch<any>(`/campaigns/${id}/simulate`, { method: "POST" });
  },
};

// ---------------- Catálogos dinámicos ----------------

export const catalogsApi = {
  metodosPago: async (): Promise<{ mtp_id: string; mtp_nombre: string }[]> => realFetch(`/catalogos/metodos-pago`),
  canales: async (): Promise<{ can_id: string; can_codigo: string }[]> => realFetch(`/catalogos/canales`),
  segmentos: async (): Promise<any[]> => realFetch(`/catalogos/segmentos`),
  subcategorias: async (cat_id?: string): Promise<any[]> => {
    const qs = cat_id ? `?cat_id=${cat_id}` : "";
    return realFetch(`/subcategorias${qs}`);
  },
};

// ---------------- Importaciones ----------------

export const importsApi = {
  preview: async (
    type: ImportSummary["type"],
    fileName: string,
    rows: Record<string, string>[]
  ): Promise<ImportSummary> => {
    return realFetch<ImportSummary>(`/imports/preview`, { method: "POST", body: JSON.stringify({ type, file_name: fileName, rows }) });
  },
  confirm: async (summary: ImportSummary): Promise<ImportSummary> => {
    return realFetch<ImportSummary>(`/imports/${summary.id}/confirm`, { method: "POST", body: JSON.stringify({ type: summary.type, file_name: summary.fileName, rows: [] }) });
  },
  history: async (): Promise<ImportSummary[]> => {
    return realFetch<ImportSummary[]>(`/imports`);
  },
};

// ---------------- Modelos ----------------

export const modelsApi = {
  list: async (): Promise<ModelVersion[]> => {
    return realFetch<ModelVersion[]>(`/models`);
  },
};

// ---------------- Configuración ----------------

export const settingsApi = {
  get: async (): Promise<BusinessSettings> => {
    return realFetch<BusinessSettings>(`/settings`);
  },
  update: async (patch: any): Promise<BusinessSettings> => {
    return realFetch<BusinessSettings>(`/settings`, { method: "PUT", body: JSON.stringify(patch) });
  },
};

export const IS_MOCK_MODE = false;
