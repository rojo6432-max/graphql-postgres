/**
 * Script para crear y poblar la base de datos automáticamente.
 * Ejecutar con: node src/setupDatabase.js
 */

require('dotenv').config();
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgres://usuario:contraseña@localhost:5432/empresa_db',
});

async function setupDatabase() {
  console.log('🔧 Configurando base de datos...\n');

  try {
    // Leer y ejecutar el script SQL del esquema
    const schemaPath = path.join(__dirname, '..', 'sql', '01_schema.sql');
    const schema = fs.readFileSync(schemaPath, 'utf8');
    await pool.query(schema);
    console.log('✅ Tablas creadas correctamente');

    // Leer y ejecutar el script SQL con datos de ejemplo
    const dataPath = path.join(__dirname, '..', 'sql', '02_datos_ejemplo.sql');
    const data = fs.readFileSync(dataPath, 'utf8');
    await pool.query(data);
    console.log('✅ Datos de ejemplo insertados correctamente');

    console.log('\n🚀 Base de datos lista. Ahora ejecuta: npm start');
  } catch (err) {
    console.error('❌ Error configurando la base de datos:', err.message);
  } finally {
    await pool.end();
  }
}

setupDatabase();
