<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Talent Search Marketplace 🔍</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Watermark -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(0,245,212,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        TALENT
    </div>

    <main class="main-content" style="position: relative; z-index: 1;">
        
        <div style="margin-bottom: 28px;">
            <span class="chip chip-secondary animate-pulse-glow" style="margin-bottom: 8px;">
                <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 14px;">person_search</span> TALENT MARKETPLACE
            </span>
            <h1 class="h1" style="font-size: clamp(2rem, 4.5vw, 3.2rem); color: #FFF;">
                DISCOVER AVAILABLE <span class="gradient-text">TEAMMATES 🔍</span>
            </h1>
            <p class="text-muted" style="font-size: 16px; margin-top: 4px;">
                Browse participants who are actively looking for a team to join.
            </p>
        </div>

        <c:choose>
            <c:when test="${empty candidates}">
                <div class="glass-panel" style="padding: 48px; text-align: center; border-color: var(--secondary);">
                    <span class="material-symbols-outlined" style="font-size: 56px; color: var(--secondary); margin-bottom: 8px;">sentiment_dissatisfied</span>
                    <h3 class="h3" style="color: #FFF;">NO CANDIDATES AVAILABLE RIGHT NOW</h3>
                    <p class="text-muted" style="margin-top: 4px;">Check back soon or post a recruitment listing to get applications.</p>
                </div>
            </c:when>

            <c:otherwise>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 24px;">
                    <c:forEach items="${candidates}" var="c">
                        <div class="glass-panel pattern-checker" style="padding: 24px; border-color: var(--secondary); border-radius: 20px; display: flex; flex-direction: column; justify-content: space-between;">
                            
                            <div>
                                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 12px;">
                                    <div style="width: 52px; height: 52px; border-radius: 50%; border: 3px solid var(--secondary); background: linear-gradient(135deg, var(--quinary), var(--accent)); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                        <span class="material-symbols-outlined icon-filled" style="font-size: 28px; color: #FFF;">person</span>
                                    </div>

                                    <div>
                                        <h3 class="h3" style="color: #FFF; font-size: 1.15rem; line-height: 1.2;">${c.user.fullName}</h3>
                                        <span class="text-muted label-sm" style="font-size: 10px;">${c.branch} • ${c.course}</span>
                                    </div>
                                </div>

                                <div style="margin-bottom: 12px;">
                                    <span class="label-sm" style="color: var(--accent); font-size: 10px; display: block; margin-bottom: 4px;">TECHNICAL SKILLS:</span>
                                    <div style="display: flex; flex-wrap: wrap; gap: 6px;">
                                        <c:forEach items="${fn:split(c.skills, ',')}" var="s">
                                            <span class="chip chip-primary" style="font-size: 10px;">${fn:trim(s)}</span>
                                        </c:forEach>
                                    </div>
                                </div>

                                <p class="text-muted" style="font-size: 13px; line-height: 1.5; margin-bottom: 16px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    ${c.bio}
                                </p>
                            </div>

                            <a href="<c:url value='/profile/view/${c.user.id}'/>" class="btn btn-outline" style="width: 100%; padding: 8px; font-size: 0.8rem;">
                                VIEW PROFILE &amp; INVITE 👤
                            </a>

                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>
