import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { Plus, Search } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { productsApi } from "@/services/api";
import { catalogsApi } from "@/services/api";
import { Badge, Button, EmptyState, FieldError, Input, Label, Select, Spinner } from "@/components/ui/Primitives";
import { Modal } from "@/components/ui/Modal";
import { formatMoney } from "@/lib/format";
import type { Product } from "@/types";

const PAGE_SIZE = 15;

const schema = z.object({
  prd_sku: z.string().min(1, "SKU obligatorio.").max(100),
  prd_nombre: z.string().min(1, "Nombre obligatorio.").max(150),
  prd_descripcion: z.string().max(500).optional().or(z.literal("")),
  prd_codbarra: z.string().max(100).optional().or(z.literal("")),
  cat_nombre: z.string().min(1, "Categoría obligatoria.").max(100),
  subcat_nombre: z.string().max(100).optional().or(z.literal("")),
  prd_marca_nombre: z.string().max(100).optional().or(z.literal("")),
  prd_precios: z.coerce.number().min(0.01, "Precio debe ser mayor a 0."),
  prd_precios_costo: z.coerce.number().min(0).optional(),
  stk_cantidad: z.coerce.number().min(0).optional(),
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
    <AppLayout title="Productos" subtitle="Catálogo de productos">
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
        {!isLoading && data?.items.length === 0 && <EmptyState title="No se encontraron productos" description="Ajusta la búsqueda o crea uno nuevo." />}
        {!isLoading && data && data.items.length > 0 && (
          <>
            <table className="w-full text-[13.5px]">
              <thead>
                <tr className="border-b border-border text-left text-[11.5px] uppercase tracking-wide text-muted">
                  <th className="px-4 py-2.5 font-medium">SKU</th>
                  <th className="px-4 py-2.5 font-medium">Nombre</th>
                  <th className="px-4 py-2.5 font-medium">Marca</th>
                  <th className="px-4 py-2.5 font-medium">Categoría</th>
                  <th className="px-4 py-2.5 font-medium text-right">Precio</th>
                  <th className="px-4 py-2.5 font-medium text-right">Stock</th>
                  <th className="px-4 py-2.5 font-medium">Estado</th>
                  <th className="px-4 py-2.5 font-medium"></th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {data.items.map((p) => (
                  <tr key={p.id} className="hover:bg-ink/[0.02]">
                    <td className="px-4 py-2.5 font-mono text-[12.5px] text-muted">{p.sku}</td>
                    <td className="px-4 py-2.5 font-medium">{p.name}<div className="text-[11px] text-muted font-mono">{p.prd_codbarra ?? ""}</div></td>
                    <td className="px-4 py-2.5 text-muted">{(p as any).marca_nombre ?? "—"}</td>
                    <td className="px-4 py-2.5 text-muted">{p.category} {(p as any).subcategoria_nombre ? `/ ${(p as any).subcategoria_nombre}` : ""}</td>
                    <td className="px-4 py-2.5 text-right">{formatMoney(p.price)}</td>
                    <td className="px-4 py-2.5 text-right text-muted">{p.stock != null ? p.stock : "—"}</td>
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
  const { data: categorias } = useQuery({ queryKey: ["categorias"], queryFn: catalogsApi.segmentos, enabled: false }); // fallback, use productsApi.categories actually
  const { data: catList } = useQuery({ queryKey: ["product-categorias"], queryFn: productsApi.categories, enabled: open });
  const { data: subcatsRaw } = useQuery({ queryKey: ["subcategorias-all"], queryFn: () => catalogsApi.subcategorias(), enabled: open });

  const {
    register,
    handleSubmit,
    reset,
    watch,
    setValue,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    values: product
      ? {
          prd_sku: (product as any).prd_sku ?? product.sku ?? "",
          prd_nombre: (product as any).prd_nombre ?? product.name ?? "",
          prd_descripcion: (product as any).prd_descripcion ?? product.description ?? "",
          prd_codbarra: (product as any).prd_codbarra ?? "",
          cat_nombre: (product as any).categoria_nombre ?? product.category ?? "",
          subcat_nombre: (product as any).subcategoria_nombre ?? "",
          prd_marca_nombre: (product as any).marca_nombre ?? "",
          prd_precios: (product as any).prd_precios ?? product.price ?? 0,
          prd_precios_costo: (product as any).prd_precios_costo ?? product.cost ?? undefined,
          stk_cantidad: (product as any).stk_cantidad ?? product.stock ?? undefined,
        }
      : { prd_sku: "", prd_nombre: "", prd_descripcion: "", prd_codbarra: "", cat_nombre: "", subcat_nombre: "", prd_marca_nombre: "", prd_precios: 0, prd_precios_costo: undefined, stk_cantidad: undefined },
  });

  const selectedCat = watch("cat_nombre");

  const mutation = useMutation({
    mutationFn: async (values: FormValues) => {
      const payload: any = {
        prd_sku: values.prd_sku.trim(),
        prd_nombre: values.prd_nombre.trim(),
        prd_descripcion: values.prd_descripcion?.trim() || null,
        prd_codbarra: values.prd_codbarra?.trim() || null,
        cat_nombre: values.cat_nombre.trim(),
        subcat_nombre: values.subcat_nombre?.trim() || null,
        prd_marca_nombre: values.prd_marca_nombre?.trim() || null,
        prd_precios: Number(values.prd_precios),
        prd_precios_costo: values.prd_precios_costo != null ? Number(values.prd_precios_costo) : null,
        stk_cantidad: values.stk_cantidad != null ? Number(values.stk_cantidad) : null,
      };
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
            <Label>SKU *</Label>
            <Input {...register("prd_sku")} placeholder="SKU-001" />
            <FieldError>{errors.prd_sku?.message}</FieldError>
          </div>
          <div>
            <Label>Cód. barras</Label>
            <Input {...register("prd_codbarra")} placeholder="750123..." />
            <FieldError>{errors.prd_codbarra?.message}</FieldError>
          </div>
        </div>
        <div>
          <Label>Nombre *</Label>
          <Input {...register("prd_nombre")} placeholder="Ej. Café Premium 250g" />
          <FieldError>{errors.prd_nombre?.message}</FieldError>
        </div>
        <div>
          <Label>Descripción</Label>
          <Input {...register("prd_descripcion")} placeholder="opcional" />
        </div>
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Categoría *</Label>
            <Input {...register("cat_nombre")} list="cat-list" placeholder="Elige o crea" />
            <datalist id="cat-list">
              {catList?.map((c: string) => <option key={c} value={c} />)}
            </datalist>
            <FieldError>{errors.cat_nombre?.message}</FieldError>
          </div>
          <div>
            <Label>Subcategoría</Label>
            <Input {...register("subcat_nombre")} list="subcat-list" placeholder="opcional" />
            <datalist id="subcat-list">
              {subcatsRaw?.map((s: any) => <option key={s.subcat_id ?? s} value={s.subcat_nombre ?? s} />)}
            </datalist>
            <FieldError>{errors.subcat_nombre?.message}</FieldError>
          </div>
        </div>
        <div>
          <Label>Marca</Label>
          <Input {...register("prd_marca_nombre")} placeholder="opcional — se crea si no existe" />
          <FieldError>{errors.prd_marca_nombre?.message}</FieldError>
        </div>
        <div className="grid grid-cols-3 gap-3">
          <div>
            <Label>Precio venta *</Label>
            <Input type="number" step="0.01" {...register("prd_precios")} />
            <FieldError>{errors.prd_precios?.message}</FieldError>
          </div>
          <div>
            <Label>Costo</Label>
            <Input type="number" step="0.01" {...register("prd_precios_costo")} placeholder="opcional" />
          </div>
          <div>
            <Label>Stock inicial</Label>
            <Input type="number" {...register("stk_cantidad")} placeholder="0" />
          </div>
        </div>
        {mutation.isError && <p className="text-[13px] text-risk-critical">{(mutation.error as any)?.message ?? "No se pudo guardar el producto. Verifica SKU único."} </p>}
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="secondary" onClick={onClose}>Cancelar</Button>
          <Button type="submit" disabled={mutation.isPending}>{mutation.isPending ? "Guardando..." : product ? "Guardar cambios" : "Crear producto"}</Button>
        </div>
      </form>
    </Modal>
  );
}

export function CategoryDatalist() {
  const { data } = useQuery({ queryKey: ["product-categories"], queryFn: productsApi.categories });
  return (
    <datalist id="categories">
      {data?.map((c) => <option key={c} value={c} />)}
    </datalist>
  );
}
