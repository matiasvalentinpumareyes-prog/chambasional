# ML.md — Pipeline de Machine Learning de Churn

## 1. Objetivo

Estimar la probabilidad de que un cliente deje de comprar, con
explicación en lenguaje simple, sin certezas absolutas, y con un
fallback de reglas transparente cuando no hay datos suficientes.

## 2. Pipeline (sección 47 del brief)

```
Datos de ventas
  → Feature engineering (app/ml/features.py)
  → Construcción del dataset con split temporal (app/ml/churn_model.py)
  → Entrenamiento y comparación de 3 modelos
  → Calibración de probabilidades
  → Evaluación (accuracy, precision, recall, F1, ROC-AUC, PR-AUC)
  → Comparación contra el modelo en producción
  → Se promueve SOLO si es mejor (nunca se reemplaza por uno peor)
  → Registro versionado (model_versions, model_metrics)
```

## 3. Variables (features)

Ver `FEATURE_NAMES` en `app/ml/features.py`: recencia, frecuencia, gasto
total, ticket promedio, intervalo promedio entre compras, desviación del
intervalo, compras en los últimos 30/90/180 días, y tendencia del ticket.
Todas se calculan exclusivamente con información anterior a la fecha de
referencia usada — nunca con datos del período que se predice.

## 4. Modelos comparados

Regresión Logística, Random Forest y HistGradientBoosting, cada uno
envuelto en `CalibratedClassifierCV` (ver sección 6). Se selecciona el
mejor por ROC-AUC y luego F1 — nunca solo por accuracy, porque con
churn las clases están naturalmente desbalanceadas.

## 5. Auditoría: bugs reales encontrados durante el desarrollo

Este pipeline no funcionó correctamente al primer intento. En vez de
ocultarlo, se documenta aquí exactamente qué falló y cómo se corrigió,
porque el brief pide explícitamente no ignorar problemas encontrados.

### Bug 1 — `recency_days` constante en el dataset de entrenamiento

**Síntoma:** el modelo entrenaba pero el feature más importante
(recencia) tenía el mismo valor (0) en absolutamente todas las filas.

**Causa:** la función que construía el dataset calculaba las features
usando como "fecha de referencia" la fecha exacta de la última compra
incluida en el corte de entrenamiento. Por construcción matemática, la
recencia respecto a esa misma fecha siempre da 0.

**Corrección:** se introdujo un punto de observación simulado, posterior
a la última compra conocida (una fracción aleatoria de su intervalo
habitual, pero siempre antes de la compra real siguiente para no filtrar
información del futuro). Esto refleja mejor cómo se usa el modelo en
producción, donde siempre ha pasado algún tiempo desde la última compra
al momento de predecir. Ver `tests/unit/test_churn_features.py::test_features_recency_is_not_always_zero_in_training_set`,
que es un test de regresión específico para este bug.

### Bug 2 — Probabilidades descalibradas (`class_weight="balanced"`)

**Síntoma:** tras corregir el Bug 1, el modelo mostraba señal real
(ROC-AUC ~0.81), pero el 25% de los clientes recibía una probabilidad de
churn de prácticamente 1.0, y más de la mitad del negocio quedaba
clasificado como "riesgo crítico".

**Causa:** `class_weight="balanced"` ayuda a los modelos lineales a
separar mejor la clase minoritaria, pero como efecto secundario satura
las probabilidades de salida hacia los extremos — dejan de reflejar la
frecuencia real del evento.

**Corrección:** se envolvió cada modelo candidato en
`CalibratedClassifierCV` (calibración sigmoide con validación cruzada
estratificada), que reescala las probabilidades para que coincidan con
la tasa real de churn observada. Verificado manualmente: la probabilidad
promedio predicha (1.6%) quedó prácticamente igual a la tasa real de
positivos en el dataset (1.4%).

### Bug 3 — Score de riesgo 0-100 inútil para un evento poco frecuente

**Síntoma:** incluso con probabilidades bien calibradas, un evento
naturalmente poco frecuente (típicamente <10% de los clientes) casi
nunca supera umbrales absolutos como 60 u 80 en una escala 0-100 — lo que
haría inútiles los niveles "alto"/"crítico" que el negocio necesita para
priorizar a quién contactar.

**Decisión de diseño (no es un bug de código, sino de producto):** se
separan dos conceptos que antes se mezclaban:
- `churn_probability`: la probabilidad calibrada real, usada para
  explicarle al usuario "este cliente tiene X% de probabilidad".
- `churn_score`: un **percentil relativo** de esa probabilidad dentro de
  la base de clientes actual del negocio, usado para los niveles
  bajo/medio/alto/crítico y para ordenar la prioridad de contacto.

Esto es coherente con la pregunta central del sistema (sección 102 del
brief): "¿a quién debería contactar primero?" es una pregunta relativa
entre los propios clientes del negocio, no un umbral estadístico
absoluto. Implementado en `_percentile_score()` en `app/services/churn.py`.

### Bug 4 — Fórmula de riesgo penalizaba a clientes recién comprados

**Síntoma:** un cliente que acababa de comprar (0 días de recencia) podía
recibir "riesgo medio" solo por tener pocas compras históricas o bajo
gasto acumulado.

**Causa:** los términos de la fórmula de fallback por baja frecuencia y
bajo gasto se sumaban sin condicionarlos a que ya hubiera pasado tiempo
relevante desde la última compra.

**Corrección:** esos términos ahora se multiplican por un
`recency_factor` (0 si acaba de comprar, hasta 1 si ya superó su ciclo
habitual), tanto en el backend (`_rule_based_probability`) como en el
frontend (`analyticsEngine.ts`, que tenía el mismo bug).

## 6. Umbrales configurables

Los cortes de riesgo (medio=30, alto=60, crítico=80 por defecto) viven en
`Business.churn_threshold_*` y son configurables por negocio desde
`PUT /api/settings` — nunca hardcodeados.

## 7. Fallback sin datos suficientes

Si un negocio tiene menos de `MIN_TRAINING_EXAMPLES = 60` ejemplos de
entrenamiento válidos, no se entrena ningún modelo: se registra un
`ModelVersion` de tipo `rules-v1-fallback` y las predicciones usan la
fórmula de reglas transparente en su lugar (sección 46 del brief).

## 8. Limitaciones conocidas (honestas, no ocultas)

- El dataset sintético de demostración genera muy pocos ejemplos
  positivos de "churn confirmado" (~30 de 2150), lo que hace que
  precision/recall en el set de prueba sean inestables entre
  reentrenamientos. El ROC-AUC (que no depende de un umbral fijo) es la
  métrica más confiable con este volumen de datos y se prioriza en la
  selección de modelo.
- No se implementó SHAP (sección 16 permite explícitamente diferirlo);
  la explicabilidad actual es "basada en features" (frases generadas a
  partir de las variables más influyentes), tal como el brief sugiere
  como paso previo.
- No se implementó detección automática de drift (sección 49); la
  arquitectura de versionado (`ModelVersion`, `dataset_version`) permite
  agregarlo después sin cambios estructurales.
