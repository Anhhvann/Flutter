const jwt = require("jsonwebtoken");
const jwtConfig = require("../config/jwt");

function createAccessToken(user) {
  return jwt.sign(
    { sub: user.id, email: user.email },
    jwtConfig.accessTokenSecret,
    { expiresIn: jwtConfig.accessTokenExpiresIn }
  );
}

function createRefreshToken(user) {
  return jwt.sign(
    { sub: user.id, email: user.email },
    jwtConfig.refreshTokenSecret,
    { expiresIn: jwtConfig.refreshTokenExpiresIn }
  );
}

function verifyAccessToken(token) {
  return jwt.verify(token, jwtConfig.accessTokenSecret);
}

function verifyRefreshToken(token) {
  return jwt.verify(token, jwtConfig.refreshTokenSecret);
}

module.exports = {
  createAccessToken,
  createRefreshToken,
  verifyAccessToken,
  verifyRefreshToken
};
