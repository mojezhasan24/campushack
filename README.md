# CampusHack - Hackathon Management System

A full-stack Spring Boot, JPA, and JSP web application designed for managing college hackathons. The system adheres to the **Cyber Campus** dark mode glassmorphism visual design system.

---

## 🔒 Authentication Overhaul & Email OTP Verification

CampusHack implements **Email-Based OTP Verification** for user registration:

1. **Zero Pre-seeded Users**:
   - The application starts with an **empty `User` database table** at runtime.
   - There are no pre-seeded default accounts. Every account must be created via registration.
2. **Registration & Role Selection**:
   - New users sign up with their **Name**, **Email**, **Username**, **Password**, and selected **Role** (`PARTICIPANT`, `ADMIN`, or `JUDGE`).
3. **6-Digit OTP Email Dispatch**:
   - Upon registration, an account is created in unverified state (`enabled = false`) and a **6-digit numeric OTP** is dispatched via SMTP from `campushack@outlook.com`.
4. **Account Verification**:
   - The user inputs the 6-digit OTP code on the `/verify-otp` page to activate their account (`enabled = true`).
5. **Strict Login Restriction**:
   - Unverified accounts cannot log in. Attempts return `403 Forbidden` with the message: *"Account not verified. Please check your email for the OTP."*

---

## ⚙️ Environment Configuration

Set the `EMAIL_PASSWORD` environment variable before running the application to enable SMTP email dispatch from `campushack@outlook.com`:

### On Linux / macOS:
```bash
export EMAIL_PASSWORD="your_outlook_app_password"
```

### On Windows (CMD / PowerShell):
```cmd
set EMAIL_PASSWORD=your_outlook_app_password
# PowerShell: $env:EMAIL_PASSWORD="your_outlook_app_password"
```

> **Note**: If 2-Factor Authentication (2FA) is enabled on `campushack@outlook.com`, generate an **App Password** from Microsoft Security Settings.

---

## 🚀 Running the Application

### 1. Build and Run via Maven
```bash
mvn clean package -DskipTests
mvn spring-boot:run
```
*(Or use portable Maven binary: `./apache-maven-3.9.6/bin/mvn spring-boot:run`)*

### 2. Access Links
- **Web App Home / Login**: [http://localhost:8080/login](http://localhost:8080/login)
- **Account Registration**: [http://localhost:8080/register](http://localhost:8080/register)
- **OTP Verification Page**: [http://localhost:8080/verify-otp](http://localhost:8080/verify-otp)
- **H2 Web Console**: [http://localhost:8080/h2-console](http://localhost:8080/h2-console) (JDBC URL: `jdbc:h2:mem:campushackdb`, User: `sa`, Password: empty)
- **Swagger / OpenAPI Documentation**: [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)
- **Postman Collection**: `./campushack_postman_collection.json`

---

## 🛠️ Tech Stack

- **Backend**: Java 17/21, Spring Boot 3.2.5 (Spring MVC, Spring Data JPA, `spring-boot-starter-mail`), H2 In-Memory DB, Lombok.
- **Frontend**: Plain HTML5, Custom Vanilla CSS (Cyber Campus Design System), JSP (JavaServer Pages), JSTL (`c:forEach`, `c:if`), Expression Language (`${...}`).
- **APIs & Security**: Session-based auth, `@RestController` for AJAX, `@ControllerAdvice` for global exception handling, Swagger/OpenAPI UI.
