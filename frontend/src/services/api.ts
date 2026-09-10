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
import { usuarioOutToAuthUser, clienteOutToCustomer, clientePaginatedToCustomer } from "@/lib/mappers";

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
    // Interceptor 401: token expirado o inválido -> logout y redirect a /login
    if (res.status === 401) {
      localStorage.removeItem("auth_token");
      localStorage.removeItem("auth_user");
      localStorage.removeItem("auth_user_raw");
      if (window.location.pathname !== "/login" && window.location.pathname !== "/register") {
        window.location.href = "/login";
      }
    }
    const body = await res.json().catch(() => null);
    throw new Error(body?.error?.message ?? body?.detail ?? `Error de red (${res.status})`);
  }
  return res.json();
}

// ---------------- Auth ----------------
// mapper importado desde @/lib/mappers para mantener emp_id 0471cf4c... y RUC/DNI handling centralizado

export const authApi = {
  login: async (identifier: string, _password: string): Promise<AuthUser> => {
    const id = identifier.trim();
    const isEmail = id.includes("@");
    const body: any = { password: _password };
    // Envía en ambos campos + alias identifier para compatibilidad backend
    // Backend hace OR sobre usu_email/usu_usuario/identifier
    if (isEmail) {
      body.usu_email = id;
      body.usu_usuario = id;
    } else {
      body.usu_usuario = id;
      body.usu_email = id;
    }
    body.identifier = id;
    const data = await realFetch<{ token: string; user: any }>("/auth/login", {
      method: "POST",
      body: JSON.stringify(body),
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
// Backend devuelve snake_case (acorde a app/schemas/dashboard.py). Frontend usa camelCase.
function mapDashboardMetrics(raw: any): DashboardMetrics {
  return {
    totalSales: raw.total_sales ?? raw.totalSales ?? 0,
    totalCustomers: raw.total_customers ?? raw.totalCustomers ?? 0,
    activeCustomers: raw.active_customers ?? raw.activeCustomers ?? 0,
    inactiveCustomers: raw.inactive_customers ?? raw.inactiveCustomers ?? 0,
    atRiskCustomers: raw.at_risk_customers ?? raw.atRiskCustomers ?? 0,
    lostCustomers: raw.lost_customers ?? raw.lostCustomers ?? 0,
    criticalCustomers: raw.critical_customers ?? raw.criticalCustomers ?? 0,
    estimatedChurnRate: raw.estimated_churn_rate ?? raw.estimatedChurnRate ?? 0,
    recoverableCustomers: raw.recoverable_customers ?? raw.recoverableCustomers ?? 0,
    totalCustomerValue: raw.total_customer_value ?? raw.totalCustomerValue ?? 0,
    avgTicket: raw.avg_ticket ?? raw.avgTicket ?? 0,
    avgPurchaseFrequencyDays: raw.avg_purchase_frequency_days ?? raw.avgPurchaseFrequencyDays ?? 0,
    recoveredRevenue: raw.recovered_revenue ?? raw.recoveredRevenue ?? 0,
    activeCampaigns: raw.active_campaigns ?? raw.activeCampaigns ?? 0,
    finishedCampaigns: raw.finished_campaigns ?? raw.finishedCampaigns ?? 0,
    conversionRate: raw.conversion_rate ?? raw.conversionRate ?? 0,
    campaignRoi: raw.campaign_roi ?? raw.campaignRoi ?? null,
    dataQualityScore: raw.data_quality_score ?? raw.dataQualityScore ?? 0,
    currency: raw.currency ?? "PEN",
  };
}

function mapDashboardSeries(raw: any): DashboardSeries {
  const toArr = (v: any) => (Array.isArray(v) ? v : []);
  return {
    salesByDay: toArr(raw.sales_by_day ?? raw.salesByDay),
    salesByMonth: toArr(raw.sales_by_month ?? raw.salesByMonth),
    newCustomersByMonth: toArr(raw.new_customers_by_month ?? raw.newCustomersByMonth),
    lostCustomersByMonth: toArr(raw.lost_customers_by_month ?? raw.lostCustomersByMonth),
    recoveredCustomersByMonth: toArr(raw.recovered_customers_by_month ?? raw.recoveredCustomersByMonth),
    churnEvolution: toArr(raw.churn_evolution ?? raw.churnEvolution),
    topProducts: toArr(raw.top_products ?? raw.topProducts),
    segmentDistribution: toArr(raw.segment_distribution ?? raw.segmentDistribution),
    revenueBySegment: toArr(raw.revenue_by_segment ?? raw.revenueBySegment),
  };
}

export const dashboardApi = {
  getMetrics: async (): Promise<DashboardMetrics> => {
    const raw = await realFetch<any>("/dashboard");
    return mapDashboardMetrics(raw);
  },
  getSeries: async (): Promise<DashboardSeries> => {
    const raw = await realFetch<any>("/dashboard/series");
    return mapDashboardSeries(raw);
  },
};

// ---------------- Clientes ----------------

export const customersApi = {
  list: async (opts: { page?: number; pageSize?: number; search?: string; [k: string]: any }): Promise<Paginated<Customer>> => {
    // Mapear pageSize -> page_size que espera backend pagination.py:10, ignorar filtros no soportados
    const params: Record<string, string> = {};
    if (opts.page) params.page = String(opts.page);
    if (opts.pageSize) params.page_size = String(opts.pageSize);
    if (opts.search) params.search = opts.search;
    // Soportar doc_id/estado si vienen en opts, para RUC/DNI filtro futuro
    if (opts.doc_id) params.doc_id = String(opts.doc_id);
    if (opts.estado !== undefined) params.estado = String(opts.estado);
    const qs = new URLSearchParams(params).toString();
    const raw = await realFetch<any>(`/clientes?${qs}`);
    return clientePaginatedToCustomer(raw);
  },
  get: async (id: string): Promise<Customer | null> => {
    const raw = await realFetch<any>(`/clientes/${id}`);
    return raw ? clienteOutToCustomer(raw) : null;
  },
  create: async (input: Partial<Customer> & { doc_id?: string; cli_ndocumento?: string }): Promise<Customer> => {
    // Adaptar EN -> ES, manejando RUC/DNI ambos (doc_id + cli_ndocumento requeridos)
    const nombre = `${input.firstName ?? ""} ${input.lastName ?? ""}`.trim() || (input as any).cli_nombre_razon_social || "—";
    const payload: any = {
      cli_nombre_razon_social: nombre,
      cli_email: input.email ?? null,
      cli_celular: input.phone ?? null,
      doc_id: (input as any).doc_id,
      cli_ndocumento: (input as any).cli_ndocumento,
      cli_direccion: (input as any).cli_direccion ?? (input as any).city ?? null,
    };
    const raw = await realFetch<any>(`/clientes`, { method: "POST", body: JSON.stringify(payload) });
    return clienteOutToCustomer(raw);
  },
  update: async (id: string, patch: Partial<Customer> & { doc_id?: string; cli_ndocumento?: string }): Promise<Customer | null> => {
    const payload: any = {};
    if (patch.firstName || patch.lastName) payload.cli_nombre_razon_social = `${patch.firstName ?? ""} ${patch.lastName ?? ""}`.trim();
    if (patch.email !== undefined) payload.cli_email = patch.email;
    if (patch.phone !== undefined) payload.cli_celular = patch.phone;
    if ((patch as any).doc_id) payload.doc_id = (patch as any).doc_id;
    if ((patch as any).cli_ndocumento) payload.cli_ndocumento = (patch as any).cli_ndocumento;
    if ((patch as any).cli_direccion) payload.cli_direccion = (patch as any).cli_direccion;
    const raw = await realFetch<any>(`/clientes/${id}`, { method: "PUT", body: JSON.stringify(payload) });
    return raw ? clienteOutToCustomer(raw) : null;
  },
  deactivate: async (id: string): Promise<Customer | null> => {
    const raw = await realFetch<any>(`/clientes/${id}`, { method: "DELETE" });
    return raw ? clienteOutToCustomer(raw) : null;
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
  documentos: async (): Promise<{ doc_id: string; doc_tipo: string; doc_descripcion: string }[]> => realFetch(`/catalogos/documentos`),
  roles: async (): Promise<any[]> => realFetch(`/roles`),
  subcategorias: async (cat_id?: string): Promise<any[]> => {
    const qs = cat_id ? `?cat_id=${cat_id}` : "";
    const raw = await realFetch<any>(`/subcategorias${qs}`);
    // Backend devuelve Paginated {items, total} desde subcategorias.py:38, no array directo
    if (raw && Array.isArray(raw.items)) return raw.items;
    if (Array.isArray(raw)) return raw;
    return [];
  },
  createSubcategoria: async (payload: { cat_id: string; subcat_nombre: string }): Promise<any> =>
    realFetch(`/subcategorias`, { method: "POST", body: JSON.stringify(payload) }),
};

// ---------------- Usuarios / Roles / Perfil (centralizado, sin fetch manual) ----------------

export const usuariosApi = {
  list: async (): Promise<any[]> => realFetch(`/usuarios`),
  create: async (payload: { usu_usuario: string; usu_email: string; password: string; rol_id?: string; usp_nombres?: string }): Promise<any> =>
    realFetch(`/usuarios`, { method: "POST", body: JSON.stringify(payload) }),
};

export const rolesApi = {
  list: async (): Promise<any[]> => realFetch(`/roles`),
};

export const perfilApi = {
  get: async (): Promise<any> => realFetch(`/usuarios/me/personal`),
  update: async (payload: any): Promise<any> => realFetch(`/usuarios/me/personal`, { method: "PUT", body: JSON.stringify(payload) }),
};

export const categoriasApi = {
  list: async (): Promise<string[]> => realFetch(`/products/categorias`),
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
export type EmpresaSettingsRaw = {
  emp_id: string;
  emp_ruc: string;
  emp_razon_social: string;
  emp_nombre_comercial: string;
  emp_direccion?: string | null;
  emp_lema?: string | null;
  emp_email?: string | null;
  emp_celular1?: string | null;
  emp_celular2?: string | null;
  emp_telefono1?: string | null;
  emp_telefono2?: string | null;
  emp_nro_cuenta1?: string | null;
  emp_nro_cuenta2?: string | null;
  dep_id?: string | null;
  prv_id?: string | null;
  dis_id?: string | null;
  estado: number;
  created_at?: string | null;
  updated_at?: string | null;
};

export const settingsApi = {
  get: async (): Promise<EmpresaSettingsRaw & Partial<BusinessSettings>> => {
    return realFetch<EmpresaSettingsRaw & Partial<BusinessSettings>>(`/settings`);
  },
  update: async (patch: any): Promise<EmpresaSettingsRaw & Partial<BusinessSettings>> => {
    return realFetch<EmpresaSettingsRaw & Partial<BusinessSettings>>(`/settings`, { method: "PUT", body: JSON.stringify(patch) });
  },
};

export const IS_MOCK_MODE = false;
