# dbForge AI Assistant — Prompts de la demo

Los prompts principales se mantienen en español porque el video está dirigido a una audiencia hispanohablante.

Las respuestas pueden variar según el modelo seleccionado, la versión del producto y el contexto disponible.

---

## 1. Optimización de la consulta del Query Profiler

Usa como entrada la consulta de:

```text
query-profiler/01_consulta_original.sql
```

Prompt:

```text
Analiza esta consulta PostgreSQL e identifica los principales problemas de rendimiento.

Genera una versión optimizada que devuelva exactamente el mismo resultado, incluyendo:
- ID del cliente
- nombre
- apellido
- cantidad de compras
- total de compras
- únicamente clientes con más de 30,000 en compras

Evita subconsultas correlacionadas innecesarias y explica brevemente los cambios realizados.
```

Después de obtener la propuesta:

1. Revisa el SQL.
2. Ejecútalo.
3. Abre Query Profiler.
4. Compara el nuevo plan con el original.

---

## 2. Lenguaje natural a SQL usando el contexto de la BD

```text
Utilizando el contexto de la base de datos db_supermercado, genera una consulta PostgreSQL que muestre los 10 productos con mayor cantidad de unidades vendidas durante 2026.

Incluye:
- código del producto
- nombre
- marca
- cantidad total de unidades vendidas
- monto total facturado

Ordena el resultado de mayor a menor por unidades vendidas.
```

Consulta de referencia:

```text
ai-assistant/reference_top_products_2026.sql
```

---

## 3. Follow-up sobre la consulta anterior

```text
Ahora modifica la consulta para mostrar solamente productos cuya facturación sea superior a 5,000 y agrega el porcentaje que representa cada producto respecto a la facturación total de 2026.
```

El objetivo de este segundo mensaje es mostrar continuidad de contexto y modificación iterativa de SQL.

---

## 4. Explicar SQL

Ejemplo:

```text
Explica por qué esta consulta necesita GROUP BY y qué función cumple junto con SUM().
```
