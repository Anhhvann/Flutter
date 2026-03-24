module.exports = {
  host: process.env.SMTP_HOST || "smtp.gmail.com",
  port: Number(process.env.SMTP_PORT || 465),
  user: process.env.SMTP_USER || "anhyeuem1phutthoi@gmail.com",
  pass: process.env.SMTP_PASS || "lsgmzwoevkflzrpu",
  from: process.env.SMTP_FROM || "anhyeuem1phutthoi@gmail.com"
};
