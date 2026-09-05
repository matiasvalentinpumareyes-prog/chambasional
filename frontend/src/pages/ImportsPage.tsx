import { useState } from "react";
import Papa from "papaparse";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { AlertTriangle, CheckCircle2, Download, UploadCloud } from "lucide-react";
import { AppLayout } from "@/components/layout/AppLayout";
import { importsApi } from "@/services/api";
import { Badge, Button, Panel, Select, Spinner } from "@/components/ui/Primitives";
import { formatDate } from "@/lib/format";
import type { ImportSummary } from "@/types";

const TEMPLATE_COLUMNS: Record<ImportSummary["type"], string[]> = {
  customers: ["firstName", "lastName", "email", "phone", "city"],
  products: ["sku", "name", "category", "price", "cost"],
  sales: ["customerEmail", "productSku", "quantity", "date"],
};

export function ImportsPage() {
  const [type, setType] = useState<ImportSummary["type"]>("customers");
  const [rows, setRows] = useState<Record<string, string>[] | null>(null);
  const [fileName, setFileName] = useState("");
  const [preview, setPreview] = useState<ImportSummary | null>(null);
  const queryClient = useQueryClient();

  const historyQuery = useQuery({ queryKey: ["imports-history"], queryFn: importsApi.history });

  const previewMutation = useMutation({
    mutationFn: () => importsApi.preview(type, fileName, rows ?? []),
    onSuccess: (summary) => setPreview(summary),
  });

  const confirmMutation = useMutation({
    mutationFn: () => importsApi.confirm(preview!),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["imports-history"] });
      setPreview(null);
      setRows(null);
      setFileName("");
    },
  });

  function handleFile(file: File) {
    setFileName(file.name);
    setPreview(null);
    Papa.parse<Record<string, string>>(file, {
      header: true,
      skipEmptyLines: true,
      complete: (results) => setRows(results.data),
    });
  }

  function downloadTemplate() {
    const headers = TEMPLATE_COLUMNS[type];
    const blob = new Blob([headers.join(",") + "\n"], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `plantilla_${type}.csv`;
    a.click();
    URL.revokeObjectURL(url);
  }

  function downloadErrorReport() {
    if (!preview) return;
    const rowsOut = preview.errors.map((e) => ({ fila: e.row, campo: e.field ?? "", error: e.message }));
    const headers = ["fila", "campo", "error"];
    const csv = [headers.join(","), ...rowsOut.map((r) => headers.map((h) => `"${String((r as any)[h])}"`).join(","))].join("\n");
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "errores_importacion.csv";
    a.click();
    URL.revokeObjectURL(url);
  }

  return (
    <AppLayout title="Importaciones" subtitle="Sube archivos CSV, revisa la validación y confirma antes de cargar los datos">
      <Panel className="mb-4">
        <div className="flex flex-col sm:flex-row items-start sm:items-center gap-3">
          <Select value={type} onChange={(e) => { setType(e.target.value as ImportSummary["type"]); setRows(null); setPreview(null); }}>
            <option value="customers">Clientes</option>
            <option value="products">Productos</option>
            <option value="sales">Ventas</option>
          </Select>
          <Button variant="secondary" size="sm" onClick={downloadTemplate}>
            <Download size={14} /> Descargar plantilla CSV
          </Button>
          <label className="inline-flex items-center gap-2 text-[13.5px] font-medium text-brand-dark cursor-pointer hover:underline">
            <UploadCloud size={16} />
            Seleccionar archivo CSV
            <input type="file" accept=".csv" className="hidden" onChange={(e) => e.target.files?.[0] && handleFile(e.target.files[0])} />
          </label>
          {fileName && <span className="text-[13px] text-muted">{fileName} ({rows?.length ?? 0} filas)</span>}
        </div>
        {rows && !preview && (
          <div className="mt-3">
            <Button onClick={() => previewMutation.mutate()} disabled={previewMutation.isPending}>
              {previewMutation.isPending ? "Validando..." : "Validar y ver vista previa"}
            </Button>
          </div>
        )}
      </Panel>

      {previewMutation.isPending && (
        <div className="flex items-center gap-2 text-muted py-8 justify-center">
          <Spinner /> Validando archivo...
        </div>
      )}

      {preview && (
        <Panel title="Vista previa de la importación" className="mb-4">
          <div className="grid grid-cols-3 gap-3 mb-4 text-center">
            <MiniStat label="Filas totales" value={String(preview.totalRows)} />
            <MiniStat label="Aceptadas" value={String(preview.acceptedRows)} tone="success" />
            <MiniStat label="Rechazadas" value={String(preview.rejectedRows)} tone="critical" />
          </div>

          {preview.errors.length > 0 && (
            <div className="mb-4">
              <div className="flex items-center justify-between mb-2">
                <p className="text-[13px] font-medium flex items-center gap-1.5 text-risk-critical">
                  <AlertTriangle size={14} /> {preview.errors.length} errores encontrados
                </p>
                <Button variant="secondary" size="sm" onClick={downloadErrorReport}>
                  <Download size={13} /> Descargar reporte
                </Button>
              </div>
              <div className="max-h-48 overflow-y-auto border border-border rounded divide-y divide-border">
                {preview.errors.slice(0, 50).map((e, i) => (
                  <div key={i} className="px-3 py-1.5 text-[12.5px] flex gap-3">
                    <span className="text-muted w-14 shrink-0">Fila {e.row}</span>
                    <span>{e.message}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {preview.warnings.length > 0 && (
            <div className="mb-4">
              <p className="text-[13px] font-medium text-urgent-dark mb-2">{preview.warnings.length} advertencias</p>
              <div className="max-h-32 overflow-y-auto border border-border rounded divide-y divide-border">
                {preview.warnings.slice(0, 30).map((w, i) => (
                  <div key={i} className="px-3 py-1.5 text-[12.5px] flex gap-3">
                    <span className="text-muted w-14 shrink-0">Fila {w.row}</span>
                    <span>{w.message}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          <div className="flex justify-end gap-2 pt-2 border-t border-border">
            <Button variant="secondary" onClick={() => { setPreview(null); setRows(null); setFileName(""); }}>Cancelar</Button>
            <Button onClick={() => confirmMutation.mutate()} disabled={confirmMutation.isPending || preview.acceptedRows === 0}>
              {confirmMutation.isPending ? "Confirmando..." : `Confirmar importación (${preview.acceptedRows} filas)`}
            </Button>
          </div>
        </Panel>
      )}

      <Panel title="Historial de importaciones">
        {historyQuery.data?.length === 0 && <p className="text-[13.5px] text-muted">Aún no se ha confirmado ninguna importación.</p>}
        <div className="divide-y divide-border">
          {historyQuery.data?.map((imp) => (
            <div key={imp.id} className="py-2.5 flex items-center justify-between text-[13px]">
              <div className="flex items-center gap-2">
                <CheckCircle2 size={14} className="text-success" />
                <span className="font-medium">{imp.fileName}</span>
                <Badge tone="neutral">{imp.type === "customers" ? "Clientes" : imp.type === "products" ? "Productos" : "Ventas"}</Badge>
              </div>
              <span className="text-muted">{imp.acceptedRows}/{imp.totalRows} filas · {formatDate(imp.createdAt)}</span>
            </div>
          ))}
        </div>
      </Panel>
    </AppLayout>
  );
}

function MiniStat({ label, value, tone }: { label: string; value: string; tone?: "success" | "critical" }) {
  const color = tone === "success" ? "text-success" : tone === "critical" ? "text-risk-critical" : "text-ink";
  return (
    <div className="bg-bg border border-border rounded py-2.5">
      <p className={`font-display text-[20px] font-semibold ${color}`}>{value}</p>
      <p className="text-[11px] text-muted">{label}</p>
    </div>
  );
}
