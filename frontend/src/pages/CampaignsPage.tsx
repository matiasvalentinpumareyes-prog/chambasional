import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useForm } from "react-hook-form";
import { FlaskConical, Plus } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { atRiskApi, campaignsApi, productsApi } from "@/services/api";
import { Badge, Button, EmptyState, Input, Label, Panel, Select, Spinner } from "@/components/ui/Primitives";
import { Modal } from "@/components/ui/Modal";
import { CHANNEL_LABEL, formatMoney, formatPercent } from "@/lib/format";
import type { Campaign, CampaignStatus, Channel } from "@/types";

const STATUS_LABEL: Record<CampaignStatus, string> = {
  draft: "Borrador",
  scheduled: "Programada",
  active: "Activa",
  paused: "Pausada",
  finished: "Finalizada",
  cancelled: "Cancelada",
};

const STATUS_TONE: Record<CampaignStatus, "neutral" | "brand" | "success" | "urgent"> = {
  draft: "neutral",
  scheduled: "urgent",
  active: "brand",
  paused: "neutral",
  finished: "success",
  cancelled: "neutral",
};

export function CampaignsPage() {
  const [formOpen, setFormOpen] = useState(false);
  const [selected, setSelected] = useState<Campaign | null>(null);
  const { data, isLoading } = useQuery({ queryKey: ["campaigns"], queryFn: () => campaignsApi.list({ page: 1, pageSize: 50 }) });

  return (
    <AppLayout title="Campañas" subtitle="Diseña, controla y simula campañas de recuperación antes de ejecutarlas">
      <div className="flex justify-end mb-4">
        <Button onClick={() => setFormOpen(true)}>
          <Plus size={16} /> Nueva campaña
        </Button>
      </div>

      {isLoading && (
        <div className="flex items-center gap-2 text-muted py-16 justify-center">
          <Spinner /> Cargando campañas...
        </div>
      )}
      {!isLoading && data?.items.length === 0 && <EmptyState title="Aún no hay campañas creadas" />}

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {data?.items.map((c) => (
          <Panel key={c.id}>
            <div className="flex items-start justify-between mb-2">
              <div>
                <p className="font-display font-semibold text-[15px]">{c.name}</p>
                <p className="text-[12.5px] text-muted mt-0.5">{c.description}</p>
              </div>
              <Badge tone={STATUS_TONE[c.status]}>{STATUS_LABEL[c.status]}</Badge>
            </div>
            <div className="flex flex-wrap gap-x-5 gap-y-1.5 text-[12.5px] text-muted mb-3">
              <span>Canal: <span className="text-ink font-medium">{CHANNEL_LABEL[c.channel]}</span></span>
              <span>Oferta: <span className="text-ink font-medium">{c.offer}</span></span>
              <span>Objetivo: <span className="text-ink font-medium">{c.targetCustomerIds.length} clientes</span></span>
            </div>
            {c.metrics && (
              <div className="grid grid-cols-3 gap-2 text-center mb-3">
                <MiniMetric label="Con consentimiento" value={String(c.metrics.withConsent)} />
                <MiniMetric label="Convertidos" value={String(c.metrics.converted)} />
                <MiniMetric label="ROI" value={c.metrics.roi != null ? `${c.metrics.roi.toFixed(1)}x` : "—"} />
              </div>
            )}
            <button onClick={() => setSelected(c)} className="text-[12.5px] font-medium text-brand-dark hover:underline">
              Ver control y simulación →
            </button>
          </Panel>
        ))}
      </div>

      <NewCampaignModal open={formOpen} onClose={() => setFormOpen(false)} />
      {selected && <CampaignControlModal campaign={selected} onClose={() => setSelected(null)} />}
    </AppLayout>
  );
}

function MiniMetric({ label, value }: { label: string; value: string }) {
  return (
    <div className="bg-bg border border-border rounded py-1.5">
      <p className="font-display font-semibold text-[14px]">{value}</p>
      <p className="text-[10.5px] text-muted">{label}</p>
    </div>
  );
}

interface CampaignFormValues {
  name: string;
  description: string;
  channel: Channel;
  offer: string;
  productId: string;
  segmentSource: "at_risk_today" | "custom";
}

