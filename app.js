const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const {json} = require("express");
const path = require('path');
const morgan = require('morgan');
const helmet = require('helmet');
const app = express();
const port = 3001;
const insumoRoutes = require('./api/routes/insumo.routes');

process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

// Middleware para parsear JSON
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(morgan('dev'));
app.use(json());

// Configuración de CORS
const corsOptions = {
  origin: process.env.FRONTEND_URL || '*', // Puedes configurar tu frontend si lo tienes
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
};

app.use(cors(corsOptions));

app.use('/api/insumo', insumoRoutes);

app.use((req, res, next) => {
  res.status(404).json({
    status: 'error',
    message: 'Router no encontrado'
  })
})

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    status: 'error',
    message: err.message || 'Algo salió mal'
  })
})

// Ruta de prueba principal
app.get('/', (req, res) => {
  res.send('Hola Morrillos');
});

// Manejo de rutas no encontradas
app.use((req, res, next) => {
  res.status(404).json({ error: 'Ruta no encontrada' });
});

// Middleware de manejo de errores
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Error interno del servidor' });
});

// Iniciar el servidor
app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});