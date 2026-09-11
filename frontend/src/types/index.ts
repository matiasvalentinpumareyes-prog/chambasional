// Tipos de dominio del sistema. Reflejan exactamente los campos descritos
// en el brief técnico (secciones 7, 8, 9, 11, 13, 17, 18, 20, 24, 29).
// Cuando el backend real (FastAPI) esté disponible, estos tipos deben
// coincidir con los schemas Pydantic de app/schemas.

export type UserRole = "admin" | "business_user";

export interface AuthUser {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  businessId: string;
  businessName: string;
}

// ---------- Clientes (sección 7) ----------
export type CustomerActivityStatus = "active" | "at_risk" | "dormant" | "lost";
export type CustomerSegment =
  | "vip"
  | "loyal"
  | "frequent"
  | "new"
  | "potential"
  | "at_risk"
  | "dormant"
  | "lost"
  | "high_value"
  | "low_value";
export type Channel = "email" | "whatsapp" | "sms" | "internal";
export type RiskLevel = "low" | "medium" | "high" | "critical";
export type CustomerValue = "low" | "medium" | "high";

export interface Customer {
  id: string;
  businessId: string;
  firstName: string;
  lastName: string;
  email: string | null;
  phone: string | null;
  city: string | null;
  registeredAt: string; // ISO date
  preferredChannel: Channel;
  consent: boolean;
  status: "active" | "inactive";
  lastPurchaseAt: string | null;
  purchaseCount: number;
  totalSpend: number; // moneda: siempre en unidades decimales, nunca float impreciso en backend real
  avgTicket: number;
  avgIntervalDays: number | null; // intervalo promedio individual entre compras
  segment: CustomerSegment | null; // null -> UI muestra —
  customerValue: CustomerValue | null;
  rfm: RFMScore | null;
  churn: ChurnPrediction | null;
  activityStatus: CustomerActivityStatus | null;
  nextPurchase: NextPurchasePrediction | null;
  // Campos crudos para RUC/DNI (doc_id + ndocumento) — se mantienen para crear/editar sin hardcode
  doc_id?: string | null;
  cli_ndocumento?: string | null;
}

export interface RFMScore {
  recencyDays: number;
  frequency: number;
  monetary: number;
  r: number; // 1-5
  f: number; // 1-5
  m: number; // 1-5
  rfmScore: string; // ej "455"
}

// ---------- Churn (sección 13-16) ----------
export interface ChurnPrediction {
  customerId: string;
  churnProbability: number; // 0-1
  churnScore: number; // 0-100
  riskLevel: RiskLevel;
  predictionDate: string;
  modelVersion: string;
  reasons: string[]; // explicabilidad en lenguaje simple (sección 16)
  confidence: number; // 0-1
}

// ---------- Próxima compra (sección 17) ----------
export interface NextPurchasePrediction {
  expectedNextPurchaseDate: string | null;
  daysUntilExpectedPurchase: number | null;
  purchaseProbability: number; // 0-1
  confidence: number;
}

// ---------- Productos (sección 8) ----------
export interface Product {
  id: string;
  businessId: string;
  sku: string;
  name: string;
  description: string | null;
  category: string;
  price: number;
  cost: number | null;
  margin: number | null;
  stock: number | null;
  status: "active" | "inactive";
}

// ---------- Ventas (sección 9) ----------
export interface SaleItem {
  productId: string;
  productName: string;
  quantity: number;
  unitPrice: number;
  discount: number;
  subtotal: number;
}

export interface Sale {
  id: string;
  businessId: string;
  customerId: string;
  customerName: string;
  date: string;
  items: SaleItem[];
  discountTotal: number;
  total: number;
  channel: Channel;
  paymentMethod: string | null;
}

// ---------- Recomendaciones de producto (sección 18-19) ----------
export interface ProductRecommendation {
  customerId: string;
  productId: string;
  productName: string;
  score: number; // 0-100
  reasons: string[];
  confidence: number;
  method: "rules" | "collaborative_filtering" | "frequency" | "cold_start";
  generatedAt: string;
  modelVersion: string;
}

// ---------- Estrategia de recuperación (sección 20-21, 26-27) ----------
export interface RecoveryStrategy {
  customerId: string;
  customerName: string;
  priorityScore: number; // 0-100, Recovery Priority Score (sección 26)
  churnProbability: number;
  recoveryProbability: number;
  customerValue: CustomerValue;
  recommendedProduct: ProductRecommendation | null;
  recommendedAction: Channel;
  recommendedOffer: string; // ej "10% de descuento"
  recommendedTiming: "now" | "today" | "in_2_days" | "in_5_days";
  reason: string;
  message: string; // mensaje generado desde plantilla, solo con datos reales
  cooldownOk: boolean; // respeta communication_cooldown (sección 30)
  hasConsent: boolean;
}

