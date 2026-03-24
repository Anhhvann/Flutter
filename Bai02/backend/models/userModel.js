const pool = require("../config/db");

async function getUserByEmail(email) {
  const [rows] = await pool.execute(
    "SELECT id, full_name, username, email, password FROM users WHERE email = ? LIMIT 1",
    [email]
  );
  return rows[0];
}

async function getUserById(id) {
  const [rows] = await pool.execute(
    "SELECT id, full_name, username, email, phone, address, avatar, role FROM users WHERE id = ? LIMIT 1",
    [id]
  );
  return rows[0];
}

async function createUser({ username, email, passwordHash }) {
  const [result] = await pool.execute(
    "INSERT INTO users (full_name, username, email, password) VALUES (?, ?, ?, ?)",
    [username, username, email, passwordHash]
  );
  return result.insertId;
}

async function updatePassword(userId, passwordHash) {
  await pool.execute("UPDATE users SET password = ? WHERE id = ?", [
    passwordHash,
    userId
  ]);
}

module.exports = {
  getUserByEmail,
  getUserById,
  createUser,
  updatePassword
};
