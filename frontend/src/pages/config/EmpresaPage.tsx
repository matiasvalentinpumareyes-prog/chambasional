import { useEffect, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { settingsApi } from "@/services/api";
import { Button, Input, Label, Panel, Spinner } from "@/components/ui/Primitives";
import type { EmpresaOut } from "@/types";

type EmpresaForm = EmpresaOut;

export function EmpresaPage() {
  const queryClient = useQueryClient();
  const { data, isLoading, isError, error, refetch } = useQuery({
    queryKey: ["settings"],
    queryFn: settingsApi.get,
    retry: 1,
  });
  const [form, setForm] = useState<EmpresaForm | null>(null);
  const [saveError, setSaveError] = useState<string | null>(null);
  const [saveOk, setSaveOk] = useState(false);

  useEffect(() => {
    if (data) {
      setForm(data as EmpresaForm);
    }
  }, [data]);

  const mutation = useMutation({
    mutationFn: (patch: Partial<EmpresaForm>) => settingsApi.update(patch),
    onSuccess: (updated) => {
      queryClient.setQueryData(["settings"], updated);
      setForm(updated as EmpresaForm);
      setSaveError(null);
      setSaveOk(true);
      setTimeout(() => setSaveOk(false), 2500);
    },
    onError: (e: any) => {
      setSaveError(e?.message ?? "Error al guardar");
    },
  });

  if (isLoading) {
    return (
      <AppLayout title="Empresa" subtitle="Datos de empresa">
        <div className="flex items-center gap-2 text-muted py-12 justify-center">
          <Spinner /> Cargando empresa...
        </div>
      </AppLayout>
    );
  }

  if (isError) {
    const msg = (error as any)?.message ?? "No se pudo cargar la configuración de empresa.";
    return (
      <AppLayout title="Empresa" subtitle="Datos de empresa">
        <div className="max-w-2xl mx-auto py-12 text-center space-y-4">
          <p className="text-risk-critical font-medium">Error al cargar empresa</p>
          <p className="text-sm text-muted break-words">{msg}</p>
          <p className="text-xs text-muted">Verifica que tu usuario tenga permisos y que el backend esté corriendo en {import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}.</p>
          <Button onClick={() => refetch()}>Reintentar</Button>
        </div>
      </AppLayout>
    );
  }

  if (!form) {
    return (
      <AppLayout title="Empresa" subtitle="Datos de empresa">
        <div className="flex items-center gap-2 text-muted py-12 justify-center">Sin datos de empresa.</div>
      </AppLayout>
    );
  }

  return (
    <AppLayout title="Empresa" subtitle="Datos de empresa">
      <div className="max-w-4xl space-y-4">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <Panel title="Datos principales">
            <div className="space-y-3">
              <div>
                <Label>RUC (11 dígitos)</Label>
                <Input value={form.emp_ruc ?? ""} onChange={(e) => setForm({ ...form, emp_ruc: e.target.value })} maxLength={11} placeholder="20123456789" />
              </div>
              <div>
                <Label>Razón social</Label>
                <Input value={form.emp_razon_social ?? ""} onChange={(e) => setForm({ ...form, emp_razon_social: e.target.value })} placeholder="Mi Empresa S.A.C." />
              </div>
              <div>
                <Label>Nombre comercial</Label>
                <Input value={form.emp_nombre_comercial ?? ""} onChange={(e) => setForm({ ...form, emp_nombre_comercial: e.target.value })} placeholder="Mi Marca" />
              </div>
              <div>
                <Label>Dirección</Label>
                <Input value={form.emp_direccion ?? ""} onChange={(e) => setForm({ ...form, emp_direccion: e.target.value })} placeholder="Av. Ejemplo 123" />
              </div>
              <div>
                <Label>Lema</Label>
                <Input value={form.emp_lema ?? ""} onChange={(e) => setForm({ ...form, emp_lema: e.target.value })} placeholder="Tu lema comercial" />
              </div>
              <div>
                <Label>Email corporativo</Label>
                <Input type="email" value={form.emp_email ?? ""} onChange={(e) => setForm({ ...form, emp_email: e.target.value })} placeholder="contacto@empresa.com" />
              </div>
            </div>
          </Panel>
          <Panel title="Contacto y cuentas">
            <div className="space-y-3">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <Label>Celular 1</Label>
                  <Input value={form.emp_celular1 ?? ""} onChange={(e) => setForm({ ...form, emp_celular1: e.target.value })} placeholder="999 888 777" />
                </div>
                <div>
                  <Label>Celular 2</Label>
                  <Input value={form.emp_celular2 ?? ""} onChange={(e) => setForm({ ...form, emp_celular2: e.target.value })} />
                </div>
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <div>
                  <Label>Teléfono 1</Label>
                  <Input value={form.emp_telefono1 ?? ""} onChange={(e) => setForm({ ...form, emp_telefono1: e.target.value })} />
                </div>
                <div>
                  <Label>Teléfono 2</Label>
                  <Input value={form.emp_telefono2 ?? ""} onChange={(e) => setForm({ ...form, emp_telefono2: e.target.value })} />
                </div>
              </div>
              <div>
                <Label>Nro. cuenta 1</Label>
                <Input value={form.emp_nro_cuenta1 ?? ""} onChange={(e) => setForm({ ...form, emp_nro_cuenta1: e.target.value })} placeholder="Cuenta bancaria" />
              </div>
              <div>
                <Label>Nro. cuenta 2</Label>
                <Input value={form.emp_nro_cuenta2 ?? ""} onChange={(e) => setForm({ ...form, emp_nro_cuenta2: e.target.value })} />
              </div>
              <p className="text-xs text-muted pt-2">ID empresa: <span className="font-mono">{form.emp_id}</span></p>
            </div>
          </Panel>
        </div>
        {saveError && <p className="text-sm text-risk-critical">{saveError}</p>}
        {saveOk && <p className="text-sm text-success">Guardado correctamente.</p>}
        <div className="flex justify-end">
          <Button onClick={() => mutation.mutate(form)} disabled={mutation.isPending}>
            {mutation.isPending ? "Guardando..." : "Guardar empresa"}
          </Button>
        </div>
      </div>
    </AppLayout>
  );
}
