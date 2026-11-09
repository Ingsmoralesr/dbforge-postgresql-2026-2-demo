# Guía rápida para reproducir las demos

## Antes de grabar

1. Crear `db_supermercado`.
2. Ejecutar los scripts `01` y `02` del repositorio original.
3. Ejecutar `database/03_db_supermercado_DML_DATASET_DEMO.sql`.
4. Verificar que las tablas tengan el volumen esperado.
5. Ejecutar `ANALYZE` si fuera necesario (el script de dataset ya lo incluye al final).

## Demo 1 — Debugger

1. Ejecutar `debugger/01_calcular_total_cliente_bug.sql`.
2. Ejecutar `debugger/02_validar_descuento.sql`.
3. Mostrar que la función ejecuta sin error pero devuelve un resultado diferente a la regla.
4. Abrir la función en dbForge.
5. Breakpoint en el `IF`.
6. Watches:
   - `p_id_cliente`
   - `v_total`
   - `v_descuento`
7. Avanzar paso a paso.
8. Identificar `0.20`.
9. Corregir a `0.10`.
10. Repetir la validación y mostrar `OK`.

## Demo 2 — Query Profiler

1. Abrir `query-profiler/01_consulta_original.sql`.
2. Ejecutar con Query Profiler.
3. Mostrar costo estimado y operaciones repetidas.
4. Mantener guardado el resultado de profiling.

## Demo 3 — AI Assistant + optimización

1. Enviar la consulta original a AI Assistant.
2. Usar el prompt de optimización en `ai-assistant/prompts.md`.
3. Revisar la consulta generada.
4. Ejecutarla con Query Profiler.
5. Seleccionar ambos resultados para comparar los planes.
6. Mostrar el cambio de estrategia y de costo estimado.

## Demo 4 — Lenguaje natural a SQL

1. Dar contexto de `db_supermercado` al AI Assistant.
2. Enviar el prompt “Top 10 productos…” de `ai-assistant/prompts.md`.
3. Revisar y ejecutar el SQL generado.
4. Hacer el follow-up para demostrar continuidad de contexto.

## Cierre — Visual Function Editor

Abrir `calcular_total_cliente` y mostrar brevemente:
- parámetro;
- tipo de retorno;
- lenguaje;
- código;
- propiedades visuales.

Mencionar que 2026.2 incorpora también editores visuales para procedimientos y event triggers.
