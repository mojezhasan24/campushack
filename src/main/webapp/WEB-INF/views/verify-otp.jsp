<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Verify Email OTP ⚡</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Massive Background Typography -->
    <div class="watermark-bg" style="position: fixed; top: 120px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 22vw, 20rem); color: rgba(0,245,212,0.03); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        VERIFY
    </div>

    <!-- Floating Decorative Shapes -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 18%; right: 6%; font-size: 3rem;">✉️</span>
    <span class="deco-shape animate-wiggle animate-delay-2" style="top: 38%; left: 4%; font-size: 2.5rem;">⚡</span>
    <span class="deco-shape animate-bounce animate-delay-3" style="bottom: 20%; right: 5%; font-size: 2.8rem;">🔐</span>

    <main class="main-content" style="display: flex; justify-content: center; align-items: center; position: relative; z-index: 1;">
        <div class="glass-panel pattern-stripes" style="width: 100%; max-width: 480px; padding: 36px 32px; border-color: var(--secondary); box-shadow: 8px 8px 0 var(--accent), 16px 16px 0 var(--tertiary);">
            
            <div style="text-align: center; display: flex; flex-direction: column; align-items: center; gap: 12px; margin-bottom: 20px;">
                <div style="width: 64px; height: 64px; border-radius: 50%; border: 3px solid var(--secondary); background: rgba(0,245,212,0.15); display: flex; align-items: center; justify-content: center; box-shadow: 0 0 20px rgba(0,245,212,0.4);">
                    <span class="material-symbols-outlined icon-filled animate-pulse-glow" style="font-size: 32px; color: var(--secondary);">mark_email_read</span>
                </div>
                <h2 class="h2" style="color: #FFF;">VERIFY YOUR EMAIL <span class="gradient-text">✉️</span></h2>
                <p class="text-muted label-sm">Enter the 6-digit OTP code sent to your email address.</p>
            </div>

            <!-- Error Banner -->
            <div id="errorAlert" class="alert-banner error" style="display: none; margin-bottom: 18px;">
                <span class="material-symbols-outlined">error</span>
                <span id="errorMessage">Invalid OTP code.</span>
            </div>

            <!-- Success Banner -->
            <div id="successAlert" class="glass-panel" style="display: none; padding: 24px; border-color: var(--secondary); flex-direction: column; gap: 16px; text-align: center; margin-bottom: 20px;">
                <div style="display: flex; align-items: center; gap: 10px; justify-content: center; font-size: 18px; font-weight: 800; color: var(--secondary);">
                    <span class="material-symbols-outlined" style="font-size: 24px;">check_circle</span>
                    <span>ACCOUNT VERIFIED! 🎉</span>
                </div>
                <p class="text-muted label-sm">Your email has been authenticated. You can now log into CampusHack.</p>
                <a href="<c:url value='/login'/>" class="btn btn-primary" style="width: 100%;">PROCEED TO LOG IN 🚀</a>
            </div>

            <form id="otpForm" onsubmit="handleOtpSubmit(event)" style="display: flex; flex-direction: column; gap: 16px;">
                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input class="form-input" id="email" type="email" placeholder="user@domain.com" required value="${param.email}"/>
                </div>

                <div class="form-group">
                    <label class="form-label" for="otpCode">6-Digit Verification OTP</label>
                    <input class="form-input" id="otpCode" type="text" maxlength="6" pattern="[0-9]{6}" placeholder="123456"
                           style="letter-spacing: 0.35em; text-align: center; font-size: 26px; font-weight: 900; color: var(--tertiary); border-color: var(--tertiary);" required/>
                </div>

                <button class="btn btn-primary" type="submit" style="width: 100%; margin-top: 6px;">
                    <span class="material-symbols-outlined">verified</span>
                    VERIFY ACCOUNT NOW ⚡
                </button>
            </form>

            <div style="text-align: center; padding-top: 18px; margin-top: 20px; border-top: 2px dashed var(--secondary);">
                <p class="label-sm text-muted">
                    Didn't receive code? <a href="<c:url value='/register'/>" style="color: var(--secondary); font-weight: 800; text-decoration: underline;">Register again 🔄</a> or check spam folder.
                </p>
            </div>
        </div>
    </main>

    <%@ include file="footer.jspf" %>

<script>
async function handleOtpSubmit(event) {
    event.preventDefault();
    const email = document.getElementById('email').value;
    const otpCode = document.getElementById('otpCode').value;

    const errorAlert = document.getElementById('errorAlert');
    const errorMessage = document.getElementById('errorMessage');
    const successAlert = document.getElementById('successAlert');
    const otpForm = document.getElementById('otpForm');

    errorAlert.style.display = 'none';

    try {
        const response = await fetch('<c:url value="/api/auth/verify-otp"/>', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, otpCode })
        });
        const data = await response.json();

        if (response.ok) {
            otpForm.style.display = 'none';
            successAlert.style.display = 'flex';
        } else {
            errorMessage.textContent = data.message || 'Invalid or expired OTP.';
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
