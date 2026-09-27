# 🚀 GraphQL con PostgreSQL — Sistema Empresarial

## ¿Qué es GraphQL?

GraphQL es un lenguaje de consulta para APIs creado por Meta. A diferencia de REST, donde cada endpoint devuelve datos fijos, GraphQL permite al cliente pedir **exactamente los datos que necesita**, ni más ni menos. Esto lo hace ideal para aplicaciones modernas donde múltiples clientes (web, móvil, dashboard) necesitan datos distintos del mismo servidor.

### GraphQL vs REST

| Característica | REST | GraphQL |
|---|---|---|
| Endpoints | Uno por recurso (`/clientes`, `/productos`) | Un solo endpoint (`/graphql`) |
| Datos devueltos | Fijos por endpoint | El cliente elige qué campos quiere |
| Over-fetching | Común (te da más datos de los que necesitas) | Eliminado |
| Under-fetching | Común (necesitas múltiples llamadas) | Un solo request |
| Tipado | No nativo | Esquema fuertemente tipado |

---

## ¿Qué es PostGraphile?

**PostGraphile** es una herramienta que lee tu base de datos PostgreSQL y **genera automáticamente un esquema GraphQL completo** con queries, mutations, filtros y paginación. No necesitas escribir resolvers manualmente.

---

## Estructura del proyecto

```
graphql-postgres/
│
├── src/
│   ├── server.js          → Servidor Express + PostGraphile
│   └── setupDatabase.js   → Script para crear tablas e insertar datos
│
├── sql/
│   ├── 01_schema.sql      → Definición de tablas (DDL)
│   └── 02_datos_ejemplo.sql → Datos de prueba (DML)
│
├── examples/
│   ├── 01_queries.graphql         → Ejemplos de consultas (GET)
│   ├── 02_mutations.graphql       → Ejemplos de CRUD (POST/PUT/DELETE)
│   └── 03_queries_avanzadas.graphql → Casos empresariales reales
│
├── .env                   → Variables de entorno (DB, puerto)
├── package.json           → Dependencias del proyecto
└── README.md              → Este archivo
```

---

## Instalación y configuración

### Requisitos previos

