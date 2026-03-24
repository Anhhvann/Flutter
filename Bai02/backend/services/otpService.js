const { createOtp } = require("../models/otpModel");
const { sendOtpEmail } = require("./mailService");

function generateOtp() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

async function issueOtp({ email, purpose, payloadJson }) {
  const otp = generateOtp();
  const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

  await createOtp({ email, otp, purpose, expiresAt, payloadJson });
  await sendOtpEmail({ email, otp, purpose });

  return { otp, expiresAt };
}

module.exports = {
  issueOtp
};
