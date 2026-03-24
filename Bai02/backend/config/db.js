const mysql = require("mysql2/promise");

const pool = mysql.createPool({
  host: process.env.DB_HOST || "mysql-16b7e0ab-anhanh190205-8701.g.aivencloud.com",
  user: process.env.DB_USER || "avnadmin",
  port: Number(process.env.DB_PORT || 25093),
  password: process.env.DB_PASS || "DB_PASSWORD",
  database: process.env.DB_NAME || "library",
  waitForConnections: true,
  connectionLimit: 10,
  timezone: "Z"
});

module.exports = pool;
