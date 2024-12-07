const sequelize = require('./database'); // Instancia de sequelize

async function actualizarInventarioParaProduccion(recetaId, lotesProducidos) {
    try {
        console.log(`Llamando al procedimiento con recetaId: ${recetaId}, lotesProducidos: ${lotesProducidos}`);

        // Ejecutar el procedimiento almacenado
        const [results] = await sequelize.query(
            'CALL ActualizarInventarioParaProduccion(:recetaId, :lotesProducidos)',
            {
                replacements: { recetaId, lotesProducidos },
                type: sequelize.QueryTypes.RAW
            }
        );

        console.log('Resultados del procedimiento:', results);

        // Verifica si el procedimiento devolvió resultados y un mensaje válido
        if (results && results.mensaje) {
            console.log(`Mensaje del procedimiento: ${results.mensaje}`);
            return {
                status: 'success',
                message: results.mensaje
            };
        } else {
            console.error('Error: El procedimiento no devolvió resultados o el mensaje es inválido.');
            return {
                status: 'error',
                message: 'El procedimiento no devolvió ningún resultado válido.'
            };
        }
    } catch (error) {
        console.error('Error al ejecutar el procedimiento almacenado:', error.message);
        console.error('Detalles completos del error:', error);

        return {
            status: 'error',
            message: 'Ocurrió un error inesperado al ejecutar el procedimiento.',
            details: error.message // Información adicional del error
        };
    }
}

module.exports = {
    actualizarInventarioParaProduccion,
};