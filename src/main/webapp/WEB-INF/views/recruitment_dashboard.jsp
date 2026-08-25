<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Team Lead &amp; Recruitment Dashboard 📊</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Watermark -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(255,58,242,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        DASHBOARD
    </div>

    <main class="main-content" style="position: relative; z-index: 1;">
        
        <div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 16px; margin-bottom: 28px;">
            <div>
                <span class="chip chip-primary animate-pulse-glow" style="margin-bottom: 8px;">
                    <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 14px;">leaderboard</span> RECRUITMENT MANAGEMENT
                </span>
                <h1 class="h1" style="font-size: clamp(2rem, 4.5vw, 3rem); color: #FFF;">
                    TEAM RECRUITMENT <span class="gradient-text">DASHBOARD 📊</span>
                </h1>
                <p class="text-muted" style="font-size: 15px; margin-top: 4px;">
                    Manage your active team listings, review candidate applications, and respond to invitations.
                </p>
            </div>

            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                <a href="<c:url value='/profile/talent-search'/>" class="btn btn-secondary">
                    <span class="material-symbols-outlined">person_search</span> DISCOVER TALENT 🔍
                </a>
                <a href="<c:url value='/recruitment/create'/>" class="btn btn-primary animate-pulse-glow">
                    <span class="material-symbols-outlined">add_circle</span> CREATE LISTING 🚀
                </a>
            </div>
        </div>

        <!-- Success/Error Alert -->
        <c:if test="${not empty successMessage}">
            <div class="alert-banner success" style="margin-bottom: 20px;">
                <span class="material-symbols-outlined">check_circle</span>
                <span>${successMessage}</span>
            </div>
        </c:if>

        <!-- Stats Bento Grid -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 32px;">
            <div class="glass-panel pattern-checker" style="padding: 22px; border-color: var(--accent); border-radius: 20px;">
                <span class="label-sm" style="color: var(--accent); font-size: 10.5px; display: block; margin-bottom: 6px;">MY RECRUITMENT POSTS</span>
                <div class="stat-lg" style="color: #FFF;">${myPosts.size()}</div>
            </div>

            <div class="glass-panel pattern-checker" style="padding: 22px; border-color: var(--secondary); border-radius: 20px;">
                <span class="label-sm" style="color: var(--secondary); font-size: 10.5px; display: block; margin-bottom: 6px;">SUBMITTED APPLICATIONS</span>
                <div class="stat-lg" style="color: #FFF;">${myApplications.size()}</div>
            </div>

            <div class="glass-panel pattern-checker" style="padding: 22px; border-color: var(--tertiary); border-radius: 20px;">
                <span class="label-sm" style="color: var(--tertiary); font-size: 10.5px; display: block; margin-bottom: 6px;">PENDING INVITATIONS</span>
                <div class="stat-lg" style="color: #FFF;">${myInvitations.size()}</div>
            </div>
        </div>

        <!-- Section 1: My Recruitment Listings (Team Lead) -->
        <div style="margin-bottom: 36px;">
            <h3 class="h3" style="color: #FFF; margin-bottom: 16px; font-size: 1.35rem;">MY ACTIVE RECRUITMENT LISTINGS 👑</h3>

            <c:choose>
                <c:when test="${empty myPosts}">
                    <div class="glass-panel" style="padding: 32px; text-align: center; border-color: var(--secondary);">
                        <p class="text-muted">You haven't posted any team recruitment listings yet.</p>
                    </div>
                </c:when>

                <c:otherwise>
                    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 20px;">
                        <c:forEach items="${myPosts}" var="post">
                            <div class="glass-panel pattern-stripes" style="padding: 22px; border-color: var(--accent); border-radius: 20px;">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                                    <span class="chip chip-tertiary" style="font-size: 10px;">${post.hackathon.title}</span>
                                    <span class="chip ${post.status == 'OPEN' ? 'chip-secondary' : 'chip-quaternary'}" style="font-size: 10px;">${post.status}</span>
                                </div>
                                <h4 class="h4" style="color: #FFF; font-size: 1.15rem; margin-bottom: 8px;">${post.title}</h4>
                                <p class="text-muted label-sm" style="font-size: 11px; margin-bottom: 14px;">Team Capacity: ${post.currentSize} / ${post.maxSize} Members</p>

                                <a href="<c:url value='/recruitment/manage/${post.id}'/>" class="btn btn-primary" style="width: 100%; padding: 8px; font-size: 0.8rem;">
                                    MANAGE APPLICATIONS ⚡
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Section 2: My Applications Sent -->
        <div style="margin-bottom: 36px;">
            <h3 class="h3" style="color: #FFF; margin-bottom: 16px; font-size: 1.35rem;">MY SUBMITTED APPLICATIONS 📩</h3>

            <c:choose>
                <c:when test="${empty myApplications}">
                    <div class="glass-panel" style="padding: 32px; text-align: center; border-color: var(--accent);">
                        <p class="text-muted">You haven't submitted any applications to join teams yet.</p>
                        <a href="<c:url value='/recruitment/browse'/>" class="btn btn-outline" style="margin-top: 12px; padding: 8px 16px; font-size: 12px;">BROWSE MARKETPLACE →</a>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="glass-panel" style="padding: 16px; border-color: var(--secondary); border-radius: 20px;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>TEAM / LISTING TITLE</th>
                                    <th>HACKATHON</th>
                                    <th>STATUS</th>
                                    <th>DATE SUBMITTED</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${myApplications}" var="app">
                                    <tr>
                                        <td><strong>${app.recruitmentPost.title}</strong></td>
                                        <td>${app.recruitmentPost.hackathon.title}</td>
                                        <td>
                                            <span class="chip ${app.status == 'ACCEPTED' ? 'chip-secondary' : app.status == 'PENDING' ? 'chip-tertiary' : 'chip-quaternary'}">
                                                ${app.status}
                                            </span>
                                        </td>
                                        <td>${app.createdAt.toLocalDate()}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>
