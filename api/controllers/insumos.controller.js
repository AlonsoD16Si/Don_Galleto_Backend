const {query} = require("../../config/database");
const procedures = require("../../config/procedures");

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

    async actualizarInventario(req, res) {
        const { id, amount } = req.params;  // Obtener parámetros de la URL

        try {
            // Llamar al procedimiento para actualizar el inventario
            const result = await procedures.actualizarInventarioParaProduccion(id, amount);

            // Verificar si el procedimiento devuelve un mensaje
            if (result && result.message) {
                console.log('Mensaje del procedimiento:', result.message);

                // Responder con el mensaje en un formato JSON
                return res.status(200).json({
                    status: result.status,
                    message: result.message
                });
            } else {
                // Si no se obtuvo mensaje, manejarlo como un error
                console.error('Error en el procedimiento, no se obtuvo mensaje');
                return res.status(500).json({
                    status: 'error',
                    message: 'No se obtuvo mensaje del procedimiento'
                });
            }
        } catch (error) {
            // Manejo del error específico de inventario insuficiente
            if (error.sqlMessage && error.sqlMessage.includes('No hay suficiente inventario para esta producción')) {
                console.error('Error al ejecutar el procedimiento SQL:', error.sqlMessage);
                return res.status(200).json({
                    status: 'warning',
                    message: 'No hay suficiente inventario para esta producción.'
                });
            } else {
                // Si se trata de otro tipo de error, manejarlo de forma general
                console.error('Error desconocido:', error);
                return res.status(500).json({
                    status: 'error',
                    message: 'Ocurrió un error inesperado.'
                });
            }
        }
    }
}

module.exports = InsumosController;