import { useQuery } from "@tanstack/react-query";
import { MessageCircle, Mail, Phone, Bell, Copy, Check } from "lucide-react";
import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { atRiskApi } from "@/services/api";
import { Badge, Panel, Spinner, EmptyState } from "@/components/ui/Primitives";
import { CHANNEL_LABEL, formatPercent } from "@/lib/format";
import type { Channel, RecoveryStrategy } from "@/types";

const CHANNEL_ICON: Record<Channel, React.ElementType> = {
  whatsapp: MessageCircle,
  email: Mail,
  sms: Phone,
  internal: Bell,
};

const TIMING_LABEL: Record<RecoveryStrategy["recommendedTiming"], string> = {
  now: "Ahora",
  today: "Hoy",
  in_2_days: "En 2 días",
  in_5_days: "En 5 días",
};

export function TodayActionsPage() {
  const { data, isLoading } = useQuery({ queryKey: ["today-actions"], queryFn: () => atRiskApi.todayActions(25) });
  const [copiedId, setCopiedId] = useState<string | null>(null);

  function copyMessage(strategy: RecoveryStrategy) {
    navigator.clipboard?.writeText(strategy.message).catch(() => {});
    setCopiedId(strategy.customerId);
    setTimeout(() => setCopiedId(null), 1500);
  }

  return (
    <AppLayout
      title="¿A quién contactar hoy?"
      subtitle="Clientes priorizados por probabilidad de recuperación y valor económico. Sin gráficos que interpretar: solo la acción a tomar."
    >
      {isLoading && (
        <div className="flex items-center gap-2 text-muted py-20 justify-center">
          <Spinner /> Priorizando clientes...
        </div>
      )}

      {!isLoading && data?.length === 0 && (
        <Panel>
          <EmptyState title="No hay acciones recomendadas por ahora" description="Todos los clientes con consentimiento están dentro de su comportamiento habitual." />
        </Panel>
      )}

      <div className="space-y-3">
        {data?.map((strategy, idx) => {
          const Icon = CHANNEL_ICON[strategy.recommendedAction];
          const tone =
            strategy.churnProbability >= 0.8 ? "critical" : strategy.churnProbability >= 0.6 ? "high" : strategy.churnProbability >= 0.3 ? "medium" : "low";
          return (
            <Panel key={strategy.customerId}>
              <div className="flex flex-col lg:flex-row lg:items-start justify-between gap-4">
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-2 flex-wrap">
                    <span className="font-display font-semibold text-[15px] text-muted">#{idx + 1}</span>
                    <span className="font-display font-semibold text-[16px]">{strategy.customerName}</span>
                    <Badge tone={tone}>Prioridad {strategy.priorityScore}/100</Badge>
                    <Badge tone={tone === "low" ? "neutral" : tone}>Riesgo {formatPercent(strategy.churnProbability)}</Badge>
                    <Badge tone={strategy.customerValue === "high" ? "brand" : "neutral"}>
                      Valor {strategy.customerValue === "high" ? "alto" : strategy.customerValue === "medium" ? "medio" : "bajo"}
                    </Badge>
                    {!strategy.hasConsent && <Badge tone="neutral">Sin consentimiento</Badge>}
                    {!strategy.cooldownOk && <Badge tone="neutral">En cooldown</Badge>}
                  </div>
                  <p className="text-[13.5px] text-ink/80 mb-3">{strategy.reason}</p>
                  <div className="flex flex-wrap gap-x-6 gap-y-2 text-[13px]">
                    <MiniField label="Producto recomendado" value={strategy.recommendedProduct?.productName ?? "Sin recomendación (datos insuficientes)"} />
                    <MiniField label="Acción" value={CHANNEL_LABEL[strategy.recommendedAction]} icon={<Icon size={13} />} />
                    <MiniField label="Oferta" value={strategy.recommendedOffer} />
                    <MiniField label="Momento" value={TIMING_LABEL[strategy.recommendedTiming]} />
                    <MiniField label="Prob. de recuperación" value={formatPercent(strategy.recoveryProbability)} />
                  </div>
                </div>
                <div className="lg:w-80 shrink-0 bg-bg border border-border rounded p-3">
                  <p className="text-[11px] uppercase tracking-wide text-muted mb-1.5 font-medium">Mensaje sugerido</p>
                  <p className="text-[13px] text-ink/85 leading-snug">{strategy.message}</p>
                  {strategy.hasConsent && (
                    <button
                      onClick={() => copyMessage(strategy)}
                      className="mt-2 inline-flex items-center gap-1.5 text-[12px] font-medium text-brand-dark hover:underline"
                    >
                      {copiedId === strategy.customerId ? <Check size={13} /> : <Copy size={13} />}
                      {copiedId === strategy.customerId ? "Copiado" : "Copiar mensaje"}
                    </button>
                  )}
                </div>
              </div>
            </Panel>
          );
        })}
      </div>
    </AppLayout>
  );
}

function MiniField({ label, value, icon }: { label: string; value: string; icon?: React.ReactNode }) {
  return (
    <div>
      <p className="text-[11px] text-muted uppercase tracking-wide">{label}</p>
      <p className="font-medium text-ink flex items-center gap-1 mt-0.5">
        {icon}
        {value}
      </p>
    </div>
  );
}