// ---------- Campañas (sección 24) ----------
export type CampaignStatus =
  | "draft"
  | "scheduled"
  | "active"
  | "paused"
  | "finished"
  | "cancelled";

export interface Campaign {
  id: string;
  businessId: string;
  name: string;
  description: string;
  segment: CustomerSegment | "custom";
  targetCustomerIds: string[];
  productId: string | null;
  offer: string;
  channel: Channel;
  startDate: string;
  endDate: string | null;
  message: string;
  status: CampaignStatus;
  metrics: CampaignMetrics | null;
}

export interface CampaignMetrics {
  targeted: number;
  withConsent: number;
  withoutConsent: number;
  estimatedCost: number;
  potentialRevenue: number;
  sent: number;
  opened: number;
  responded: number;
  converted: number;
  recoveredCustomers: number;
  recoveredRevenue: number;
  roi: number | null;
}

// ---------- Importaciones (sección 10) ----------
export interface ImportError {
  row: number;
  field: string | null;
  message: string;
}

export interface ImportSummary {
  id: string;
  fileName: string;
  type: "customers" | "products" | "sales";
  totalRows: number;
  acceptedRows: number;
  rejectedRows: number;
  errors: ImportError[];
  warnings: ImportError[];
  status: "pending_confirmation" | "confirmed" | "cancelled";
  createdAt: string;
}

// ---------- Dashboard / analítica (sección 6.1) ----------
export interface DashboardMetrics {
  totalSales: number;
  totalCustomers: number;
  activeCustomers: number;
  inactiveCustomers: number;
  atRiskCustomers: number;
  lostCustomers: number;
  criticalCustomers: number;
  estimatedChurnRate: number;
  recoverableCustomers: number;
  totalCustomerValue: number;
  avgTicket: number;
  avgPurchaseFrequencyDays: number;
  recoveredRevenue: number;
  activeCampaigns: number;
  finishedCampaigns: number;
  conversionRate: number;
  campaignRoi: number | null;
  dataQualityScore: number; // sección 73
  currency: string;
}

export interface SeriesPoint {
  label: string;
  value: number;
}

export interface DashboardSeries {
  salesByDay: SeriesPoint[];
  salesByMonth: SeriesPoint[];
  newCustomersByMonth: SeriesPoint[];
  lostCustomersByMonth: SeriesPoint[];
  recoveredCustomersByMonth: SeriesPoint[];
  churnEvolution: SeriesPoint[];
  topProducts: SeriesPoint[];
  segmentDistribution: SeriesPoint[];
  revenueBySegment: SeriesPoint[];
}

// ---------- Modelos ML (sección 47-48) ----------
export type ModelStatus = "training" | "candidate" | "production" | "deprecated" | "failed";

export interface ModelVersion {
  id: string;
  modelName: string;
  version: string;
  trainingDate: string;
  datasetVersion: string;
  features: string[];
  metrics: {
    accuracy: number;
    precision: number;
    recall: number;
    f1: number;
    rocAuc: number;
    prAuc: number;
  };
  status: ModelStatus;
}

// ---------- Configuración del negocio (sección 69) ----------
export interface BusinessSettings {
  businessName: string;
  currency: "PEN" | "USD" | "EUR" | "MXN" | "COP";
  timezone: string;
  analysisWindowDays: number;
  churnThresholds: { medium: number; high: number; critical: number };
  campaignCooldownDays: number;
  availableChannels: Channel[];
  discountRules: { segment: string; maxDiscountPct: number }[];
  language: "es" | "en";
}

// ---------- Empresa (tenant) — espejo de backend/app/schemas/empresa.py EmpresaOut ----------
// Tabla real: empresa (emp_id, emp_ruc, emp_razon_social, emp_nombre_comercial, emp_direccion, emp_lema, emp_email, emp_celular1/2, emp_telefono1/2, emp_nro_cuenta1/2, dep_id, prv_id, dis_id) — database_postgres.sql:148
export interface EmpresaOut {
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
}
// Alias legado para compatibilidad con código que importaba EmpresaSettingsRaw desde services/api
export type EmpresaSettingsRaw = EmpresaOut;

// ---------- Paginación genérica ----------
export interface Paginated<T> {
  items: T[];
  page: number;
  pageSize: number;
  total: number;
}

export interface ApiError {
  success: false;
  error: { code: string; message: string };
}
