<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Account Registration ⚡</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Massive Background Typography -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 22vw, 20rem); color: rgba(255,58,242,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        REGISTER
    </div>

    <!-- Floating Decorative Shapes -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 14%; right: 5%; font-size: 2.8rem;">✨</span>
    <span class="deco-shape animate-wiggle animate-delay-2" style="top: 35%; left: 3%; font-size: 2.4rem;">⚡</span>
    <span class="deco-shape animate-bounce animate-delay-3" style="bottom: 16%; right: 4%; font-size: 2.6rem;">🚀</span>

    <main class="main-content" style="display: flex; justify-content: center; align-items: center; position: relative; z-index: 1;">
        
        <!-- Ultra Compact Glass Card -->
        <div class="glass-panel pattern-checker" style="width: 100%; max-width: 480px; padding: 24px 24px; border-color: var(--accent); border-radius: 20px; box-shadow: 6px 6px 0 var(--tertiary), 12px 12px 0 var(--quinary); background: rgba(13,13,26,0.88); backdrop-filter: blur(20px);">
            
            <div style="text-align: center; margin-bottom: 14px;">
                <span class="chip chip-primary animate-pulse-glow" style="margin-bottom: 6px; font-size: 10px; padding: 3px 10px;">
                    <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 13px;">person_add</span> CREATE ACCOUNT
                </span>
                <h2 class="h2" style="color: #FFF; font-size: 1.5rem; margin-bottom: 2px;">JOIN CAMPUSHACK <span class="gradient-text">⚡</span></h2>
                <p class="text-muted label-sm" style="font-size: 11px;">Create your profile to compete or manage events</p>
            </div>

            <!-- Error Alert -->
            <div id="errorAlert" class="alert-banner error" style="display: none; margin-bottom: 12px; padding: 8px 12px; font-size: 0.8rem;">
                <span class="material-symbols-outlined" style="font-size: 16px;">error</span>
                <span id="errorMessage">Error registering user.</span>
            </div>

            <form id="registerForm" onsubmit="handleRegisterSubmit(event)">
                
                <!-- Account Role -->
                <div class="form-group" style="margin-bottom: 10px;">
                    <label class="form-label" for="role" style="font-size: 0.7rem;">Account Role</label>
                    <select class="form-select" id="role" onchange="toggleStudentFields()" style="padding: 8px 36px 8px 12px; font-size: 0.88rem; border-radius: 12px;" required>
                        <option value="PARTICIPANT">Student / Participant 🚀</option>
                        <option value="ADMIN">Faculty / Admin 🛡️</option>
                        <option value="JUDGE">Judge ⚖️</option>
                    </select>
                </div>

                <!-- Full Name -->
                <div class="form-group" style="margin-bottom: 10px;">
                    <label class="form-label" for="fullName" style="font-size: 0.7rem;">Full Name</label>
                    <input class="form-input" id="fullName" type="text" placeholder="e.g. Aditya Verma" style="padding: 8px 12px; font-size: 0.88rem; border-radius: 12px;" required/>
                </div>

                <!-- Email -->
                <div class="form-group" style="margin-bottom: 10px;">
                    <label class="form-label" for="email" style="font-size: 0.7rem;">Email Address (OTP sent here)</label>
                    <input class="form-input" id="email" type="email" placeholder="user@domain.com" style="padding: 8px 12px; font-size: 0.88rem; border-radius: 12px;" required/>
                </div>

                <!-- Side-by-Side: Username + Roll Number -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 10px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="username" style="font-size: 0.7rem;">Username</label>
                        <input class="form-input" id="username" type="text" placeholder="aditya_v" style="padding: 8px 12px; font-size: 0.88rem; border-radius: 12px;" required/>
                    </div>
                    <div class="form-group" id="rollNumberGroup" style="margin-bottom: 0;">
                        <label class="form-label" for="rollNumber" style="font-size: 0.7rem;">Roll Number</label>
                        <input class="form-input" id="rollNumber" type="text" placeholder="CS2024-042" style="padding: 8px 12px; font-size: 0.88rem; border-radius: 12px;"/>
                    </div>
                </div>

                <!-- Side-by-Side: Branch + Year -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 10px;" id="studentAcademicGroup">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="branch" style="font-size: 0.7rem;">Branch</label>
                        <select class="form-select" id="branch" style="padding: 8px 36px 8px 12px; font-size: 0.88rem; border-radius: 12px;">
                            <option value="Computer Science">Computer Sci</option>
                            <option value="Information Tech">Info Tech</option>
                            <option value="Electronics">Electronics</option>
                            <option value="Design">Design</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="yearOfStudy" style="font-size: 0.7rem;">Year of Study</label>
                        <select class="form-select" id="yearOfStudy" style="padding: 8px 36px 8px 12px; font-size: 0.88rem; border-radius: 12px;">
                            <option value="1st Year">1st Year</option>
                            <option value="2nd Year">2nd Year</option>
                            <option value="3rd Year">3rd Year</option>
                            <option value="4th Year">4th Year</option>
                            <option value="5th Year">5th Year</option>
                        </select>
                    </div>
                </div>

                <!-- Password -->
                <div class="form-group" style="margin-bottom: 12px;">
                    <label class="form-label" for="password" style="font-size: 0.7rem;">Password</label>
                    <input class="form-input" id="password" type="password" placeholder="Create a strong password" style="padding: 8px 12px; font-size: 0.88rem; border-radius: 12px;" required/>
                </div>

                <!-- Submit -->
                <button class="btn btn-primary animate-pulse-glow" type="submit" style="width: 100%; padding: 10px; font-size: 0.88rem; margin-top: 4px;">
                    <span class="material-symbols-outlined animate-wiggle" style="font-size: 16px;">send</span>
                    REGISTER &amp; SEND OTP 🚀
                </button>
            </form>

            <div style="text-align: center; padding-top: 12px; margin-top: 14px; border-top: 2px dashed var(--accent);">
                <p class="label-sm text-muted" style="font-size: 11px;">
                    Already registered? <a href="<c:url value='/login'/>" style="color: var(--secondary); font-weight: 800; text-decoration: underline;">Log In here 🔑</a>
                </p>
            </div>
        </div>
    </main>

    <%@ include file="footer.jspf" %>

<script>
function toggleStudentFields() {
    const role = document.getElementById('role').value;
    const rollGroup = document.getElementById('rollNumberGroup');
    const academicGroup = document.getElementById('studentAcademicGroup');
    if (role === 'PARTICIPANT') {
        rollGroup.style.display = 'block';
        academicGroup.style.display = 'grid';
    } else {
        rollGroup.style.display = 'none';
        academicGroup.style.display = 'none';
    }
}

async function handleRegisterSubmit(event) {
    event.preventDefault();
    const email = document.getElementById('email').value;
    const payload = {
        role: document.getElementById('role').value,
        fullName: document.getElementById('fullName').value,
        email: email,
        username: document.getElementById('username').value,
        rollNumber: document.getElementById('rollNumber').value,
        branch: document.getElementById('branch').value,
        yearOfStudy: document.getElementById('yearOfStudy').value,
        password: document.getElementById('password').value
    };

    const errorAlert = document.getElementById('errorAlert');
    const errorMessage = document.getElementById('errorMessage');
    errorAlert.style.display = 'none';

    try {
        const response = await fetch('<c:url value="/api/auth/register"/>', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        const data = await response.json();

        if (response.ok) {
            window.location.href = '<c:url value="/verify-otp"/>?email=' + encodeURIComponent(email);
        } else {
            errorMessage.textContent = data.message || 'Registration failed.';
            errorAlert.style.display = 'flex';
        }
    } catch (err) {
        errorMessage.textContent = 'Server error. Please try again.';
        errorAlert.style.display = 'flex';
    }
}
</script>
</body>
</html>
