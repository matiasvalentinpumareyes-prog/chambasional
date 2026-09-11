import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Package, AlertTriangle, Plus } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { stockApi, productsApi } from "@/services/api";
import { Badge, Button, Spinner, Input, Label, Select } from "@/components/ui/Primitives";
import { Modal } from "@/components/ui/Modal";

export function StockPage() {
  const [filter, setFilter] = useState<"all" | "bajo">("all");
  const queryClient = useQueryClient();
  const [movOpen, setMovOpen] = useState(false);
  const [selectedPrdId, setSelectedPrdId] = useState("");

  const { data: stockList, isLoading } = useQuery({
    queryKey: ["stock", filter],
    queryFn: () => stockApi.list().then((list) => (filter === "bajo" ? list.filter((s: any) => s.alerta_bajo_minimo) : list)),
  });

  const { data: productsPage } = useQuery({
    queryKey: ["products-for-stock"],
    queryFn: () => productsApi.list({ page: 1, pageSize: 200 }),
  });

  return (
    <AppLayout title="Inventario" subtitle="Control de stock por producto (stk_cantidad / stk_min / stk_max)">
      <div className="flex gap-2 mb-4">
        <Button variant={filter === "all" ? "primary" : "secondary"} onClick={() => setFilter("all")}>Todo</Button>
        <Button variant={filter === "bajo" ? "primary" : "secondary"} onClick={() => setFilter("bajo")}>
          <AlertTriangle size={16} /> Bajo mínimo
        </Button>
        <div className="ml-auto">
          <Button onClick={() => setMovOpen(true)}>
            <Plus size={16} /> Movimiento
          </Button>
        </div>
      </div>

      <div className="bg-surface border border-border rounded shadow-panel overflow-hidden">
        {isLoading ? (
          <div className="flex items-center gap-2 py-16 justify-center text-muted">
            <Spinner /> Cargando stock...
          </div>
        ) : (
          <table className="w-full text-[13.5px]">
            <thead>
              <tr className="border-b border-border text-left text-[11.5px] uppercase tracking-wide text-muted">
                <th className="px-4 py-2.5">Producto</th>
                <th className="px-4 py-2.5">SKU</th>
                <th className="px-4 py-2.5 text-right">Cantidad</th>
                <th className="px-4 py-2.5 text-right">Mín</th>
                <th className="px-4 py-2.5 text-right">Máx</th>
                <th className="px-4 py-2.5">Estado</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-border">
              {stockList?.map((s: any) => (
                <tr key={`${s.emp_id}-${s.prd_id}`} className={s.alerta_bajo_minimo ? "bg-risk-critical/5" : "hover:bg-ink/[0.02]"}>
                  <td className="px-4 py-2.5 font-medium">{s.prd_nombre ?? s.prd_id}</td>
                  <td className="px-4 py-2.5 text-muted">{s.prd_sku ?? "-"}</td>
                  <td className="px-4 py-2.5 text-right font-medium">{s.stk_cantidad}</td>
                  <td className="px-4 py-2.5 text-right">{s.stk_min}</td>
                  <td className="px-4 py-2.5 text-right">{s.stk_max ?? "-"}</td>
                  <td className="px-4 py-2.5">
                    {s.alerta_bajo_minimo ? <Badge tone="critical">Bajo mínimo</Badge> : s.alerta_sobre_maximo ? <Badge tone="warning">Sobre máximo</Badge> : <Badge tone="success">OK</Badge>}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      <MovimientoModal open={movOpen} onClose={() => setMovOpen(false)} products={productsPage?.items ?? []} onSuccess={() => queryClient.invalidateQueries({ queryKey: ["stock"] })} />
    </AppLayout>
  );
}

function MovimientoModal({ open, onClose, products, onSuccess }: { open: boolean; onClose: () => void; products: any[]; onSuccess: () => void }) {
  const [prd_id, setPrdId] = useState("");
  const [delta, setDelta] = useState<number>(1);
  const [motivo, setMotivo] = useState("");

  const mutation = useMutation({
    mutationFn: () => stockApi.movimiento(prd_id, delta, motivo),
    onSuccess: () => {
      onSuccess();
      onClose();
      setPrdId("");
      setDelta(1);
      setMotivo("");
    },
  });

  return (
    <Modal open={open} onClose={onClose} title="Ajuste de stock" width="max-w-md">
      <div className="space-y-4">
        <div>
          <Label>Producto</Label>
          <Select value={prd_id} onChange={(e) => setPrdId(e.target.value)} className="w-full">
            <option value="">Selecciona producto</option>
            {products.map((p) => (
              <option key={p.id ?? p.prd_id} value={p.id ?? p.prd_id}>
                {p.name ?? p.prd_nombre} — {p.sku ?? p.prd_sku}
              </option>
            ))}
          </Select>
        </div>
        <div>
          <Label>Stock</Label>
          <Input type="number" value={delta} onChange={(e) => setDelta(Number(e.target.value))} />
        </div>
        <div>
          <Label>Motivo</Label>
          <Input value={motivo} onChange={(e) => setMotivo(e.target.value)} placeholder="venta, ajuste inventario" />
        </div>
        {mutation.isError && <p className="text-[13px] text-risk-critical">Error al ajustar stock.</p>}
        <div className="flex justify-end gap-2 pt-2">
          <Button variant="secondary" onClick={onClose}>Cancelar</Button>
          <Button onClick={() => mutation.mutate()} disabled={!prd_id || mutation.isPending}>
            {mutation.isPending ? "Guardando..." : "Ajustar"}
          </Button>
        </div>
      </div>
    </Modal>
  );
}
