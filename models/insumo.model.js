const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Insumo = sequelize.define('Insumo', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    insumo_nombre: {
        type: DataTypes.STRING,
        allowNull: false // Añadimos esto para indicar que el nombre es obligatorio
    },
    cantidad_existente: {
        type: DataTypes.INTEGER,
        allowNull: false // Añadimos esto para indicar que la cantidad es obligatoria
    },
    unidad: {
        type: DataTypes.STRING,
        allowNull: false // Añadimos esto para indicar que la unidad es obligatoria
    },
    lote_id: {
        type: DataTypes.STRING
    },
    fecha_registro: {
        type: DataTypes.DATE
    },
    fecha_caducidad: {
        type: DataTypes.DATE
    }
}, {
    tableName: 'administracioninsumos',
    timestamps: false
});

module.exports = Insumo;