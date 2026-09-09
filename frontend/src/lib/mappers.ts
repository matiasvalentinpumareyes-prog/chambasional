import type { AuthUser, Customer, Paginated } from "@/types";

// Auth: UsuarioOut (ES, backend) -> AuthUser (EN, frontend)
// Mantiene emp_id para aislar datos por empresa (ej 0471cf4c... con 1252 clientes)
export function usuarioOutToAuthUser(u: any): AuthUser {
  return {
    id: u.usu_id,
    name: u.usp_nombres ?? u.usu_usuario ?? u.usu_email,
    email: u.usu_email,
    role: (u.rol_codigo === "SUPERADMIN" || u.rol_codigo === "ADMIN_EMPRESA" ? "admin" : "business_user") as AuthUser["role"],
    businessId: u.emp_id,
    businessName: u.emp_nombre_comercial ?? "",
  };
}

// Paginated: backend snake_case -> frontend camelCase
export function mapPaginated<T, R>(raw: { items: T[]; page: number; page_size: number; total: number }, mapper: (t: T) => R): Paginated<R> {
  return {
    items: raw.items.map(mapper),
    page: raw.page,
    pageSize: raw.page_size,
    total: raw.total,
  };
}

// ClienteOut (ES) -> Customer (EN)
// Muestra "—" en UI para nulls hasta conseguir datos reales (Fase 5)
export function clienteOutToCustomer(c: any): Customer {
  const nombre = (c.cli_nombre_razon_social ?? "").trim();
  const parts = nombre.split(/\s+/).filter(Boolean);
  const firstName = parts[0] ?? "—";
  const lastName = parts.slice(1).join(" ") || "—";
  // segment puede venir como segmento_actual o null
  const segRaw = c.segmento_actual ?? c.segment ?? null;
  // Normalizar segmentos ES -> EN del frontend si hace falta, si no, dejar null y UI muestra —
  const segmentMap: Record<string, string> = {
    NUEVO: "new",
    ACTIVO: "loyal",
    EN_RIESGO: "at_risk",
    PERDIDO: "lost",
    RECUPERADO: "potential",
    LEAL: "vip",
  };
  const segment = segRaw ? (segmentMap[segRaw] ?? segRaw.toLowerCase()) : null;

  return {
    id: c.cli_id,
    businessId: c.emp_id,
    firstName,
    lastName,
    email: c.cli_email ?? null,
    phone: c.cli_celular ?? null,
    city: c.cli_direccion ?? null, // direccion como fallback temporal
    registeredAt: c.created_at ?? new Date().toISOString(),
    preferredChannel: "internal",
    consent: false,
    status: c.estado === 1 ? "active" : "inactive",
    lastPurchaseAt: null, // hasta tener ventas
    purchaseCount: 0,
    totalSpend: 0,
    avgTicket: 0,
    avgIntervalDays: null,
    segment: segment as Customer["segment"] | null,
    customerValue: null as any,
    rfm: null as any,
    churn: null,
    activityStatus: "active" as any,
    nextPurchase: null,
  };
}

// ClienteOut list -> Paginated<Customer>
export function clientePaginatedToCustomer(raw: any): Paginated<Customer> {
  // raw ya viene con snake_case desde backend
  return mapPaginated(raw, clienteOutToCustomer);
}
