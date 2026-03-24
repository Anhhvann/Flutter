module.exports = {
  accessTokenSecret: process.env.JWT_SECRET || "change-me",
  refreshTokenSecret: process.env.JWT_REFRESH_SECRET || "change-me-refresh",
  accessTokenExpiresIn: process.env.JWT_EXPIRES_IN || "15m",
  refreshTokenExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || "7d"
};
