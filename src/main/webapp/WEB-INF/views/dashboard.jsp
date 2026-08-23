<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Participant Dashboard ⚡</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Massive Background Typography -->
    <div class="watermark-bg" style="position: fixed; top: 120px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 22vw, 20rem); color: rgba(255,58,242,0.03); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        HACKATHON
    </div>

    <!-- Floating Decorative Shapes -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 15%; right: 4%; font-size: 3rem;">⚡</span>
    <span class="deco-shape animate-wiggle animate-delay-2" style="top: 35%; left: 2%; font-size: 2.5rem;">🔥</span>
    <span class="deco-shape animate-bounce animate-delay-3" style="bottom: 20%; right: 3%; font-size: 2.8rem;">🚀</span>
    <span class="deco-shape animate-float-reverse animate-delay-4" style="bottom: 10%; left: 4%; font-size: 2.2rem;">✨</span>

    <main class="main-content" style="position: relative; z-index: 1;">

        <!-- Hero Banner -->
        <section class="glass-panel pattern-checker" style="padding: 40px 44px; margin-bottom: 32px; border-color: var(--accent); box-shadow: 10px 10px 0 var(--tertiary), 20px 20px 0 var(--quinary);">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 20px;">
                <div>
                    <span class="chip chip-tertiary animate-pulse-glow" style="margin-bottom: 12px; font-size: 11px;">
                        <span class="material-symbols-outlined icon-filled" style="font-size: 14px;">waving_hand</span> WELCOME BACK INNOVATOR
                    </span>
                    <h1 class="h1" style="color: #FFFFFF; margin-top: 4px;">
                        <c:out value="${sessionScope.user.fullName}" default="Participant"/> <span class="gradient-text">🚀</span>
                    </h1>
                    <p class="text-muted" style="font-size: 18px; font-weight: 500; margin-top: 8px;">Here's your live telemetry across active CampusHack events.</p>
                </div>
                <div style="display: flex; gap: 12px; flex-shrink: 0; align-self: flex-end;">
                    <a href="<c:url value='/discover'/>" class="btn btn-primary">
                        <span class="material-symbols-outlined" style="font-size: 18px;">explore</span>
                        DISCOVER EVENTS 🚀
                    </a>
                </div>
            </div>
        </section>

        <!-- Stats Grid (Accent rotation: Magenta, Cyan, Yellow) -->
        <section style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; margin-bottom: 40px;">

            <!-- Stat 1: Magenta -->
            <div class="glass-panel" style="padding: 28px; border-color: var(--accent); border-style: solid; box-shadow: 6px 6px 0 var(--tertiary), 12px 12px 0 var(--quinary); transform: rotate(-0.6deg);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                    <p class="label-sm" style="color: var(--accent);">Active Events ⚡</p>
                    <div class="stat-icon" style="background: rgba(255,58,242,0.15); border-color: var(--accent);">
                        <span class="material-symbols-outlined icon-filled" style="color: var(--accent); font-size: 26px;">event</span>
                    </div>
                </div>
                <p class="stat-lg" style="color: #FFFFFF; text-shadow: 3px 3px 0 var(--quinary), 6px 6px 0 var(--accent);">${activeEventsCount != null ? activeEventsCount : 0}</p>
            </div>

            <!-- Stat 2: Cyan -->
            <div class="glass-panel" style="padding: 28px; border-color: var(--secondary); border-style: dashed; box-shadow: 6px 6px 0 var(--accent), 12px 12px 0 var(--tertiary); transform: rotate(0.8deg);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                    <p class="label-sm" style="color: var(--secondary);">Total Hackathons 🏆</p>
                    <div class="stat-icon" style="background: rgba(0,245,212,0.15); border-color: var(--secondary);">
                        <span class="material-symbols-outlined icon-filled" style="color: var(--secondary); font-size: 26px;">emoji_events</span>
                    </div>
                </div>
                <p class="stat-lg" style="color: #FFFFFF; text-shadow: 3px 3px 0 var(--accent), 6px 6px 0 var(--secondary);">${hackathons != null ? hackathons.size() : 0}</p>
            </div>

            <!-- Stat 3: Yellow -->
            <div class="glass-panel" style="padding: 28px; border-color: var(--tertiary); border-style: solid; box-shadow: 6px 6px 0 var(--quinary), 12px 12px 0 var(--secondary); transform: rotate(-0.5deg);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                    <p class="label-sm" style="color: var(--tertiary);">Your Role 🛡️</p>
                    <div class="stat-icon" style="background: rgba(255,230,0,0.15); border-color: var(--tertiary);">
                        <span class="material-symbols-outlined icon-filled" style="color: var(--tertiary); font-size: 26px;">badge</span>
                    </div>
                </div>
                <p class="stat-lg" style="font-size: 2rem; text-transform: uppercase; color: #FFFFFF; text-shadow: 2px 2px 0 var(--quinary), 4px 4px 0 var(--tertiary);">
                    ${sessionScope.user.role}
                </p>
            </div>

        </section>

        <!-- Main Content: Activity Feed + Sidebar -->
        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 28px;" class="col-2">

            <!-- Activity Feed -->
            <div style="display: flex; flex-direction: column; gap: 20px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                    <h3 class="h3" style="color: var(--secondary);">CAMPUS ACTIVITY FEED 🔥</h3>
                    <a href="<c:url value='/discover'/>" class="btn btn-outline" style="padding: 8px 16px; font-size: 12px;">
                        BROWSE ALL →
                    </a>
                </div>

                <article class="glass-panel pattern-dots" style="padding: 24px; display: flex; gap: 20px; align-items: flex-start; border-color: var(--accent); transform: rotate(-0.3deg);">
                    <div style="width: 52px; height: 52px; border-radius: 50%; border: 3px solid var(--accent); background: linear-gradient(135deg, var(--accent), var(--quinary)); display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 16px; flex-shrink: 0; color: #FFF; box-shadow: 0 0 14px rgba(255,58,242,0.5);">
                        RS
                    </div>
                    <div style="flex-grow: 1;">
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px; flex-wrap: wrap;">
                            <strong style="font-size: 16px; color: #FFF;">Rahul Sharma</strong>
                            <span class="chip chip-secondary" style="font-size: 10px;">CSE · 3rd Year</span>
                            <span class="text-muted label-sm" style="margin-left: auto; font-size: 12px;">2 hours ago</span>
                        </div>
                        <p class="text-muted" style="font-size: 15px;">Joined <strong style="color: var(--secondary);">AI Innovate 2024</strong> as a Full-Stack Developer ⚡</p>
                    </div>
                </article>

                <article class="glass-panel pattern-stripes" style="padding: 24px; display: flex; gap: 20px; align-items: flex-start; border-color: var(--secondary); transform: rotate(0.4deg);">
                    <div style="width: 52px; height: 52px; border-radius: 50%; border: 3px solid var(--secondary); background: linear-gradient(135deg, var(--secondary), #0EA5E9); display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 16px; flex-shrink: 0; color: #000; box-shadow: 0 0 14px rgba(0,245,212,0.5);">
                        PP
                    </div>
                    <div style="flex-grow: 1;">
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px; flex-wrap: wrap;">
                            <strong style="font-size: 16px; color: #FFF;">Priya Patel</strong>
                            <span class="chip chip-tertiary" style="font-size: 10px;">ECE · 2nd Year</span>
                            <span class="text-muted label-sm" style="margin-left: auto; font-size: 12px;">5 hours ago</span>
                        </div>
                        <p class="text-muted" style="font-size: 15px;">Submitted project <strong style="color: var(--tertiary);">DeFi Wallet Companion</strong> to Web3 Build Hackathon 🚀</p>
                    </div>
                </article>

                <article class="glass-panel pattern-checker" style="padding: 24px; display: flex; gap: 20px; align-items: flex-start; border-color: var(--tertiary); transform: rotate(-0.4deg);">
                    <div style="width: 52px; height: 52px; border-radius: 50%; border: 3px solid var(--tertiary); background: rgba(255,230,0,0.15); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <span class="material-symbols-outlined" style="color: var(--tertiary); font-size: 26px;">group</span>
                    </div>
                    <div style="flex-grow: 1;">
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px; flex-wrap: wrap;">
                            <strong style="font-size: 16px; color: #FFF;">Team Null Pointers</strong>
                            <span class="text-muted label-sm" style="margin-left: auto; font-size: 12px;">Yesterday</span>
                        </div>
                        <p class="text-muted" style="font-size: 15px;">Looking for a <strong style="color: var(--quaternary);">UI/UX Designer</strong> for the Cloud Quest hackathon ✨</p>
                    </div>
                </article>

                <!-- Empty state if no hackathons exist -->
                <c:if test="${empty hackathons}">
                    <div class="glass-panel" style="padding: 48px; text-align: center; border-color: var(--quinary);">
                        <span class="material-symbols-outlined animate-bounce" style="font-size: 56px; color: var(--tertiary);">celebration</span>
                        <p class="text-muted" style="margin-top: 14px; font-size: 16px; font-weight: 700;">No hackathons yet. Check back soon for exciting events!</p>
                    </div>
                </c:if>
            </div>

            <!-- Sidebar: Upcoming Hackathons -->
            <div>
                <div class="glass-panel" style="padding: 28px; position: sticky; top: 96px; border-color: var(--quinary);">
                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
                        <span class="material-symbols-outlined icon-filled animate-wiggle" style="color: var(--quaternary); font-size: 26px;">local_fire_department</span>
                        <h3 class="h3" style="color: var(--quaternary);">TRENDING EVENTS</h3>
                    </div>

                    <c:choose>
                        <c:when test="${empty hackathons}">
                            <p class="text-muted label-sm" style="text-align: center; padding: 24px 0;">No events available.</p>
                        </c:when>
                        <c:otherwise>
                            <div style="display: flex; flex-direction: column; gap: 14px;">
                                <c:forEach var="h" items="${hackathons}">
                                    <a href="<c:url value='/hackathon/${h.id}'/>" style="display: block; padding: 16px; background: rgba(13,13,26,0.6); border: 3px solid var(--accent); border-radius: 16px; transition: all 0.2s ease; text-decoration: none;"
                                       onmouseover="this.style.borderColor='var(--secondary)'; this.style.transform='translateX(4px)'" onmouseout="this.style.borderColor='var(--accent)'; this.style.transform='translateX(0)'">
                                        <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 10px;">
                                            <div>
                                                <h4 style="font-size: 15px; font-weight: 800; color: #FFF; line-height: 1.3;">${h.title}</h4>
                                                <p class="text-muted" style="font-size: 12px; margin-top: 4px; font-weight: 700; color: var(--secondary);">${h.category}</p>
                                            </div>
                                            <span class="chip chip-tertiary" style="font-size: 11px; white-space: nowrap;">$${h.prizePool}</span>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <a href="<c:url value='/discover'/>" class="btn btn-secondary" style="width: 100%; margin-top: 24px; text-align: center;">
                        BROWSE ALL EVENTS 🚀
                    </a>
                </div>
            </div>

        </div>

    </main>

    <%@ include file="footer.jspf" %>

</body>
</html>
