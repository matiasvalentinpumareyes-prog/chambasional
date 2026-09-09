import { useState } from "react";
import { useQuery, useQueryClient, useMutation } from "@tanstack/react-query";
import { Plus, Search } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { customersApi } from "@/services/api";
import { Badge, Button, EmptyState, Input, Select, Spinner } from "@/components/ui/Primitives";
import { ACTIVITY_LABEL, RISK_LABEL, SEGMENT_LABEL, formatDate, formatMoney } from "@/lib/format";
import type { Customer } from "@/types";
import { CustomerFormModal } from "./customers/CustomerFormModal";
import { CustomerDetailPanel } from "./customers/CustomerDetailPanel";

const PAGE_SIZE = 15;

export function CustomersPage() {
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [segment, setSegment] = useState("");
  const [selected, setSelected] = useState<Customer | null>(null);
  const [editing, setEditing] = useState<Customer | null>(null);
  const [formOpen, setFormOpen] = useState(false);
  const queryClient = useQueryClient();

  const { data, isLoading } = useQuery({
    queryKey: ["customers", page, search],
    queryFn: () => customersApi.list({ page, pageSize: PAGE_SIZE, search }),
  });

  const deactivateMutation = useMutation({
    mutationFn: (id: string) => customersApi.deactivate(id),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["customers"] }),
  });

  const totalPages = data ? Math.max(1, Math.ceil(data.total / PAGE_SIZE)) : 1;

  return (
    <AppLayout title="Clientes" subtitle="Gestiona la base de clientes del negocio">
      <div className="flex flex-col sm:flex-row gap-3 mb-4 items-start sm:items-center justify-between">
        <div className="flex gap-2 flex-1 w-full sm:w-auto">
          <div className="relative flex-1 max-w-xs">
            <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted" />
            <Input
              placeholder="Buscar por nombre o email..."
              value={search}
              onChange={(e) => { setSearch(e.target.value); setPage(1); }}
              className="pl-8"
            />
          </div>
          <Select value={segment} onChange={(e) => { setSegment(e.target.value); setPage(1); }}>
            <option value="">Todos los segmentos</option>
            {Object.entries(SEGMENT_LABEL).map(([key, label]) => (
              <option key={key} value={key}>{label}</option>
            ))}
          </Select>
        </div>
        <Button onClick={() => { setEditing(null); setFormOpen(true); }}>
          <Plus size={16} /> Nuevo cliente
        </Button>
      </div>

      <div className="bg-surface border border-border rounded shadow-panel overflow-hidden">
        {isLoading && (
          <div className="flex items-center gap-2 text-muted py-16 justify-center">
            <Spinner /> Cargando clientes...
          </div>
        )}
        {!isLoading && data?.items.length === 0 && <EmptyState title="No se encontraron clientes" description="Ajusta la búsqueda o los filtros." />}
        {!isLoading && data && data.items.length > 0 && (
          <>
            <table className="w-full text-[13.5px]">
              <thead>
                <tr className="border-b border-border text-left text-[11.5px] uppercase tracking-wide text-muted">
                  <th className="px-4 py-2.5 font-medium">Cliente</th>
                  <th className="px-4 py-2.5 font-medium">Segmento</th>
                  <th className="px-4 py-2.5 font-medium">Estado</th>
                  <th className="px-4 py-2.5 font-medium">Riesgo</th>
                  <th className="px-4 py-2.5 font-medium">Última compra</th>
                  <th className="px-4 py-2.5 font-medium text-right">Gasto total</th>
                  <th className="px-4 py-2.5 font-medium"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {data.items.map((c) => (
                  <tr key={c.id} className="hover:bg-ink/[0.02] cursor-pointer" onClick={() => setSelected(c)}>
                    <td className="px-4 py-2.5">
                      <p className="font-medium text-ink">{c.firstName} {c.lastName}</p>
                      <p className="text-[12px] text-muted">{c.email ?? "—"}</p>
                    </td>
                    <td className="px-4 py-2.5"><Badge tone="neutral">{c.segment ? SEGMENT_LABEL[c.segment as keyof typeof SEGMENT_LABEL] ?? c.segment : "—"}</Badge></td>
                    <td className="px-4 py-2.5">{c.activityStatus ? ACTIVITY_LABEL[c.activityStatus as keyof typeof ACTIVITY_LABEL] ?? c.activityStatus : "—"}</td>
                    <td className="px-4 py-2.5">
                      {c.churn ? <Badge tone={c.churn.riskLevel === "low" ? "success" : c.churn.riskLevel}>{RISK_LABEL[c.churn.riskLevel]}</Badge> : <span className="text-muted">—</span>}
                    </td>
                    <td className="px-4 py-2.5 text-muted">{formatDate(c.lastPurchaseAt)}</td>
                    <td className="px-4 py-2.5 text-right font-medium">{c.totalSpend ? formatMoney(c.totalSpend) : "—"}</td>
                    <td className="px-4 py-2.5 text-right">
                      <button
                        onClick={(e) => { e.stopPropagation(); setEditing(c); setFormOpen(true); }}
                        className="text-[12.5px] text-brand-dark hover:underline mr-3"
                      >
                        Editar
                      </button>
                      {c.status === "active" && (
                        <button
                          onClick={(e) => { e.stopPropagation(); deactivateMutation.mutate(c.id); }}
                          className="text-[12.5px] text-muted hover:text-risk-critical hover:underline"
                        >
                          Desactivar
                        </button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
            <div className="flex items-center justify-between px-4 py-3 border-t border-border text-[12.5px] text-muted">
              <span>{data.total} clientes en total</span>
              <div className="flex items-center gap-2">
                <Button variant="secondary" size="sm" disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>Anterior</Button>
                <span>Página {page} de {totalPages}</span>
                <Button variant="secondary" size="sm" disabled={page >= totalPages} onClick={() => setPage((p) => p + 1)}>Siguiente</Button>
              </div>
            </div>
          </>
        )}
      </div>

      <CustomerFormModal open={formOpen} onClose={() => setFormOpen(false)} customer={editing} />
      {selected && <CustomerDetailPanel customer={selected} onClose={() => setSelected(null)} />}
    </AppLayout>
  );
}
