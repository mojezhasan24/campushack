<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Admin Approvals ✅</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Background -->
    <div class="watermark-bg" style="position: fixed; top: 120px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 22vw, 20rem); color: rgba(255,230,0,0.03); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        APPROVALS
    </div>

    <main class="main-content" style="position: relative; z-index: 1;">

        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 32px; flex-wrap: wrap; gap: 20px;">
            <div>
                <h1 class="h1" style="color: #FFF;">Pending <span style="color: var(--tertiary);">Approvals</span> ✅</h1>
                <p class="text-muted" style="font-size: 16px; margin-top: 8px;">Review and approve external hackathon achievements reported by students.</p>
            </div>
            <div class="chip chip-tertiary">
                <span class="material-symbols-outlined icon-filled" style="font-size: 18px;">hourglass_empty</span>
                ${pendingAchievements != null ? pendingAchievements.size() : 0} PENDING
            </div>
        </div>

        <c:choose>
            <c:when test="${empty pendingAchievements}">
                <div class="glass-panel" style="padding: 60px; text-align: center; border-color: var(--quinary);">
                    <span class="material-symbols-outlined animate-bounce" style="font-size: 64px; color: var(--tertiary);">task_alt</span>
                    <h3 class="h3" style="color: #FFF; margin-top: 20px;">All caught up!</h3>
                    <p class="text-muted" style="margin-top: 10px; font-size: 16px;">There are no pending achievements to review right now.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 24px;">
                    <c:forEach var="a" items="${pendingAchievements}">
                        <article class="glass-panel" style="padding: 24px; border-color: var(--tertiary); display: flex; flex-direction: column;">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                                <h3 class="h3" style="color: var(--tertiary); margin-bottom: 0;">${a.projectTitle}</h3>
                                <span class="chip chip-tertiary" style="font-size: 10px;">${a.submittedAt}</span>
                            </div>
                            
                            <div style="margin-bottom: 16px; font-size: 14px; flex-grow: 1;">
                                <p style="margin-bottom: 6px;"><strong style="color: var(--fg);">Student:</strong> ${a.student.fullName} (${a.student.email})</p>
                                <p style="margin-bottom: 6px;"><strong style="color: var(--fg);">Hackathon:</strong> ${a.hackathonName}</p>
                                <p style="margin-bottom: 6px;"><strong style="color: var(--fg);">Organizer:</strong> ${a.organizer}</p>
                                <p style="margin-bottom: 6px;"><strong style="color: var(--fg);">Date:</strong> ${a.date}</p>
                                
                                <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-top: 12px;">
                                    <c:if test="${not empty a.projectRepoLink}">
                                        <a href="${a.projectRepoLink}" target="_blank" class="btn btn-outline" style="padding: 4px 10px; font-size: 11px;">GitHub</a>
                                    </c:if>
                                    <c:if test="${not empty a.demoLink}">
                                        <a href="${a.demoLink}" target="_blank" class="btn btn-outline" style="padding: 4px 10px; font-size: 11px;">Demo</a>
                                    </c:if>
                                    <c:if test="${not empty a.certificatePath}">
                                        <a href="<c:url value='${a.certificatePath}'/>" target="_blank" class="btn btn-primary" style="padding: 4px 10px; font-size: 11px;">View Certificate</a>
                                    </c:if>
                                </div>
                            </div>

                            <div style="display: flex; gap: 12px; margin-top: 16px;">
                                <button onclick="handleApproval(${a.id}, 'approve')" class="btn btn-secondary" style="flex: 1; padding: 10px;">APPROVE ✅</button>
                                <button onclick="handleApproval(${a.id}, 'reject')" class="btn btn-outline" style="flex: 1; padding: 10px; border-color: var(--accent); color: var(--accent);">REJECT ❌</button>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <%@ include file="footer.jspf" %>

    <script>
        async function handleApproval(id, action) {
            if (!confirm(`Are you sure you want to \${action} this achievement?`)) return;
            
            try {
                const response = await fetch(`<c:url value="/api/achievements/"/>\${id}/\${action}`, {
                    method: 'POST'
                });
                const data = await response.json();
                if (data.success) {
                    window.location.reload();
                } else {
                    alert(data.message || 'Failed to process request');
                }
            } catch (err) {
                console.error(err);
                alert('An error occurred');
            }
        }
    </script>
</body>
</html>
