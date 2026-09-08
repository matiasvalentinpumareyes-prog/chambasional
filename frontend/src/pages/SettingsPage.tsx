import { useEffect, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { settingsApi } from "@/services/api";
import { Button, Input, Label, Panel, Select, Spinner, Badge } from "@/components/ui/Primitives";
import type { BusinessSettings } from "@/types";

export function SettingsPage() {
  return (
    <AppLayout title="Configuración" subtitle="Empresa, usuarios, roles y datos personales">
      <div className="space-y-6">
        <EmpresaTab />
        <UsuariosTab />
        <RolesTab />
        <PerfilTab />
      </div>
    </AppLayout>
  );
}

function EmpresaTab() {
  const queryClient = useQueryClient();
  const { data, isLoading } = useQuery({ queryKey: ["settings"], queryFn: settingsApi.get });
  const [form, setForm] = useState<BusinessSettings | null>(null);
  useEffect(() => { if (data) setForm(data); }, [data]);
  const mutation = useMutation({
    mutationFn: (patch: Partial<BusinessSettings>) => settingsApi.update(patch),
    onSuccess: (updated) => {
      queryClient.setQueryData(["settings"], updated);
      setForm(updated);
    },
  });
  if (isLoading || !form) return <div className="flex items-center gap-2 text-muted py-12 justify-center"><Spinner /> Cargando empresa...</div>;
  return (
    <div className="max-w-4xl space-y-4">
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <Panel title="Datos de empresa (empresa.emp_id)">
          <div className="space-y-3">
            <div><Label>Nombre comercial (emp_nombre_comercial)</Label><Input value={form.businessName} onChange={(e) => setForm({ ...form, businessName: e.target.value })} /></div>
            <div><Label>Moneda</Label><Select value={form.currency} onChange={(e) => setForm({ ...form, currency: e.target.value as any })} className="w-full"><option value="PEN">PEN</option><option value="USD">USD</option><option value="EUR">EUR</option><option value="MXN">MXN</option><option value="COP">COP</option></Select></div>
            <div><Label>Zona horaria</Label><Select value={form.timezone} onChange={(e) => setForm({ ...form, timezone: e.target.value })} className="w-full"><option value="America/Lima">America/Lima</option><option value="America/Mexico_City">America/Mexico_City</option><option value="America/Bogota">America/Bogota</option></Select></div>
            <div><Label>Idioma</Label><Select value={form.language} onChange={(e) => setForm({ ...form, language: e.target.value as any })} className="w-full"><option value="es">Español</option><option value="en">English</option></Select></div>
          </div>
        </Panel>
        <Panel title="Reglas">
          <div className="space-y-3">
            <div><Label>Umbral medio</Label><Input type="number" value={form.churnThresholds.medium} onChange={(e) => setForm({ ...form, churnThresholds: { ...form.churnThresholds, medium: Number(e.target.value) } })} /></div>
            <div><Label>Umbral alto</Label><Input type="number" value={form.churnThresholds.high} onChange={(e) => setForm({ ...form, churnThresholds: { ...form.churnThresholds, high: Number(e.target.value) } })} /></div>
            <div><Label>Umbral crítico</Label><Input type="number" value={form.churnThresholds.critical} onChange={(e) => setForm({ ...form, churnThresholds: { ...form.churnThresholds, critical: Number(e.target.value) } })} /></div>
            <div><Label>Cooldown campañas (días)</Label><Input type="number" value={form.campaignCooldownDays} onChange={(e) => setForm({ ...form, campaignCooldownDays: Number(e.target.value) })} /></div>
          </div>
        </Panel>
      </div>
      <div className="flex justify-end"><Button onClick={() => mutation.mutate(form)} disabled={mutation.isPending}>{mutation.isPending ? "Guardando..." : "Guardar empresa"}</Button></div>
    </div>
  );
}

function UsuariosTab() {
  const { data, isLoading, refetch } = useQuery({
    queryKey: ["usuarios"],
    queryFn: async () => {
      const res = await fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/usuarios`, { headers: { Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` } });
      if (!res.ok) throw new Error("Error");
      return res.json() as Promise<any[]>;
    },
  });
  const [form, setForm] = useState({ usu_usuario: "", usu_email: "", password: "", rol_id: "", usp_nombres: "" });
  const [roles, setRoles] = useState<any[]>([]);
  useEffect(() => {
    fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/roles`, { headers: { Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` } })
      .then((r) => r.json())
      .then(setRoles)
      .catch(() => {});
  }, []);
  const create = useMutation({
    mutationFn: async () => {
      const res = await fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/usuarios`, {
        method: "POST",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` },
        body: JSON.stringify({ ...form, emp_id: "ignored" }),
      });
      if (!res.ok) throw new Error((await res.json()).error?.message ?? "Error");
      return res.json();
    },
    onSuccess: () => refetch(),
  });

  return (
    <div className="max-w-4xl space-y-4">
      <Panel title="Usuarios">
        <div className="space-y-3">
          {isLoading ? <div className="flex gap-2 py-6 justify-center text-muted"><Spinner /> Cargando...</div> : (
            <table className="w-full text-[13px]">
              <thead><tr className="border-b border-border text-left text-[11px] uppercase text-muted"><th className="px-2 py-2">usu_usuario</th><th className="px-2 py-2">usu_email</th><th className="px-2 py-2">rol</th><th className="px-2 py-2">estado</th></tr></thead>
              <tbody className="divide-y divide-border">
                {data?.map((u: any) => (
                  <tr key={u.usu_id}><td className="px-2 py-2 font-medium">{u.usu_usuario}</td><td className="px-2 py-2 text-muted">{u.usu_email}</td><td className="px-2 py-2"><Badge tone="neutral">{u.rol_nombre ?? u.rol_id?.slice(0,8) ?? "-"}</Badge></td><td className="px-2 py-2">{u.estado === 1 ? <Badge tone="success">Activo</Badge> : <Badge tone="critical">Inactivo</Badge>}</td></tr>
                ))}
              </tbody>
            </table>
          )}
          <div className="grid grid-cols-2 gap-3 pt-4 border-t border-border">
            <div><Label>usu_usuario</Label><Input value={form.usu_usuario} onChange={(e) => setForm({ ...form, usu_usuario: e.target.value })} placeholder="ej. juan.perez" /></div>
            <div><Label>usu_email</Label><Input value={form.usu_email} onChange={(e) => setForm({ ...form, usu_email: e.target.value })} /></div>
            <div><Label>usp_nombres (usuario_personal)</Label><Input value={form.usp_nombres} onChange={(e) => setForm({ ...form, usp_nombres: e.target.value })} /></div>
            <div><Label>rol_id</Label><Select value={form.rol_id} onChange={(e) => setForm({ ...form, rol_id: e.target.value })} className="w-full"><option value="">Sin rol</option>{roles.map((r) => <option key={r.rol_id} value={r.rol_id}>{r.rol_codigo} — {r.rol_nombre}</option>)}</Select></div>
            <div><Label>password</Label><Input type="password" value={form.password} onChange={(e) => setForm({ ...form, password: e.target.value })} /></div>
          </div>
          <Button onClick={() => create.mutate()} disabled={create.isPending}>{create.isPending ? "..." : "Crear usuario"}</Button>
          {create.isError && <p className="text-[12px] text-risk-critical">{(create.error as any)?.message}</p>}
        </div>
      </Panel>
    </div>
  );
}

