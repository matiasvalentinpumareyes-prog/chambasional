import { useQuery } from "@tanstack/react-query";
import { AlertTriangle, TrendingUp, PiggyBank, CircleCheck } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { dashboardApi } from "@/services/api";
import { Panel, StatCard, Spinner } from "@/components/ui/Primitives";
import { SimpleLineChart, SimpleBarChart, SimplePieChart } from "@/components/charts/Charts";
import { formatMoney, formatNumber, formatPercent } from "@/lib/format";

export function DashboardPage() {
  const metrics = useQuery({ queryKey: ["dashboard-metrics"], queryFn: dashboardApi.getMetrics });
  const series = useQuery({ queryKey: ["dashboard-series"], queryFn: dashboardApi.getSeries });

  if (metrics.isLoading || series.isLoading || !metrics.data || !series.data) {
    return (
      <AppLayout title="Dashboard">
        <div className="flex items-center gap-2 text-muted py-20 justify-center">
          <Spinner /> Calculando métricas del negocio...
        </div>
      </AppLayout>
    );
  }

  const m = metrics.data;
  const s = series.data;
  const currency = m.currency;

  return (
    <AppLayout title="Dashboard" subtitle="Qué está pasando en tu negocio ahora mismo">
      <div className="space-y-6">
        {/* Alertas (sección 67) */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3">
          <AlertCard
            icon={<AlertTriangle size={16} />}
            tone="critical"
            text={`${m.criticalCustomers} clientes tienen riesgo crítico de abandono.`}
          />
          <AlertCard
            icon={<TrendingUp size={16} />}
            tone="urgent"
            text={`${m.atRiskCustomers} clientes están en riesgo y podrían recuperarse.`}
          />
          <AlertCard
            icon={<CircleCheck size={16} />}
            tone="success"
            text={`${formatNumber(Math.round(m.finishedCampaigns))} campañas finalizadas con resultados medidos.`}
          />
          <AlertCard
            icon={<PiggyBank size={16} />}
            tone="brand"
            text={`Se recuperaron ${formatMoney(m.recoveredRevenue, currency)} en campañas.`}
          />
        </div>

        {/* KPIs principales */}
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-3">
          <StatCard label="Ventas totales" value={formatMoney(m.totalSales, currency)} tone="brand" />
          <StatCard label="Clientes totales" value={formatNumber(m.totalCustomers)} sub={`${m.activeCustomers} activos`} />
          <StatCard label="Clientes en riesgo" value={formatNumber(m.atRiskCustomers)} tone="urgent" />
          <StatCard label="Clientes críticos" value={formatNumber(m.criticalCustomers)} tone="critical" />
          <StatCard label="Tasa de churn estimada" value={formatPercent(m.estimatedChurnRate)} />
          <StatCard label="Clientes recuperables" value={formatNumber(m.recoverableCustomers)} tone="success" />
          <StatCard label="Valor total de clientes" value={formatMoney(m.totalCustomerValue, currency)} />
          <StatCard label="Ticket promedio" value={formatMoney(m.avgTicket, currency)} />
          <StatCard label="Frecuencia promedio" value={`${m.avgPurchaseFrequencyDays} días`} />
          <StatCard label="Ingresos recuperados" value={formatMoney(m.recoveredRevenue, currency)} tone="success" />
          <StatCard label="Campañas activas" value={formatNumber(m.activeCampaigns)} />
          <StatCard label="Tasa de conversión" value={formatPercent(m.conversionRate)} />
          <StatCard label="ROI de campañas" value={m.campaignRoi != null ? `${m.campaignRoi.toFixed(1)}x` : "—"} />
          <StatCard label="Calidad de datos" value={`${m.dataQualityScore}%`} />
        </div>

        {/* Gráficos */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <Panel title="Ventas por día (últimos 30 días)">
            <SimpleLineChart data={s.salesByDay} />
          </Panel>
          <Panel title="Ventas por mes">
            <SimpleBarChart data={s.salesByMonth} />
          </Panel>
          <Panel title="Nuevos clientes por mes">
            <SimpleLineChart data={s.newCustomersByMonth} color="#3C8361" />
          </Panel>
          <Panel title="Evolución de la tasa de churn (%)">
            <SimpleLineChart data={s.churnEvolution} color="#B5442E" />
          </Panel>
          <Panel title="Productos más vendidos (unidades)">
            <SimpleBarChart data={s.topProducts} horizontal color="#1F6F5C" />
          </Panel>
          <Panel title="Distribución de segmentos de clientes">
            <SimplePieChart data={s.segmentDistribution} />
          </Panel>
          <Panel title="Ingresos por segmento" className="lg:col-span-2">
            <SimpleBarChart data={s.revenueBySegment} color="#E7A33E" />
          </Panel>
        </div>
      </div>
    </AppLayout>
  );
}

function AlertCard({ icon, text, tone }: { icon: React.ReactNode; text: string; tone: "critical" | "urgent" | "success" | "brand" }) {
  const styles: Record<string, string> = {
    critical: "bg-[#F7DED9] text-risk-critical",
    urgent: "bg-urgent-light text-urgent-dark",
    success: "bg-success-light text-success",
    brand: "bg-brand-light text-brand-dark",
  };
  return (
    <div className={`rounded px-3.5 py-3 flex items-start gap-2.5 text-[13px] font-medium ${styles[tone]}`}>
      <span className="mt-0.5">{icon}</span>
      <span>{text}</span>
    </div>
  );
}
