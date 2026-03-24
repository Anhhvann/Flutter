const nodemailer = require("nodemailer");
const mailConfig = require("../config/mail");

function canSendEmail() {
  return (
    mailConfig.host &&
    mailConfig.port &&
    mailConfig.user &&
    mailConfig.pass &&
    mailConfig.from
  );
}

async function sendOtpEmail({ email, otp, purpose }) {
  if (!canSendEmail()) {
    console.log(`OTP for ${email} (${purpose}): ${otp}`);
    return;
  }

  const transporter = nodemailer.createTransport({
    host: mailConfig.host,
    port: mailConfig.port,
    secure: mailConfig.port === 465,
    auth: {
      user: mailConfig.user,
      pass: mailConfig.pass
    }
  });

  await transporter.sendMail({
    from: mailConfig.from,
    to: email,
    subject: "Your OTP Code",
    text: `Your OTP code is: ${otp}. It expires in 5 minutes.`
  });
}

module.exports = {
  sendOtpEmail
};
