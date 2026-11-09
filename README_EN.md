# dbForge 2026.2 + PostgreSQL — Practical Demo

Companion repository for the Spanish-language video **“PostgreSQL + IA: Debugging y Optimización con dbForge Edge 2026.2”**, prepared by **Segundo Morales Rubio** in collaboration with **Devart**.

[Versión en español](README.md)

## 🎯 Objective

Reproduce the practical demonstrations used in the video with a PostgreSQL supermarket database:

1. **PostgreSQL Debugger** — trace a logical bug in a PL/pgSQL function.
2. **Query Profiler** — analyze an inefficient query with repeated correlated subqueries.
3. **dbForge AI Assistant** — optimize SQL and generate PostgreSQL queries from natural language.
4. **Plan comparison** — validate the optimization by comparing execution plans.
5. **Visual Function Editor** — review the function used in the debugging scenario.

## 🧰 Requirements

- PostgreSQL
- dbForge Studio for PostgreSQL 2026.2 or dbForge Edge 2026.2
- Access to dbForge AI Assistant for the AI demos
- The original `db_supermercado_PostgreSQL` database

## 🗄️ Original database

This demo is based on the public project:

**Andrés Weitzel — db_supermercado_PostgreSQL**  
https://github.com/andresWeitzel/db_supermercado_PostgreSQL

The original project is distributed under the **GNU General Public License v3.0 (GPL-3.0)**.

To avoid duplicating the original project, this repository contains only the **expanded demo dataset** and scripts created specifically for the dbForge 2026.2 demonstrations.

## 🚀 Setup

### 1. Create the database

Create a PostgreSQL database named:

```text
db_supermercado
```

### 2. Execute the original scripts

From the original repository, execute:

```text
01_db_supermercado_DDL.sql
02_db_supermercado_DML_INSERTS.sql
```

### 3. Expand the dataset

Run:

```text
database/03_db_supermercado_DML_DATASET_DEMO.sql
```

The resulting dataset contains approximately 20 suppliers, 200 products, 30 employees, 1,000 customers, 10,000 invoices, 10,000 sales, 40,000 product-sale rows, and 10,000 customer-purchase relationships.

All additional records are synthetic and intended only for demonstrations and training.

## 🐞 Demo 1 — PostgreSQL Debugger

Run:

```text
debugger/01_calcular_total_cliente_bug.sql
debugger/02_validar_descuento.sql
```

Business rule:

- purchases below 90,000 → **5% discount**
- purchases of 90,000 or more → **10% discount**

The first function intentionally applies **20%** in the second case. Use the debugger to inspect `p_id_cliente`, `v_total`, and `v_descuento`, identify the logical bug, and validate the correction.

The fixed version is available at:

```text
debugger/03_calcular_total_cliente_fix.sql
```

## 📊 Demo 2 — Query Profiler

Profile:

```text
query-profiler/01_consulta_original.sql
```

Then use AI Assistant to propose an optimized version and compare the result with:

```text
query-profiler/02_consulta_optimizada_referencia.sql
```

During video preparation, the observed estimated cost changed approximately from:

```text
Original query:   ~506K
Optimized query:  ~1.2K
```

> Execution time and estimated plan cost may vary depending on PostgreSQL version, statistics, hardware, cache, configuration, and the exact dataset state.

## 🤖 Demo 3 — dbForge AI Assistant

Prompts are available at:

```text
ai-assistant/prompts.md
```

A reproducible reference query is included at:

```text
ai-assistant/reference_top_products_2026.sql
```

AI-generated SQL may vary depending on the selected model and supplied context.

## 📄 License and attribution

This repository is distributed under **GPL-3.0** to remain compatible with the project used as the foundation for the demo.

See `LICENSE` and `THIRD_PARTY_NOTICE.md`.
