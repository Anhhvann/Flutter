const pool = require("../config/db");

async function getAllCategories() {
  const [rows] = await pool.execute(
    "SELECT id, name FROM categories ORDER BY name ASC"
  );
  return rows;
}

module.exports = {
  getAllCategories
};
