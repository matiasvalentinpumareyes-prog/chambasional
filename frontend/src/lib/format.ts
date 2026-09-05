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
export function formatMoney(amount: number, currency: string = "PEN"): string {
  const locale = CURRENCY_LOCALE[currency] ?? "es-PE";
  return new Intl.NumberFormat(locale, {
    style: "currency",
    currency,
    maximumFractionDigits: 2,
  }).format(amount);
}

export function formatNumber(n: number): string {
  return new Intl.NumberFormat("es-PE").format(n);
}

export function formatPercent(fraction: number, digits = 0): string {
  return `${(fraction * 100).toFixed(digits)}%`;
}

export function formatDate(iso: string | null): string {
  if (!iso) return "—";
  const d = new Date(iso);
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

export const RISK_LABEL: Record<RiskLevel, string> = {
  low: "Bajo",
  medium: "Medio",
  high: "Alto",
  critical: "Crítico",
};

export const RISK_COLOR: Record<RiskLevel, string> = {
  low: "risk-low",
  medium: "risk-medium",
  high: "risk-high",
  critical: "risk-critical",
};

export const SEGMENT_LABEL: Record<CustomerSegment, string> = {
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

export const ACTIVITY_LABEL: Record<CustomerActivityStatus, string> = {
  active: "Activo",
  at_risk: "En riesgo",
  dormant: "Dormido",
  lost: "Perdido",
};

export const CHANNEL_LABEL: Record<Channel, string> = {
  email: "Email",
  whatsapp: "WhatsApp",
  sms: "SMS",
  internal: "Notificación interna",
};

export function classNames(...values: Array<string | false | null | undefined>): string {
  return values.filter(Boolean).join(" ");
}
