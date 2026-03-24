const bcrypt = require("bcryptjs");

const { getUserByEmail, createUser, updatePassword } = require("../models/userModel");
const { findValidOtp, markUsed } = require("../models/otpModel");
const {
  createRefreshToken,
  findValidRefreshToken,
  revokeAllForUser
} = require("../models/refreshTokenModel");
const { issueOtp } = require("../services/otpService");
const {
  createAccessToken,
  createRefreshToken: signRefreshToken,
  verifyRefreshToken
} = require("../services/tokenService");

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

async function register(req, res) {
  const { username, email, password } = req.body;

  if (!username || !email || !password) {
    return res.status(400).json({ message: "Missing fields" });
  }

  if (!isValidEmail(email) || password.length < 6) {
    return res.status(400).json({ message: "Invalid email or password" });
  }

  const existing = await getUserByEmail(email);
  if (existing) {
    return res.status(409).json({ message: "Email already registered" });
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const payloadJson = JSON.stringify({ username, passwordHash });

  await issueOtp({ email, purpose: "register", payloadJson });

  return res.json({ message: "OTP sent" });
}

async function verifyOtp(req, res) {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).json({ message: "Missing fields" });
  }

  const record = await findValidOtp(email, otp, "register");
  if (!record) {
    return res.status(400).json({ message: "Invalid or expired OTP" });
  }

  const existing = await getUserByEmail(email);
  if (existing) {
    await markUsed(record.id);
    return res.status(409).json({ message: "Email already registered" });
  }

  const payload = JSON.parse(record.payload_json || "{}");
  if (!payload.username || !payload.passwordHash) {
    return res.status(400).json({ message: "Invalid OTP payload" });
  }

  await createUser({
    username: payload.username,
    email,
    passwordHash: payload.passwordHash
  });

  await markUsed(record.id);

  return res.status(201).json({ message: "Account created" });
}

async function login(req, res) {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Missing fields" });
  }

  const user = await getUserByEmail(email);
  if (!user) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  const matches = await bcrypt.compare(password, user.password_hash);
  if (!matches) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  const accessToken = createAccessToken(user);
  const refreshToken = signRefreshToken(user);

  await revokeAllForUser(user.id);
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  await createRefreshToken({ userId: user.id, token: refreshToken, expiresAt });

  return res.json({
    accessToken,
    refreshToken
  });
}

async function forgotPassword(req, res) {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ message: "Missing email" });
  }

  const user = await getUserByEmail(email);
  if (user) {
    await issueOtp({ email, purpose: "reset", payloadJson: null });
  }

  return res.json({ message: "If the email exists, OTP was sent" });
}

async function resetPassword(req, res) {
  const { email, otp, newPassword } = req.body;

  if (!email || !otp || !newPassword) {
    return res.status(400).json({ message: "Missing fields" });
  }

  if (newPassword.length < 6) {
    return res.status(400).json({ message: "Password too short" });
  }

  const record = await findValidOtp(email, otp, "reset");
  if (!record) {
    return res.status(400).json({ message: "Invalid or expired OTP" });
  }

  const user = await getUserByEmail(email);
  if (!user) {
    return res.status(404).json({ message: "User not found" });
  }

  const passwordHash = await bcrypt.hash(newPassword, 10);
  await updatePassword(user.id, passwordHash);
  await markUsed(record.id);
  await revokeAllForUser(user.id);

  return res.json({ message: "Password updated" });
}

async function refreshToken(req, res) {
  const { refreshToken: token } = req.body;

  if (!token) {
    return res.status(400).json({ message: "Missing refresh token" });
  }

  const record = await findValidRefreshToken(token);
  if (!record) {
    return res.status(401).json({ message: "Invalid refresh token" });
  }

  try {
    const payload = verifyRefreshToken(token);
    const accessToken = createAccessToken({ id: payload.sub, email: payload.email });
    return res.json({ accessToken });
  } catch (error) {
    return res.status(401).json({ message: "Invalid refresh token" });
  }
}

module.exports = {
  register,
  verifyOtp,
  login,
  forgotPassword,
  resetPassword,
  refreshToken
};
