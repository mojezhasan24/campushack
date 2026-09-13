<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - ${hackathon.title} ⚡</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Massive Background Typography -->
    <div style="position: fixed; top: 120px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 20vw, 18rem); color: rgba(255,58,242,0.03); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        EVENT
    </div>

    <!-- Floating Decorative Shapes -->
    <span class="deco-shape animate-float" style="top: 14%; right: 4%; font-size: 3rem;">⚡</span>
    <span class="deco-shape animate-wiggle" style="top: 30%; left: 2%; font-size: 2.6rem;">🏆</span>
    <span class="deco-shape animate-bounce" style="bottom: 15%; right: 3%; font-size: 2.8rem;">🚀</span>

    <main class="main-content" style="position: relative; z-index: 1;">

        <!-- Breadcrumb -->
        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 24px; font-size: 14px; font-weight: 700;">
            <a href="<c:url value='/discover'/>" style="color: var(--secondary); text-transform: uppercase;">Discover 🚀</a>
            <span class="material-symbols-outlined" style="font-size: 16px; color: var(--accent);">chevron_right</span>
            <span style="color: #FFF;">${hackathon.title}</span>
        </div>

        <!-- Banner Header -->
        <section class="glass-panel pattern-checker" style="padding: 40px; margin-bottom: 32px; border-color: var(--accent); box-shadow: 10px 10px 0 var(--tertiary), 20px 20px 0 var(--quinary);">
            <div style="position: relative; z-index: 1;">
                <div style="display: flex; gap: 10px; margin-bottom: 16px; flex-wrap: wrap;">
                    <span class="chip chip-primary">${hackathon.category}</span>
                    <span class="chip chip-tertiary animate-pulse-glow">
                        <span class="material-symbols-outlined" style="font-size: 14px;">emoji_events</span>
                        PRIZE POOL: $${hackathon.prizePool} 🔥
                    </span>
                    <span class="chip chip-secondary">
                        <span class="material-symbols-outlined" style="font-size: 14px;">group</span>
                        MAX ${hackathon.maxTeamSize} PER TEAM
                    </span>
                    <c:choose>
                        <c:when test="${hackathon.status == 'ACTIVE'}"><span class="chip chip-secondary">ACTIVE 🔥</span></c:when>
                        <c:when test="${hackathon.status == 'UPCOMING'}"><span class="chip chip-tertiary">UPCOMING ⏳</span></c:when>
                        <c:otherwise><span class="chip chip-error">COMPLETED 🏁</span></c:otherwise>
                    </c:choose>
                </div>
                <h1 class="h1" style="font-size: clamp(2.2rem, 5vw, 3.8rem); margin-bottom: 16px; color: #FFF;">${hackathon.title}</h1>
                <p class="text-muted" style="font-size: 18px; max-width: 800px; line-height: 1.7; font-weight: 500;">${hackathon.description}</p>
                
                <div style="display: flex; gap: 28px; margin-top: 24px; flex-wrap: wrap;">
                    <div style="display: flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 700;">
                        <span class="material-symbols-outlined" style="font-size: 20px; color: var(--secondary);">calendar_today</span>
                        START: <strong style="color: #FFF;">${hackathon.startDate}</strong>
                    </div>
                    <div style="display: flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 700;">
                        <span class="material-symbols-outlined" style="font-size: 20px; color: var(--quaternary);">event_busy</span>
                        ENDS: <strong style="color: #FFF;">${hackathon.endDate}</strong>
                    </div>
                    <div style="display: flex; align-items: center; gap: 8px; font-size: 14px; font-weight: 700;">
                        <span class="material-symbols-outlined" style="font-size: 20px; color: var(--tertiary);">timer</span>
                        REG DEADLINE: <strong style="color: var(--tertiary);">${hackathon.registrationDeadline}</strong>
                    </div>
                </div>
            </div>
        </section>

        <!-- Participant-only section: Team Formation -->
        <c:if test="${sessionScope.role == 'PARTICIPANT'}">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 28px; margin-bottom: 32px;" class="col-2">

                <!-- Create Team -->
                <div class="glass-panel pattern-dots" style="padding: 32px; border-color: var(--secondary);">
                    <h3 class="h3" style="color: var(--secondary); margin-bottom: 6px;">CREATE A TEAM 🚩</h3>
                    <p class="text-muted label-sm" style="margin-bottom: 24px;">Generate an 8-character invite code to share with your teammates.</p>
                    <form onsubmit="handleCreateTeam(event)">
                        <input type="hidden" id="createHackathonId" value="${hackathon.id}"/>
                        <div class="form-group">
                            <label class="form-label" for="newTeamName">Team Name</label>
                            <input class="form-input" id="newTeamName" type="text" placeholder="e.g. Binary Builders" required/>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                            <span class="material-symbols-outlined" style="font-size: 18px;">add</span>
                            CREATE TEAM &amp; GET CODE ⚡
                        </button>
                    </form>
                    <div id="createTeamResult" style="margin-top: 16px; display: none;"></div>
                </div>

                <!-- Join Team -->
                <div class="glass-panel pattern-stripes" style="padding: 32px; border-color: var(--tertiary);">
                    <h3 class="h3" style="color: var(--tertiary); margin-bottom: 6px;">JOIN EXISTING TEAM 🤝</h3>
                    <p class="text-muted label-sm" style="margin-bottom: 24px;">Enter the invite code shared by your team leader.</p>
                    <form onsubmit="handleJoinTeam(event)">
                        <div class="form-group">
                            <label class="form-label" for="inviteCodeInput">Team Invite Code</label>
                            <input class="form-input" id="inviteCodeInput" type="text"
                                   placeholder="e.g. A1B2C3D4"
                                   maxlength="8"
                                   style="text-transform: uppercase; letter-spacing: 0.2em; text-align: center; font-size: 22px; font-weight: 900; color: var(--tertiary);"
                                   oninput="this.value = this.value.toUpperCase()"
                                   required/>
                        </div>
                        <button type="submit" class="btn btn-secondary" style="width: 100%;">
                            <span class="material-symbols-outlined" style="font-size: 18px;">group_add</span>
                            JOIN TEAM NOW 🚀
                        </button>
                    </form>
                    <div id="joinTeamResult" style="margin-top: 16px; display: none;"></div>
                </div>

            </div>
        </c:if>

        <!-- View-only notice for non-participants -->
        <c:if test="${sessionScope.role == 'ADMIN' or sessionScope.role == 'JUDGE'}">
            <div class="glass-panel" style="padding: 28px; display: flex; align-items: center; gap: 20px; border-color: var(--secondary); margin-bottom: 32px;">
                <span class="material-symbols-outlined" style="font-size: 36px; color: var(--secondary); flex-shrink: 0;">info</span>
                <div>
                    <p style="font-size: 17px; font-weight: 800; color: #FFF;">VIEWING AS ${sessionScope.role} 🛡️</p>
                    <p class="text-muted" style="font-size: 15px; margin-top: 2px;">Team formation and project submission are available to Student / Participant accounts only.</p>
                </div>
            </div>
        </c:if>

        <!-- Teams registered (visible to all) -->
        <c:if test="${not empty teams}">
            <div class="glass-panel pattern-dots" style="padding: 32px; border-color: var(--quinary);">
                <h3 class="h3" style="margin-bottom: 20px; color: #FFF;">
                    REGISTERED TEAMS
                    <span class="chip chip-tertiary" style="margin-left: 10px; font-size: 12px;">${teams.size()} ROSTERS</span>
                </h3>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px;">
                    <c:forEach var="t" items="${teams}" varStatus="loop">
                        <div style="padding: 16px 20px; background: rgba(13,13,26,0.7); border: 3px solid ${loop.index % 4 == 0 ? 'var(--accent)' : loop.index % 4 == 1 ? 'var(--secondary)' : loop.index % 4 == 2 ? 'var(--tertiary)' : 'var(--quaternary)'}; border-radius: 16px; display: flex; align-items: center; gap: 14px;">
                            <span class="material-symbols-outlined" style="color: var(--accent); font-size: 24px;">group</span>
                            <div>
                                <div style="font-size: 15px; font-weight: 800; color: #FFF;">${t.teamName}</div>
                                <div class="text-muted label-sm" style="font-size: 12px; margin-top: 2px;">${t.members.size()} member(s)</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

    </main>

    <%@ include file="footer.jspf" %>

