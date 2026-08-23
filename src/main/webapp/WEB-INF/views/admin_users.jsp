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
    <span class="deco-shape animate-bounce animate-delay-3" style="bottom: 15%; right: 3%; font-size: 3rem;">🛡️</span>

    <main class="main-content" style="position: relative; z-index: 1;">

        <!-- Page Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; flex-wrap: wrap; gap: 16px;">
            <div>
                <span class="chip chip-secondary animate-pulse-glow" style="margin-bottom: 10px; font-size: 11px;">
                    <span class="material-symbols-outlined icon-filled" style="font-size: 14px;">admin_panel_settings</span> Access &amp; Permissions Control
                </span>
                <h1 class="h1" style="margin-top: 4px;">USER MANAGEMENT <span class="gradient-text">👥</span></h1>
                <p class="text-muted" style="font-size: 18px; font-weight: 500; margin-top: 6px;">Manage system accounts, verify registrations, and update role access.</p>
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
        <form action="<c:url value='/admin/users'/>" method="GET" class="glass-panel pattern-checker" style="padding: 24px; margin-bottom: 32px; display: flex; gap: 20px; flex-wrap: wrap; align-items: center; border-color: var(--secondary);">
            <div style="flex-grow: 1; max-width: 440px;">
                <input class="form-input" name="search" type="text" placeholder="Search by username, email, or full name..." value="${search}"/>
            </div>
            <select class="form-select" style="width: 220px;" name="role" onchange="this.form.submit()">
                <option value="">All Roles</option>
                <option value="PARTICIPANT" ${selectedRole == 'PARTICIPANT' ? 'selected' : ''}>Student / Participant</option>
                <option value="ADMIN" ${selectedRole == 'ADMIN' ? 'selected' : ''}>Faculty / Admin</option>
                <option value="JUDGE" ${selectedRole == 'JUDGE' ? 'selected' : ''}>Judge</option>
            </select>
            <button type="submit" class="btn btn-primary" style="padding: 12px 24px;">
                <span class="material-symbols-outlined">search</span>
                FILTER USERS 🔍
            </button>
            <c:if test="${not empty search || not empty selectedRole}">
                <a href="<c:url value='/admin/users'/>" class="btn btn-outline" style="padding: 12px 20px;">RESET 🔄</a>
            </c:if>
        </form>

        <!-- Users Data Table -->
        <section class="glass-panel" style="overflow: hidden; border-color: var(--accent);">
            <div style="padding: 24px 32px; border-bottom: 4px solid var(--accent); background: rgba(255,58,242,0.15); display: flex; justify-content: space-between; align-items: center;">
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
                                        <c:when test="${u.role == 'JUDGE'}"><span class="chip chip-tertiary">JUDGE ⚖️</span></c:when>
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
                                    <span class="text-muted label-sm">${u.createdAt != null ? u.createdAt : 'System Initialized'}</span>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 10px; align-items: center;">

                                        <!-- Enable / Disable Toggle -->
                                        <c:choose>
                                            <c:when test="${sessionScope.user.id == u.id}">
                                                <span class="chip chip-quinary" style="font-size: 10px;">Self Account</span>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="<c:url value='/admin/users/toggle-enable/${u.id}'/>" method="POST" style="margin: 0;">
                                                    <button type="submit" class="btn ${u.enabled ? 'btn-danger' : 'btn-primary'}" style="padding: 6px 14px; font-size: 11px;">
                                                        ${u.enabled ? 'Disable 🚫' : 'Approve ✅'}
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Change Role Form -->
                                        <c:choose>
                                            <c:when test="${sessionScope.user.id == u.id}">
                                                <span class="text-muted label-sm" style="font-size: 11px;">(Admin)</span>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="<c:url value='/admin/users/change-role/${u.id}'/>" method="POST" style="margin: 0; display: flex; gap: 4px;">
                                                    <select name="newRole" class="form-select" style="padding: 6px 12px; font-size: 12px; width: auto; border-width: 3px;" onchange="this.form.submit()">
                                                        <option value="PARTICIPANT" ${u.role == 'PARTICIPANT' ? 'selected' : ''}>Participant</option>
                                                        <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                                        <option value="JUDGE" ${u.role == 'JUDGE' ? 'selected' : ''}>Judge</option>
                                                    </select>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
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

    <%@ include file="footer.jspf" %>

</body>
</html>
