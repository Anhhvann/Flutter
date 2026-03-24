const pool = require("../config/db");

async function createRefreshToken({ userId, token, expiresAt }) {
  await pool.execute(
    "INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (?, ?, ?)",
    [userId, token, expiresAt]
  );
}

async function findValidRefreshToken(token) {
  const [rows] = await pool.execute(
    "SELECT id, user_id, token, expires_at, revoked FROM refresh_tokens WHERE token = ? AND revoked = 0 AND expires_at > NOW() LIMIT 1",
    [token]
  );
  return rows[0];
}

async function revokeToken(id) {
  await pool.execute("UPDATE refresh_tokens SET revoked = 1 WHERE id = ?", [
    id
  ]);
}

async function revokeAllForUser(userId) {
  await pool.execute(
    "UPDATE refresh_tokens SET revoked = 1 WHERE user_id = ?",
    [userId]
  );
}

module.exports = {
  createRefreshToken,
  findValidRefreshToken,
  revokeToken,
  revokeAllForUser
};
