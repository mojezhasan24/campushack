<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Private Workspace: ${workspace.team.teamName} 🛡️</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Watermark -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(0,245,212,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        WORKSPACE
    </div>

    <main class="main-content" style="position: relative; z-index: 1; max-width: 1080px; margin: 0 auto;">
        
        <!-- Header Panel -->
        <div class="glass-panel pattern-checker" style="padding: 32px; border-color: var(--secondary); border-radius: 28px; margin-bottom: 28px;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 16px;">
                <div>
                    <span class="chip chip-secondary animate-pulse-glow" style="margin-bottom: 8px;">
                        🛡️ PRIVATE TEAM WORKSPACE
                    </span>
                    <h1 class="h1" style="font-size: 2.2rem; color: #FFF; line-height: 1.1;">
                        ${workspace.team.teamName} <span class="gradient-text">🚀</span>
                    </h1>
                    <p class="text-muted" style="font-size: 15px; margin-top: 4px;">
                        Hackathon: <strong>${workspace.team.hackathon.title}</strong> • Leader: <strong>👑 ${workspace.team.leader.fullName}</strong>
                    </p>
                </div>

                <div>
                    <span class="chip chip-tertiary" style="font-size: 12px; padding: 8px 16px;">
                        📅 Submission Deadline: ${workspace.submissionDeadline}
                    </span>
                </div>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 340px; gap: 28px;" class="col-2">
            
            <!-- Left Main Column: Project Info & Task Board -->
            <div style="display: flex; flex-direction: column; gap: 24px;">
                
                <!-- Project Vision -->
                <div class="glass-panel pattern-stripes" style="padding: 28px; border-color: var(--accent); border-radius: 24px;">
                    <h3 class="h3" style="color: #FFF; margin-bottom: 12px; font-size: 1.25rem;">PROJECT VISION &amp; DETAILS 💡</h3>
                    <p style="color: var(--fg); font-size: 15px; line-height: 1.6;">${workspace.projectInfo}</p>
                </div>

                <!-- Shared Task Board -->
                <div class="glass-panel pattern-checker" style="padding: 28px; border-color: var(--tertiary); border-radius: 24px;">
                    <h3 class="h3" style="color: #FFF; margin-bottom: 12px; font-size: 1.25rem;">TEAM TASK BOARD 📌</h3>
                    <textarea class="form-textarea" rows="8" style="font-family: monospace; font-size: 14px; line-height: 1.5; padding: 14px;" readonly>${workspace.taskBoard}</textarea>
                </div>

                <!-- Shared Links -->
                <div class="glass-panel pattern-stripes" style="padding: 28px; border-color: var(--secondary); border-radius: 24px;">
                    <h3 class="h3" style="color: #FFF; margin-bottom: 12px; font-size: 1.25rem;">SHARED RESOURCES &amp; LINKS 🔗</h3>
                    <p style="color: var(--secondary); font-weight: 800; font-size: 14.5px;">${workspace.sharedLinks}</p>
                </div>

            </div>

            <!-- Right Column: Team Roster -->
            <div>
                <div class="glass-panel pattern-stripes" style="padding: 24px; border-color: var(--accent); border-radius: 24px; position: sticky; top: 96px;">
                    <h3 class="h3" style="color: #FFF; margin-bottom: 16px; font-size: 1.2rem;">SQUAD MEMBERS (${workspace.team.members.size()}) 👥</h3>

                    <div style="display: flex; flex-direction: column; gap: 14px;">
                        <c:forEach items="${workspace.team.members}" var="m">
                            <div style="padding: 12px 14px; background: rgba(13,13,26,0.7); border: 2px solid ${m.id == workspace.team.leader.id ? 'var(--tertiary)' : 'var(--secondary)'}; border-radius: 14px; display: flex; align-items: center; justify-content: space-between;">
                                <div>
                                    <span style="color: #FFF; font-weight: 800; font-size: 14px;">
                                        ${m.id == workspace.team.leader.id ? '👑 ' : '👤 '}${m.fullName}
                                    </span>
                                    <span class="text-muted label-sm" style="font-size: 10px; display: block;">${m.rollNumber} • ${m.branch}</span>
                                </div>
                                <span class="chip ${m.id == workspace.team.leader.id ? 'chip-tertiary' : 'chip-secondary'}" style="font-size: 9px;">
                                    ${m.id == workspace.team.leader.id ? 'LEAD' : 'MEMBER'}
                                </span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

        </div>

    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>
