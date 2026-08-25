<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - ${post.title} 🤝</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Watermark -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(255,58,242,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        APPLY
    </div>

    <main class="main-content" style="position: relative; z-index: 1; max-width: 1000px; margin: 0 auto;">
        
        <!-- Back Navigation -->
        <a href="<c:url value='/recruitment/browse'/>" class="btn btn-outline" style="margin-bottom: 20px; padding: 6px 14px; font-size: 12px;">
            <span class="material-symbols-outlined">arrow_back</span> BACK TO MARKETPLACE
        </a>

        <div style="display: grid; grid-template-columns: 1fr 380px; gap: 28px;" class="col-2">
            
            <!-- Left Details Column -->
            <div style="display: flex; flex-direction: column; gap: 20px;">
                <div class="glass-panel pattern-checker" style="padding: 32px; border-color: var(--accent); border-radius: 24px;">
                    
                    <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 12px;">
                        <span class="chip chip-tertiary">🏆 ${post.hackathon.title}</span>
                        <span class="chip chip-secondary">👥 ${post.currentSize} / ${post.maxSize} Members</span>
                        <span class="chip chip-primary">${post.onlinePref ? '🌐 Remote / Online' : '📍 On-Campus'}</span>
                    </div>

                    <h1 class="h1" style="font-size: 2.2rem; color: #FFF; margin-bottom: 14px; line-height: 1.2;">
                        ${post.title}
                    </h1>

                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 20px; padding: 12px 16px; background: rgba(13,13,26,0.6); border: 2px dashed var(--secondary); border-radius: 14px;">
                        <span class="material-symbols-outlined" style="font-size: 32px; color: var(--secondary);">workspace_premium</span>
                        <div>
                            <span class="label-sm" style="color: var(--text-muted); font-size: 10px; display: block;">TEAM LEADER</span>
                            <span style="font-weight: 800; color: #FFF; font-size: 15px;">👑 ${post.teamLead.fullName} (${post.teamLead.email})</span>
                        </div>
                    </div>

                    <h4 class="h4" style="color: var(--secondary); margin-bottom: 8px;">TEAM &amp; OPPORTUNITY DESCRIPTION</h4>
                    <p style="color: var(--fg); font-size: 15px; line-height: 1.6; margin-bottom: 20px;">
                        ${post.description}
                    </p>

                    <h4 class="h4" style="color: var(--tertiary); margin-bottom: 8px;">PROJECT CONCEPT / VISION</h4>
                    <p style="color: var(--fg); font-size: 15px; line-height: 1.6; margin-bottom: 24px;">
                        ${post.projectDescription}
                    </p>

                    <!-- Required Skills & Roles -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 20px;">
                        <div style="padding: 16px; background: rgba(13,13,26,0.6); border: 2px solid var(--accent); border-radius: 16px;">
                            <span class="label-sm" style="color: var(--accent); font-size: 11px; display: block; margin-bottom: 8px;">REQUIRED SKILLS</span>
                            <div style="display: flex; flex-wrap: wrap; gap: 6px;">
                                <c:forEach items="${fn:split(post.requiredSkills, ',')}" var="skill">
                                    <span class="chip chip-primary" style="font-size: 10px;">${fn:trim(skill)}</span>
                                </c:forEach>
                            </div>
                        </div>

                        <div style="padding: 16px; background: rgba(13,13,26,0.6); border: 2px solid var(--tertiary); border-radius: 16px;">
                            <span class="label-sm" style="color: var(--tertiary); font-size: 11px; display: block; margin-bottom: 8px;">ROLES NEEDED</span>
                            <div style="display: flex; flex-wrap: wrap; gap: 6px;">
                                <c:forEach items="${fn:split(post.requiredRoles, ',')}" var="role">
                                    <span class="chip chip-quinary" style="font-size: 10px;">${fn:trim(role)}</span>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty post.preferredSkills}">
                        <div style="margin-bottom: 16px;">
                            <span class="label-sm" style="color: var(--secondary); font-size: 10.5px;">PREFERRED / BONUS SKILLS:</span>
                            <span style="color: var(--fg); font-size: 13.5px; font-weight: 700; margin-left: 6px;">${post.preferredSkills}</span>
                        </div>
                    </c:if>

                    <c:if test="${not empty post.additionalRequirements}">
                        <div style="margin-bottom: 16px;">
                            <span class="label-sm" style="color: var(--quaternary); font-size: 10.5px;">ADDITIONAL REQUIREMENTS:</span>
                            <p style="color: var(--fg); font-size: 13.5px; margin-top: 4px;">${post.additionalRequirements}</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Right Application Form Column -->
            <div>
                <div class="glass-panel pattern-stripes" style="padding: 28px; border-color: var(--secondary); border-radius: 24px; position: sticky; top: 96px;">
                    
                    <h3 class="h3" style="color: #FFF; margin-bottom: 6px; font-size: 1.3rem;">APPLY TO JOIN SQUAD 🚀</h3>
                    <p class="text-muted label-sm" style="font-size: 11px; margin-bottom: 18px;">Send your application directly to the team leader.</p>

                    <c:if test="${not empty error}">
                        <div class="alert-banner error" style="margin-bottom: 14px;">
                            <span class="material-symbols-outlined">error</span>
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <form action="<c:url value='/recruitment/apply'/>" method="POST" style="display: flex; flex-direction: column; gap: 14px;">
                        <input type="hidden" name="postId" value="${post.id}"/>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label" for="message" style="font-size: 0.7rem;">Why do you want to join this team?</label>
                            <textarea class="form-textarea" id="message" name="message" rows="3" placeholder="Introduce yourself and explain why you're excited about this project..." required></textarea>
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label" for="contribution" style="font-size: 0.7rem;">What will you contribute?</label>
                            <textarea class="form-textarea" id="contribution" name="contribution" rows="3" placeholder="Specify your primary role, key technical contributions, or deliverables..." required></textarea>
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label" for="relevantSkills" style="font-size: 0.7rem;">Your Relevant Skills</label>
                            <input class="form-input" id="relevantSkills" name="relevantSkills" type="text" placeholder="e.g. React, Node.js, UI Design" required value="${studentProfile.skills}"/>
                        </div>

                        <button type="submit" class="btn btn-primary animate-pulse-glow" style="width: 100%; padding: 12px; margin-top: 6px;">
                            <span class="material-symbols-outlined animate-wiggle">send</span>
                            SUBMIT APPLICATION NOW ⚡
                        </button>
                    </form>
                </div>
            </div>

        </div>

    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>
