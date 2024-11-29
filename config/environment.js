require('dotenv').config();

module.exports = {
  PORT: process.env.PORT || 3001,
  DB_NAME: process.env.DB_NAME || 'Don_Galleto',
  DB_USER: process.env.DB_USER || 'root',
  DB_PASS: process.env.DB_PASS || '',
  DB_HOST: process.env.DB_HOST || 'localhost',
};
