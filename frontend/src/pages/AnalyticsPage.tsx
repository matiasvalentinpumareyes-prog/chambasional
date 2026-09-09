import { useQuery } from "@tanstack/react-query";
import { Download } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { atRiskApi, campaignsApi, customersApi, dashboardApi } from "@/services/api";
import { Button, Panel, Spinner } from "@/components/ui/Primitives";
import { SimpleBarChart } from "@/components/charts/Charts";
import { formatMoney } from "@/lib/format";
import type { Customer } from "@/types";

function downloadCsv(filename: string, rows: Record<string, string | number>[]) {
  if (rows.length === 0) return;
  const headers = Object.keys(rows[0]);
  const csv = [headers.join(","), ...rows.map((r) => headers.map((h) => `"${String(r[h]).replace(/"/g, '""')}"`).join(","))].join("\n");
  const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = filename;
  a.click();
  URL.revokeObjectURL(url);
}

export function AnalyticsPage() {
  const series = useQuery({ queryKey: ["dashboard-series"], queryFn: dashboardApi.getSeries });
  const atRisk = useQuery({ queryKey: ["at-risk-report"], queryFn: () => atRiskApi.list({ page: 1, pageSize: 1000 }) });
  const campaigns = useQuery({ queryKey: ["campaigns-report"], queryFn: () => campaignsApi.list({ page: 1, pageSize: 200 }) });
  const customers = useQuery({ queryKey: ["customers-report"], queryFn: () => customersApi.list({ page: 1, pageSize: 2000 }) });

  function exportAtRisk() {
    const rows = (atRisk.data?.items ?? []).map((c: Customer) => ({
      cliente: `${c.firstName} ${c.lastName}`,
      email: c.email ?? "",
      riesgo: c.churn?.riskLevel ?? "",
      probabilidad: c.churn?.churnProbability ?? "",
      ultima_compra: c.lastPurchaseAt ?? "",
      gasto_total: c.totalSpend,
    }));
    downloadCsv("clientes_en_riesgo.csv", rows);
  }

  function exportCampaigns() {
    const rows = (campaigns.data?.items ?? []).map((c) => ({
      campana: c.name,
      estado: c.status,
      canal: c.channel,
      objetivo: c.targetCustomerIds.length,
      convertidos: c.metrics?.converted ?? 0,
      ingresos_recuperados: c.metrics?.recoveredRevenue ?? 0,
      roi: c.metrics?.roi ?? "",
    }));
    downloadCsv("campanas.csv", rows);
  }

  function exportCustomers() {
    const rows = (customers.data?.items ?? []).map((c) => ({
      cliente: `${c.firstName} ${c.lastName}`,
      segmento: c.segment ?? "—",
      gasto_total: c.totalSpend,
      frecuencia: c.purchaseCount,
      ultima_compra: c.lastPurchaseAt ?? "—",
    }));
    downloadCsv("clientes.csv", rows as any);
  }

  const isLoading = series.isLoading || atRisk.isLoading || campaigns.isLoading;

  return (
    <AppLayout title="Analítica" subtitle="Reportes detallados, exportables para análisis externo">
      {isLoading && (
        <div className="flex items-center gap-2 text-muted py-16 justify-center">
          <Spinner /> Generando reportes...
        </div>
      )}

      {!isLoading && (
        <div className="space-y-4">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
            <Panel title="Productos más vendidos">
              <SimpleBarChart data={series.data?.topProducts ?? []} horizontal />
            </Panel>
            <Panel title="Ingresos por segmento">
              <SimpleBarChart data={series.data?.revenueBySegment ?? []} color="#E7A33E" />
            </Panel>
          </div>

          <Panel
            title="Reporte: clientes en riesgo"
            action={<Button size="sm" variant="secondary" onClick={exportAtRisk}><Download size={14} /> Exportar CSV</Button>}
          >
            <p className="text-[13px] text-muted mb-2">{atRisk.data?.total ?? 0} clientes con riesgo, dormidos o perdidos actualmente.</p>
          </Panel>

          <Panel
            title="Reporte: campañas"
            action={<Button size="sm" variant="secondary" onClick={exportCampaigns}><Download size={14} /> Exportar CSV</Button>}
          >
            <div className="divide-y divide-border">
              {campaigns.data?.items.map((c) => (
                <div key={c.id} className="py-2 flex items-center justify-between text-[13px]">
                  <span className="font-medium">{c.name}</span>
                  <span className="text-muted">
                    ROI: {c.metrics?.roi != null ? `${c.metrics.roi.toFixed(1)}x` : "—"} · Recuperado: {formatMoney(c.metrics?.recoveredRevenue ?? 0)}
                  </span>
                </div>
              ))}
            </div>
          </Panel>

          <Panel
            title="Reporte: base completa de clientes"
            action={<Button size="sm" variant="secondary" onClick={exportCustomers}><Download size={14} /> Exportar CSV</Button>}
          >
            <p className="text-[13px] text-muted">{customers.data?.total ?? 0} clientes registrados en total.</p>
          </Panel>
        </div>
      )}
    </AppLayout>
  );
}
