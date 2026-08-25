<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Team Recruitment Marketplace 🤝</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Background Typography Watermark -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(0,245,212,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        MARKETPLACE
    </div>

    <!-- Floating Background Shapes -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 14%; left: 3%; font-size: 3rem;">⚡</span>
    <span class="deco-shape animate-wiggle animate-delay-2" style="top: 22%; right: 4%; font-size: 2.8rem;">🏆</span>
    <span class="deco-shape animate-bounce animate-delay-3" style="bottom: 14%; right: 5%; font-size: 3.2rem;">🤝</span>

    <main class="main-content" style="position: relative; z-index: 1;">
        
        <!-- Header Banner & Post Creation CTA -->
        <div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 16px; margin-bottom: 28px;">
            <div>
                <span class="chip chip-secondary animate-pulse-glow" style="margin-bottom: 8px;">
                    <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 14px;">groups</span> TEAM FORMATION MARKETPLACE
                </span>
                <h1 class="h1" style="font-size: clamp(2rem, 4.5vw, 3.2rem); color: #FFF;">
                    FIND YOUR <span class="gradient-text">DREAM TEAM ⚡</span>
                </h1>
                <p class="text-muted" style="font-size: 16px; margin-top: 4px;">
                    Discover open recruitment posts or find teammates with the exact skills you need.
                </p>
            </div>

            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                <a href="<c:url value='/profile/edit'/>" class="btn btn-outline">
                    <span class="material-symbols-outlined">person_pin</span>
                    TOGGLE "LOOKING FOR TEAM" 🟢
                </a>
                <a href="<c:url value='/recruitment/create'/>" class="btn btn-primary animate-pulse-glow">
                    <span class="material-symbols-outlined">add_circle</span>
                    CREATE RECRUITMENT POST 🚀
                </a>
            </div>
        </div>

        <!-- Search & Filter Bar -->
        <div class="glass-panel pattern-stripes" style="padding: 20px 24px; border-color: var(--secondary); margin-bottom: 32px; border-radius: 20px;">
            <form action="<c:url value='/recruitment/browse'/>" method="GET" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)) 140px; gap: 16px; align-items: end;">
                
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label" for="hackathonId" style="font-size: 0.7rem;">Filter by Hackathon</label>
                    <select class="form-select" id="hackathonId" name="hackathonId">
                        <option value="">All Hackathons 🏆</option>
                        <c:forEach items="${hackathons}" var="h">
                            <option value="${h.id}" ${param.hackathonId == h.id ? 'selected' : ''}>${h.title}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label" for="experienceLevel" style="font-size: 0.7rem;">Experience Level</label>
                    <select class="form-select" id="experienceLevel" name="experienceLevel">
                        <option value="">Any Experience ✨</option>
                        <option value="Beginner Friendly" ${param.experienceLevel == 'Beginner Friendly' ? 'selected' : ''}>Beginner Friendly 🌱</option>
                        <option value="Intermediate" ${param.experienceLevel == 'Intermediate' ? 'selected' : ''}>Intermediate ⚡</option>
                        <option value="Advanced / Experienced" ${param.experienceLevel == 'Advanced / Experienced' ? 'selected' : ''}>Advanced / Experienced 🔥</option>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label" for="onlinePref" style="font-size: 0.7rem;">Location / Mode</label>
                    <select class="form-select" id="onlinePref" name="onlinePref">
                        <option value="">All Modes 🌐</option>
                        <option value="true" ${param.onlinePref == 'true' ? 'selected' : ''}>Online / Remote Only</option>
                        <option value="false" ${param.onlinePref == 'false' ? 'selected' : ''}>In-Person / On-Campus</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary" style="padding: 10px 18px;">
                    <span class="material-symbols-outlined">search</span>
                    FILTER
                </button>
            </form>
        </div>

        <!-- Recruitment Posts Grid -->
        <c:choose>
            <c:when test="${empty posts}">
                <div class="glass-panel" style="padding: 48px; text-align: center; border-color: var(--accent);">
                    <span class="material-symbols-outlined" style="font-size: 56px; color: var(--accent); margin-bottom: 12px;">person_search</span>
                    <h3 class="h3" style="color: #FFF;">NO RECRUITMENT POSTS FOUND</h3>
                    <p class="text-muted" style="margin-top: 6px;">Be the first team leader to create a post and assemble your squad!</p>
                    <a href="<c:url value='/recruitment/create'/>" class="btn btn-primary" style="margin-top: 18px;">CREATE POST NOW 🚀</a>
                </div>
            </c:when>

            <c:otherwise>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 24px;">
                    <c:forEach items="${posts}" var="post" varStatus="loop">
                        <div class="glass-panel pattern-checker" style="padding: 24px; border-color: ${loop.index % 3 == 0 ? 'var(--accent)' : loop.index % 3 == 1 ? 'var(--secondary)' : 'var(--tertiary)'}; display: flex; flex-direction: column; justify-content: space-between;">
                            
                            <div>
                                <!-- Card Header: Hackathon & Capacity -->
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; margin-bottom: 12px;">
                                    <span class="chip chip-tertiary" style="font-size: 10px;">
                                        🏆 ${post.hackathon.title}
                                    </span>
                                    <span class="chip chip-secondary" style="font-size: 10px; font-weight: 900;">
                                        👥 ${post.currentSize} / ${post.maxSize} MEMBERS
                                    </span>
                                </div>

                                <!-- Post Title -->
                                <h3 class="h3" style="color: #FFF; font-size: 1.2rem; line-height: 1.3; margin-bottom: 8px;">
                                    ${post.title}
                                </h3>

                                <p class="text-muted" style="font-size: 13.5px; line-height: 1.5; margin-bottom: 14px; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">
                                    ${post.description}
                                </p>

                                <!-- Required Skills Chips -->
                                <div style="margin-bottom: 14px;">
                                    <span class="label-sm" style="font-size: 10px; color: var(--secondary); display: block; margin-bottom: 6px;">REQUIRED SKILLS:</span>
                                    <div style="display: flex; flex-wrap: wrap; gap: 6px;">
                                        <c:forEach items="${fn:split(post.requiredSkills, ',')}" var="skill">
                                            <span class="chip chip-primary" style="font-size: 10px; padding: 3px 9px;">${fn:trim(skill)}</span>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Required Roles -->
                                <div style="margin-bottom: 16px;">
                                    <span class="label-sm" style="font-size: 10px; color: var(--tertiary); display: block; margin-bottom: 6px;">ROLES NEEDED:</span>
                                    <div style="display: flex; flex-wrap: wrap; gap: 6px;">
                                        <c:forEach items="${fn:split(post.requiredRoles, ',')}" var="role">
                                            <span class="chip chip-quinary" style="font-size: 10px; padding: 3px 9px;">${fn:trim(role)}</span>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>

                            <!-- Card Footer: Team Leader & Apply Button -->
                            <div style="border-top: 2px dashed rgba(255,58,242,0.3); padding-top: 14px; margin-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                                <div>
                                    <span class="label-sm" style="font-size: 9.5px; color: var(--text-muted); display: block;">TEAM LEAD</span>
                                    <span style="font-weight: 800; font-size: 13px; color: #FFF;">👑 ${post.teamLead.fullName}</span>
                                </div>

                                <a href="<c:url value='/recruitment/view/${post.id}'/>" class="btn btn-primary" style="padding: 8px 18px; font-size: 0.78rem;">
                                    VIEW &amp; APPLY ⚡
                                </a>
                            </div>

                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>
