# Deployment Guide

This project is a stateless Spring Boot REST API that uses environment variables for configuration. This ensures no secrets are leaked when deploying to platforms like Render and Vercel.

## 🚀 Setup for New Developers (Local Dev)

1. **Do NOT modify `application.properties` to add secrets.**
2. Copy the dev template to create your local config:
   ```bash
   cp src/main/resources/application-dev.properties.example src/main/resources/application-dev.properties
   ```
3. Open `application-dev.properties` and fill in your actual local configuration (like local passwords or custom JWT secret). 
   - `application-dev.properties` is **gitignored** and will never be committed.

## 🚀 Deployment to Render (Backend)

When deploying to Render, the backend will use `application-prod.properties`. You must set the following **Environment Variables** in the Render Dashboard under your web service settings:

### Database (Neon PostgreSQL)
- `SPRING_DATASOURCE_URL`: (e.g. `jdbc:postgresql://ep-xxx.region.aws.neon.tech/neondb?sslmode=require`)
- `SPRING_DATASOURCE_USERNAME`: (your neon user)
- `SPRING_DATASOURCE_PASSWORD`: (your neon password)

### Security
- `JWT_SECRET_KEY`: A secure, random string at least 32 characters long.

### File Storage (Supabase S3)
- `SUPABASE_S3_ENDPOINT`: `https://<project_ref>.supabase.co/storage/v1/s3`
- `SUPABASE_S3_REGION`: `ap-southeast-1` (or your project's region)
- `SUPABASE_S3_ACCESS_KEY`: (Supabase S3 access key)
- `SUPABASE_S3_SECRET_KEY`: (Supabase S3 secret key)
- `SUPABASE_S3_BUCKET`: `certificates` (or your bucket name)
- `SUPABASE_PUBLIC_URL`: `https://<project_ref>.supabase.co/storage/v1/object/public/<bucket>`

### Mail (Gmail SMTP)
- `SPRING_MAIL_HOST`: `smtp.gmail.com`
- `SPRING_MAIL_PORT`: `587`
- `EMAIL_USERNAME`: your-email@gmail.com
- `EMAIL_PASSWORD`: your 16-character app password
- `SPRING_MAIL_AUTH`: `true`
- `SPRING_MAIL_STARTTLS`: `true`

### CORS / Profile
- `CORS_ALLOWED_ORIGINS`: `https://your-frontend-project.vercel.app` (The Vercel URL)
- `SPRING_PROFILES_ACTIVE`: `prod`

## 🚀 Deployment to Vercel (Frontend)

Your Vercel React frontend needs to know where the backend is located. Set this environment variable in the Vercel Dashboard:

- `VITE_API_BASE_URL` (or `REACT_APP_API_BASE_URL` depending on your build tool): `https://your-render-backend-url.onrender.com`

## ⚠️ Security Warnings

- **NEVER** commit real passwords, API keys, or JWT secrets to this repository.
- If you accidentally commit a secret, **consider it compromised**. You must:
  1. Revoke/delete the key immediately from the provider (e.g. Supabase, Neon, Google).
  2. Generate a new key.
  3. Update the Render dashboard with the new key.
- A pre-commit hook is provided to help catch accidental commits (see `check-secrets.sh`).
