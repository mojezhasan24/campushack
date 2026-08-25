<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - ${profile.user.fullName}'s Profile 👤</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Watermark Background -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(0,245,212,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        PROFILE
    </div>

    <main class="main-content" style="position: relative; z-index: 1; max-width: 960px; margin: 0 auto;">
        
        <c:if test="${not empty successMessage}">
            <div class="alert-banner success" style="margin-bottom: 20px;">
                <span class="material-symbols-outlined">check_circle</span>
                <span>${successMessage}</span>
            </div>
        </c:if>

        <!-- Profile Header Card -->
        <div class="glass-panel pattern-checker" style="padding: 36px 32px; border-color: var(--accent); border-radius: 28px; margin-bottom: 28px;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 20px;">
                
                <div style="display: flex; align-items: center; gap: 20px;">
                    <!-- Avatar Badge -->
                    <div style="width: 80px; height: 80px; border-radius: 50%; border: 4px solid var(--secondary); background: linear-gradient(135deg, var(--quinary), var(--accent)); display: flex; align-items: center; justify-content: center; box-shadow: 0 0 24px rgba(0,245,212,0.5);" class="animate-bounce">
                        <span class="material-symbols-outlined icon-filled" style="font-size: 42px; color: #FFF;">person</span>
                    </div>

                    <div>
                        <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                            <h1 class="h1" style="font-size: 2.2rem; color: #FFF; line-height: 1.1;">
                                ${profile.user.fullName}
                            </h1>
                            <c:if test="${profile.lookingForTeam}">
                                <span class="chip chip-secondary animate-pulse-glow" style="font-size: 10px;">
                                    🟢 LOOKING FOR A TEAM
                                </span>
                            </c:if>
                        </div>

                        <p class="text-muted" style="font-size: 15px; font-weight: 700; margin-top: 4px;">
                            🎓 ${profile.branch} (${profile.course}) • Roll: ${profile.user.rollNumber}
                        </p>
                        <p class="text-muted label-sm" style="font-size: 11px; margin-top: 2px;">
                            🏛️ ${profile.college}
                        </p>
                    </div>
                </div>

                <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                    <c:if test="${isSelf}">
                        <a href="<c:url value='/profile/edit'/>" class="btn btn-primary animate-pulse-glow" style="padding: 10px 20px; font-size: 0.8rem;">
                            <span class="material-symbols-outlined">edit</span> EDIT PROFILE
                        </a>
                    </c:if>
                </div>
            </div>

            <c:if test="${not empty profile.bio}">
                <div style="margin-top: 24px; padding-top: 18px; border-top: 2px dashed rgba(255,58,242,0.3);">
                    <span class="label-sm" style="color: var(--secondary); font-size: 10.5px; display: block; margin-bottom: 4px;">BIO &amp; ABOUT</span>
                    <p style="color: var(--fg); font-size: 15px; line-height: 1.6;">${profile.bio}</p>
                </div>
            </c:if>
        </div>

        <!-- Details Grid -->
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;" class="col-2">
            
            <!-- Skills & Tech Stack -->
            <div class="glass-panel pattern-stripes" style="padding: 28px; border-color: var(--secondary); border-radius: 24px;">
                <h3 class="h3" style="color: #FFF; margin-bottom: 16px; font-size: 1.25rem;">SKILLS &amp; TECH STACK ⚡</h3>

                <div style="margin-bottom: 20px;">
                    <span class="label-sm" style="color: var(--accent); font-size: 10.5px; display: block; margin-bottom: 8px;">TECHNICAL SKILLS</span>
                    <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                        <c:forEach items="${fn:split(profile.skills, ',')}" var="s">
                            <span class="chip chip-primary" style="font-size: 11px;">${fn:trim(s)}</span>
                        </c:forEach>
                    </div>
                </div>

                <div style="margin-bottom: 20px;">
                    <span class="label-sm" style="color: var(--tertiary); font-size: 10.5px; display: block; margin-bottom: 6px;">PRIMARY TECH STACK</span>
                    <span style="font-weight: 800; color: #FFF; font-size: 15px;">${profile.techStack}</span>
                </div>

                <div>
                    <span class="label-sm" style="color: var(--quaternary); font-size: 10.5px; display: block; margin-bottom: 6px;">EXPERIENCE</span>
                    <span style="font-weight: 800; color: #FFF; font-size: 15px;">🔥 ${profile.experienceYears} Year(s) in Software Development</span>
                </div>
            </div>

            <!-- Social Links & Projects -->
            <div class="glass-panel pattern-stripes" style="padding: 28px; border-color: var(--tertiary); border-radius: 24px;">
                <h3 class="h3" style="color: #FFF; margin-bottom: 16px; font-size: 1.25rem;">PORTFOLIO &amp; LINKS 🔗</h3>

                <div style="display: flex; flex-direction: column; gap: 12px; margin-bottom: 20px;">
                    <c:if test="${not empty profile.github}">
                        <a href="${profile.github}" target="_blank" class="chip chip-secondary" style="font-size: 12px; padding: 8px 14px; text-decoration: none;">
                            💻 GitHub Profile →
                        </a>
                    </c:if>
                    <c:if test="${not empty profile.linkedin}">
                        <a href="${profile.linkedin}" target="_blank" class="chip chip-primary" style="font-size: 12px; padding: 8px 14px; text-decoration: none;">
                            💼 LinkedIn Profile →
                        </a>
                    </c:if>
                    <c:if test="${not empty profile.portfolio}">
                        <a href="${profile.portfolio}" target="_blank" class="chip chip-tertiary" style="font-size: 12px; padding: 8px 14px; text-decoration: none;">
                            🌐 Personal Portfolio →
                        </a>
                    </c:if>
                </div>

                <c:if test="${not empty profile.projects}">
                    <div>
                        <span class="label-sm" style="color: var(--secondary); font-size: 10.5px; display: block; margin-bottom: 6px;">FEATURED PROJECTS</span>
                        <p style="color: var(--fg); font-size: 14px; line-height: 1.5;">${profile.projects}</p>
                    </div>
                </c:if>
            </div>

        </div>

    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>
