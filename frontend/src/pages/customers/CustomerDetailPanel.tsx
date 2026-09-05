import { useQuery } from "@tanstack/react-query";
import { X } from "lucide-react";
import { customersApi } from "@/services/api";
import { Badge, Spinner } from "@/components/ui/Primitives";
import { ACTIVITY_LABEL, CHANNEL_LABEL, RISK_LABEL, SEGMENT_LABEL, formatDate, formatMoney, formatPercent } from "@/lib/format";
import type { Customer } from "@/types";

export function CustomerDetailPanel({ customer, onClose }: { customer: Customer; onClose: () => void }) {
  const salesQuery = useQuery({ queryKey: ["customer-sales", customer.id], queryFn: () => customersApi.sales(customer.id) });
  const recsQuery = useQuery({ queryKey: ["customer-recs", customer.id], queryFn: () => customersApi.recommendations(customer.id) });
  const strategyQuery = useQuery({ queryKey: ["customer-strategy", customer.id], queryFn: () => customersApi.strategy(customer.id) });

  return (
    <div className="fixed inset-0 z-40 flex justify-end">
      <div className="fixed inset-0 bg-ink/30" onClick={onClose} />
      <div className="relative w-full max-w-lg bg-surface h-screen overflow-y-auto shadow-popover border-l border-border">
        <div className="sticky top-0 bg-surface border-b border-border px-5 py-4 flex items-center justify-between">
          <div>
            <h3 className="font-display font-semibold text-[16px]">{customer.firstName} {customer.lastName}</h3>
            <p className="text-[12.5px] text-muted">{customer.email ?? "Sin email"} · {customer.city ?? "Ciudad no registrada"}</p>
          </div>
          <button onClick={onClose} className="text-muted hover:text-ink p-1.5 rounded hover:bg-ink/5">
            <X size={18} />
          </button>
        </div>

        <div className="p-5 space-y-6">
          {/* Estado general */}
          <div className="flex flex-wrap gap-2">
            <Badge tone="neutral">{SEGMENT_LABEL[customer.segment]}</Badge>
            <Badge tone={customer.activityStatus === "active" ? "success" : "neutral"}>{ACTIVITY_LABEL[customer.activityStatus]}</Badge>
            {customer.churn && <Badge tone={customer.churn.riskLevel === "low" ? "success" : customer.churn.riskLevel}>Riesgo {RISK_LABEL[customer.churn.riskLevel]}</Badge>}
            <Badge tone={customer.consent ? "success" : "neutral"}>{customer.consent ? "Con consentimiento" : "Sin consentimiento"}</Badge>
          </div>

          {/* RFM */}
          <Section title="RFM">
            <div className="grid grid-cols-3 gap-3 text-center">
              <MiniStat label="Recencia" value={`${customer.rfm.recencyDays} días`} />
              <MiniStat label="Frecuencia" value={String(customer.rfm.frequency)} />
              <MiniStat label="Monetario" value={formatMoney(customer.rfm.monetary)} />
            </div>
            <p className="text-[12.5px] text-muted mt-2">RFM Score: <span className="font-mono text-ink">{customer.rfm.rfmScore}</span></p>
          </Section>

          {/* Churn y explicación (sección 16) */}
          <Section title="Riesgo de abandono">
            {customer.churn ? (
              <>
                <p className="text-[14px] font-medium mb-1">
                  {formatPercent(customer.churn.churnProbability)} de probabilidad estimada — nivel {RISK_LABEL[customer.churn.riskLevel]}
                </p>
                <p className="text-[12px] text-muted mb-2">
                  Confianza de la estimación: {formatPercent(customer.churn.confidence)} · modelo: {customer.churn.modelVersion}
                </p>
                <p className="text-[12px] uppercase tracking-wide text-muted mb-1">¿Por qué?</p>
                <ul className="list-disc list-inside space-y-1 text-[13.5px] text-ink/85">
                  {customer.churn.reasons.map((r, i) => (
                    <li key={i}>{r}</li>
                  ))}
                </ul>
              </>
            ) : (
              <p className="text-[13.5px] text-muted">No hay suficientes datos para estimar el riesgo de este cliente todavía.</p>
            )}
          </Section>

          {/* Próxima compra */}
          {customer.nextPurchase && customer.nextPurchase.expectedNextPurchaseDate && (
            <Section title="Próxima compra estimada">
              <p className="text-[13.5px]">
                Fecha estimada: <span className="font-medium">{formatDate(customer.nextPurchase.expectedNextPurchaseDate)}</span>
              </p>
              <p className="text-[12.5px] text-muted mt-1">
                Probabilidad de compra: {formatPercent(customer.nextPurchase.purchaseProbability)} (estimación, no una certeza)
              </p>
            </Section>
          )}

          {/* Recomendaciones de producto */}
          <Section title="Productos recomendados">
            {recsQuery.isLoading && <Spinner />}
            {recsQuery.data && recsQuery.data.length === 0 && <p className="text-[13.5px] text-muted">Sin recomendaciones por ahora.</p>}
            <div className="space-y-2">
              {recsQuery.data?.map((rec) => (
                <div key={rec.productId} className="border border-border rounded p-2.5">
                  <div className="flex items-center justify-between">
                    <p className="font-medium text-[13.5px]">{rec.productName}</p>
                    <Badge tone="brand">Score {rec.score}</Badge>
                  </div>
                  <ul className="text-[12px] text-muted mt-1 list-disc list-inside">
                    {rec.reasons.map((r, i) => (
                      <li key={i}>{r}</li>
                    ))}
                  </ul>
                </div>
              ))}
            </div>
          </Section>

          {/* Estrategia sugerida */}
          {strategyQuery.data && (
            <Section title="Estrategia de recuperación sugerida">
              <div className="bg-bg border border-border rounded p-3 text-[13.5px] space-y-1.5">
                <p><span className="text-muted">Prioridad:</span> <span className="font-medium">{strategyQuery.data.priorityScore}/100</span></p>
                <p><span className="text-muted">Acción:</span> <span className="font-medium">{CHANNEL_LABEL[strategyQuery.data.recommendedAction]}</span></p>
                <p><span className="text-muted">Oferta:</span> <span className="font-medium">{strategyQuery.data.recommendedOffer}</span></p>
                <p className="text-ink/80 pt-1">{strategyQuery.data.message}</p>
              </div>
            </Section>
          )}

          {/* Historial de compras */}
          <Section title={`Historial de compras (${customer.purchaseCount})`}>
            {salesQuery.isLoading && <Spinner />}
            <div className="divide-y divide-border">
              {salesQuery.data?.slice(0, 10).map((sale) => (
                <div key={sale.id} className="py-2 flex items-center justify-between text-[13px]">
                  <div>
                    <p className="font-medium">{formatDate(sale.date)}</p>
                    <p className="text-muted text-[12px]">{sale.items.map((i) => i.productName).join(", ")}</p>
                  </div>
                  <p className="font-medium">{formatMoney(sale.total)}</p>
                </div>
              ))}
              {salesQuery.data?.length === 0 && <p className="text-[13.5px] text-muted py-2">Sin compras registradas.</p>}
            </div>
          </Section>
        </div>
      </div>
    </div>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div>
      <h4 className="font-display font-semibold text-[13px] uppercase tracking-wide text-muted mb-2">{title}</h4>
      {children}
    </div>
  );
}

function MiniStat({ label, value }: { label: string; value: string }) {
  return (
    <div className="bg-bg border border-border rounded py-2">
      <p className="text-[15px] font-display font-semibold">{value}</p>
      <p className="text-[11px] text-muted">{label}</p>
    </div>
  );
}
