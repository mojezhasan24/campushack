<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Judge Evaluation Portal ⚖️</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Massive Background Typography -->
    <div class="watermark-bg" style="position: fixed; top: 120px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 22vw, 20rem); color: rgba(255,230,0,0.03); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        JUDGE
    </div>

    <!-- Floating Decorative Shapes -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 15%; right: 4%; font-size: 3rem;">⚖️</span>
    <span class="deco-shape animate-wiggle animate-delay-2" style="top: 35%; left: 3%; font-size: 2.5rem;">⚡</span>
    <span class="deco-shape animate-bounce animate-delay-3" style="bottom: 18%; right: 3%; font-size: 2.8rem;">🎯</span>

    <main class="main-content" style="position: relative; z-index: 1;">

        <!-- Page Header -->
        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 32px; flex-wrap: wrap; gap: 16px;">
            <div>
                <span class="chip chip-tertiary animate-pulse-glow" style="margin-bottom: 10px; font-size: 11px;">
                    <span class="material-symbols-outlined icon-filled" style="font-size: 14px;">gavel</span> EVALUATION OPERATIONS
                </span>
                <h1 class="h1" style="margin-top: 4px;">JUDGE EVALUATION PORTAL <span class="gradient-text">⚖️</span></h1>
                <p class="text-muted" style="font-size: 18px; font-weight: 500; margin-top: 6px;">Rate project submissions across 4 dimensions and track real-time leaderboard standings.</p>
            </div>
            <div style="display: flex; align-items: center; gap: 10px;">
                <span class="chip chip-primary" style="font-size: 13px; padding: 8px 18px;">
                    <span class="material-symbols-outlined icon-filled" style="font-size: 16px;">person</span>
                    Judge: <c:out value="${sessionScope.user.fullName}" default="Faculty Judge"/>
                </span>
            </div>
        </div>

        <c:choose>
            <%-- No submissions yet --%>
            <c:when test="${empty submissions}">
                <div class="glass-panel pattern-checker" style="padding: 72px; text-align: center; border-color: var(--tertiary);">
                    <span class="material-symbols-outlined animate-bounce" style="font-size: 64px; color: var(--tertiary);">inbox</span>
                    <h3 class="h3" style="margin-top: 24px; color: #FFF;">NO SUBMISSIONS TO SCORE YET</h3>
                    <p class="text-muted" style="margin-top: 10px; font-size: 16px;">Participants haven't submitted any projects yet. Check back once the hackathon submission window opens.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 28px;" class="col-2">

                    <!-- Left: Scoring Form -->
                    <div class="glass-panel pattern-dots" style="padding: 32px; border-color: var(--accent);">
                        <h3 class="h3" style="color: var(--accent); margin-bottom: 6px;">SCORE A SUBMISSION 🎯</h3>
                        <p class="text-muted label-sm" style="margin-bottom: 24px;">Scores are averaged across all judge ratings for each project.</p>

                        <form onsubmit="handleRatingSubmit(event)">
                            <div class="form-group">
                                <label class="form-label" for="evalSubmissionId">Select Project Submission</label>
                                <select class="form-select" id="evalSubmissionId" required>
                                    <option value="" disabled selected>Choose a project to score...</option>
                                    <c:forEach var="sub" items="${submissions}">
                                        <option value="${sub.id}">${sub.projectTitle} — Team: ${sub.team.teamName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Innovation -->
                            <div class="form-group">
                                <label class="form-label" style="display: flex; justify-content: space-between; align-items: center;">
                                    <span>Innovation &amp; Originality 💡</span>
                                    <strong id="valInnovation" style="color: var(--accent); font-size: 18px;">85</strong>
                                </label>
                                <input type="range" min="0" max="100" value="85" id="scoreInnovation"
                                       style="width: 100%; accent-color: var(--accent); height: 8px; cursor: pointer;"
                                       oninput="updateSlider('valInnovation', this.value)"/>
                                <div style="display: flex; justify-content: space-between; font-size: 11px; color: var(--text-muted); margin-top: 2px; font-weight: 700;">
                                    <span>0</span><span>50</span><span>100</span>
                                </div>
                            </div>

                            <!-- Technical -->
                            <div class="form-group">
                                <label class="form-label" style="display: flex; justify-content: space-between; align-items: center;">
                                    <span>Technical Complexity ⚙️</span>
                                    <strong id="valTechnical" style="color: var(--secondary); font-size: 18px;">90</strong>
                                </label>
                                <input type="range" min="0" max="100" value="90" id="scoreTechnical"
                                       style="width: 100%; accent-color: var(--secondary); height: 8px; cursor: pointer;"
                                       oninput="updateSlider('valTechnical', this.value)"/>
                                <div style="display: flex; justify-content: space-between; font-size: 11px; color: var(--text-muted); margin-top: 2px; font-weight: 700;">
                                    <span>0</span><span>50</span><span>100</span>
                                </div>
                            </div>

                            <!-- Design -->
                            <div class="form-group">
                                <label class="form-label" style="display: flex; justify-content: space-between; align-items: center;">
                                    <span>UI/UX &amp; Design Quality ✨</span>
                                    <strong id="valDesign" style="color: var(--tertiary); font-size: 18px;">80</strong>
                                </label>
                                <input type="range" min="0" max="100" value="80" id="scoreDesign"
                                       style="width: 100%; accent-color: var(--tertiary); height: 8px; cursor: pointer;"
                                       oninput="updateSlider('valDesign', this.value)"/>
                                <div style="display: flex; justify-content: space-between; font-size: 11px; color: var(--text-muted); margin-top: 2px; font-weight: 700;">
                                    <span>0</span><span>50</span><span>100</span>
                                </div>
                            </div>

                            <!-- Presentation -->
                            <div class="form-group">
                                <label class="form-label" style="display: flex; justify-content: space-between; align-items: center;">
                                    <span>Presentation &amp; Pitch 🎤</span>
                                    <strong id="valPresentation" style="color: var(--quaternary); font-size: 18px;">88</strong>
                                </label>
                                <input type="range" min="0" max="100" value="88" id="scorePresentation"
                                       style="width: 100%; accent-color: var(--quaternary); height: 8px; cursor: pointer;"
                                       oninput="updateSlider('valPresentation', this.value)"/>
                                <div style="display: flex; justify-content: space-between; font-size: 11px; color: var(--text-muted); margin-top: 2px; font-weight: 700;">
                                    <span>0</span><span>50</span><span>100</span>
                                </div>
                            </div>

                            <!-- Projected total -->
                            <div style="background: rgba(13,13,26,0.8); border: 3px solid var(--tertiary); border-radius: 16px; padding: 16px 20px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; box-shadow: 4px 4px 0 var(--quinary);">
                                <span class="label-sm" style="color: var(--tertiary);">PROJECTED OVERALL SCORE</span>
                                <span id="projectedScore" class="h3" style="font-size: 24px; color: var(--tertiary);">85.75 pts</span>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="judgeFeedback">Feedback Notes <span style="font-weight: 400; color: var(--text-muted);">(optional)</span></label>
                                <textarea class="form-textarea" id="judgeFeedback" rows="3" placeholder="Constructive feedback for the team..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary" style="width: 100%;">
                                <span class="material-symbols-outlined" style="font-size: 18px;">save</span>
                                SUBMIT SCORE 🚀
                            </button>
                        </form>

                        <div id="evalResult" style="margin-top: 16px; display: none;"></div>
                    </div>

                    <!-- Right: Live Leaderboard -->
                    <div class="glass-panel pattern-checker" style="padding: 32px; border-color: var(--tertiary);">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                            <h3 class="h3" style="color: var(--tertiary);">LIVE LEADERBOARD 🏆</h3>
                            <span class="chip chip-tertiary animate-pulse-glow" style="font-size: 11px;">
                                <span class="material-symbols-outlined" style="font-size: 13px;">refresh</span>
                                AUTO-UPDATED
                            </span>
                        </div>

                        <div style="display: flex; flex-direction: column; gap: 14px;" id="leaderboardList">
                            <c:forEach var="entry" items="${leaderboard}" varStatus="loop">
                                <div style="padding: 18px 20px; background: rgba(13,13,26,0.7); border: 3px solid ${loop.index == 0 ? 'var(--tertiary)' : loop.index == 1 ? 'var(--secondary)' : loop.index == 2 ? 'var(--quaternary)' : 'var(--quinary)'}; border-radius: 16px; display: flex; align-items: center; gap: 16px; transition: transform 0.2s ease, box-shadow 0.2s ease;"
                                     onmouseover="this.style.transform='translateX(4px)';" onmouseout="this.style.transform='translateX(0)';">
                                    <!-- Rank badge -->
                                    <div style="width: 44px; height: 44px; border-radius: 50%; flex-shrink: 0;
                                                background: ${loop.index == 0 ? 'linear-gradient(135deg, var(--tertiary), #D97706)' : loop.index == 1 ? 'linear-gradient(135deg, var(--secondary), #0EA5E9)' : loop.index == 2 ? 'linear-gradient(135deg, var(--quaternary), #DC2626)' : 'rgba(45,27,78,0.9)'};
                                                display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 16px; color: ${loop.index < 3 ? '#000' : 'var(--text-muted)'}; border: 3px solid #FFF;">
                                        #${loop.index + 1}
                                    </div>
                                    <!-- Info -->
                                    <div style="flex-grow: 1; min-width: 0;">
                                        <h4 style="font-size: 16px; font-weight: 800; color: #FFF; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${entry.projectTitle}</h4>
                                        <p class="text-muted label-sm" style="font-size: 12px; margin-top: 2px;">Team: ${entry.teamName}</p>
                                    </div>
                                    <!-- Score + GitHub -->
                                    <div style="text-align: right; flex-shrink: 0;">
                                        <div class="h3" style="font-size: 20px; color: var(--tertiary);">${entry.averageScore}</div>
                                        <div class="label-sm text-muted" style="font-size: 10px;">PTS</div>
                                        <c:if test="${not empty entry.githubUrl}">
                                            <a href="${entry.githubUrl}" target="_blank"
                                               style="font-size: 11px; color: var(--secondary); display: block; margin-top: 4px; font-weight: 700;">GitHub ↗</a>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${empty leaderboard}">
                                <div style="text-align: center; padding: 48px 0;">
                                    <span class="material-symbols-outlined animate-bounce" style="font-size: 48px; color: var(--text-muted);">leaderboard</span>
                                    <p class="text-muted" style="margin-top: 16px; font-size: 15px;">No scored submissions yet. Rate a project to populate the leaderboard.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>

                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <%@ include file="footer.jspf" %>

<script>
function updateSlider(labelId, value) {
    document.getElementById(labelId).textContent = value;
    recalcProjectedScore();
}

function recalcProjectedScore() {
    const v1 = parseFloat(document.getElementById('scoreInnovation').value);
    const v2 = parseFloat(document.getElementById('scoreTechnical').value);
    const v3 = parseFloat(document.getElementById('scoreDesign').value);
    const v4 = parseFloat(document.getElementById('scorePresentation').value);
    const avg = ((v1 + v2 + v3 + v4) / 4).toFixed(2);
    const el = document.getElementById('projectedScore');
    if (el) el.textContent = avg + ' pts';
}

// Initialize projected score on load
document.addEventListener('DOMContentLoaded', recalcProjectedScore);

async function handleRatingSubmit(e) {
    e.preventDefault();
    const submissionId = document.getElementById('evalSubmissionId').value;
    const resDiv = document.getElementById('evalResult');

    if (!submissionId) {
        resDiv.style.display = 'flex';
        resDiv.className = 'alert-banner error';
        resDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size:20px;">error</span> Please select a submission to score.';
        return;
    }

    const innovationScore = parseInt(document.getElementById('scoreInnovation').value);
    const technicalScore = parseInt(document.getElementById('scoreTechnical').value);
    const designScore = parseInt(document.getElementById('scoreDesign').value);
    const presentationScore = parseInt(document.getElementById('scorePresentation').value);
    const feedback = document.getElementById('judgeFeedback').value;

    resDiv.style.display = 'none';
    try {
        const res = await fetch('<c:url value="/api/ratings"/>', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ submissionId, innovationScore, technicalScore, designScore, presentationScore, feedback })
        });
        const data = await res.json();
        if (res.ok) {
            resDiv.style.display = 'flex';
            resDiv.className = 'alert-banner success';
            resDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size:20px;">check_circle</span> Score submitted! Calculated total: <strong>' + data.totalScore + ' pts</strong>';
            setTimeout(() => window.location.reload(), 1800);
        } else {
            resDiv.style.display = 'flex';
            resDiv.className = 'alert-banner error';
            resDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size:20px;">error</span> ' + (data.message || 'Error submitting score.');
        }
    } catch (err) {
        resDiv.style.display = 'flex';
        resDiv.className = 'alert-banner error';
        resDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size:20px;">error</span> Server error. Please try again.';
    }
}
</script>
</body>
</html>
