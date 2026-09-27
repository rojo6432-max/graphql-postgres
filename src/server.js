/**
 * Servidor principal - GraphQL con PostgreSQL usando PostGraphile
 * 
 * PostGraphile genera automáticamente el esquema GraphQL
 * a partir de las tablas definidas en PostgreSQL.
 */

require('dotenv').config();
const express = require('express');
const { postgraphile } = require('postgraphile');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// ─── Middleware ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// ─── Ruta de bienvenida ────────────────────────────────────────────────────────
app.get('/', (req, res) => {
  res.json({
    mensaje: '🚀 API GraphQL con PostgreSQL - Sistema Empresarial',
    graphql_endpoint: `http://localhost:${PORT}/graphql`,
    graphiql_ui: `http://localhost:${PORT}/graphiql`,
    version: '1.0.0',
  });
});

// ─── PostGraphile: genera el esquema GraphQL automáticamente ──────────────────
app.use(
  postgraphile(
    process.env.DATABASE_URL || 'postgres://usuario:contraseña@localhost:5432/empresa_db',
    'public',  // esquema de PostgreSQL a exponer
    {
      // Habilita la interfaz visual GraphiQL en el navegador
      graphiql: true,

      // Muestra errores detallados en desarrollo
      enhanceGraphiql: true,
      allowExplain: process.env.NODE_ENV !== 'production',

      // Recarga el esquema si cambia la BD (solo en desarrollo)
      watchPg: process.env.NODE_ENV !== 'production',

      // Muestra errores completos solo en desarrollo
      showErrorStack: process.env.NODE_ENV !== 'production',
      extendedErrors: ['hint', 'detail', 'errcode'],

      // Permite hacer queries por GET (útil para pruebas)
      enableQueryBatching: true,

      // Agrega timestamps a todas las mutaciones
      dynamicJson: true,
    }
  )
);

// ─── Iniciar servidor ──────────────────────────────────────────────────────────
app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n✅ Servidor corriendo en http://0.0.0.0:${PORT}`);
  console.log(`📊 GraphQL endpoint:  http://0.0.0.0:${PORT}/graphql`);
  console.log(`🔍 GraphiQL (UI):     http://0.0.0.0:${PORT}/graphiql\n`);
});