<script>
async function handleCreateTeam(e) {
    e.preventDefault();
    const hackathonId = document.getElementById('createHackathonId').value;
    const teamName = document.getElementById('newTeamName').value.trim();
    const resDiv = document.getElementById('createTeamResult');

    if (!teamName) return;

    resDiv.style.display = 'none';
    try {
        const res = await fetch('<c:url value="/api/teams/create"/>', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ hackathonId, teamName })
        });
        const data = await res.json();
        if (res.ok) {
            resDiv.style.display = 'flex';
            resDiv.className = 'alert-banner success';
            resDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size:20px;">check_circle</span> Team created! Your invite code: <strong style="letter-spacing:0.15em; font-size: 18px; margin-left: 6px;">' + data.inviteCode + '</strong> <button type="button" class="btn btn-outline" style="margin-left: 12px; padding: 4px 8px; font-size: 12px; cursor: pointer;" onclick="navigator.clipboard.writeText(\'' + data.inviteCode + '\'); this.innerText=\'Copied!\';">Copy</button>';
        } else {
            resDiv.style.display = 'flex';
            resDiv.className = 'alert-banner error';
            resDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size:20px;">error</span> ' + (data.message || 'Error creating team.');
        }
    } catch (err) {
        resDiv.style.display = 'flex';
        resDiv.className = 'alert-banner error';
        resDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size:20px;">error</span> Server error. Please try again.';
    }
}

async function handleJoinTeam(e) {
    e.preventDefault();
    const inviteCode = document.getElementById('inviteCodeInput').value.trim().toUpperCase();
    const resDiv = document.getElementById('joinTeamResult');

    if (inviteCode.length !== 8) {
        resDiv.style.display = 'flex';
        resDiv.className = 'alert-banner error';
        resDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size:20px;">error</span> Invite code must be exactly 8 characters.';
        return;
    }

    resDiv.style.display = 'none';
    try {
        const res = await fetch('<c:url value="/api/teams/join"/>', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ inviteCode })
        });
        const data = await res.json();
        if (res.ok) {
            resDiv.style.display = 'flex';
            resDiv.className = 'alert-banner success';
            resDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size:20px;">check_circle</span> Successfully joined: <strong>' + data.teamName + '</strong>';
            setTimeout(() => window.location.reload(), 2000);
        } else {
            resDiv.style.display = 'flex';
            resDiv.className = 'alert-banner error';
            resDiv.innerHTML = '<span class="material-symbols-outlined" style="font-size:20px;">error</span> ' + (data.message || 'Invalid invite code or team is full.');
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
