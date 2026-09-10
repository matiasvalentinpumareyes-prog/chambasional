import { useEffect, useState } from "react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { Button, Input, Label, Panel, Spinner } from "@/components/ui/Primitives";
import { perfilApi } from "@/services/api";

export function PerfilPage() {
  const { data, isLoading } = useQuery({
    queryKey: ["mi-perfil"],
    queryFn: perfilApi.get,
  });
  const [form, setForm] = useState<any>({});
  useEffect(() => {
    if (data) setForm(data);
  }, [data]);

  const mutation = useMutation({
    mutationFn: () => perfilApi.update(form),
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
              <Label>Nombres</Label>
              <Input value={form.usp_nombres ?? ""} onChange={(e) => setForm({ ...form, usp_nombres: e.target.value })} />
            </div>
            <div>
              <Label>dni</Label>
              <Input value={form.usp_dni ?? ""} onChange={(e) => setForm({ ...form, usp_dni: e.target.value })} maxLength={8} />
            </div>
            <div>
              <Label>celular</Label>
              <Input value={form.usp_celular ?? ""} onChange={(e) => setForm({ ...form, usp_celular: e.target.value })} />
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
