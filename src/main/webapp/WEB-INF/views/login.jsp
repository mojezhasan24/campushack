<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Sign In ⚡</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
    <style>
        /* Additional Micro-Animations for Login */
        .login-hero-pill {
            transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.3s ease;
        }
        .login-hero-pill:hover {
            transform: translateY(-4px) scale(1.04) rotate(1.5deg);
            box-shadow: 0 0 24px rgba(255,58,242,0.5), 6px 6px 0 var(--tertiary) !important;
        }
        .form-input-animated {
            transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1), border-color 0.25s ease, box-shadow 0.25s ease;
        }
        .form-input-animated:focus {
            transform: scale(1.02);
        }
        .tab-btn-animated {
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .tab-btn-animated:active {
            transform: scale(0.94);
        }
    </style>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Massive Background Typography Watermark -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 24vw, 22rem); color: rgba(255,58,242,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        WELCOME
    </div>

    <!-- Floating Decorative Elements with Keyframe Animations -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 14%; left: 4%; font-size: 3.2rem;">🚀</span>
    <span class="deco-shape animate-wiggle animate-delay-2" style="top: 18%; right: 5%; font-size: 3rem;">✨</span>
    <span class="deco-shape animate-spin-slow animate-delay-3" style="bottom: 18%; left: 3%; font-size: 3.5rem;">💫</span>
    <span class="deco-shape animate-pulse-glow animate-delay-4" style="bottom: 12%; right: 4%; font-size: 3.2rem;">⚡</span>
    <span class="deco-shape animate-bounce animate-delay-5" style="top: 45%; right: 2%; font-size: 2.5rem;">🏆</span>
    <span class="deco-shape animate-float-reverse animate-delay-2" style="top: 55%; left: 2%; font-size: 2.6rem;">🔒</span>

    <main class="main-content" style="display: flex; justify-content: center; align-items: center; position: relative; z-index: 1;">
        
        <div style="width: 100%; max-width: 1040px; display: grid; grid-template-columns: 1fr 450px; gap: 36px; align-items: center;" class="col-2">
            
            <!-- Left Hero Section -->
            <div style="display: flex; flex-direction: column; gap: 18px;" class="animate-float-slow">
                <span class="chip chip-tertiary animate-pulse-glow" style="align-self: flex-start; font-size: 11px; padding: 5px 14px; cursor: default;">
                    <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 15px;">bolt</span> THE ULTIMATE HACKATHON ARENA
                </span>
                
                <h1 class="h1" style="font-size: clamp(2.6rem, 5.5vw, 4.5rem); line-height: 1.05; color: #FFFFFF;">
                    WHERE IDEAS <br/><span class="gradient-text">COMPETE ⚡</span>
                </h1>
                
                <p class="text-muted" style="font-size: 18px; font-weight: 500; max-width: 480px; line-height: 1.65;">
                    Join the collegiate innovation ecosystem. Build groundbreaking projects, collaborate in real-time, and win amazing prize pools.
                </p>

                <!-- Interactive Animated Feature Badges -->
                <div style="display: flex; gap: 12px; flex-wrap: wrap; margin-top: 6px;">
                    <div class="login-hero-pill" style="padding: 10px 16px; background: rgba(45,27,78,0.7); border: 3px solid var(--accent); border-radius: 14px; display: flex; align-items: center; gap: 10px; box-shadow: 4px 4px 0 var(--tertiary); cursor: pointer;">
                        <span class="material-symbols-outlined animate-wiggle" style="color: var(--accent); font-size: 20px;">shield_lock</span>
                        <span style="font-size: 13px; font-weight: 800; color: #FFF;">OTP Authenticated</span>
                    </div>
                    <div class="login-hero-pill" style="padding: 10px 16px; background: rgba(45,27,78,0.7); border: 3px solid var(--secondary); border-radius: 14px; display: flex; align-items: center; gap: 10px; box-shadow: 4px 4px 0 var(--quinary); cursor: pointer;">
                        <span class="material-symbols-outlined animate-bounce" style="color: var(--secondary); font-size: 20px;">leaderboard</span>
                        <span style="font-size: 13px; font-weight: 800; color: #FFF;">Live Telemetry</span>
                    </div>
                </div>
            </div>

            <!-- Right Login Card with Animated Glass Frame -->
            <div class="glass-panel pattern-checker" style="padding: 30px 26px; border-color: var(--accent); border-radius: 24px; box-shadow: 6px 6px 0 var(--tertiary), 14px 14px 0 var(--quinary); background: rgba(13,13,26,0.88); backdrop-filter: blur(20px);">
                
                <!-- Card Header -->
                <div style="text-align: center; margin-bottom: 18px;">
                    <div style="width: 54px; height: 54px; border-radius: 16px; border: 3px solid var(--tertiary); background: linear-gradient(135deg, var(--quinary), var(--accent)); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 8px; box-shadow: 0 0 20px rgba(255,58,242,0.6);" class="animate-bounce">
                        <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 28px; color: #FFF;">code_blocks</span>
                    </div>
                    <h2 class="h2" style="font-family: var(--font-display); font-size: 1.85rem; margin-bottom: 2px; background: linear-gradient(90deg, var(--accent), var(--secondary), var(--tertiary)); -webkit-background-clip: text; background-clip: text; -webkit-text-fill-color: transparent;">CAMPUSHACK</h2>
                    <p class="text-muted label-sm" style="font-size: 11.5px; color: rgba(255,255,255,0.75);">SIGN IN TO YOUR DASHBOARD</p>
                </div>

                <!-- Role Selector Tabs -->
                <div class="tab-container" style="margin-bottom: 16px;">
                    <button type="button" id="tabStudent" onclick="switchTab('STUDENT')" class="tab-btn tab-btn-animated active">
                        🎓 STUDENT
                    </button>
                    <button type="button" id="tabFaculty" onclick="switchTab('FACULTY')" class="tab-btn tab-btn-animated">
                        🛡️ FACULTY / ADMIN
                    </button>
                </div>

                <!-- Error Alert Row -->
                <div id="errorRow" class="alert-banner error" style="display: none; margin-bottom: 14px; animation: bounce-subtle 0.4s ease;">
                    <span class="material-symbols-outlined" style="font-size: 18px;">error</span>
                    <span id="errorMsg">Invalid credentials. Please try again.</span>
                </div>

                <!-- Form -->
                <form id="loginForm" onsubmit="handleLogin(event)" novalidate autocomplete="on">
                    
                    <!-- Identifier Field -->
                    <div class="form-group" style="margin-bottom: 12px;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <label class="form-label" id="identifierLabel" for="loginIdentifier">Roll Number</label>
                        </div>
                        <input class="form-input form-input-animated" id="loginIdentifier" type="text"
                               placeholder="Enter your roll number"
                               style="border-color: var(--secondary); font-size: 0.95rem; padding: 10px 14px;"
                               autocomplete="username" required/>
                    </div>

                    <!-- Password Field -->
                    <div class="form-group" style="margin-bottom: 14px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2px;">
                            <label class="form-label" for="password">Password</label>
                            <span style="font-size: 11px; font-weight: 700; color: var(--secondary); cursor: pointer; text-decoration: underline;"
                                  onclick="alert('For password resets, please re-register or contact your CampusHack administrator.')">Forgot password?</span>
                        </div>
                        <div style="position: relative;">
                            <input class="form-input form-input-animated" id="password" type="password"
                                   placeholder="••••••••••••••••"
                                   style="border-color: var(--secondary); padding: 10px 44px 10px 14px; font-size: 0.95rem;"
                                   autocomplete="current-password" required/>
                            <button type="button" onclick="togglePwd()" aria-label="Show/hide password"
                                    style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); background: none; border: none; color: var(--accent); cursor: pointer; display: flex; align-items: center; padding: 4px; transition: transform 0.2s ease;"
                                    onmouseover="this.style.transform='translateY(-50%) scale(1.2)'"
                                    onmouseout="this.style.transform='translateY(-50%) scale(1)'">
                                <span class="material-symbols-outlined" id="eyeIcon" style="font-size: 20px;">visibility</span>
                            </button>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" id="loginBtn" class="btn btn-primary animate-pulse-glow" style="width: 100%; margin-top: 6px; padding: 12px; font-size: 0.95rem;">
                        <span class="spinner" id="spinner" style="display: none; width: 16px; height: 16px; border: 3px solid rgba(255,255,255,0.3); border-top-color: #FFF; border-radius: 50%; animation: spin-slow 0.6s linear infinite;"></span>
                        <span class="material-symbols-outlined animate-wiggle" style="font-size: 18px;">login</span>
                        <span id="btnText">LOG IN NOW 🚀</span>
                    </button>
                </form>

                <!-- Links Footer -->
                <div style="display: flex; flex-direction: column; gap: 6px; text-align: center; margin-top: 16px; padding-top: 14px; border-top: 2px dashed var(--accent);">
                    <p class="label-sm text-muted" style="font-size: 11.5px;">
                        New student? <a href="<c:url value='/register'/>" style="color: var(--secondary); font-weight: 800; text-decoration: underline;">Register here 🚀</a>
                    </p>
                    <p class="label-sm text-muted" style="font-size: 11.5px;">
                        Need to verify email? <a href="<c:url value='/verify-otp'/>" style="color: var(--tertiary); font-weight: 800; text-decoration: underline;">Enter OTP 🔑</a>
                    </p>
                </div>

            </div>

        </div>

    </main>

    <%@ include file="footer.jspf" %>

