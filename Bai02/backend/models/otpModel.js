const pool = require("../config/db");

async function createOtp({ email, otp, purpose, expiresAt, payloadJson }) {
  await pool.execute(
    "INSERT INTO otps (email, otp_code, purpose, expires_at, payload_json) VALUES (?, ?, ?, ?, ?)",
    [email, otp, purpose, expiresAt, payloadJson]
  );
}

async function findValidOtp(email, otp, purpose) {
  const [rows] = await pool.execute(
    "SELECT id, email, otp_code, purpose, expires_at, payload_json FROM otps WHERE email = ? AND otp_code = ? AND purpose = ? AND used = 0 AND expires_at > NOW() ORDER BY id DESC LIMIT 1",
    [email, otp, purpose]
  );
  return rows[0];
}

async function markUsed(id) {
  await pool.execute("UPDATE otps SET used = 1 WHERE id = ?", [id]);
}

module.exports = {
  createOtp,
  findValidOtp,
  markUsed
};
