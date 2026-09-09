import { useEffect, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { settingsApi } from "@/services/api";
import { Button, Input, Label, Panel, Select, Spinner } from "@/components/ui/Primitives";
import type { BusinessSettings } from "@/types";

export function EmpresaPage() {
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
      <AppLayout title="Empresa" subtitle="Datos de empresa">
        <div className="flex items-center gap-2 text-muted py-12 justify-center">
          <Spinner /> Cargando empresa...
        </div>
      </AppLayout>
    );
  }
  return (
    <AppLayout title="Empresa" subtitle="Datos de empresa">
      <div className="max-w-4xl space-y-4">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <Panel title="Datos de empresa">
            <div className="space-y-3">
              <div>
                <Label>Nombre comercial</Label>
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
          <Panel title="Reglas">
            <div className="space-y-3">
              <div>
                <Label>Umbral medio</Label>
                <Input type="number" value={form.churnThresholds.medium} onChange={(e) => setForm({ ...form, churnThresholds: { ...form.churnThresholds, medium: Number(e.target.value) } })} />
              </div>
              <div>
                <Label>Umbral alto</Label>
                <Input type="number" value={form.churnThresholds.high} onChange={(e) => setForm({ ...form, churnThresholds: { ...form.churnThresholds, high: Number(e.target.value) } })} />
              </div>
              <div>
                <Label>Umbral crítico</Label>
                <Input type="number" value={form.churnThresholds.critical} onChange={(e) => setForm({ ...form, churnThresholds: { ...form.churnThresholds, critical: Number(e.target.value) } })} />
              </div>
              <div>
                <Label>Cooldown campañas (días)</Label>
                <Input type="number" value={form.campaignCooldownDays} onChange={(e) => setForm({ ...form, campaignCooldownDays: Number(e.target.value) })} />
              </div>
            </div>
          </Panel>
        </div>
        <div className="flex justify-end">
          <Button onClick={() => mutation.mutate(form)} disabled={mutation.isPending}>
            {mutation.isPending ? "Guardando..." : "Guardar empresa"}
          </Button>
        </div>
      </div>
    </AppLayout>
  );
}