function RolesTab() {
  const { data, isLoading } = useQuery({
    queryKey: ["roles"],
    queryFn: async () => {
      const res = await fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/roles`, { headers: { Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` } });
      if (!res.ok) throw new Error("Error");
      return res.json() as Promise<any[]>;
    },
  });
  return (
    <div className="max-w-4xl">
      <Panel title="Roles del sistema (roles.rol_id / rol_codigo)">
        {isLoading ? <div className="py-8 flex justify-center text-muted"><Spinner /></div> : (
          <table className="w-full text-[13px]">
            <thead><tr className="border-b border-border text-left text-[11px] uppercase text-muted"><th className="px-2 py-2">rol_codigo</th><th className="px-2 py-2">rol_nombre</th><th className="px-2 py-2">rol_descripcion</th></tr></thead>
            <tbody className="divide-y divide-border">
              {data?.map((r: any) => (
                <tr key={r.rol_id}><td className="px-2 py-2 font-medium">{r.rol_codigo}</td><td className="px-2 py-2">{r.rol_nombre}</td><td className="px-2 py-2 text-muted">{r.rol_descripcion ?? "-"}</td></tr>
              ))}
            </tbody>
          </table>
        )}
        <p className="text-[11px] text-muted mt-3">Catálogo global sin emp_id. Añade nuevos roles con INSERT INTO roles (rol_codigo, rol_nombre) — aparecen sin deploy.</p>
      </Panel>
    </div>
  );
}

function PerfilTab() {
  const { data, isLoading } = useQuery({
    queryKey: ["mi-perfil"],
    queryFn: async () => {
      const res = await fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/usuarios/me/personal`, { headers: { Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` } });
      if (!res.ok) throw new Error("Error");
      return res.json() as Promise<any>;
    },
  });
  const [form, setForm] = useState<any>({});
  useEffect(() => { if (data) setForm(data); }, [data]);
  const mutation = useMutation({
    mutationFn: async () => {
      const res = await fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/usuarios/me/personal`, {
        method: "PUT",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` },
        body: JSON.stringify(form),
      });
      if (!res.ok) throw new Error("Error");
      return res.json();
    },
  });
  if (isLoading) return <div className="flex gap-2 py-12 justify-center text-muted"><Spinner /> Cargando perfil...</div>;
  return (
    <div className="max-w-2xl">
      <Panel title="Mi ficha personal">
        <div className="space-y-3">
          <div><Label>usp_nombres</Label><Input value={form.usp_nombres ?? ""} onChange={(e) => setForm({ ...form, usp_nombres: e.target.value })} /></div>
          <div><Label>usp_dni (8 dígitos, único por emp_id)</Label><Input value={form.usp_dni ?? ""} onChange={(e) => setForm({ ...form, usp_dni: e.target.value })} maxLength={8} /></div>
          <div><Label>usp_celular</Label><Input value={form.usp_celular ?? ""} onChange={(e) => setForm({ ...form, usp_celular: e.target.value })} /></div>
          <div className="flex gap-2 text-[11px] text-muted"><span>usp_id: {form.usp_id?.slice(0, 8)}…</span><span>emp_id: {form.emp_id?.slice(0, 8)}…</span><span>estado: {form.estado}</span></div>
          <Button onClick={() => mutation.mutate()} disabled={mutation.isPending}>{mutation.isPending ? "Guardando..." : "Guardar mis datos"}</Button>
        </div>
      </Panel>
    </div>
  );
}
