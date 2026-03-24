const { sendOtpEmail } = require("./mailService");

const otpStore = new Map();

function generateOtp() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

async function issueOtp({ email, purpose, payloadJson }) {
  const otp = generateOtp();
  const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

  otpStore.set(`${email}:${purpose}`, {
    email,
    otp,
    purpose,
    expiresAt,
    used: false,
    payload_json: payloadJson
  });
  await sendOtpEmail({ email, otp, purpose });

  return { otp, expiresAt };
}

module.exports = {
  issueOtp,
  findValidOtp: async (email, otp, purpose) => {
    const record = otpStore.get(`${email}:${purpose}`);
    if (!record) {
      return null;
    }
    if (record.used || record.otp !== otp || record.expiresAt <= new Date()) {
      return null;
    }
    return record;
  },
  markUsed: async (email, purpose) => {
    const record = otpStore.get(`${email}:${purpose}`);
    if (record) {
      record.used = true;
    }
  }
};
