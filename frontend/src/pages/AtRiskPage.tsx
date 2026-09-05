import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { atRiskApi } from "@/services/api";
import { Badge, EmptyState, Select, Spinner } from "@/components/ui/Primitives";
import { RISK_LABEL, formatDate, formatPercent } from "@/lib/format";
import type { Customer, RiskLevel } from "@/types";
import { CustomerDetailPanel } from "./customers/CustomerDetailPanel";

const PAGE_SIZE = 15;

export function AtRiskPage() {
  const [page, setPage] = useState(1);
  const [riskLevel, setRiskLevel] = useState<RiskLevel | "">("");
  const [selected, setSelected] = useState<Customer | null>(null);

  const { data, isLoading } = useQuery({
    queryKey: ["at-risk", page, riskLevel],
    queryFn: () => atRiskApi.list({ page, pageSize: PAGE_SIZE, filters: { riskLevel: riskLevel || undefined } }),
  });

  const totalPages = data ? Math.max(1, Math.ceil(data.total / PAGE_SIZE)) : 1;

  return (
    <AppLayout title="Clientes en riesgo" subtitle="Clientes que se están alejando de su comportamiento habitual de compra">
      <div className="mb-4 flex items-center gap-3">
        <Select value={riskLevel} onChange={(e) => { setRiskLevel(e.target.value as RiskLevel | ""); setPage(1); }}>
          <option value="">Todos los niveles de riesgo</option>
          <option value="critical">Crítico</option>
          <option value="high">Alto</option>
          <option value="medium">Medio</option>
          <option value="low">Bajo</option>
        </Select>
      </div>

      <div className="bg-surface border border-border rounded shadow-panel overflow-hidden">
        {isLoading && (
          <div className="flex items-center gap-2 text-muted py-16 justify-center">
            <Spinner /> Calculando riesgo de abandono...
          </div>
        )}
        {!isLoading && data?.items.length === 0 && (
          <EmptyState title="No hay clientes en riesgo con este filtro" description="Buena señal: tu base de clientes está saludable en este segmento." />
        )}
        {!isLoading && data && data.items.length > 0 && (
          <>
            <table className="w-full text-[13.5px]">
              <thead>
                <tr className="border-b border-border text-left text-[11.5px] uppercase tracking-wide text-muted">
                  <th className="px-4 py-2.5 font-medium">Cliente</th>
                  <th className="px-4 py-2.5 font-medium">Riesgo</th>
                  <th className="px-4 py-2.5 font-medium">Valor</th>
                  <th className="px-4 py-2.5 font-medium">Última compra</th>
                  <th className="px-4 py-2.5 font-medium">Próxima compra estimada</th>
                  <th className="px-4 py-2.5 font-medium">Acción sugerida</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {data.items.map((c) => (
                  <tr key={c.id} className="hover:bg-ink/[0.02] cursor-pointer" onClick={() => setSelected(c)}>
                    <td className="px-4 py-2.5">
                      <p className="font-medium text-ink">{c.firstName} {c.lastName}</p>
                      <p className="text-[12px] text-muted">{c.email ?? "Sin email"}</p>
                    </td>
                    <td className="px-4 py-2.5">
                      {c.churn && (
                        <Badge tone={c.churn.riskLevel === "low" ? "success" : c.churn.riskLevel}>
                          {RISK_LABEL[c.churn.riskLevel]} ({formatPercent(c.churn.churnProbability)})
                        </Badge>
                      )}
                    </td>
                    <td className="px-4 py-2.5">{c.customerValue === "high" ? "Alto" : c.customerValue === "medium" ? "Medio" : "Bajo"}</td>
                    <td className="px-4 py-2.5 text-muted">{formatDate(c.lastPurchaseAt)}</td>
                    <td className="px-4 py-2.5 text-muted">
                      {c.nextPurchase?.expectedNextPurchaseDate ? formatDate(c.nextPurchase.expectedNextPurchaseDate) : "Sin estimación"}
                    </td>
                    <td className="px-4 py-2.5 font-medium">{c.preferredChannel === "whatsapp" ? "WhatsApp" : c.preferredChannel === "email" ? "Email" : c.preferredChannel === "sms" ? "SMS" : "Interno"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            <div className="flex items-center justify-between px-4 py-3 border-t border-border text-[12.5px] text-muted">
              <span>{data.total} clientes con riesgo o inactividad</span>
              <div className="flex items-center gap-2">
                <button disabled={page <= 1} onClick={() => setPage((p) => p - 1)} className="disabled:opacity-40 hover:underline">Anterior</button>
                <span>Página {page} de {totalPages}</span>
                <button disabled={page >= totalPages} onClick={() => setPage((p) => p + 1)} className="disabled:opacity-40 hover:underline">Siguiente</button>
              </div>
            </div>
          </>
        )}
      </div>

      {selected && <CustomerDetailPanel customer={selected} onClose={() => setSelected(null)} />}
    </AppLayout>
  );
}