function NewCampaignModal({ open, onClose }: { open: boolean; onClose: () => void }) {
  const queryClient = useQueryClient();
  const { data: products } = useQuery({ queryKey: ["products-for-campaign"], queryFn: () => productsApi.list({ page: 1, pageSize: 100 }), enabled: open });
  const { data: todayActions } = useQuery({ queryKey: ["today-actions-for-campaign"], queryFn: () => atRiskApi.todayActions(60), enabled: open });
  const { register, handleSubmit, reset } = useForm<CampaignFormValues>({
    defaultValues: { name: "", description: "", channel: "whatsapp", offer: "10% de descuento", productId: "", segmentSource: "at_risk_today" },
  });

  const mutation = useMutation({
    mutationFn: (values: CampaignFormValues) => {
      const targetCustomerIds = (todayActions ?? []).map((s) => s.customerId);
      return campaignsApi.create({
        name: values.name,
        description: values.description,
        segment: "at_risk",
        targetCustomerIds,
        productId: values.productId || null,
        offer: values.offer,
        channel: values.channel,
        startDate: new Date().toISOString(),
        endDate: null,
        message: "Hola {{customer_name}}, hace un tiempo que no te vemos. Tenemos una oferta especial para ti esta semana.",
      });
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["campaigns"] });
      reset();
      onClose();
    },
  });

  return (
    <Modal open={open} onClose={onClose} title="Nueva campaña de recuperación">
      <form onSubmit={handleSubmit((v) => mutation.mutate(v))} className="space-y-4">
        <div>
          <Label>Nombre de la campaña</Label>
          <Input {...register("name", { required: true })} placeholder="Ej. Reactivación clientes en riesgo — Octubre" />
        </div>
        <div>
          <Label>Descripción</Label>
          <Input {...register("description")} placeholder="Objetivo de la campaña" />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Canal</Label>
            <Select {...register("channel")} className="w-full">
              <option value="whatsapp">WhatsApp</option>
              <option value="email">Email</option>
              <option value="sms">SMS</option>
              <option value="internal">Notificación interna</option>
            </Select>
          </div>
          <div>
            <Label>Oferta</Label>
            <Select {...register("offer")} className="w-full">
              <option>5% de descuento</option>
              <option>10% de descuento</option>
              <option>15% de descuento</option>
              <option>Envío gratis</option>
            </Select>
          </div>
        </div>
        <div>
          <Label>Producto destacado</Label>
          <Select {...register("productId")} className="w-full">
            <option value="">Sin producto específico</option>
            {products?.items.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
          </Select>
        </div>
        <p className="text-[12.5px] text-muted bg-bg border border-border rounded p-2.5">
          Esta campaña se dirigirá automáticamente a los {todayActions?.length ?? 0} clientes priorizados hoy en
          "Contactar hoy" que tienen consentimiento de comunicaciones.
        </p>
        {mutation.isError && <p className="text-[13px] text-risk-critical">No se pudo crear la campaña.</p>}
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="secondary" onClick={onClose}>Cancelar</Button>
          <Button type="submit" disabled={mutation.isPending}>{mutation.isPending ? "Creando..." : "Crear campaña (borrador)"}</Button>
        </div>
      </form>
    </Modal>
  );
}

function CampaignControlModal({ campaign, onClose }: { campaign: Campaign; onClose: () => void }) {
  const queryClient = useQueryClient();
  const [simResult, setSimResult] = useState<Awaited<ReturnType<typeof campaignsApi.simulate>> | null>(null);

  const simulateMutation = useMutation({
    mutationFn: () => campaignsApi.simulate(campaign.id),
    onSuccess: (result) => setSimResult(result),
  });

  const activateMutation = useMutation({
    mutationFn: () => campaignsApi.updateStatus(campaign.id, "active"),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["campaigns"] });
      onClose();
    },
  });

  const m = campaign.metrics;

  return (
    <Modal open onClose={onClose} title={campaign.name} width="max-w-xl">
      <div className="space-y-5">
        {/* Control antes de enviar (sección 81) */}
        {m && (
          <div>
            <h4 className="font-display font-semibold text-[13px] uppercase tracking-wide text-muted mb-2">Antes de enviar</h4>
            <div className="grid grid-cols-2 gap-2 text-[13.5px]">
              <Row label="Clientes objetivo" value={String(m.targeted)} />
              <Row label="Con consentimiento" value={String(m.withConsent)} />
              <Row label="Sin consentimiento" value={String(m.withoutConsent)} />
              <Row label="Costo estimado" value={formatMoney(m.estimatedCost)} />
              <Row label="Ingresos potenciales" value={formatMoney(m.potentialRevenue)} />
              <Row label="Oferta" value={campaign.offer} />
            </div>
          </div>
        )}

        {/* Simulación (sección 82) */}
        <div>
          <h4 className="font-display font-semibold text-[13px] uppercase tracking-wide text-muted mb-2">Modo simulación</h4>
          <p className="text-[12.5px] text-muted mb-3">
            Simula el resultado esperado sin enviar comunicaciones reales. Útil para pruebas y demostraciones.
          </p>
          <Button variant="secondary" size="sm" onClick={() => simulateMutation.mutate()} disabled={simulateMutation.isPending}>
            <FlaskConical size={14} /> {simulateMutation.isPending ? "Simulando..." : "Simular campaña"}
          </Button>
          {simResult && (
            <div className="grid grid-cols-3 gap-2 mt-3 text-center">
              <MiniMetric label="Conversión estimada" value={formatPercent(simResult.estimatedConversionRate)} />
              <MiniMetric label="Clientes recuperados (est.)" value={String(simResult.estimatedConverted)} />
              <MiniMetric label="ROI estimado" value={simResult.estimatedRoi != null ? `${simResult.estimatedRoi.toFixed(1)}x` : "—"} />
            </div>
          )}
        </div>

        <div className="flex justify-end gap-2 pt-2 border-t border-border">
          <Button variant="secondary" onClick={onClose}>Cerrar</Button>
          {campaign.status === "draft" && (
            <Button onClick={() => activateMutation.mutate()} disabled={activateMutation.isPending}>
              {activateMutation.isPending ? "Confirmando..." : "Confirmar y activar campaña"}
            </Button>
          )}
        </div>
      </div>
    </Modal>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between bg-bg border border-border rounded px-3 py-2">
      <span className="text-muted">{label}</span>
      <span className="font-medium">{value}</span>
    </div>
  );
}
