import type {
  ChurnPrediction,
  Customer,
  CustomerActivityStatus,
  CustomerSegment,
  CustomerValue,
  NextPurchasePrediction,
  Product,
  ProductRecommendation,
  RecoveryStrategy,
  RFMScore,
  RiskLevel,
  Sale,
} from "@/types";
import { daysBetween } from "@/lib/format";

/**
 * MOTOR DE ANÁLISIS — capa de reglas (fallback transparente).
 *
 * Este archivo implementa la sección 76 del brief técnico ("sistema de
 * fallback"): mientras el pipeline real de Machine Learning (backend/ml,
 * a cargo del Programador 1 según el plan de roles) no esté disponible,
 * el frontend calcula RFM, riesgo de abandono, próxima compra y
 * recomendaciones mediante REGLAS explícitas y trazables aplicadas sobre
 * los datos reales del negocio (no hay ningún valor inventado: todo sale
 * de las ventas y clientes generados en seedData.ts).
 *
 * Cuando el backend con los modelos entrenados (Regresión Logística /
 * Random Forest / Gradient Boosting, ver ML.md) esté listo, basta con
 * reemplazar las llamadas a estas funciones por peticiones a
 * /api/predictions/churn, /api/recommendations y /api/strategies — la
 * forma de los datos (los tipos en src/types) ya es la misma.
 *
 * model_version aquí se identifica como "rules-v1-fallback" para dejar
 * explícito, en toda la interfaz, que no se trata todavía de un modelo
 * de ML entrenado (regla 79 del brief: nunca fingir una funcionalidad).
 */

const MODEL_VERSION = "rules-v1-fallback";

// ---------------- RFM ----------------

function scoreQuintile(value: number, thresholds: number[]): number {
  // thresholds ascendentes de 4 cortes -> score 1..5
  let score = 1;
  for (const t of thresholds) {
    if (value >= t) score += 1;
  }
  return Math.min(score, 5);
}

export function computeRFM(customer: Customer, referenceDate: Date): RFMScore {
  const recencyDays = customer.lastPurchaseAt
    ? daysBetween(referenceDate, new Date(customer.lastPurchaseAt))
    : 9999;
  const frequency = customer.purchaseCount;
  const monetary = customer.totalSpend;

  // Recencia: menor es mejor -> invertir escala.
  const r = 6 - scoreQuintile(recencyDays, [15, 30, 60, 120]);
  const f = scoreQuintile(frequency, [2, 4, 7, 12]);
  const m = scoreQuintile(monetary, [50, 150, 400, 900]);

  return {
    recencyDays,
    frequency,
    monetary,
    r: Math.max(1, r),
    f,
    m,
    rfmScore: `${Math.max(1, r)}${f}${m}`,
  };
}

export function segmentFromRFM(rfm: RFMScore, purchaseCount: number, registeredDaysAgo: number): CustomerSegment {
  if (purchaseCount === 0) return "new";
  if (registeredDaysAgo <= 30 && purchaseCount <= 2) return "new";
  if (rfm.r <= 1 && rfm.f <= 2) return "lost";
  if (rfm.r === 2 && rfm.f <= 3) return "dormant";
  if (rfm.r <= 2 && rfm.f >= 3) return "at_risk";
  if (rfm.r >= 4 && rfm.f >= 4 && rfm.m >= 4) return "vip";
  if (rfm.m >= 4 && rfm.f <= 3) return "high_value";
  if (rfm.f >= 4 && rfm.r >= 3) return "loyal";
  if (rfm.f >= 3) return "frequent";
  if (rfm.m <= 2 && rfm.f <= 2) return "low_value";
  return "potential";
}

export function customerValueFromRFM(rfm: RFMScore): CustomerValue {
  const score = rfm.m + rfm.f;
  if (score >= 7) return "high";
  if (score >= 4) return "medium";
  return "low";
}

// ---------------- Detección de actividad individual (sección 12) ----------------

/**
 * Clasifica al cliente usando SU PROPIO intervalo promedio de compra, no un
 * umbral fijo como "30 días = perdido". Un cliente que compra cada 7 días y
 * lleva 20 sin comprar está mucho más "en riesgo" que uno que compra cada
 * 180 días y lleva 100 sin comprar.
 */
