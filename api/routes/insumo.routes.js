const express = require('express');
const router = express.Router();

const Insumo = require('../../models/insumo.model'); // Importa el modelo
const InsumoService = require('../../services/insumo.service'); // Importa el servicio
const InsumoController = require('../controllers/insumos.controller');

// Instancia del servicio y del controlador
const insumoService = new InsumoService(Insumo);
const insumoController = new InsumoController(insumoService);

// Define las rutas
router.get('/', insumoController.getInsumos.bind(insumoController));
router.post('/', insumoController.createInsumo.bind(insumoController));
router.get('/:id', insumoController.getInsumoById.bind(insumoController));

module.exports = router;