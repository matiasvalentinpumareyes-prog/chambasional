import type { Channel, CustomerActivityStatus, CustomerSegment, RiskLevel } from "@/types";

const CURRENCY_LOCALE: Record<string, string> = {
  PEN: "es-PE",
  USD: "en-US",
  EUR: "de-DE",
  MXN: "es-MX",
  COP: "es-CO",
};

/**
 * Formatea un monto monetario. En el backend real el valor debe viajar como
 * string/decimal (NUMERIC), nunca float sin control de precisión (sección 72
 * del brief). Aquí solo se formatea para presentación.
 */
export function formatMoney(amount: number | string | null | undefined, currency: string = "PEN"): string {
  if (amount === null || amount === undefined || amount === "") return "—";
  const n = typeof amount === "string" ? parseFloat(amount) : amount;
  if (Number.isNaN(n) || !Number.isFinite(n)) return "—";
  const locale = CURRENCY_LOCALE[currency] ?? "es-PE";
  return new Intl.NumberFormat(locale, {
    style: "currency",
    currency,
    maximumFractionDigits: 2,
  }).format(n);
}

export function formatNumber(n: number): string {
  return new Intl.NumberFormat("es-PE").format(n);
}

export function formatPercent(fraction: number | string | null | undefined, digits = 0): string {
  if (fraction === null || fraction === undefined || fraction === "") return "—";
  const n = typeof fraction === "string" ? parseFloat(fraction) : fraction;
  if (Number.isNaN(n) || !Number.isFinite(n)) return "—";
  return `${(n * 100).toFixed(digits)}%`;
}

export function formatDate(iso: string | null | undefined): string {
  if (!iso) return "—";
  const d = new Date(iso);
  if (Number.isNaN(d.getTime())) return "—";
  return d.toLocaleDateString("es-PE", { year: "numeric", month: "short", day: "2-digit" });
}

export function daysBetween(a: Date, b: Date): number {
  const ms = Math.abs(a.getTime() - b.getTime());
  return Math.floor(ms / (1000 * 60 * 60 * 24));
}

export function daysAgo(iso: string | null, reference: Date = new Date()): number | null {
  if (!iso) return null;
  return daysBetween(reference, new Date(iso));
}

export const RISK_LABEL: Record<string, string> = {
  low: "Bajo",
  medium: "Medio",
  high: "Alto",
  critical: "Crítico",
  LOW: "Bajo",
  MEDIUM: "Medio",
  HIGH: "Alto",
  CRITICAL: "Crítico",
};

export const RISK_COLOR: Record<RiskLevel, string> = {
  low: "risk-low",
  medium: "risk-medium",
  high: "risk-high",
  critical: "risk-critical",
};

export const SEGMENT_LABEL: Record<string, string> = {
  vip: "VIP",
  loyal: "Fiel",
  frequent: "Frecuente",
  new: "Nuevo",
  potential: "Potencial",
  at_risk: "En riesgo",
  dormant: "Dormido",
  lost: "Perdido",
  high_value: "Alto valor",
  low_value: "Bajo valor",
};

export const ACTIVITY_LABEL: Record<string, string> = {
  active: "Activo",
  at_risk: "En riesgo",
  dormant: "Dormido",
  lost: "Perdido",
};

export const CHANNEL_LABEL: Record<string, string> = {
  email: "Email",
  whatsapp: "WhatsApp",
  sms: "SMS",
  internal: "Notificación interna",
  EMAIL: "Email",
  WHATSAPP: "WhatsApp",
  SMS: "SMS",
  PUSH: "Push",
};

export function classNames(...values: Array<string | false | null | undefined>): string {
  return values.filter(Boolean).join(" ");
}
