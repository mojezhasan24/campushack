<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Discover Hackathons ⚡</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Massive Background Typography -->
    <div class="watermark-bg" style="position: fixed; top: 120px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 22vw, 20rem); color: rgba(0,245,212,0.03); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        DISCOVER
    </div>

    <!-- Floating Decorative Shapes -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 15%; right: 4%; font-size: 3rem;">🚀</span>
    <span class="deco-shape animate-wiggle animate-delay-2" style="top: 32%; left: 3%; font-size: 2.5rem;">✨</span>
    <span class="deco-shape animate-bounce animate-delay-3" style="bottom: 18%; right: 3%; font-size: 2.8rem;">⚡</span>
    <span class="deco-shape animate-float-reverse animate-delay-4" style="bottom: 12%; left: 4%; font-size: 2.2rem;">🎯</span>

    <main class="main-content" style="position: relative; z-index: 1;">

        <!-- Page Header -->
        <section style="margin-bottom: 36px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
            <div>
                <span class="chip chip-secondary animate-pulse-glow" style="margin-bottom: 10px; font-size: 11px;">
                    <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 14px;">radio_button_checked</span> LIVE HACKATHON FEED
                </span>
                <h1 class="h1" style="margin-top: 4px;">DISCOVER HACKATHONS <span class="gradient-text">🚀</span></h1>
                <p class="text-muted" style="font-size: 17px; font-weight: 500; margin-top: 6px;">
                    ${hackathons != null ? hackathons.size() : 0} event(s) available — Register your team and build something incredible.
                </p>
            </div>
        </section>

        <!-- Clean Responsive Card Grid -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(340px, 1fr)); gap: 28px; padding-bottom: 32px; align-items: stretch;">

            <c:forEach var="h" items="${hackathons}" varStatus="loop">
                <div class="glass-panel ${loop.index % 3 == 0 ? 'pattern-dots' : loop.index % 3 == 1 ? 'pattern-stripes' : 'pattern-checker'}"
                     style="padding: 28px; display: flex; flex-direction: column; justify-content: space-between; height: 100%;
                            border-color: ${loop.index % 4 == 0 ? 'var(--accent)' : loop.index % 4 == 1 ? 'var(--secondary)' : loop.index % 4 == 2 ? 'var(--tertiary)' : 'var(--quinary)'};
                            border-style: solid;
                            box-shadow: 6px 6px 0 ${loop.index % 4 == 0 ? 'var(--tertiary)' : loop.index % 4 == 1 ? 'var(--quinary)' : loop.index % 4 == 2 ? 'var(--accent)' : 'var(--secondary)'};
                            border-radius: 24px;">

                    <div>
                        <!-- Top row: category + status -->
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; flex-wrap: wrap; gap: 8px;">
                            <span class="chip ${loop.index % 4 == 0 ? 'chip-primary' : loop.index % 4 == 1 ? 'chip-secondary' : loop.index % 4 == 2 ? 'chip-tertiary' : 'chip-quinary'}">${h.category}</span>
                            <c:choose>
                                <c:when test="${h.status == 'ACTIVE'}">
                                    <span class="chip chip-secondary animate-pulse-glow">
                                        <span class="material-symbols-outlined" style="font-size: 13px;">radio_button_checked</span>
                                        ACTIVE 🔥
                                    </span>
                                </c:when>
                                <c:when test="${h.status == 'UPCOMING'}">
                                    <span class="chip chip-tertiary">
                                        <span class="material-symbols-outlined" style="font-size: 13px;">schedule</span>
                                        UPCOMING ⏳
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="chip chip-error">
                                        <span class="material-symbols-outlined" style="font-size: 13px;">event_busy</span>
                                        COMPLETED 🏁
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Title and description -->
                        <h2 class="h3" style="font-size: 1.4rem; margin-bottom: 10px; line-height: 1.3; color: #FFF;">${h.title}</h2>
                        <p class="text-muted" style="font-size: 14.5px; line-height: 1.6; margin-bottom: 20px; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; min-height: 70px;">
                            ${h.description}
                        </p>

                        <!-- Meta chips -->
                        <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 20px;">
                            <span class="chip chip-secondary" style="font-size: 11px;">
                                <span class="material-symbols-outlined" style="font-size: 13px;">group</span>
                                MAX ${h.maxTeamSize} PER TEAM
                            </span>
                            <span class="chip chip-tertiary" style="font-size: 11px;">
                                <span class="material-symbols-outlined" style="font-size: 13px;">emoji_events</span>
                                PRIZE: ${h.formattedPrizePool}
                            </span>
                            <span class="chip chip-primary" style="font-size: 11px;">
                                <span class="material-symbols-outlined" style="font-size: 13px;">calendar_today</span>
                                DEADLINE: ${h.formattedRegistrationDeadline}
                            </span>
                        </div>
                    </div>

                    <!-- CTA -->
                    <div style="border-top: 3px dashed var(--accent); padding-top: 18px; margin-top: auto;">
                        <c:choose>
                            <c:when test="${h.status == 'COMPLETED'}">
                                <a href="<c:url value='/hackathon/${h.id}'/>" class="btn btn-outline" style="width: 100%; justify-content: center;">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">info</span>
                                    VIEW RESULTS 🏁
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="<c:url value='/hackathon/${h.id}'/>" class="btn btn-primary animate-pulse-glow" style="width: 100%; justify-content: center;">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">arrow_forward</span>
                                    VIEW DETAILS &amp; JOIN 🚀
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>

            <!-- Empty state -->
            <c:if test="${empty hackathons}">
                <div class="glass-panel" style="padding: 72px; text-align: center; grid-column: 1 / -1; border-color: var(--accent);">
                    <span class="material-symbols-outlined animate-bounce" style="font-size: 64px; color: var(--accent);">event_busy</span>
                    <h3 class="h3" style="margin-top: 24px; color: #FFF;">NO HACKATHONS AVAILABLE</h3>
                    <p class="text-muted" style="margin-top: 10px; font-size: 16px;">Check back later or ask your admin to publish new events!</p>
                </div>
            </c:if>

        </div>

    </main>

    <%@ include file="footer.jspf" %>

</body>
</html>
