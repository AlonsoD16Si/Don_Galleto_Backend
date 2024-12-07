const express = require('express');
const router = express.Router();
const insumosRoutes = require('/api/routes/insumo.routes');
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

router.use('/insumo', insumosRoutes);

module.exports = router;
