const express = require('express');
const router = express.Router();
const insumosRoutes = require('/api/routes/insumo.routes');

router.use('/insumo', insumosRoutes);

module.exports = router;
