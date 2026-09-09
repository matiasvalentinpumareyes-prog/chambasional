import { useEffect, useState } from "react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { Button, Input, Label, Panel, Spinner } from "@/components/ui/Primitives";

export function PerfilPage() {
  const { data, isLoading } = useQuery({
    queryKey: ["mi-perfil"],
    queryFn: async () => {
      const res = await fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/usuarios/me/personal`, {
        headers: { Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` },
      });
      if (!res.ok) throw new Error("Error");
      return res.json() as Promise<any>;
    },
  });
  const [form, setForm] = useState<any>({});
  useEffect(() => {
    if (data) setForm(data);
  }, [data]);

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

  if (isLoading) {
    return (
      <AppLayout title="Mi perfil" subtitle="Datos personales">
        <div className="flex gap-2 py-12 justify-center text-muted">
          <Spinner /> Cargando perfil...
        </div>
      </AppLayout>
    );
  }

  return (
    <AppLayout title="Mi perfil" subtitle="Datos personales">
      <div className="max-w-2xl">
        <Panel title="Mi ficha personal">
          <div className="space-y-3">
            <div>
              <Label>usp_nombres</Label>
              <Input value={form.usp_nombres ?? ""} onChange={(e) => setForm({ ...form, usp_nombres: e.target.value })} />
            </div>
            <div>
              <Label>usp_dni</Label>
              <Input value={form.usp_dni ?? ""} onChange={(e) => setForm({ ...form, usp_dni: e.target.value })} maxLength={8} />
            </div>
            <div>
              <Label>usp_celular</Label>
              <Input value={form.usp_celular ?? ""} onChange={(e) => setForm({ ...form, usp_celular: e.target.value })} />
            </div>
            <div className="flex gap-2 text-[11px] text-muted">
              <span>usp_id: {form.usp_id?.slice(0, 8)}…</span>
              <span>emp_id: {form.emp_id?.slice(0, 8)}…</span>
              <span>estado: {form.estado}</span>
            </div>
            <Button onClick={() => mutation.mutate()} disabled={mutation.isPending}>
              {mutation.isPending ? "Guardando..." : "Guardar mis datos"}
            </Button>
          </div>
        </Panel>
      </div>
    </AppLayout>
  );
}
