import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useForm, useFieldArray } from "react-hook-form";
import { Plus, Trash2 } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { customersApi, productsApi, salesApi } from "@/services/api";
import { Badge, Button, EmptyState, Input, Label, Select, Spinner } from "@/components/ui/Primitives";
import { Modal } from "@/components/ui/Modal";
import { CHANNEL_LABEL, formatDate, formatMoney } from "@/lib/format";
import type { Channel } from "@/types";

const PAGE_SIZE = 15;

export function SalesPage() {
  const [page, setPage] = useState(1);
  const [formOpen, setFormOpen] = useState(false);

  const { data, isLoading } = useQuery({
    queryKey: ["sales", page],
    queryFn: () => salesApi.list({ page, pageSize: PAGE_SIZE }),
  });

  const totalPages = data ? Math.max(1, Math.ceil(data.total / PAGE_SIZE)) : 1;

  return (
    <AppLayout title="Ventas" subtitle="Registro de todas las transacciones del negocio">
      <div className="flex justify-end mb-4">
        <Button onClick={() => setFormOpen(true)}>
          <Plus size={16} /> Registrar venta
        </Button>
      </div>

      <div className="bg-surface border border-border rounded shadow-panel overflow-hidden">
        {isLoading && (
          <div className="flex items-center gap-2 text-muted py-16 justify-center">
            <Spinner /> Cargando ventas...
          </div>
        )}
        {!isLoading && data?.items.length === 0 && <EmptyState title="Aún no hay ventas registradas" />}
        {!isLoading && data && data.items.length > 0 && (
          <>
            <table className="w-full text-[13.5px]">
              <thead>
                <tr className="border-b border-border text-left text-[11.5px] uppercase tracking-wide text-muted">
                  <th className="px-4 py-2.5 font-medium">Fecha</th>
                  <th className="px-4 py-2.5 font-medium">Cliente</th>
                  <th className="px-4 py-2.5 font-medium">Productos</th>
                  <th className="px-4 py-2.5 font-medium">Canal</th>
                  <th className="px-4 py-2.5 font-medium text-right">Total</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {data.items.map((s) => (
                  <tr key={s.id} className="hover:bg-ink/[0.02]">
                    <td className="px-4 py-2.5 text-muted">{formatDate(s.date)}</td>
                    <td className="px-4 py-2.5 font-medium">{s.customerName}</td>
                    <td className="px-4 py-2.5 text-muted">{s.items.map((i) => `${i.quantity}× ${i.productName}`).join(", ")}</td>
                    <td className="px-4 py-2.5"><Badge tone="neutral">{CHANNEL_LABEL[s.channel]}</Badge></td>
                    <td className="px-4 py-2.5 text-right font-medium">{formatMoney(s.total)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            <div className="flex items-center justify-between px-4 py-3 border-t border-border text-[12.5px] text-muted">
              <span>{data.total} ventas en total</span>
              <div className="flex items-center gap-2">
                <button disabled={page <= 1} onClick={() => setPage((p) => p - 1)} className="disabled:opacity-40 hover:underline">Anterior</button>
                <span>Página {page} de {totalPages}</span>
                <button disabled={page >= totalPages} onClick={() => setPage((p) => p + 1)} className="disabled:opacity-40 hover:underline">Siguiente</button>
              </div>
            </div>
          </>
        )}
      </div>

      <NewSaleModal open={formOpen} onClose={() => setFormOpen(false)} />
    </AppLayout>
  );
}

interface SaleFormValues {
  customerId: string;
  channel: Channel;
  paymentMethod: string;
  items: { productId: string; quantity: number }[];
}

function NewSaleModal({ open, onClose }: { open: boolean; onClose: () => void }) {
  const queryClient = useQueryClient();
  const { data: customersPage } = useQuery({
    queryKey: ["customers-for-sale"],
    queryFn: () => customersApi.list({ page: 1, pageSize: 200, sortBy: "firstName", sortDir: "asc" }),
    enabled: open,
  });
  const { data: productsPage } = useQuery({
    queryKey: ["products-for-sale"],
    queryFn: () => productsApi.list({ page: 1, pageSize: 200, filters: { status: "active" } }),
    enabled: open,
  });

  const { register, control, handleSubmit, reset } = useForm<SaleFormValues>({
    defaultValues: { customerId: "", channel: "internal", paymentMethod: "Efectivo", items: [{ productId: "", quantity: 1 }] },
  });
  const { fields, append, remove } = useFieldArray({ control, name: "items" });

  const mutation = useMutation({
    mutationFn: (values: SaleFormValues) =>
      salesApi.create({
        customerId: values.customerId,
        channel: values.channel,
        paymentMethod: values.paymentMethod,
        items: values.items.filter((i) => i.productId).map((i) => ({ productId: i.productId, quantity: Number(i.quantity) })),
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["sales"] });
      queryClient.invalidateQueries({ queryKey: ["customers"] });
      queryClient.invalidateQueries({ queryKey: ["dashboard-metrics"] });
      reset();
      onClose();
    },
  });

  return (
    <Modal open={open} onClose={onClose} title="Registrar nueva venta" width="max-w-xl">
      <form onSubmit={handleSubmit((v) => mutation.mutate(v))} className="space-y-4">
        <div>
          <Label>Cliente</Label>
          <Select {...register("customerId", { required: true })} className="w-full">
            <option value="">Selecciona un cliente</option>
            {customersPage?.items.map((c) => (
              <option key={c.id} value={c.id}>{c.firstName} {c.lastName}</option>
            ))}
          </Select>
        </div>

        <div>
          <Label>Productos</Label>
          <div className="space-y-2">
            {fields.map((field, idx) => (
              <div key={field.id} className="flex gap-2 items-center">
                <Select {...register(`items.${idx}.productId` as const)} className="flex-1">
                  <option value="">Selecciona un producto</option>
                  {productsPage?.items.map((p) => (
                    <option key={p.id} value={p.id}>{p.name} — {formatMoney(p.price)}</option>
                  ))}
                </Select>
                <Input type="number" min={1} defaultValue={1} className="w-20" {...register(`items.${idx}.quantity` as const, { valueAsNumber: true })} />
                <button type="button" onClick={() => remove(idx)} className="text-muted hover:text-risk-critical p-1.5">
                  <Trash2 size={15} />
                </button>
              </div>
            ))}
          </div>
          <button type="button" onClick={() => append({ productId: "", quantity: 1 })} className="text-[12.5px] text-brand-dark hover:underline mt-2">
            + Agregar producto
          </button>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Canal</Label>
            <Select {...register("channel")} className="w-full">
              <option value="internal">Presencial / interno</option>
              <option value="whatsapp">WhatsApp</option>
              <option value="email">Email</option>
              <option value="sms">SMS</option>
            </Select>
          </div>
          <div>
            <Label>Método de pago</Label>
            <Select {...register("paymentMethod")} className="w-full">
              <option value="Efectivo">Efectivo</option>
              <option value="Tarjeta">Tarjeta</option>
              <option value="Yape/Plin">Yape/Plin</option>
            </Select>
          </div>
        </div>

        {mutation.isError && <p className="text-[13px] text-risk-critical">No se pudo registrar la venta.</p>}
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="secondary" onClick={onClose}>Cancelar</Button>
          <Button type="submit" disabled={mutation.isPending}>{mutation.isPending ? "Guardando..." : "Registrar venta"}</Button>
        </div>
      </form>
    </Modal>
  );
}
