<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Notifications Inbox 🔔</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Watermark -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(255,58,242,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        ALERTS
    </div>

    <main class="main-content" style="position: relative; z-index: 1; max-width: 860px; margin: 0 auto;">
        
        <div style="margin-bottom: 24px; text-align: center;">
            <span class="chip chip-secondary animate-pulse-glow" style="margin-bottom: 8px;">
                <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 14px;">notifications</span> REAL-TIME INBOX
            </span>
            <h1 class="h1" style="font-size: 2.2rem; color: #FFF;">
                YOUR <span class="gradient-text">NOTIFICATIONS 🔔</span>
            </h1>
        </div>

        <c:choose>
            <c:when test="${empty notifications}">
                <div class="glass-panel" style="padding: 48px; text-align: center; border-color: var(--secondary);">
                    <span class="material-symbols-outlined" style="font-size: 56px; color: var(--secondary); margin-bottom: 8px;">notifications_off</span>
                    <h3 class="h3" style="color: #FFF;">NO NOTIFICATIONS</h3>
                    <p class="text-muted" style="margin-top: 4px;">You're all caught up! Updates regarding team applications and invitations will appear here.</p>
                </div>
            </c:when>

            <c:otherwise>
                <div style="display: flex; flex-direction: column; gap: 14px;">
                    <c:forEach items="${notifications}" var="n">
                        <div class="glass-panel pattern-checker" style="padding: 20px 24px; border-color: ${n.readStatus ? 'var(--muted)' : 'var(--accent)'}; border-radius: 18px; display: flex; align-items: center; justify-content: space-between; gap: 16px; opacity: ${n.readStatus ? '0.75' : '1'};">
                            
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <div style="width: 44px; height: 44px; border-radius: 50%; border: 2px solid var(--accent); background: rgba(255,58,242,0.15); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                    <span class="material-symbols-outlined" style="color: var(--accent); font-size: 24px;">
                                        ${n.type == 'INVITATION' ? 'mail' : n.type == 'TEAM_UPDATE' ? 'groups' : 'notifications'}
                                    </span>
                                </div>

                                <div>
                                    <p style="color: #FFF; font-weight: 700; font-size: 14.5px; line-height: 1.4;">${n.message}</p>
                                    <span class="text-muted label-sm" style="font-size: 10px;">${n.createdAt.toLocalDate()} • ${n.type}</span>
                                </div>
                            </div>

                            <c:if test="${not empty n.link}">
                                <a href="<c:url value='${n.link}'/>" class="btn btn-primary" style="padding: 6px 14px; font-size: 11px; flex-shrink: 0;">
                                    VIEW DETAILS →
                                </a>
                            </c:if>

                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>
