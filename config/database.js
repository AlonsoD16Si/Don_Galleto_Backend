const { Sequelize } = require('sequelize');
const { DB_NAME, DB_USER, DB_PASS, DB_HOST } = require('./environment');

const sequelize = new Sequelize(DB_NAME, DB_USER, DB_PASS, {
  host: DB_HOST,
  dialect: 'mysql',
  port: process.env.DB_PORT || 3306,
  logging: false,
  dialectModule: require('mysql2'), // Añade esta línea
  dialectOptions: {
    ssl: {
      rejectUnauthorized: true // Añade soporte para conexiones SSL
    }
  }
});

module.exports = sequelize;