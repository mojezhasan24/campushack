<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Manage Applications for ${post.title} 👥</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Watermark -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(0,245,212,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        APPLICANTS
    </div>

    <main class="main-content" style="position: relative; z-index: 1; max-width: 1000px; margin: 0 auto;">
        
        <a href="<c:url value='/recruitment/dashboard'/>" class="btn btn-outline" style="margin-bottom: 20px; padding: 6px 14px; font-size: 12px;">
            <span class="material-symbols-outlined">arrow_back</span> BACK TO DASHBOARD
        </a>

        <!-- Listing Banner -->
        <div class="glass-panel pattern-checker" style="padding: 28px; border-color: var(--accent); border-radius: 24px; margin-bottom: 28px;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 14px;">
                <div>
                    <span class="chip chip-tertiary" style="margin-bottom: 6px;">🏆 ${post.hackathon.title}</span>
                    <h1 class="h1" style="font-size: 1.8rem; color: #FFF;">${post.title}</h1>
                    <p class="text-muted" style="font-size: 14px; margin-top: 4px;">
                        Team: <strong>${post.team.teamName}</strong> • Current Capacity: <strong>${post.currentSize} / ${post.maxSize} Members</strong>
                    </p>
                </div>

                <div style="display: flex; gap: 10px;">
                    <span class="chip ${post.status == 'OPEN' ? 'chip-secondary' : 'chip-quaternary'}">STATUS: ${post.status}</span>
                </div>
            </div>
        </div>

        <h3 class="h3" style="color: #FFF; margin-bottom: 18px; font-size: 1.35rem;">CANDIDATE APPLICATIONS 📩</h3>

        <c:choose>
            <c:when test="${empty applications}">
                <div class="glass-panel" style="padding: 40px; text-align: center; border-color: var(--secondary);">
                    <span class="material-symbols-outlined" style="font-size: 48px; color: var(--secondary); margin-bottom: 8px;">inbox</span>
                    <h4 class="h4" style="color: #FFF;">NO APPLICATIONS RECEIVED YET</h4>
                    <p class="text-muted" style="font-size: 14px; margin-top: 4px;">Share your post link or use Talent Search to invite candidate students directly.</p>
                </div>
            </c:when>

            <c:otherwise>
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <c:forEach items="${applications}" var="app">
                        <div class="glass-panel pattern-stripes" style="padding: 24px; border-color: ${app.status == 'ACCEPTED' ? 'var(--secondary)' : app.status == 'REJECTED' ? 'var(--quaternary)' : 'var(--accent)'}; border-radius: 20px;">
                            
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 16px; margin-bottom: 14px;">
                                <div>
                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <h3 class="h3" style="color: #FFF; font-size: 1.3rem;">👤 ${app.applicant.fullName}</h3>
                                        <span class="chip ${app.status == 'ACCEPTED' ? 'chip-secondary' : app.status == 'REJECTED' ? 'chip-quaternary' : 'chip-tertiary'}" style="font-size: 10px;">
                                            ${app.status}
                                        </span>
                                    </div>
                                    <p class="text-muted label-sm" style="font-size: 11px; margin-top: 2px;">
                                        Roll Number: ${app.applicant.rollNumber} • ${app.applicant.email}
                                    </p>
                                </div>

                                <a href="<c:url value='/profile/view/${app.applicant.id}'/>" target="_blank" class="btn btn-outline" style="padding: 6px 14px; font-size: 11px;">
                                    VIEW FULL PROFILE 👤
                                </a>
                            </div>

                            <!-- Skills -->
                            <div style="margin-bottom: 12px;">
                                <span class="label-sm" style="color: var(--secondary); font-size: 10px; display: block; margin-bottom: 4px;">APPLICANT SKILLS:</span>
                                <div style="display: flex; flex-wrap: wrap; gap: 6px;">
                                    <c:forEach items="${fn:split(app.relevantSkills, ',')}" var="s">
                                        <span class="chip chip-primary" style="font-size: 10px;">${fn:trim(s)}</span>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Message & Contribution -->
                            <div style="padding: 14px; background: rgba(13,13,26,0.6); border: 2px dashed var(--accent); border-radius: 14px; margin-bottom: 16px;">
                                <span class="label-sm" style="color: var(--accent); font-size: 10px; display: block; margin-bottom: 4px;">WHY THEY WANT TO JOIN:</span>
                                <p style="color: var(--fg); font-size: 14px; line-height: 1.5; margin-bottom: 10px;">${app.message}</p>

                                <span class="label-sm" style="color: var(--tertiary); font-size: 10px; display: block; margin-bottom: 4px;">EXPECTED CONTRIBUTION:</span>
                                <p style="color: var(--fg); font-size: 14px; line-height: 1.5;">${app.contribution}</p>
                            </div>

                            <!-- Action Buttons for PENDING applications -->
                            <c:if test="${app.status == 'PENDING'}">
                                <div style="display: flex; gap: 12px; justify-content: flex-end;">
                                    <form action="<c:url value='/recruitment/reject'/>" method="POST" style="margin: 0;">
                                        <input type="hidden" name="applicationId" value="${app.id}"/>
                                        <input type="hidden" name="postId" value="${post.id}"/>
                                        <button type="submit" class="btn btn-danger" style="padding: 8px 18px; font-size: 12px;">
                                            REJECT ❌
                                        </button>
                                    </form>

                                    <form action="<c:url value='/recruitment/accept'/>" method="POST" style="margin: 0;">
                                        <input type="hidden" name="applicationId" value="${app.id}"/>
                                        <input type="hidden" name="postId" value="${post.id}"/>
                                        <button type="submit" class="btn btn-primary animate-pulse-glow" style="padding: 8px 22px; font-size: 12px;">
                                            ACCEPT TO TEAM 🎉
                                        </button>
                                    </form>
                                </div>
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