export function computeActivityStatus(customer: Customer, rfm: RFMScore): CustomerActivityStatus {
  if (customer.purchaseCount === 0) return "active"; // cliente nuevo sin historial suficiente
  if (customer.purchaseCount === 1 || !customer.avgIntervalDays) {
    // Sin suficientes compras para estimar un intervalo individual: usar
    // una regla general conservadora (cold start, sección 46).
    if (rfm.recencyDays > 90) return "lost";
    if (rfm.recencyDays > 45) return "at_risk";
    return "active";
  }
  const ratio = rfm.recencyDays / customer.avgIntervalDays;
  if (ratio <= 1.3) return "active";
  if (ratio <= 2.2) return "at_risk";
  if (ratio <= 4) return "dormant";
  return "lost";
}

// ---------------- Churn (secciones 13-16) ----------------

const RISK_THRESHOLDS: Array<[number, RiskLevel]> = [
  [80, "critical"],
  [60, "high"],
  [30, "medium"],
  [0, "low"],
];

export function computeChurn(customer: Customer, rfm: RFMScore, activity: CustomerActivityStatus): ChurnPrediction | null {
  if (customer.purchaseCount === 0) return null; // cold start: sin datos, no se predice (sección 46)

  const avgInterval = customer.avgIntervalDays ?? 30;
  const ratio = avgInterval > 0 ? rfm.recencyDays / avgInterval : 1;
  const recencyFactor = Math.max(0, Math.min(1, ratio));

  // Score compuesto y transparente (0-100) a partir de variables
  // disponibles ANTES del período que se predice (sin data leakage,
  // sección 14): recencia relativa, frecuencia, gasto reciente y consentimiento.
  let score = 0;
  score += Math.min(55, Math.max(0, (ratio - 0.8) * 35)); // peso principal: qué tan atrasado está
  score += (rfm.f <= 2 ? 15 : rfm.f <= 3 ? 8 : 0) * recencyFactor; // baja frecuencia histórica
  score += (rfm.m <= 2 ? 10 : 0) * recencyFactor; // bajo gasto histórico
  score += (customer.purchaseCount === 1 ? 10 : 0) * recencyFactor; // poca relación con el negocio
  score = Math.max(0, Math.min(100, Math.round(score)));

  const riskLevel = RISK_THRESHOLDS.find(([min]) => score >= min)![1];
  const confidence = customer.purchaseCount >= 4 ? 0.82 : customer.purchaseCount >= 2 ? 0.6 : 0.35;

  const reasons: string[] = [];
  if (customer.avgIntervalDays) {
    reasons.push(
      `Normalmente compra cada ${customer.avgIntervalDays} días y lleva ${rfm.recencyDays} días sin comprar.`
    );
  } else {
    reasons.push(`Lleva ${rfm.recencyDays} días sin comprar, sin historial suficiente para estimar su frecuencia habitual.`);
  }
  if (ratio > 1.5) reasons.push("Su tiempo sin comprar supera claramente su comportamiento habitual.");
  if (rfm.f <= 2) reasons.push("Tiene una frecuencia de compra históricamente baja.");
  if (rfm.m <= 2) reasons.push("Su gasto histórico acumulado es bajo comparado con otros clientes.");
  if (activity === "dormant" || activity === "lost") reasons.push("Actualmente está clasificado como cliente inactivo por tiempo de inactividad.");

  return {
    customerId: customer.id,
    churnProbability: Math.round(score) / 100,
    churnScore: score,
    riskLevel,
    predictionDate: new Date().toISOString(),
    modelVersion: MODEL_VERSION,
    reasons,
    confidence,
  };
}

// ---------------- Próxima compra (sección 17) ----------------

