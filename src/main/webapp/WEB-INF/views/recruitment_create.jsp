<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Create Team Recruitment Listing 🤝</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Watermark Background -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(255,58,242,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        RECRUIT
    </div>

    <!-- Floating Background Shapes -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 15%; left: 4%; font-size: 3rem;">🤝</span>
    <span class="deco-shape animate-wiggle animate-delay-2" style="top: 25%; right: 5%; font-size: 2.6rem;">🚀</span>
    <span class="deco-shape animate-bounce animate-delay-3" style="bottom: 15%; left: 5%; font-size: 2.8rem;">⚡</span>

    <main class="main-content" style="position: relative; z-index: 1; max-width: 860px; margin: 0 auto;">
        
        <div style="margin-bottom: 24px; text-align: center;">
            <span class="chip chip-primary animate-pulse-glow" style="margin-bottom: 8px;">
                <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 14px;">group_add</span> TEAM BUILDING MARKETPLACE
            </span>
            <h1 class="h1" style="font-size: clamp(2rem, 4vw, 3rem); margin-bottom: 6px; color: #FFF;">
                POST A <span class="gradient-text">TEAM RECRUITMENT 🚀</span>
            </h1>
            <p class="text-muted" style="font-size: 15px;">
                Find talented teammates for your hackathon squad. Specify your required skills, roles, and project vision.
            </p>
        </div>

        <div class="glass-panel pattern-checker" style="padding: 32px 28px; border-color: var(--accent); border-radius: 24px;">
            
            <form action="<c:url value='/recruitment/create'/>" method="POST" style="display: flex; flex-direction: column; gap: 16px;">
                
                <!-- Error Banner -->
                <c:if test="${not empty error}">
                    <div class="alert-banner error" style="margin-bottom: 8px;">
                        <span class="material-symbols-outlined">error</span>
                        <span>${error}</span>
                    </div>
                </c:if>

                <!-- Hackathon & Team Select Row -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;" class="col-2">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="hackathonId">Target Hackathon</label>
                        <select class="form-select" id="hackathonId" name="hackathonId" required>
                            <c:choose>
                                <c:when test="${empty hackathons}">
                                    <option value="" disabled selected>No Active Hackathons Available</option>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${hackathons}" var="h">
                                        <option value="${h.id}">${h.title} (Max ${h.maxTeamSize} Members)</option>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="teamId">Your Team</label>
                        <select class="form-select" id="teamId" name="teamId" required>
                            <c:choose>
                                <c:when test="${empty teams}">
                                    <option value="" disabled selected>No Teams Available (Lead a team first)</option>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${teams}" var="t">
                                        <option value="${t.id}">${t.teamName}</option>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </div>
                </div>

                <!-- Post Title -->
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label" for="title">Recruitment Listing Title</label>
                    <input class="form-input" id="title" name="title" type="text" placeholder="e.g. Seeking Full-Stack & UI Designer for AI Medical App" required/>
                </div>

                <!-- Required & Preferred Skills -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="requiredSkills">Required Skills (Comma separated)</label>
                        <input class="form-input" id="requiredSkills" name="requiredSkills" type="text" placeholder="React, Node.js, Python, Figma" required/>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="preferredSkills">Preferred Skills (Optional)</label>
                        <input class="form-input" id="preferredSkills" name="preferredSkills" type="text" placeholder="Docker, TensorFlow, Web3"/>
                    </div>
                </div>

                <!-- Roles Needed & Experience Level -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="requiredRoles">Required Roles Needed</label>
                        <input class="form-input" id="requiredRoles" name="requiredRoles" type="text" placeholder="Frontend Developer, Backend Lead, UI/UX" required/>
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="experienceLevel">Experience Preference</label>
                        <select class="form-select" id="experienceLevel" name="experienceLevel">
                            <option value="Any Level">Any Level ✨</option>
                            <option value="Beginner Friendly">Beginner Friendly 🌱</option>
                            <option value="Intermediate">Intermediate ⚡</option>
                            <option value="Advanced / Experienced">Advanced / Experienced 🔥</option>
                        </select>
                    </div>
                </div>

                <!-- Location & Mode -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="locationPref">Location / Campus</label>
                        <input class="form-input" id="locationPref" name="locationPref" type="text" placeholder="Main Campus / Online" value="On-Campus / Remote"/>
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="applicationDeadline">Application Deadline</label>
                        <input class="form-input" id="applicationDeadline" name="applicationDeadline" type="date" required/>
                    </div>
                </div>

                <!-- Short Team & Project Description -->
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label" for="description">About Your Team &amp; What You're Looking For</label>
                    <textarea class="form-textarea" id="description" name="description" rows="3" placeholder="Describe your team vibe, work style, and specific gaps you want to fill..." required></textarea>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label" for="projectDescription">Project Idea / Problem Statement Being Solved</label>
                    <textarea class="form-textarea" id="projectDescription" name="projectDescription" rows="3" placeholder="Brief outline of project concept or track you intend to enter..." required></textarea>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary animate-pulse-glow" style="width: 100%; margin-top: 10px; padding: 14px;">
                    <span class="material-symbols-outlined animate-wiggle">rocket_launch</span>
                    PUBLISH RECRUITMENT POST NOW 🚀
                </button>
            </form>
        </div>
    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>
