import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { catalogsApi } from "@/services/api";
import { Button, Input, Label, Spinner } from "@/components/ui/Primitives";
import { Modal } from "@/components/ui/Modal";

export function CategoriesPage() {
  const queryClient = useQueryClient();
  const [open, setOpen] = useState(false);
  const [cat_nombre, setCatNombre] = useState("");

  const { data: categorias, isLoading } = useQuery({
    queryKey: ["categorias"],
    queryFn: async () => {
      // Usa endpoint existente /products/categorias para categorías, y /catalogos para subcategorias
      const res = await fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/products/categorias`, {
        headers: { Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` },
      });
      if (!res.ok) return [];
      return res.json() as Promise<string[]>;
    },
  });

  const mutation = useMutation({
    mutationFn: async () => {
      const res = await fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/catalogos/subcategorias`, {
        method: "GET",
        headers: { Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` },
      });
      return res.json();
    },
  });

  return (
    <AppLayout title="Categorías" subtitle="Control de categorias.cat_id / cat_nombre (1 tabla principal)">
      <div className="flex justify-end mb-4">
        <Button onClick={() => setOpen(true)}>Nueva categoría</Button>
      </div>
      <div className="bg-surface border border-border rounded shadow-panel p-4">
        {isLoading ? (
          <div className="flex items-center gap-2 py-8 justify-center text-muted">
            <Spinner /> Cargando...
          </div>
        ) : (
          <ul className="divide-y divide-border">
            {categorias?.map((c) => (
              <li key={c} className="py-2.5 text-[13.5px]">
                {c}
              </li>
            ))}
            {(!categorias || categorias.length === 0) && <li className="py-8 text-center text-muted">Sin categorías</li>}
          </ul>
        )}
      </div>
      <Modal open={open} onClose={() => setOpen(false)} title="Nueva categoría">
        <div className="space-y-3">
          <Label>cat_nombre</Label>
          <Input value={cat_nombre} onChange={(e) => setCatNombre(e.target.value)} placeholder="Ej. Panadería" />
          <div className="flex justify-end gap-2">
            <Button variant="secondary" onClick={() => setOpen(false)}>Cancelar</Button>
            <Button onClick={() => setOpen(false)}>Guardar (vía Productos)</Button>
          </div>
          <p className="text-[11px] text-muted">Las categorías se crean automáticamente al crear un producto con nueva categoría (producto_repo.get_or_create_categoria).</p>
        </div>
      </Modal>
    </AppLayout>
  );
}

export function SubcategoriasPage() {
  const [cat_id, setCatId] = useState("");
  const [subcat_nombre, setSubcatNombre] = useState("");

  const { data: subcategorias, isLoading, refetch } = useQuery({
    queryKey: ["subcategorias", cat_id],
    queryFn: () => catalogsApi.subcategorias(cat_id || undefined),
  });

  const queryClient = useQueryClient();
  const mutation = useMutation({
    mutationFn: async () => {
      const res = await fetch(`${import.meta.env.VITE_API_URL ?? "http://localhost:8000/api"}/subcategorias`, {
        method: "POST",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${localStorage.getItem("auth_token") ?? ""}` },
        body: JSON.stringify({ cat_id, subcat_nombre }),
      });
      if (!res.ok) throw new Error("Error");
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["subcategorias"] });
      setSubcatNombre("");
    },
  });

  return (
    <AppLayout title="Subcategorías" subtitle="Control de subcategorias.subcat_id / cat_id (tabla principal, hija de categorias)">
      <div className="flex gap-2 mb-4">
        <Input placeholder="cat_id para filtrar/crear" value={cat_id} onChange={(e) => setCatId(e.target.value)} className="flex-1" />
        <Input placeholder="subcat_nombre" value={subcat_nombre} onChange={(e) => setSubcatNombre(e.target.value)} className="flex-1" />
        <Button onClick={() => mutation.mutate()} disabled={!cat_id || !subcat_nombre || mutation.isPending}>
          {mutation.isPending ? "..." : "Crear"}
        </Button>
      </div>
      <div className="bg-surface border border-border rounded shadow-panel p-4">
        {isLoading ? (
          <div className="flex justify-center py-8 text-muted">
            <Spinner />
          </div>
        ) : (
          <ul className="divide-y divide-border">
            {subcategorias?.map((s: any) => (
              <li key={s.subcat_id} className="py-2.5 text-[13.5px] flex justify-between">
                <span>{s.subcat_nombre}</span>
                <span className="text-muted text-xs">{s.subcat_id.slice(0, 8)}… cat_id {s.cat_id.slice(0, 8)}…</span>
              </li>
            ))}
            {(!subcategorias || subcategorias.length === 0) && <li className="py-8 text-center text-muted">Sin subcategorías para este cat_id</li>}
          </ul>
        )}
      </div>
    </AppLayout>
  );
}
