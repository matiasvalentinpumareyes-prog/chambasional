import { useQuery } from "@tanstack/react-query";
import { AppLayout } from "@/components/layout/AppLayout";
import { modelsApi } from "@/services/api";
import { Badge, Panel, Spinner } from "@/components/ui/Primitives";
import { formatDate } from "@/lib/format";
import type { ModelStatus } from "@/types";

const STATUS_LABEL: Record<ModelStatus, string> = {
  training: "Entrenando",
  candidate: "Candidato",
  production: "En producción",
  deprecated: "Desactualizado",
  failed: "Fallido",
};

const STATUS_TONE: Record<ModelStatus, "neutral" | "brand" | "success" | "urgent" | "critical"> = {
  training: "urgent",
  candidate: "neutral",
  production: "success",
  deprecated: "neutral",
  failed: "critical",
};

export function ModelsPage() {
  const { data, isLoading } = useQuery({ queryKey: ["models"], queryFn: modelsApi.list });

  return (
    <AppLayout title="Modelos" subtitle="Versionado y métricas del pipeline de Machine Learning">
      {isLoading && (
        <div className="flex items-center gap-2 text-muted py-16 justify-center">
          <Spinner /> Cargando modelos...
        </div>
      )}

      {!isLoading && (
        <Panel className="mb-4">
          <p className="text-[13.5px] text-ink/85">
            El sistema actualmente calcula el riesgo de abandono, la próxima compra y las recomendaciones mediante un{" "}
            <span className="font-medium">motor de reglas transparente</span> (versión <span className="font-mono">rules-v1-fallback</span>),
            construido directamente sobre el historial real de ventas de cada cliente. Este es el comportamiento esperado en la fase
            actual del proyecto (sección 76 del brief: sistema de fallback). Cuando el pipeline de Machine Learning entrenado
            (Regresión Logística, Random Forest, Gradient Boosting) esté disponible en el backend, aparecerá aquí como un nuevo
            modelo candidato, y solo reemplazará al de producción si sus métricas son mejores.
          </p>
        </Panel>
      )}

      <div className="space-y-3">
        {data?.map((model) => (
          <Panel key={model.id}>
            <div className="flex items-start justify-between mb-3">
              <div>
                <p className="font-display font-semibold text-[15px]">{model.modelName}</p>
                <p className="text-[12.5px] text-muted">
                  Versión {model.version} · dataset {model.datasetVersion} · entrenado el {formatDate(model.trainingDate)}
                </p>
              </div>
              <Badge tone={STATUS_TONE[model.status]}>{STATUS_LABEL[model.status]}</Badge>
            </div>
            <div className="grid grid-cols-3 sm:grid-cols-6 gap-2 text-center mb-3">
              <MiniMetric label="Accuracy" value={model.metrics.accuracy || "—"} />
              <MiniMetric label="Precision" value={model.metrics.precision || "—"} />
              <MiniMetric label="Recall" value={model.metrics.recall || "—"} />
              <MiniMetric label="F1" value={model.metrics.f1 || "—"} />
              <MiniMetric label="ROC-AUC" value={model.metrics.rocAuc || "—"} />
              <MiniMetric label="PR-AUC" value={model.metrics.prAuc || "—"} />
            </div>
            <p className="text-[12px] text-muted">Features: {model.features.join(", ")}</p>
          </Panel>
        ))}
      </div>
    </AppLayout>
  );
}

function MiniMetric({ label, value }: { label: string; value: string | number }) {
  return (
    <div className="bg-bg border border-border rounded py-1.5">
      <p className="font-display font-semibold text-[13px]">{value}</p>
      <p className="text-[10.5px] text-muted">{label}</p>
    </div>
  );
}
