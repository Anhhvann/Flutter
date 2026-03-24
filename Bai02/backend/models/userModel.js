const pool = require("../config/db");

async function getUserByEmail(email) {
  const [rows] = await pool.execute(
    "SELECT id, username, email, password_hash FROM users WHERE email = ? LIMIT 1",
    [email]
  );
  return rows[0];
}

async function createUser({ username, email, passwordHash }) {
  const [result] = await pool.execute(
    "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)",
    [username, email, passwordHash]
  );
  return result.insertId;
}

async function updatePassword(userId, passwordHash) {
  await pool.execute("UPDATE users SET password_hash = ? WHERE id = ?", [
    passwordHash,
    userId
  ]);
}

module.exports = {
  getUserByEmail,
  createUser,
  updatePassword
};