export function computeNextPurchase(customer: Customer, rfm: RFMScore): NextPurchasePrediction | null {
  if (customer.purchaseCount < 2 || !customer.avgIntervalDays) {
    return { expectedNextPurchaseDate: null, daysUntilExpectedPurchase: null, purchaseProbability: 0, confidence: 0.2 };
  }
  const daysUntil = customer.avgIntervalDays - rfm.recencyDays;
  const expected = new Date();
  expected.setDate(expected.getDate() + Math.max(daysUntil, 0));

  // Probabilidad decreciente mientras más atrasado está respecto a su ciclo habitual.
  const ratio = rfm.recencyDays / customer.avgIntervalDays;
  const probability = Math.max(0.05, Math.min(0.95, 1.2 - ratio * 0.5));

  return {
    expectedNextPurchaseDate: expected.toISOString(),
    daysUntilExpectedPurchase: daysUntil,
    purchaseProbability: Math.round(probability * 100) / 100,
    confidence: customer.purchaseCount >= 5 ? 0.75 : 0.5,
  };
}

// ---------------- Recomendación de productos (sección 18-19) ----------------

export function recommendProducts(
  customer: Customer,
  customerSales: Sale[],
  allProducts: Product[],
  topSellingProductIds: string[]
): ProductRecommendation[] {
  const active = allProducts.filter((p) => p.status === "active");
  if (active.length === 0) return [];

  // Cold start: cliente sin compras -> productos populares / buen margen (sección 18).
  if (customerSales.length === 0) {
    return active
      .slice()
      .sort((a, b) => (b.margin ?? 0) - (a.margin ?? 0))
      .slice(0, 3)
      .map((p) => ({
        customerId: customer.id,
        productId: p.id,
        productName: p.name,
        score: 55,
        reasons: ["Cliente nuevo sin historial: se recomienda por popularidad y margen (cold start)."],
        confidence: 0.4,
        method: "cold_start" as const,
        generatedAt: new Date().toISOString(),
        modelVersion: MODEL_VERSION,
      }));
  }

  const purchaseCountByProduct = new Map<string, { count: number; lastDate: string; product: Product }>();
  for (const sale of customerSales) {
    for (const item of sale.items) {
      const product = active.find((p) => p.id === item.productId);
      if (!product) continue;
      const entry = purchaseCountByProduct.get(item.productId);
      if (entry) {
        entry.count += item.quantity;
        if (sale.date > entry.lastDate) entry.lastDate = sale.date;
      } else {
        purchaseCountByProduct.set(item.productId, { count: item.quantity, lastDate: sale.date, product });
      }
    }
  }

  const recommendations: ProductRecommendation[] = [];

  // Frecuencia: productos que ya compró, priorizados por veces comprado + recencia.
  const frequent = [...purchaseCountByProduct.entries()]
    .sort((a, b) => b[1].count - a[1].count)
    .slice(0, 2);
  for (const [productId, info] of frequent) {
    const reasons = [`Lo compró ${info.count} ${info.count === 1 ? "vez" : "veces"}.`];
    const daysSince = daysBetween(new Date(), new Date(info.lastDate));
    if (daysSince < 60) reasons.push("Lo compró recientemente.");
    recommendations.push({
      customerId: customer.id,
      productId,
      productName: info.product.name,
      score: Math.min(96, 60 + info.count * 6),
      reasons,
      confidence: 0.75,
      method: "frequency",
      generatedAt: new Date().toISOString(),
      modelVersion: MODEL_VERSION,
    });
  }

  // Basado en categoría favorita (aproximación a collaborative filtering: "clientes similares también lo compran").
  const favoriteCategory = [...purchaseCountByProduct.values()].sort((a, b) => b.count - a.count)[0]?.product.category;
  if (favoriteCategory) {
    const candidate = active.find(
      (p) => p.category === favoriteCategory && !purchaseCountByProduct.has(p.id)
    );
    if (candidate) {
      recommendations.push({
        customerId: customer.id,
        productId: candidate.id,
        productName: candidate.name,
        score: 78,
        reasons: [`Clientes con gustos similares (categoría ${favoriteCategory}) también lo compran.`, "Existe una probabilidad razonable de recompra en esta categoría."],
        confidence: 0.6,
        method: "collaborative_filtering",
        generatedAt: new Date().toISOString(),
        modelVersion: MODEL_VERSION,
      });
    }
  }

  // Si aún no hay 3 recomendaciones, completar con productos populares del negocio.
  if (recommendations.length < 3) {
    for (const productId of topSellingProductIds) {
      if (recommendations.some((r) => r.productId === productId)) continue;
      const product = active.find((p) => p.id === productId);
      if (!product) continue;
      recommendations.push({
        customerId: customer.id,
        productId,
        productName: product.name,
        score: 50,
        reasons: ["Es uno de los productos más vendidos del negocio."],
        confidence: 0.35,
        method: "frequency",
        generatedAt: new Date().toISOString(),
        modelVersion: MODEL_VERSION,
      });
      if (recommendations.length >= 3) break;
    }
  }

  return recommendations.slice(0, 3).sort((a, b) => b.score - a.score);
}

