
const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Venta = sequelize.define('Venta', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    tipo_venta: {
        type: DataTypes.ENUM('Unidad', 'Gramaje', 'Monto'),
        allowNull: false
    },
    cantidad: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    precio_unitario: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    total_venta: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    descuento_aplicado: {
        type: DataTypes.DECIMAL(10, 2),
        defaultValue: 0
    },
    cliente_pago: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    cambio: {
        type: DataTypes.DECIMAL(10, 2)
    },
    fecha_venta: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    },
    receta_id: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
}, {
    tableName: 'ModuloVentas',
    timestamps: false
});

module.exports = Venta;



