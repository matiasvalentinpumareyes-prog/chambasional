import { useQuery } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { Panel, Spinner } from "@/components/ui/Primitives";
import { rolesApi } from "@/services/api";

export function RolesPage() {
  const { data, isLoading } = useQuery({
    queryKey: ["roles"],
    queryFn: rolesApi.list,
  });

  return (
    <AppLayout title="Roles" subtitle="Catálogo de roles del sistema">
      <div className="max-w-4xl">
        <Panel title="Roles">
          {isLoading ? (
            <div className="py-8 flex justify-center text-muted">
              <Spinner />
            </div>
          ) : (
            <table className="w-full text-[13px]">
              <thead>
                <tr className="border-b border-border text-left text-[11px] uppercase text-muted">
                  <th className="px-2 py-2">rol_codigo</th>
                  <th className="px-2 py-2">rol_nombre</th>
                  <th className="px-2 py-2">rol_descripcion</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {data?.map((r: any) => (
                  <tr key={r.rol_id}>
                    <td className="px-2 py-2 font-medium">{r.rol_codigo}</td>
                    <td className="px-2 py-2">{r.rol_nombre}</td>
                    <td className="px-2 py-2 text-muted">{r.rol_descripcion ?? "-"}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </Panel>
      </div>
    </AppLayout>
  );
}
