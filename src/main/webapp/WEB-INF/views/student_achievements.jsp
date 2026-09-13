<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Achievements 🏆</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Background -->
    <div class="watermark-bg" style="position: fixed; top: 120px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 22vw, 20rem); color: rgba(0,245,212,0.03); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        ACHIEVEMENTS
    </div>

    <main class="main-content" style="position: relative; z-index: 1;">

        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 32px;" class="col-2">
            
            <!-- Sidebar: Report Form -->
            <div>
                <section class="glass-panel" style="padding: 28px; position: sticky; top: 96px; border-color: var(--secondary); box-shadow: 6px 6px 0 var(--tertiary), 12px 12px 0 var(--quinary);">
                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
                        <span class="material-symbols-outlined icon-filled" style="color: var(--secondary); font-size: 26px;">add_circle</span>
                        <h3 class="h3" style="color: var(--secondary);">REPORT HACKATHON</h3>
                    </div>
                    <p class="text-muted" style="font-size: 14px; margin-bottom: 24px;">Did you participate in an external hackathon? Report it here to add it to your profile achievements.</p>
                    
                    <form id="achievementForm" enctype="multipart/form-data">
                        <div class="form-group" style="margin-bottom: 16px;">
                            <label class="form-label">Hackathon Name <span style="color: var(--accent);">*</span></label>
                            <input type="text" class="form-control" name="hackathonName" required placeholder="e.g. Global Tech Hack">
                        </div>
                        <div class="form-group" style="margin-bottom: 16px;">
                            <label class="form-label">Organizer <span style="color: var(--accent);">*</span></label>
                            <input type="text" class="form-control" name="organizer" required placeholder="e.g. MLH">
                        </div>
                        <div class="form-group" style="margin-bottom: 16px;">
                            <label class="form-label">Date <span style="color: var(--accent);">*</span></label>
                            <input type="date" class="form-control" name="date" required>
                        </div>
                        <div class="form-group" style="margin-bottom: 16px;">
                            <label class="form-label">Project Title <span style="color: var(--accent);">*</span></label>
                            <input type="text" class="form-control" name="projectTitle" required placeholder="e.g. AI Health Assistant">
                        </div>
                        <div class="form-group" style="margin-bottom: 16px;">
                            <label class="form-label">Project Repo Link</label>
                            <input type="url" class="form-control" name="projectRepoLink" placeholder="https://github.com/...">
                        </div>
                        <div class="form-group" style="margin-bottom: 16px;">
                            <label class="form-label">Demo Link</label>
                            <input type="url" class="form-control" name="demoLink" placeholder="https://...">
                        </div>
                        <div class="form-group" style="margin-bottom: 24px;">
                            <label class="form-label">Certificate (PDF/Image)</label>
                            <input type="file" class="form-control" name="certificate" accept=".pdf,image/*">
                        </div>

                        <div id="formStatus" class="alert" style="display: none; margin-bottom: 16px;"></div>

                        <button type="submit" class="btn btn-secondary" style="width: 100%;" id="submitBtn">
                            SUBMIT FOR VERIFICATION 🚀
                        </button>
                    </form>
                </section>
            </div>

            <!-- Main Content: Lists -->
            <div style="display: flex; flex-direction: column; gap: 32px;">

                <!-- Achievements (Approved) -->
                <div>
                    <h2 class="h2" style="color: #FFF; margin-bottom: 16px; border-left: 4px solid var(--secondary); padding-left: 12px;">🏆 Your Achievements</h2>
                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <c:set var="hasApproved" value="false" />
                        <c:forEach var="a" items="${achievements}">
                            <c:if test="${a.status == 'APPROVED'}">
                                <c:set var="hasApproved" value="true" />
                                <article class="glass-panel" style="padding: 24px; border-color: var(--secondary);">
                                    <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; flex-wrap: wrap;">
                                        <div>
                                            <h3 class="h3" style="color: var(--secondary); margin-bottom: 4px;">${a.projectTitle}</h3>
                                            <p class="text-muted" style="font-size: 15px; margin-bottom: 12px;">
                                                Built at <strong style="color: #FFF;">${a.hackathonName}</strong> (${a.organizer}) &bull; ${a.date}
                                            </p>
                                            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                                                <c:if test="${not empty a.projectRepoLink}">
                                                    <a href="${a.projectRepoLink}" target="_blank" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px;">Repo Link</a>
                                                </c:if>
                                                <c:if test="${not empty a.demoLink}">
                                                    <a href="${a.demoLink}" target="_blank" class="btn btn-primary" style="padding: 6px 12px; font-size: 12px;">View Demo</a>
                                                </c:if>
                                                <c:if test="${not empty a.certificatePath}">
                                                    <a href="<c:url value='${a.certificatePath}'/>" target="_blank" class="btn btn-tertiary" style="padding: 6px 12px; font-size: 12px;">Certificate</a>
                                                </c:if>
                                            </div>
                                        </div>
                                        <span class="chip chip-secondary"><span class="material-symbols-outlined icon-filled" style="font-size: 14px;">verified</span> VERIFIED</span>
                                    </div>
                                </article>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not hasApproved}">
                            <div class="glass-panel" style="padding: 32px; text-align: center; border-color: rgba(255,255,255,0.1);">
                                <span class="material-symbols-outlined" style="font-size: 48px; color: rgba(255,255,255,0.2);">emoji_events</span>
                                <p class="text-muted" style="margin-top: 12px;">No verified achievements yet.</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Pending Verification -->
                <div>
                    <h2 class="h2" style="color: #FFF; margin-bottom: 16px; border-left: 4px solid var(--tertiary); padding-left: 12px;">⏳ Pending Verification</h2>
                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <c:set var="hasPending" value="false" />
                        <c:forEach var="a" items="${achievements}">
                            <c:if test="${a.status == 'PENDING'}">
                                <c:set var="hasPending" value="true" />
                                <article class="glass-panel" style="padding: 24px; border-color: var(--tertiary); opacity: 0.8;">
                                    <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; flex-wrap: wrap;">
                                        <div>
                                            <h3 class="h3" style="color: var(--tertiary); margin-bottom: 4px;">${a.projectTitle}</h3>
                                            <p class="text-muted" style="font-size: 15px; margin-bottom: 12px;">
                                                Built at <strong style="color: #FFF;">${a.hackathonName}</strong>
                                            </p>
                                        </div>
                                        <span class="chip chip-tertiary">PENDING REVIEW</span>
                                    </div>
                                </article>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not hasPending}">
                            <div class="glass-panel" style="padding: 24px; text-align: center; border-color: rgba(255,255,255,0.1);">
                                <p class="text-muted">No pending submissions.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
                
                <!-- Rejected (Optional) -->
                <div>
                    <h2 class="h2" style="color: #FFF; margin-bottom: 16px; border-left: 4px solid var(--accent); padding-left: 12px;">❌ Rejected</h2>
                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <c:set var="hasRejected" value="false" />
                        <c:forEach var="a" items="${achievements}">
                            <c:if test="${a.status == 'REJECTED'}">
                                <c:set var="hasRejected" value="true" />
                                <article class="glass-panel" style="padding: 16px 24px; border-color: var(--accent); opacity: 0.7;">
                                    <div style="display: flex; justify-content: space-between; align-items: center; gap: 16px; flex-wrap: wrap;">
                                        <h3 class="h3" style="color: var(--accent); margin-bottom: 0;">${a.projectTitle} <span style="font-size: 14px; font-weight: normal; color: #888;">(${a.hackathonName})</span></h3>
                                        <span class="chip chip-primary">REJECTED</span>
                                    </div>
                                </article>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not hasRejected}">
                            <p class="text-muted" style="padding-left: 12px;">No rejected submissions.</p>
                        </c:if>
                    </div>
                </div>

            </div>
        </div>
    </main>

    <%@ include file="footer.jspf" %>

    <script>
        document.getElementById('achievementForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            const btn = document.getElementById('submitBtn');
            const statusDiv = document.getElementById('formStatus');
            btn.disabled = true;
            btn.innerHTML = 'SUBMITTING... ⏳';

            const formData = new FormData(this);

            try {
                const response = await fetch('<c:url value="/api/achievements/submit"/>', {
                    method: 'POST',
                    body: formData
                });
                
                const data = await response.json();
                
                statusDiv.style.display = 'block';
                if (data.success) {
                    statusDiv.className = 'alert alert-success';
                    statusDiv.textContent = 'Achievement submitted successfully! Waiting for admin approval.';
                    this.reset();
                    setTimeout(() => window.location.reload(), 2000);
                } else {
                    statusDiv.className = 'alert alert-error';
                    statusDiv.textContent = data.message || 'Failed to submit. Please try again.';
                    btn.disabled = false;
                    btn.innerHTML = 'SUBMIT FOR VERIFICATION 🚀';
                }
            } catch (error) {
                console.error(error);
                statusDiv.style.display = 'block';
                statusDiv.className = 'alert alert-error';
                statusDiv.textContent = 'An error occurred. Please try again.';
                btn.disabled = false;
                btn.innerHTML = 'SUBMIT FOR VERIFICATION 🚀';
            }
        });
    </script>
</body>
</html>
