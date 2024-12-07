class InsumosController {
    constructor(insumoController) {
        this.insumoController = insumoController;
    }

    async createInsumo(req, res) {
        try {
            const insumo = await this.insumoController.create(req.body);
            res.status(201).json({
                status: 'success',
                data: insumo
            });
        }  catch (error) {
            res.status(400).json({
                status: 'error',
                message: error.message
            });
        }
    }

    async getInsumos(req, res) {
        try {
            const insumos = await this.insumoController.getAllInsumos();
            res.json({
                status: 'success',
                data: insumos
            });
        } catch (error) {
            res.status(500).json({
                status: 'error',
                message: error.message
            });
        }
    }

    async getInsumoById(req, res) {
        try {
            const { id } = req.params; // Extraer el ID de los parámetros de la solicitud
            const insumo = await this.insumoController.getInsumoById(id); // Llamar al método correspondiente del controlador

            if (!insumo) {
                return res.status(404).json({
                    status: 'error',
                    message: `Insumo con ID ${id} no encontrado`,
                });
            }

            res.json({
                status: 'success',
                data: insumo,
            });
        } catch (error) {
            res.status(500).json({
                status: 'error',
                message: error.message,
            });
        }
    }
}

module.exports = InsumosController;