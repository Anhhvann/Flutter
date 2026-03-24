const pool = require("../config/db");

async function getFeaturedBooks(limit) {
  const safeLimit = Number(limit) || 0;
  const [rows] = await pool.execute(
    "SELECT b.id, b.title, b.description, b.price, b.cover_image, b.stock, " +
      "c.name AS category, a.name AS author, p.name AS publisher " +
      "FROM books b " +
      "LEFT JOIN categories c ON b.category_id = c.id " +
      "LEFT JOIN authors a ON b.author_id = a.id " +
      "LEFT JOIN publishers p ON b.publisher_id = p.id " +
      `ORDER BY b.created_at DESC LIMIT ${safeLimit}`
  );
  return rows;
}

async function getBestSellers(limit) {
  const safeLimit = Number(limit) || 0;
  const [rows] = await pool.execute(
    "SELECT b.id, b.title, b.description, b.price, b.cover_image, b.stock, " +
      "c.name AS category, a.name AS author, p.name AS publisher " +
      "FROM books b " +
      "LEFT JOIN categories c ON b.category_id = c.id " +
      "LEFT JOIN authors a ON b.author_id = a.id " +
      "LEFT JOIN publishers p ON b.publisher_id = p.id " +
      `ORDER BY b.stock DESC, b.created_at DESC LIMIT ${safeLimit}`
  );
  return rows;
}

module.exports = {
  getFeaturedBooks,
  getBestSellers
};
