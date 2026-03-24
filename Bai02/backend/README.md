# Backend Auth API

## Setup
1. Install dependencies:
   - npm install
2. Create a MySQL database (example: auth_demo) and run the schema:
   - Use schema.sql to create tables
3. Create a .env file based on .env.example
4. Start the server:
   - npm run dev

## Endpoints
- POST /api/auth/register
- POST /api/auth/verify-otp
- POST /api/auth/login
- POST /api/auth/forgot-password
- POST /api/auth/reset-password
- GET /api/auth/me (requires Bearer token)

## Notes
- OTPs expire in 5 minutes and are stored in memory (not in DB).
- JWT refresh tokens are disabled (access token only).
- Email sending falls back to console logs when SMTP is not configured.