// ---------------- Estrategia y priorización (secciones 20-21, 26-30) ----------------

const CONFIDENCE_THRESHOLD = 0.3; // sección 75: no recomendar acciones agresivas con baja confianza

export function buildRecoveryStrategy(
  customer: Customer,
  churn: ChurnPrediction,
  recommendation: ProductRecommendation | null,
  lastCampaignDaysAgo: number | null,
  cooldownDays: number
): RecoveryStrategy {
  const cooldownOk = lastCampaignDaysAgo === null || lastCampaignDaysAgo >= cooldownDays;
  const recoveryProbability = Math.max(0.05, Math.min(0.95, 1 - churn.churnProbability * 0.4));
  const valueWeight = customer.customerValue === "high" ? 1 : customer.customerValue === "medium" ? 0.6 : 0.3;
  const marginWeight = recommendation ? 0.8 : 0.5;

  const priorityRaw = churn.churnProbability * valueWeight * recoveryProbability * marginWeight;
  const priorityScore = Math.round(Math.min(1, priorityRaw / 0.4) * 100);

  let offer = "Sin oferta (confianza insuficiente)";
  let timing: RecoveryStrategy["recommendedTiming"] = "in_5_days";
  if (churn.confidence >= CONFIDENCE_THRESHOLD) {
    if (churn.riskLevel === "critical") {
      offer = customer.customerValue === "high" ? "15% de descuento" : "10% de descuento";
      timing = "now";
    } else if (churn.riskLevel === "high") {
      offer = "10% de descuento";
      timing = "today";
    } else if (churn.riskLevel === "medium") {
      offer = "5% de descuento";
      timing = "in_2_days";
    } else {
      offer = "Mensaje de agradecimiento, sin descuento";
      timing = "in_5_days";
    }
  }

  const action = customer.preferredChannel;
  const productPhrase = recommendation ? recommendation.productName : "un producto de su interés";

  const reasonParts: string[] = [...churn.reasons];
  if (recommendation) reasonParts.push(`Ha mostrado interés en ${recommendation.productName}.`);
  const reason = reasonParts.join(" ");

  const message = customer.consent
    ? buildMessage(customer, recommendation, offer)
    : "No se genera mensaje: el cliente no ha dado consentimiento de comunicaciones.";

  return {
    customerId: customer.id,
    customerName: `${customer.firstName} ${customer.lastName}`,
    priorityScore,
    churnProbability: churn.churnProbability,
    recoveryProbability: Math.round(recoveryProbability * 100) / 100,
    customerValue: customer.customerValue,
    recommendedProduct: recommendation,
    recommendedAction: action,
    recommendedOffer: offer,
    recommendedTiming: cooldownOk ? timing : "in_5_days",
    reason,
    message,
    cooldownOk,
    hasConsent: customer.consent,
  };
}

function buildMessage(customer: Customer, recommendation: ProductRecommendation | null, offer: string): string {
  const name = customer.firstName;
  if (recommendation) {
    return `Hola ${name}, hace un tiempo que no te vemos. Sabemos que te gusta ${recommendation.productName} y tenemos ${offer.toLowerCase()} especial para ti esta semana.`;
  }
  return `Hola ${name}, hace un tiempo que no te vemos. Tenemos ${offer.toLowerCase()} especial para ti esta semana.`;
}
