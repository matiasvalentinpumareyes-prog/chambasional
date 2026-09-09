import { useEffect, useState } from "react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { Badge, Button, Input, Label, Panel, Select, Spinner } from "@/components/ui/Primitives";

export function UsuariosPage() {
  const { data, isLoading, refetch } = useQuery({
    queryKey: ["usuarios"],
    queryFn: async () => {
      const res = await fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/usuarios`, {
        headers: { Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` },
      });
      if (!res.ok) throw new Error("Error");
      return res.json() as Promise<any[]>;
    },
  });
  const [form, setForm] = useState({ usu_usuario: "", usu_email: "", password: "", rol_id: "", usp_nombres: "" });
  const [roles, setRoles] = useState<any[]>([]);

  useEffect(() => {
    fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/roles`, {
      headers: { Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` },
    })
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
    <AppLayout title="Usuarios" subtitle="Gestión de usuarios del sistema">
      <div className="max-w-4xl space-y-4">
        <Panel title="Usuarios">
          <div className="space-y-3">
            {isLoading ? (
              <div className="flex gap-2 py-6 justify-center text-muted">
                <Spinner /> Cargando...
              </div>
            ) : (
              <table className="w-full text-[13px]">
                <thead>
                  <tr className="border-b border-border text-left text-[11px] uppercase text-muted">
                    <th className="px-2 py-2">usuario</th>
                    <th className="px-2 py-2">email</th>
                    <th className="px-2 py-2">rol</th>
                    <th className="px-2 py-2">estado</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border">
                  {data?.map((u: any) => (
                    <tr key={u.usu_id}>
                      <td className="px-2 py-2 font-medium">{u.usu_usuario}</td>
                      <td className="px-2 py-2 text-muted">{u.usu_email}</td>
                      <td className="px-2 py-2">
                        <Badge tone="neutral">{u.rol_nombre ?? u.rol_id?.slice(0, 8) ?? "-"}</Badge>
                      </td>
                      <td className="px-2 py-2">{u.estado === 1 ? <Badge tone="success">Activo</Badge> : <Badge tone="critical">Inactivo</Badge>}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
            <div className="grid grid-cols-2 gap-3 pt-4 border-t border-border">
              <div>
                <Label>usuario</Label>
                <Input value={form.usu_usuario} onChange={(e) => setForm({ ...form, usu_usuario: e.target.value })} placeholder="ej. juan.perez" />
              </div>
              <div>
                <Label>email</Label>
                <Input value={form.usu_email} onChange={(e) => setForm({ ...form, usu_email: e.target.value })} />
              </div>
              <div>
                <Label>nombres</Label>
                <Input value={form.usp_nombres} onChange={(e) => setForm({ ...form, usp_nombres: e.target.value })} />
              </div>
              <div>
                <Label>rol</Label>
                <Select value={form.rol_id} onChange={(e) => setForm({ ...form, rol_id: e.target.value })} className="w-full">
                  <option value="">Sin rol</option>
                  {roles.map((r) => (
                    <option key={r.rol_id} value={r.rol_id}>
                      {r.rol_codigo} — {r.rol_nombre}
                    </option>
                  ))}
                </Select>
              </div>
              <div>
                <Label>password</Label>
                <Input type="password" value={form.password} onChange={(e) => setForm({ ...form, password: e.target.value })} />
              </div>
            </div>
            <Button onClick={() => create.mutate()} disabled={create.isPending}>
              {create.isPending ? "..." : "Crear usuario"}
            </Button>
            {create.isError && <p className="text-[12px] text-risk-critical">{(create.error as any)?.message}</p>}
          </div>
        </Panel>
      </div>
    </AppLayout>
  );
}
