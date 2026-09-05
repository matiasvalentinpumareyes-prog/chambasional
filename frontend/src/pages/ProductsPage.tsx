import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { Plus, Search } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { productsApi } from "@/services/api";
import { Badge, Button, EmptyState, FieldError, Input, Label, Spinner } from "@/components/ui/Primitives";
import { Modal } from "@/components/ui/Modal";
import { formatMoney } from "@/lib/format";
import type { Product } from "@/types";

const PAGE_SIZE = 15;

const schema = z.object({
  sku: z.string().min(1, "El SKU es obligatorio."),
  name: z.string().min(1, "El nombre es obligatorio."),
  description: z.string().optional().or(z.literal("")),
  category: z.string().min(1, "La categoría es obligatoria."),
  price: z.coerce.number().min(0.01, "El precio debe ser mayor a 0."),
  cost: z.coerce.number().min(0, "El costo no puede ser negativo.").optional(),
  stock: z.coerce.number().min(0).optional(),
});
type FormValues = z.infer<typeof schema>;

export function ProductsPage() {
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState("");
  const [formOpen, setFormOpen] = useState(false);
  const [editing, setEditing] = useState<Product | null>(null);
  const queryClient = useQueryClient();

  const { data, isLoading } = useQuery({
    queryKey: ["products", page, search],
    queryFn: () => productsApi.list({ page, pageSize: PAGE_SIZE, search }),
  });

  const deactivateMutation = useMutation({
    mutationFn: (id: string) => productsApi.deactivate(id),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["products"] }),
  });

  const totalPages = data ? Math.max(1, Math.ceil(data.total / PAGE_SIZE)) : 1;

  return (
    <AppLayout title="Productos" subtitle="Catálogo de productos del negocio">
      <div className="flex flex-col sm:flex-row gap-3 mb-4 items-start sm:items-center justify-between">
        <div className="relative max-w-xs w-full">
          <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-muted" />
          <Input placeholder="Buscar por nombre o SKU..." value={search} onChange={(e) => { setSearch(e.target.value); setPage(1); }} className="pl-8" />
        </div>
        <Button onClick={() => { setEditing(null); setFormOpen(true); }}>
          <Plus size={16} /> Nuevo producto
        </Button>
      </div>

      <div className="bg-surface border border-border rounded shadow-panel overflow-hidden">
        {isLoading && (
          <div className="flex items-center gap-2 text-muted py-16 justify-center">
            <Spinner /> Cargando productos...
          </div>
        )}
        {!isLoading && data?.items.length === 0 && <EmptyState title="No se encontraron productos" />}
        {!isLoading && data && data.items.length > 0 && (
          <>
            <table className="w-full text-[13.5px]">
              <thead>
                <tr className="border-b border-border text-left text-[11.5px] uppercase tracking-wide text-muted">
                  <th className="px-4 py-2.5 font-medium">SKU</th>
                  <th className="px-4 py-2.5 font-medium">Nombre</th>
                  <th className="px-4 py-2.5 font-medium">Categoría</th>
                  <th className="px-4 py-2.5 font-medium text-right">Precio</th>
                  <th className="px-4 py-2.5 font-medium text-right">Margen</th>
                  <th className="px-4 py-2.5 font-medium">Estado</th>
                  <th className="px-4 py-2.5 font-medium"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {data.items.map((p) => (
                  <tr key={p.id} className="hover:bg-ink/[0.02]">
                    <td className="px-4 py-2.5 font-mono text-[12.5px] text-muted">{p.sku}</td>
                    <td className="px-4 py-2.5 font-medium">{p.name}</td>
                    <td className="px-4 py-2.5 text-muted">{p.category}</td>
                    <td className="px-4 py-2.5 text-right">{formatMoney(p.price)}</td>
                    <td className="px-4 py-2.5 text-right text-muted">{p.margin != null ? `${p.margin}%` : "—"}</td>
                    <td className="px-4 py-2.5">
                      <Badge tone={p.status === "active" ? "success" : "neutral"}>{p.status === "active" ? "Activo" : "Inactivo"}</Badge>
                    </td>
                    <td className="px-4 py-2.5 text-right">
                      <button onClick={() => { setEditing(p); setFormOpen(true); }} className="text-[12.5px] text-brand-dark hover:underline mr-3">Editar</button>
                      {p.status === "active" && (
                        <button onClick={() => deactivateMutation.mutate(p.id)} className="text-[12.5px] text-muted hover:text-risk-critical hover:underline">Desactivar</button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
            <div className="flex items-center justify-between px-4 py-3 border-t border-border text-[12.5px] text-muted">
              <span>{data.total} productos en total</span>
              <div className="flex items-center gap-2">
                <button disabled={page <= 1} onClick={() => setPage((p) => p - 1)} className="disabled:opacity-40 hover:underline">Anterior</button>
                <span>Página {page} de {totalPages}</span>
                <button disabled={page >= totalPages} onClick={() => setPage((p) => p + 1)} className="disabled:opacity-40 hover:underline">Siguiente</button>
              </div>
            </div>
          </>
        )}
      </div>

      <ProductFormModal open={formOpen} onClose={() => setFormOpen(false)} product={editing} />
    </AppLayout>
  );
}

function ProductFormModal({ open, onClose, product }: { open: boolean; onClose: () => void; product: Product | null }) {
  const queryClient = useQueryClient();
  const { register, handleSubmit, reset, formState: { errors } } = useForm<FormValues>({
    resolver: zodResolver(schema),
    values: product
      ? { sku: product.sku, name: product.name, description: product.description ?? "", category: product.category, price: product.price, cost: product.cost ?? undefined, stock: product.stock ?? undefined }
      : { sku: "", name: "", description: "", category: "", price: 0, cost: undefined, stock: undefined },
  });

  const mutation = useMutation({
    mutationFn: async (values: FormValues) => {
      const payload = { ...values, description: values.description || null, cost: values.cost ?? null, stock: values.stock ?? null, status: "active" as const };
      if (product) return productsApi.update(product.id, payload);
      return productsApi.create(payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["products"] });
      reset();
      onClose();
    },
  });

  return (
    <Modal open={open} onClose={onClose} title={product ? "Editar producto" : "Nuevo producto"}>
      <form onSubmit={handleSubmit((v) => mutation.mutate(v))} className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>SKU</Label>
            <Input {...register("sku")} />
            <FieldError>{errors.sku?.message}</FieldError>
          </div>
          <div>
            <Label>Categoría</Label>
            <Input {...register("category")} list="categories" />
            <CategoryDatalist />
            <FieldError>{errors.category?.message}</FieldError>
          </div>
        </div>
        <div>
          <Label>Nombre</Label>
          <Input {...register("name")} />
          <FieldError>{errors.name?.message}</FieldError>
        </div>
        <div>
          <Label>Descripción</Label>
          <Input {...register("description")} placeholder="opcional" />
        </div>
        <div className="grid grid-cols-3 gap-3">
          <div>
            <Label>Precio</Label>
            <Input type="number" step="0.01" {...register("price")} />
            <FieldError>{errors.price?.message}</FieldError>
          </div>
          <div>
            <Label>Costo</Label>
            <Input type="number" step="0.01" {...register("cost")} placeholder="opcional" />
          </div>
          <div>
            <Label>Stock</Label>
            <Input type="number" {...register("stock")} placeholder="opcional" />
          </div>
        </div>
        {mutation.isError && <p className="text-[13px] text-risk-critical">No se pudo guardar el producto.</p>}
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="secondary" onClick={onClose}>Cancelar</Button>
          <Button type="submit" disabled={mutation.isPending}>{mutation.isPending ? "Guardando..." : product ? "Guardar cambios" : "Crear producto"}</Button>
        </div>
      </form>
    </Modal>
  );
}

// Referencia usada por el datalist de categorías en el formulario.
export function CategoryDatalist() {
  const { data } = useQuery({ queryKey: ["product-categories"], queryFn: productsApi.categories });
  return (
    <datalist id="categories">
      {data?.map((c) => <option key={c} value={c} />)}
    </datalist>
  );
}