- [Node.js](https://nodejs.org) v18 o superior
- [PostgreSQL](https://www.postgresql.org) v14 o superior

### Paso 1 — Instalar dependencias

```bash
npm install
```

### Paso 2 — Crear la base de datos en PostgreSQL

```sql
-- Ejecutar en psql o pgAdmin
CREATE DATABASE empresa_db;
CREATE USER usuario WITH PASSWORD 'contraseña';
GRANT ALL PRIVILEGES ON DATABASE empresa_db TO usuario;
```

### Paso 3 — Configurar variables de entorno

Editar el archivo `.env`:

```env
DATABASE_URL=postgres://usuario:contraseña@localhost:5432/empresa_db
PORT=3000
NODE_ENV=development
```

### Paso 4 — Crear tablas y cargar datos de ejemplo

```bash
npm run setup-db
```

### Paso 5 — Iniciar el servidor

```bash
npm start
```

### Paso 6 — Abrir la interfaz GraphiQL

Abrir en el navegador: **http://localhost:3000/graphiql**

---

## Modelo de datos

El sistema simula una empresa de ventas con las siguientes tablas:

```
departamentos ──┐
                ├── empleados ──────────── pedidos ──── detalle_pedidos
                                               │               │
clientes ───────────────────────────────────────       productos
                                                            │
                                                       categorias
```

### Tablas principales

| Tabla | Descripción |
|---|---|
| `departamentos` | Áreas de la empresa (Ventas, IT, RRHH, Finanzas) |
| `empleados` | Personal con cargo, salario y departamento |
| `clientes` | Compradores con datos de contacto y empresa |
| `categorias` | Agrupación de productos |
| `productos` | Catálogo con precio, stock y SKU |
| `pedidos` | Órdenes de compra con estado y total |
| `detalle_pedidos` | Líneas de cada pedido (producto, cantidad, precio) |

---

## Operaciones CRUD con GraphQL

### CREATE — Crear un cliente nuevo

```graphql
mutation {
  createCliente(input: {
    cliente: {
      nombre: "Jorge"
      apellido: "Pérez"
      email: "jorge@empresa.com"
      empresa: "Tech Corp"
      ciudad: "Monterrey"
    }
  }) {
    cliente { id nombre email }
  }
}
```

### READ — Leer todos los productos

```graphql
query {
  allProductos {
    nodes {
      id nombre precio stock
      categoriaByCategoriaid { nombre }
    }
  }
}
```

### UPDATE — Actualizar estado de un pedido

```graphql
mutation {
  updatePedidoById(input: {
    id: 3
    pedidoPatch: { estado: "enviado" }
  }) {
    pedido { id estado }
  }
}
```

### DELETE — Eliminar un registro

```graphql
mutation {
  deleteDetallePedidoById(input: { id: 5 }) {
    deletedDetallePedidoId
  }
}
```

---

## Ejemplos de aplicación empresarial

### 🏪 1. E-commerce (Amazon, MercadoLibre)
- **Query**: Catálogo de productos filtrado por categoría, precio mínimo/máximo, stock disponible
- **Mutation**: Crear pedido, agregar al carrito, actualizar estado de envío
- **Ventaja GraphQL**: El app móvil pide solo `nombre, precio, imagen` mientras el admin pide todos los campos

### 🏥 2. Sistema hospitalario
- **Tablas**: pacientes, médicos, citas, diagnósticos, medicamentos
- **Query**: Historial clínico de un paciente con todas sus citas y diagnósticos en un solo request
- **Mutation**: Registrar nueva cita, actualizar diagnóstico, prescribir medicamento

### 🏦 3. Banco / Fintech
- **Tablas**: cuentas, transacciones, usuarios, tarjetas
- **Query**: Estado de cuenta con últimas 10 transacciones y saldo actual
- **Mutation**: Realizar transferencia, activar tarjeta, actualizar límite de crédito
- **Ventaja GraphQL**: La app del banco pide datos resumidos, el portal web pide el detalle completo

### 🏭 4. Manufactura / ERP
- **Tablas**: materias_primas, ordenes_produccion, empleados, maquinaria
- **Query**: Reporte de producción del mes con eficiencia por línea
- **Mutation**: Crear orden de producción, registrar salida de material, asignar turno

### 🏨 5. Hotelería (como Marriott, Hilton)
- **Tablas**: hoteles, habitaciones, reservaciones, huéspedes, servicios
- **Query**: Disponibilidad de habitaciones en fechas específicas con precio por noche
- **Mutation**: Crear reservación, hacer check-in, agregar consumo al cuarto
- **Ventaja GraphQL**: El motor de reservas del sitio web, la app del huésped y el sistema del recepcionista usan el mismo endpoint con distintos campos

### 📦 6. Logística (como DHL, FedEx)
- **Tablas**: paquetes, rutas, conductores, vehiculos, puntos_entrega
- **Query**: Rastreo de paquete con historial de movimientos en tiempo real
- **Mutation**: Registrar escaneo de paquete, asignar ruta, marcar como entregado
- **Ventaja GraphQL**: El cliente rastrea solo el estado, el sistema interno accede a todos los datos del conductor y ruta

---

## Ventajas de PostGraphile para empresas

| Situación | Solución con PostGraphile |
|---|---|
| Equipo pequeño, muchos endpoints necesarios | Genera toda la API automáticamente desde PostgreSQL |
| Múltiples clientes (web, móvil, IoT) | Un solo endpoint GraphQL, cada cliente pide lo que necesita |
| Cambios frecuentes en la BD | PostGraphile detecta cambios y recarga el esquema (`watchPg: true`) |
| Necesidad de documentación | GraphiQL genera documentación interactiva automáticamente |
| Alto rendimiento | Genera SQL optimizado con JOINs eficientes |

---

## Endpoints disponibles

| URL | Descripción |
|---|---|
| `GET http://localhost:3000/` | Info del servidor |
| `POST http://localhost:3000/graphql` | Endpoint principal de la API |
| `GET http://localhost:3000/graphiql` | Interfaz visual para explorar y probar queries |
