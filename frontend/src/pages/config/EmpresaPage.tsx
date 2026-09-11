import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Plus } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { empresasApi } from "@/services/api";
import { Badge, Button, Input, Panel, Spinner } from "@/components/ui/Primitives";
import { EmpresaFormModal } from "./EmpresaFormModal";

export function EmpresaPage() {
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState<any | null>(null);
  const [search, setSearch] = useState("");

  const { data: empresas, isLoading } = useQuery({
    queryKey: ["empresas", search],
    queryFn: () => empresasApi.list(search || undefined),
  });

  return (
    <AppLayout title="Empresa" subtitle="Gestión de empresas">
      <div className="max-w-5xl space-y-4">
        <Panel
          title="Empresas"
          action={
            <Button
              onClick={() => {
                setEditing(null);
                setOpen(true);
              }}
            >
              <Plus size={16} /> Nueva empresa
            </Button>
          }
        >
          <div className="space-y-3">
            <div className="flex gap-2">
              <Input placeholder="Buscar por RUC o nombre..." value={search} onChange={(e) => setSearch(e.target.value)} className="max-w-xs" />
            </div>
            {isLoading ? (
              <div className="flex gap-2 py-6 justify-center text-muted">
                <Spinner /> Cargando...
              </div>
            ) : (
              <table className="w-full text-[13px]">
                <thead>
                  <tr className="border-b border-border text-left text-[11px] uppercase text-muted">
                    <th className="px-2 py-2">RUC</th>
                    <th className="px-2 py-2">Razón social</th>
                    <th className="px-2 py-2">Nombre comercial</th>
                    <th className="px-2 py-2">Email</th>
                    <th className="px-2 py-2">Estado</th>
                    <th className="px-2 py-2 text-right"></th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-border">
                  {(empresas ?? []).map((e: any) => (
                    <tr key={e.emp_id} className="hover:bg-ink/[0.02]">
                      <td className="px-2 py-2 font-mono text-[12px]">{e.emp_ruc}</td>
                      <td className="px-2 py-2">{e.emp_razon_social}</td>
                      <td className="px-2 py-2 font-medium">{e.emp_nombre_comercial}</td>
                      <td className="px-2 py-2 text-muted">{e.emp_email ?? "—"}</td>
                      <td className="px-2 py-2">
                        {e.estado === 1 ? <Badge tone="success">Activo</Badge> : <Badge tone="critical">Inactivo</Badge>}
                      </td>
                      <td className="px-2 py-2 text-right">
                        <button
                          onClick={() => {
                            setEditing(e);
                            setOpen(true);
                          }}
                          className="text-[12px] text-brand-dark hover:underline font-medium"
                        >
                          Editar
                        </button>
                      </td>
                    </tr>
                  ))}
                  {(empresas ?? []).length === 0 && (
                    <tr>
                      <td colSpan={6} className="px-2 py-8 text-center text-muted">
                        Sin empresas. Crea la primera con el botón superior.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            )}
          </div>
        </Panel>
      </div>
      <EmpresaFormModal open={open} onClose={() => { setOpen(false); setEditing(null); }} empresa={editing} />
    </AppLayout>
  );
}
