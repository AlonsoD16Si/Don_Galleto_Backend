require('dotenv').config();

module.exports = {
  PORT: process.env.PORT || 3001,
  DB_NAME: process.env.DB_NAME || 'http://galleto.c3mkc6auc4br.us-east-2.rds.amazonaws.com/',//'Don_Galleto',
  DB_USER: process.env.DB_USER || 'admin',
  DB_PASS: process.env.DB_PASS || 'rootgalleto',
  DB_HOST: process.env.DB_HOST || 'Don_Galleto',
};
