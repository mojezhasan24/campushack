<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - User Management ⚡</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Massive Background Typography -->
    <div class="watermark-bg" style="position: fixed; top: 120px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 20vw, 18rem); color: rgba(0,245,212,0.03); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        MEMBERS
    </div>

    <!-- Floating Decorative Shapes -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 18%; right: 5%; font-size: 2.8rem;">👥</span>
    <span class="deco-shape animate-wiggle animate-delay-2" style="top: 40%; left: 2%; font-size: 2.5rem;">⚡</span>
    <span class="deco-shape animate-bounce animate-delay-3" style="bottom: 25%; right: 4%; font-size: 3rem;">🛡️</span>

    <main class="main-content" style="position: relative; z-index: 1;">

        <!-- Page Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; flex-wrap: wrap; gap: 16px;">
            <div>
                <span class="chip chip-secondary animate-pulse-glow" style="margin-bottom: 10px; font-size: 11px;">
                    <span class="material-symbols-outlined icon-filled" style="font-size: 14px;">admin_panel_settings</span> Access &amp; Permissions Control
                </span>
                <h1 class="h1" style="margin-top: 4px;">USER MANAGEMENT <span class="gradient-text">👥</span></h1>
                <p class="text-muted" style="font-size: 17px; font-weight: 500; margin-top: 4px;">Manage system accounts, verify registrations, reset passwords, and update role access.</p>
            </div>
        </div>

        <!-- Flash Alert Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert-banner success" style="margin-bottom: 24px;">
                <span class="material-symbols-outlined">check_circle</span>
                <span>${successMessage}</span>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert-banner error" style="margin-bottom: 24px;">
                <span class="material-symbols-outlined">error</span>
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <!-- Search and Filter Bar -->
        <form action="<c:url value='/admin/users'/>" method="GET" class="glass-panel pattern-checker" style="padding: 20px 28px; margin-bottom: 32px; border-color: var(--secondary); border-radius: 20px;">
            <div style="display: flex; gap: 16px; flex-wrap: wrap; align-items: center;">
                <div style="flex: 1; min-width: 260px;">
                    <input class="form-input" name="search" type="text" placeholder="Search by username, email, or full name..." value="${search}"/>
                </div>
                <div style="width: 220px;">
                    <select class="form-select" name="role" onchange="this.form.submit()" style="border-width: 3px;">
                        <option value="">All Roles</option>
                        <option value="PARTICIPANT" ${selectedRole == 'PARTICIPANT' ? 'selected' : ''}>Student / Participant</option>
                        <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>Faculty / Admin</option>

                    </select>
                </div>
                <button type="submit" class="btn btn-primary" style="padding: 10px 22px; font-size: 13px;">
                    <span class="material-symbols-outlined" style="font-size: 18px;">search</span>
                    FILTER USERS 🔍
                </button>
                <c:if test="${not empty search || not empty selectedRole}">
                    <a href="<c:url value='/admin/users'/>" class="btn btn-outline" style="padding: 10px 18px; font-size: 13px;">RESET 🔄</a>
                </c:if>
            </div>
        </form>

        <!-- Users Data Table -->
        <section class="glass-panel" style="overflow: hidden; border-color: var(--accent); border-radius: 24px;">
            <div style="padding: 22px 28px; border-bottom: 4px solid var(--accent); background: rgba(255,58,242,0.15); display: flex; justify-content: space-between; align-items: center;">
                <h3 class="h3" style="color: #FFFFFF;">DATABASE REGISTERED ACCOUNTS</h3>
                <span class="chip chip-tertiary">${users != null ? users.size() : 0} TOTAL RECORDS</span>
            </div>

            <div style="overflow-x: auto;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>User Profile</th>
                            <th>Academic Info</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Registered On</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td><strong style="color: var(--tertiary);">#${u.id}</strong></td>
                                <td>
                                    <strong style="font-size: 1rem; color: var(--fg);">${u.fullName != null ? u.fullName : u.username}</strong>
                                    <div class="text-muted label-sm" style="font-size: 12px; margin-top: 2px;">@${u.username} • ${u.email}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty u.branch}">
                                            <div style="font-size: 14px; font-weight: 700; color: var(--secondary);">${u.branch}</div>
                                            <div class="text-muted label-sm" style="font-size: 11px;">${u.yearOfStudy} ${not empty u.rollNumber ? '• ' : ''}${u.rollNumber}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted label-sm">N/A</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.role == 'ADMIN'}"><span class="chip chip-primary">ADMIN 🛡️</span></c:when>

                                        <c:otherwise><span class="chip chip-secondary">PARTICIPANT 🚀</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.enabled}">
                                            <span class="chip chip-secondary" style="font-size: 11px;">VERIFIED ✅</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="chip chip-error animate-pulse-glow" style="font-size: 11px;">UNVERIFIED ⚠️</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="text-muted label-sm" style="font-size: 12px; color: var(--secondary); font-weight: 600;">${u.formattedCreatedAt}</span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 8px; align-items: center; flex-wrap: nowrap;">

                                        <!-- Enable / Disable Toggle -->
                                        <c:choose>
                                            <c:when test="${sessionScope.user.id == u.id}">
                                                <span class="chip chip-quinary" style="font-size: 10px;">Self Account</span>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="<c:url value='/admin/users/toggle-enable/${u.id}'/>" method="POST" style="margin: 0;">
                                                    <button type="submit" class="btn ${u.enabled ? 'btn-danger' : 'btn-primary'}" style="padding: 6px 12px; font-size: 11px;">
                                                        ${u.enabled ? 'Disable 🚫' : 'Approve ✅'}
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Change Role Dropdown -->
                                        <c:choose>
                                            <c:when test="${sessionScope.user.id == u.id}">
                                                <span class="text-muted label-sm" style="font-size: 11px;">(Admin)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="<c:url value='/admin/users/change-role/${u.id}'/>" method="POST" style="margin: 0;">
                                                    <select name="newRole" class="form-select" style="padding: 6px 10px; font-size: 11px; width: auto; border-width: 2px;" onchange="this.form.submit()">
                                                        <option value="PARTICIPANT" ${u.role == 'PARTICIPANT' ? 'selected' : ''}>Participant</option>
                                                        <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>Admin</option>

                                                    </select>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Admin Password View & Reset Button -->
                                        <button type="button" class="btn btn-tertiary" style="padding: 6px 12px; font-size: 11px;" onclick="openPasswordModal(${u.id}, '${u.username}', '${u.email}', '${u.password}')">
                                            🔑 Password
                                        </button>

                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 48px;" class="text-muted">
                                    No user accounts matching the search criteria were found in the database.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>

    </main>

    <!-- Admin Password Management Modal -->
    <div id="passwordModal" style="display: none; position: fixed; inset: 0; background: rgba(13,13,26,0.85); backdrop-filter: blur(8px); z-index: 9999; align-items: center; justify-content: center; padding: 20px;">
        <div class="glass-panel pattern-checker" style="width: 100%; max-width: 480px; padding: 32px; border-color: var(--secondary); border-radius: 24px; position: relative;">
            
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h3 class="h3" style="color: #FFF; font-size: 1.3rem;">🔑 MANAGE USER PASSWORD</h3>
                <button type="button" onclick="closePasswordModal()" style="background: none; border: none; color: var(--fg); cursor: pointer; font-size: 20px;">✕</button>
            </div>

            <div style="margin-bottom: 20px; padding: 12px 16px; background: rgba(0,245,212,0.1); border: 2px dashed var(--secondary); border-radius: 14px;">
                <span style="color: var(--secondary); font-weight: 800; font-size: 13px; display: block;">TARGET ACCOUNT:</span>
                <span id="modalUsername" style="color: #FFF; font-weight: 700; font-size: 15px;"></span>
                <span id="modalEmail" class="text-muted" style="font-size: 12px; display: block;"></span>
            </div>

            <!-- Current Password View (Admin Only) -->
            <div style="margin-bottom: 20px;">
                <label class="form-label" style="font-size: 12px; color: var(--tertiary);">CURRENT STORED PASSWORD (ADMIN VIEW) 👁️</label>
                <div style="display: flex; gap: 8px;">
                    <input type="password" id="modalCurrentPassword" class="form-input" readonly style="font-family: monospace; font-size: 15px; font-weight: 700; letter-spacing: 1px; color: #00F5D4; background: rgba(13,13,26,0.8);"/>
                    <button type="button" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px;" onclick="toggleCurrentPasswordVisibility()">
                        <span id="eyeIcon" class="material-symbols-outlined" style="font-size: 18px;">visibility</span>
                    </button>
                </div>
            </div>

            <!-- Change Password Form -->
            <form id="passwordForm" action="" method="POST">
                <div class="form-group" style="margin-bottom: 20px;">
                    <label class="form-label" style="font-size: 12px; color: var(--accent);">SET CUSTOM NEW PASSWORD ✏️</label>
                    <div style="display: flex; gap: 8px;">
                        <input type="text" name="newPassword" id="modalNewPassword" class="form-input" placeholder="Enter custom new password..." required style="font-family: monospace; font-size: 14px;"/>
                        <button type="button" class="btn btn-tertiary" style="padding: 6px 12px; font-size: 11px; white-space: nowrap;" onclick="generateRandomPassword()">
                            ⚡ Auto
                        </button>
                    </div>
                </div>

                <div style="display: flex; gap: 12px; justify-content: flex-end; margin-top: 24px;">
                    <button type="button" class="btn btn-outline" onclick="closePasswordModal()" style="padding: 10px 18px; font-size: 12px;">CANCEL</button>
                    <button type="submit" class="btn btn-primary animate-pulse-glow" style="padding: 10px 22px; font-size: 12px;">SAVE NEW PASSWORD 💾</button>
                </div>
            </form>

        </div>
    </div>

    <script>
        function openPasswordModal(id, username, email, currentPassword) {
            document.getElementById('modalUsername').innerText = '@' + username;
            document.getElementById('modalEmail').innerText = email;
            document.getElementById('modalCurrentPassword').value = currentPassword;
            document.getElementById('modalCurrentPassword').type = 'password';
            document.getElementById('eyeIcon').innerText = 'visibility';
            document.getElementById('modalNewPassword').value = '';
            document.getElementById('passwordForm').action = '<c:url value="/admin/users/change-password/"/>' + id;
            document.getElementById('passwordModal').style.display = 'flex';
        }

        function closePasswordModal() {
            document.getElementById('passwordModal').style.display = 'none';
        }

        function toggleCurrentPasswordVisibility() {
            const pwdInput = document.getElementById('modalCurrentPassword');
            const eyeIcon = document.getElementById('eyeIcon');
            if (pwdInput.type === 'password') {
                pwdInput.type = 'text';
                eyeIcon.innerText = 'visibility_off';
            } else {
                pwdInput.type = 'password';
                eyeIcon.innerText = 'visibility';
            }
        }

        function generateRandomPassword() {
            const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*';
            let pwd = 'Hack#2026!';
            for (let i = 0; i < 4; i++) {
                pwd += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            document.getElementById('modalNewPassword').value = pwd;
        }
    </script>

    <%@ include file="footer.jspf" %>

</body>
</html>
