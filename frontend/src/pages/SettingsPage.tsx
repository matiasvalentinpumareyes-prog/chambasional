import { useEffect, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { settingsApi } from "@/services/api";
import { Button, Input, Label, Panel, Select, Spinner } from "@/components/ui/Primitives";
import type { BusinessSettings } from "@/types";

export function SettingsPage() {
  const queryClient = useQueryClient();
  const { data, isLoading } = useQuery({ queryKey: ["settings"], queryFn: settingsApi.get });
  const [form, setForm] = useState<BusinessSettings | null>(null);

  useEffect(() => {
    if (data) setForm(data);
  }, [data]);

  const mutation = useMutation({
    mutationFn: (patch: Partial<BusinessSettings>) => settingsApi.update(patch),
    onSuccess: (updated) => {
      queryClient.setQueryData(["settings"], updated);
      setForm(updated);
    },
  });

  if (isLoading || !form) {
    return (
      <AppLayout title="Configuración">
        <div className="flex items-center gap-2 text-muted py-20 justify-center">
          <Spinner /> Cargando configuración...
        </div>
      </AppLayout>
    );
  }

  return (
    <AppLayout title="Configuración" subtitle="Ajustes generales del negocio">
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4 max-w-4xl">
        <Panel title="Datos del negocio">
          <div className="space-y-3">
            <div>
              <Label>Nombre del negocio</Label>
              <Input value={form.businessName} onChange={(e) => setForm({ ...form, businessName: e.target.value })} />
            </div>
            <div>
              <Label>Moneda</Label>
              <Select value={form.currency} onChange={(e) => setForm({ ...form, currency: e.target.value as BusinessSettings["currency"] })} className="w-full">
                <option value="PEN">Sol peruano (PEN)</option>
                <option value="USD">Dólar estadounidense (USD)</option>
                <option value="EUR">Euro (EUR)</option>
                <option value="MXN">Peso mexicano (MXN)</option>
                <option value="COP">Peso colombiano (COP)</option>
              </Select>
            </div>
            <div>
              <Label>Zona horaria</Label>
              <Select value={form.timezone} onChange={(e) => setForm({ ...form, timezone: e.target.value })} className="w-full">
                <option value="America/Lima">América/Lima</option>
                <option value="America/Mexico_City">América/Ciudad de México</option>
                <option value="America/Bogota">América/Bogotá</option>
              </Select>
            </div>
            <div>
              <Label>Idioma</Label>
              <Select value={form.language} onChange={(e) => setForm({ ...form, language: e.target.value as "es" | "en" })} className="w-full">
                <option value="es">Español</option>
                <option value="en">English</option>
              </Select>
            </div>
          </div>
        </Panel>

        <Panel title="Reglas de riesgo y campañas">
          <div className="space-y-3">
            <div>
              <Label>Umbral de riesgo medio (score ≥)</Label>
              <Input type="number" value={form.churnThresholds.medium} onChange={(e) => setForm({ ...form, churnThresholds: { ...form.churnThresholds, medium: Number(e.target.value) } })} />
            </div>
            <div>
              <Label>Umbral de riesgo alto (score ≥)</Label>
              <Input type="number" value={form.churnThresholds.high} onChange={(e) => setForm({ ...form, churnThresholds: { ...form.churnThresholds, high: Number(e.target.value) } })} />
            </div>
            <div>
              <Label>Umbral de riesgo crítico (score ≥)</Label>
              <Input type="number" value={form.churnThresholds.critical} onChange={(e) => setForm({ ...form, churnThresholds: { ...form.churnThresholds, critical: Number(e.target.value) } })} />
            </div>
            <div>
              <Label>Cooldown de campañas (días entre comunicaciones)</Label>
              <Input type="number" value={form.campaignCooldownDays} onChange={(e) => setForm({ ...form, campaignCooldownDays: Number(e.target.value) })} />
            </div>
          </div>
        </Panel>
      </div>

      <div className="mt-4 max-w-4xl flex justify-end">
        <Button onClick={() => mutation.mutate(form)} disabled={mutation.isPending}>
          {mutation.isPending ? "Guardando..." : "Guardar cambios"}
        </Button>
      </div>
    </AppLayout>
  );
}
