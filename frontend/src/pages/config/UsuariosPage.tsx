import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Plus } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { Badge, Button, Panel, Spinner } from "@/components/ui/Primitives";
import { usuariosApi } from "@/services/api";
import { UsuarioFormModal } from "./UsuarioFormModal";

export function UsuariosPage() {
  const { data, isLoading } = useQuery({
    queryKey: ["usuarios"],
    queryFn: usuariosApi.list,
  });
  const [open, setOpen] = useState(false);

  return (
    <AppLayout title="Usuarios" subtitle="Gestión de usuarios del sistema">
      <div className="max-w-4xl space-y-4">
        <Panel
          title="Usuarios"
          action={
            <Button onClick={() => setOpen(true)}>
              <Plus size={16} /> Nuevo usuario
            </Button>
          }
        >
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
                  {data?.length === 0 && (
                    <tr>
                      <td colSpan={4} className="px-2 py-8 text-center text-muted">
                        Sin usuarios. Crea el primero con el botón superior.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            )}
          </div>
        </Panel>
      </div>
      <UsuarioFormModal open={open} onClose={() => setOpen(false)} />
    </AppLayout>
  );
}
