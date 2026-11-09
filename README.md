# dbForge 2026.2 + PostgreSQL — Demo práctica

Repositorio complementario del video en español **“PostgreSQL + IA: Debugging y Optimización con dbForge Edge 2026.2”**, preparado por **Segundo Morales Rubio** en colaboración con **Devart**.

[English version](README_EN.md)

## 🎯 Objetivo

Reproducir las demostraciones utilizadas en el video con una base de datos de supermercado en PostgreSQL:

1. **PostgreSQL Debugger** — detectar un error lógico en una función PL/pgSQL.
2. **Query Profiler** — analizar una consulta ineficiente con subconsultas correlacionadas.
3. **dbForge AI Assistant** — optimizar SQL y generar consultas desde lenguaje natural.
4. **Comparación de planes** — validar la mejora comparando planes de ejecución.
5. **Visual Function Editor** — revisar visualmente la función utilizada en la demo.

## 🧰 Requisitos

- PostgreSQL
- dbForge Studio for PostgreSQL 2026.2 o dbForge Edge 2026.2
- Acceso a dbForge AI Assistant para las demos de IA
- Base original `db_supermercado_PostgreSQL`

## 🗄️ Base de datos original

Esta demo utiliza como base el proyecto público:

**Andrés Weitzel — db_supermercado_PostgreSQL**  
https://github.com/andresWeitzel/db_supermercado_PostgreSQL

El proyecto original se distribuye bajo **GNU General Public License v3.0 (GPL-3.0)**.

Para evitar duplicar el proyecto original, este repositorio incluye solamente el **dataset ampliado** y los scripts creados específicamente para las demostraciones de dbForge 2026.2.

## 🚀 Instalación

### 1. Crear la base

Crea una base PostgreSQL llamada:

```text
db_supermercado
```

### 2. Ejecutar los scripts originales

Desde el repositorio original, ejecuta en este orden:

```text
01_db_supermercado_DDL.sql
02_db_supermercado_DML_INSERTS.sql
```

### 3. Ampliar el dataset

Ejecuta:

```text
database/03_db_supermercado_DML_DATASET_DEMO.sql
```

El script es re-ejecutable y deja un volumen aproximado de:

| Objeto | Registros aprox. |
|---|---:|
| proveedores | 20 |
| productos | 200 |
| empleados | 30 |
| clientes | 1,000 |
| facturas | 10,000 |
| facturas_detalles | 10,000 |
| ventas | 10,000 |
| ventas_productos | 40,000 |
| compras_clientes | 10,000 |

Los registros adicionales son sintéticos y fueron creados únicamente para demostraciones y capacitación.

## 🐞 Demo 1 — PostgreSQL Debugger

Ejecuta:

```text
debugger/01_calcular_total_cliente_bug.sql
```

Regla de negocio:

- compras menores a 90,000 → **5% de descuento**
- compras de 90,000 o más → **10% de descuento**

La función contiene intencionalmente un error lógico: aplica **20%** en el segundo caso.

Luego usa:

```text
debugger/02_validar_descuento.sql
```

Con dbForge PostgreSQL Debugger:

- agrega un breakpoint;
- observa `p_id_cliente`, `v_total` y `v_descuento`;
- avanza paso a paso;
- identifica el porcentaje incorrecto;
- corrige la función;
- valida nuevamente el resultado.

La versión corregida está en:

```text
debugger/03_calcular_total_cliente_fix.sql
```

## 📊 Demo 2 — Query Profiler

Perfila primero:

```text
query-profiler/01_consulta_original.sql
```

La consulta está diseñada intencionalmente con varias subconsultas correlacionadas.

Después de utilizar AI Assistant para proponer una optimización, puedes comparar el resultado con:

```text
query-profiler/02_consulta_optimizada_referencia.sql
```

En el entorno utilizado para preparar el video, el costo estimado observado fue aproximadamente:

```text
Consulta original:    ~506K
Consulta optimizada:  ~1.2K
```

> Los tiempos y costos pueden variar según la versión de PostgreSQL, estadísticas, hardware, caché, configuración y estado exacto del dataset. El objetivo de la demo es comparar las estrategias del plan y el trabajo repetido.

## 🤖 Demo 3 — dbForge AI Assistant

Los prompts utilizados están disponibles en:

```text
ai-assistant/prompts.md
```

También se incluye una consulta de referencia reproducible:

```text
ai-assistant/reference_top_products_2026.sql
```

Las respuestas generadas por IA pueden variar según el modelo seleccionado y el contexto proporcionado.

## 🧭 Flujo recomendado

```text
Preparar base de datos
        ↓
PostgreSQL Debugger
        ↓
Query Profiler — consulta original
        ↓
AI Assistant — optimización
        ↓
Query Profiler — consulta optimizada
        ↓
Comparar ambos planes
        ↓
AI Assistant — lenguaje natural a SQL
        ↓
Visual Function Editor
```

Consulta `docs/demo-guide.md` para una guía breve de reproducción.

## 📁 Estructura

```text
dbforge-postgresql-2026-2-demo/
├── README.md
├── README_EN.md
├── LICENSE
├── THIRD_PARTY_NOTICE.md
├── database/
│   └── 03_db_supermercado_DML_DATASET_DEMO.sql
├── debugger/
│   ├── 01_calcular_total_cliente_bug.sql
│   ├── 02_validar_descuento.sql
│   └── 03_calcular_total_cliente_fix.sql
├── query-profiler/
│   ├── 01_consulta_original.sql
│   └── 02_consulta_optimizada_referencia.sql
├── ai-assistant/
│   ├── prompts.md
│   └── reference_top_products_2026.sql
└── docs/
    └── demo-guide.md
```

## ⚠️ Notas

- El error de la función del Demo 1 es **intencional**.
- La consulta original del Demo 2 es **intencionalmente ineficiente**.
- El dataset ampliado es para demostraciones, no para producción.
- No se incluyen datos reales de clientes.

## 👤 Autor de las demos

**Segundo Morales Rubio**  
Microsoft MVP | Data, Power Platform & AI

Video preparado en colaboración con Devart.

## 📄 Licencia y atribución

Este repositorio se publica bajo **GPL-3.0**, manteniendo compatibilidad con el proyecto base utilizado para la demostración.

Consulta `LICENSE` y `THIRD_PARTY_NOTICE.md`.