<script>
const roleConfig = {
    STUDENT: { label: 'Roll Number',       placeholder: 'Enter your roll number' },
    FACULTY: { label: 'Username / Email',  placeholder: 'Enter your username or email' }
};
let currentRole = 'STUDENT';

function switchTab(role) {
    currentRole = role;
    const tabStu = document.getElementById('tabStudent');
    const tabFac = document.getElementById('tabFaculty');
    
    if (role === 'STUDENT') {
        tabStu.classList.add('active');
        tabFac.classList.remove('active');
    } else {
        tabFac.classList.add('active');
        tabStu.classList.remove('active');
    }

    const cfg = roleConfig[role];
    document.getElementById('identifierLabel').textContent = cfg.label;
    document.getElementById('loginIdentifier').placeholder = cfg.placeholder;
    document.getElementById('loginIdentifier').focus();
}

// Initialize default active tab styles
document.addEventListener('DOMContentLoaded', () => {
    switchTab('STUDENT');
});

function togglePwd() {
    const inp  = document.getElementById('password');
    const icon = document.getElementById('eyeIcon');
    const show = inp.type === 'password';
    inp.type         = show ? 'text' : 'password';
    icon.textContent = show ? 'visibility_off' : 'visibility';
}

async function handleLogin(e) {
    e.preventDefault();
    const loginIdentifier = document.getElementById('loginIdentifier').value.trim();
    const password        = document.getElementById('password').value;
    const errorRow        = document.getElementById('errorRow');
    const errorMsg        = document.getElementById('errorMsg');
    const btn             = document.getElementById('loginBtn');
    const spinner         = document.getElementById('spinner');
    const btnText         = document.getElementById('btnText');

    errorRow.style.display = 'none';
    if (!loginIdentifier || !password) {
        errorMsg.textContent = 'Please fill in all fields.';
        errorRow.style.display = 'flex';
        return;
    }

    btn.disabled          = true;
    spinner.style.display = 'inline-block';
    btnText.textContent   = 'SIGNING IN…';

    try {
        const res  = await fetch('<c:url value="/api/auth/login"/>', {
            method:  'POST',
            headers: { 'Content-Type': 'application/json' },
            body:    JSON.stringify({ loginIdentifier, password })
        });
        const data = await res.json();

        if (res.ok) {
            btnText.textContent = 'REDIRECTING…';
            const role = data.user.role;
            if (role === 'ADMIN')      window.location.href = '<c:url value="/admin/analytics"/>';
            else if (role === 'JUDGE') window.location.href = '<c:url value="/judge/eval"/>';
            else                       window.location.href = '<c:url value="/dashboard"/>';
        } else {
            const msg = data.message || 'Invalid credentials. Please try again.';
            if (res.status === 403 || msg.toLowerCase().includes('not verified')) {
                const enc = encodeURIComponent(loginIdentifier);
                errorMsg.innerHTML = msg + ' <a href="<c:url value="/verify-otp"/>?email=' + enc
                    + '" style="color:var(--secondary); font-weight:800; text-decoration:underline; margin-left:6px;">Verify OTP →</a>';
            } else {
                errorMsg.textContent = msg;
            }
            errorRow.style.display = 'flex';
            btn.disabled          = false;
            spinner.style.display = 'none';
            btnText.textContent   = 'LOG IN NOW 🚀';
        }
    } catch (err) {
        errorMsg.textContent  = 'Server error. Please try again.';
        errorRow.style.display = 'flex';
        btn.disabled          = false;
        spinner.style.display = 'none';
        btnText.textContent   = 'LOG IN NOW 🚀';
    }
}
</script>
</body>
</html>
