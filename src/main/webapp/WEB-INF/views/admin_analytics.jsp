<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Admin Analytics ⚡</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Massive Background Typography -->
    <div class="watermark-bg" style="position: fixed; top: 120px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 20vw, 18rem); color: rgba(255,58,242,0.03); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        METRICS
    </div>

    <!-- Floating Decorative Shapes -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 15%; left: 3%; font-size: 2.5rem;">⚡</span>
    <span class="deco-shape animate-float-reverse animate-delay-2" style="top: 25%; right: 4%; font-size: 3rem;">🔥</span>
    <span class="deco-shape animate-wiggle animate-delay-3" style="bottom: 20%; left: 2%; font-size: 2.2rem;">📊</span>
    <span class="deco-shape animate-bounce animate-delay-4" style="bottom: 15%; right: 3%; font-size: 2.8rem;">🚀</span>

    <main class="main-content" style="position: relative; z-index: 1;">

        <!-- Page Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; flex-wrap: wrap; gap: 16px;">
            <div>
                <span class="chip chip-tertiary animate-pulse-glow" style="margin-bottom: 10px; font-size: 11px;">
                    <span class="material-symbols-outlined icon-filled" style="font-size: 14px;">bolt</span> Real-time Database Telemetry
                </span>
                <h1 class="h1" style="margin-top: 4px;">SYSTEM ANALYTICS <span class="gradient-text">⚡</span></h1>
                <p class="text-muted" style="font-size: 18px; font-weight: 500; margin-top: 6px;">Live database activity feeds, demographics, and student participant export.</p>
            </div>
            <button onclick="openExportModal()" class="btn btn-primary">
                <span class="material-symbols-outlined" style="font-size: 18px;">download</span>
                EXPORT STUDENT CSV 🚀
            </button>
        </div>

        <!-- 100% Real Database Bento Grid Statistics (Accent rotation modulo 5) -->
        <section style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; margin-bottom: 40px;">
            
            <!-- Stat Card 1: Accent (Magenta) -->
            <div class="glass-panel" style="padding: 28px; border-color: var(--accent); border-style: solid; box-shadow: 6px 6px 0 var(--tertiary), 12px 12px 0 var(--quinary); transform: rotate(-0.5deg);">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px;">
                    <span class="label-sm" style="color: var(--accent);">Total Users 👥</span>
                    <div class="stat-icon" style="background: rgba(255,58,242,0.15); border-color: var(--accent);">
                        <span class="material-symbols-outlined icon-filled" style="color: var(--accent); font-size: 26px;">groups</span>
                    </div>
                </div>
                <div>
                    <div class="stat-lg" style="color: #FFFFFF; text-shadow: 3px 3px 0 var(--quinary), 6px 6px 0 var(--accent);">${analytics.totalParticipants}</div>
                    <div class="label-sm text-muted" style="margin-top: 8px;">Registered Accounts</div>
                </div>
            </div>

            <!-- Stat Card 2: Secondary (Cyan) -->
            <div class="glass-panel" style="padding: 28px; border-color: var(--secondary); border-style: dashed; box-shadow: 6px 6px 0 var(--accent), 12px 12px 0 var(--tertiary); transform: rotate(0.8deg);">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px;">
                    <span class="label-sm" style="color: var(--secondary);">Total Events 🏆</span>
                    <div class="stat-icon" style="background: rgba(0,245,212,0.15); border-color: var(--secondary);">
                        <span class="material-symbols-outlined icon-filled" style="color: var(--secondary); font-size: 26px;">event</span>
                    </div>
                </div>
                <div>
                    <div class="stat-lg" style="color: #FFFFFF; text-shadow: 3px 3px 0 var(--accent), 6px 6px 0 var(--secondary);">${analytics.totalHackathons}</div>
                    <div class="label-sm text-muted" style="margin-top: 8px;">Active &amp; Upcoming</div>
                </div>
            </div>

            <!-- Stat Card 3: Tertiary (Yellow) -->
            <div class="glass-panel" style="padding: 28px; border-color: var(--tertiary); border-style: solid; box-shadow: 6px 6px 0 var(--quinary), 12px 12px 0 var(--secondary); transform: rotate(-0.7deg);">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px;">
                    <span class="label-sm" style="color: var(--tertiary);">Total Teams 🚩</span>
                    <div class="stat-icon" style="background: rgba(255,230,0,0.15); border-color: var(--tertiary);">
                        <span class="material-symbols-outlined icon-filled" style="color: var(--tertiary); font-size: 26px;">groups_3</span>
                    </div>
                </div>
                <div>
                    <div class="stat-lg" style="color: #FFFFFF; text-shadow: 3px 3px 0 var(--quinary), 6px 6px 0 var(--tertiary);">${analytics.totalTeams}</div>
                    <div class="label-sm text-muted" style="margin-top: 8px;">Rosters Formed</div>
                </div>
            </div>

            <!-- Stat Card 4: Quaternary (Orange) -->
            <div class="glass-panel" style="padding: 28px; border-color: var(--quaternary); border-style: dashed; box-shadow: 6px 6px 0 var(--secondary), 12px 12px 0 var(--accent); transform: rotate(0.5deg); background: linear-gradient(135deg, rgba(45,27,78,0.9), rgba(255,107,53,0.15));">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px;">
                    <span class="label-sm" style="color: var(--quaternary);">Submissions 📤</span>
                    <div class="stat-icon" style="background: rgba(255,107,53,0.15); border-color: var(--quaternary);">
                        <span class="material-symbols-outlined icon-filled" style="color: var(--quaternary); font-size: 26px;">upload_file</span>
                    </div>
                </div>
                <div>
                    <div class="stat-lg" style="color: #FFFFFF; text-shadow: 3px 3px 0 var(--quinary), 6px 6px 0 var(--quaternary);">${analytics.totalSubmissions}</div>
                    <div class="label-sm text-muted" style="margin-top: 8px;">Submitted for Judging</div>
                </div>
            </div>
        </section>

        <!-- Branch Analytics and Activity Feed -->
        <section style="display: grid; grid-template-columns: 1fr 1fr; gap: 28px; margin-bottom: 40px;" class="col-2">
            
            <!-- Branch Distribution Chart Card -->
            <div class="glass-panel pattern-checker" style="padding: 32px; border-color: var(--secondary);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <h3 class="h3" style="color: var(--secondary);">BRANCH DEMOGRAPHICS</h3>
                    <span class="chip chip-secondary">LIVE DB DATA</span>
                </div>

                <c:choose>
                    <c:when test="${not empty analytics.branchDistribution}">
                        <div style="display: flex; flex-direction: column; gap: 20px;">
                            <c:forEach var="entry" items="${analytics.branchDistribution}" varStatus="status">
                                <div>
                                    <div style="display: flex; justify-content: space-between; font-size: 15px; margin-bottom: 8px; font-weight: 700;">
                                        <span>${entry.key}</span>
                                        <span class="chip ${status.index % 4 == 0 ? 'chip-primary' : status.index % 4 == 1 ? 'chip-secondary' : status.index % 4 == 2 ? 'chip-tertiary' : 'chip-quaternary'}">${entry.value} participants</span>
                                    </div>
                                    <div class="segment-track" style="height: 12px;">
                                        <div style="width: ${analytics.totalParticipants > 0 ? (entry.value * 100 / analytics.totalParticipants) : 0}%; height: 100%; background: ${status.index % 4 == 0 ? 'var(--accent)' : status.index % 4 == 1 ? 'var(--secondary)' : status.index % 4 == 2 ? 'var(--tertiary)' : 'var(--quaternary)'}; border-radius: 9999px; box-shadow: 0 0 10px currentColor;"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted label-sm" style="text-align: center; padding: 32px;">No branch demographics recorded in database yet.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Recent Activity Feed Card -->
            <div class="glass-panel pattern-dots" style="padding: 32px; border-color: var(--tertiary);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <h3 class="h3" style="color: var(--tertiary);">RECENT ACTIVITY FEED</h3>
                    <span class="chip chip-tertiary animate-pulse-glow">LIVE LOGS</span>
                </div>

                <div style="display: flex; flex-direction: column; gap: 16px;">
                    <c:forEach var="user" items="${analytics.recentUsers}">
                        <div style="display: flex; align-items: center; gap: 14px; padding: 12px 16px; background: rgba(13,13,26,0.6); border: 2px solid var(--accent); border-radius: 16px;">
                            <div class="stat-icon" style="width: 40px; height: 40px; border-color: var(--accent); background: rgba(255,58,242,0.15);">
                                <span class="material-symbols-outlined" style="color: var(--accent); font-size: 20px;">person_add</span>
                            </div>
                            <div>
                                <strong style="font-size: 15px;">${user.fullName != null ? user.fullName : user.username}</strong> registered as <span class="chip chip-primary" style="font-size: 10px; padding: 2px 8px;">${user.role}</span>
                                <div class="text-muted label-sm" style="font-size: 12px; margin-top: 2px;">${user.email}</div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:forEach var="h" items="${analytics.recentHackathons}">
                        <div style="display: flex; align-items: center; gap: 14px; padding: 12px 16px; background: rgba(13,13,26,0.6); border: 2px solid var(--secondary); border-radius: 16px;">
                            <div class="stat-icon" style="width: 40px; height: 40px; border-color: var(--secondary); background: rgba(0,245,212,0.15);">
                                <span class="material-symbols-outlined" style="color: var(--secondary); font-size: 20px;">event</span>
                            </div>
                            <div>
                                <strong style="font-size: 15px;">Hackathon Created:</strong> ${h.title}
                                <div class="text-muted label-sm" style="font-size: 12px; margin-top: 2px;">Category: ${h.category} • Start: ${h.startDate}</div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty analytics.recentUsers && empty analytics.recentHackathons}">
                        <p class="text-muted label-sm" style="text-align: center; padding: 32px;">No recent database activity found.</p>
                    </c:if>
                </div>
            </div>
        </section>

        <!-- Hackathons Overview Table -->
        <section class="glass-panel" style="overflow: hidden; border-color: var(--quinary);">
            <div style="padding: 24px 32px; border-bottom: 4px solid var(--quinary); background: rgba(123,47,255,0.15); display: flex; justify-content: space-between; align-items: center;">
                <h3 class="h3" style="color: #FFFFFF;">ACTIVE HACKATHONS OVERVIEW</h3>
                <a href="<c:url value='/admin/hackathons'/>" class="btn btn-outline" style="padding: 8px 18px; font-size: 12px;">MANAGE EVENTS 🏆 →</a>
            </div>

            <div style="overflow-x: auto;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Hackathon Title</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Prize Pool</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="h" items="${hackathons}">
                            <tr>
                                <td>
                                    <strong><a href="<c:url value='/hackathon/${h.id}'/>" style="color: var(--secondary); font-weight: 800; font-size: 1rem;">${h.title}</a></strong>
                                </td>
                                <td><span class="chip chip-primary">${h.category}</span></td>
                                <td><span class="chip chip-secondary">${h.status}</span></td>
                                <td><strong style="color: var(--tertiary); font-size: 1.1rem;">$${h.prizePool}</strong></td>
                                <td><span class="text-muted label-sm">${h.startDate}</span></td>
                                <td><span class="text-muted label-sm">${h.endDate}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Export Student CSV Filter Modal -->
        <div id="exportModal" style="display: none; position: fixed; inset: 0; background: rgba(13,13,26,0.9); backdrop-filter: blur(12px); z-index: 2000; justify-content: center; align-items: center; padding: 24px;">
            <div class="glass-panel pattern-stripes" style="width: 100%; max-width: 520px; padding: 36px; border-color: var(--tertiary); box-shadow: 10px 10px 0 var(--accent), 20px 20px 0 var(--quinary);">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <h3 class="h3" style="color: var(--tertiary);">EXPORT STUDENT CSV 🚀</h3>
                    <button onclick="closeExportModal()" style="background: none; border: 3px solid var(--accent); color: var(--accent); border-radius: 50%; width: 36px; height: 36px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-weight: 900;">
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>

                <form action="<c:url value='/admin/export/students'/>" method="GET" target="_blank" onsubmit="closeExportModal()">
                    <div class="form-group">
                        <label class="form-label">Specific Hackathon</label>
                        <select class="form-select" name="hackathonId">
                            <option value="">All Hackathons</option>
                            <c:forEach var="h" items="${hackathons}">
                                <option value="${h.id}">${h.title}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label class="form-label">Branch</label>
                            <select class="form-select" name="branch">
                                <option value="">All Branches</option>
                                <option value="Computer Science">Computer Science</option>
                                <option value="Information Tech">Information Tech</option>
                                <option value="Electronics">Electronics</option>
                                <option value="Design">Design</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Year of Study</label>
                            <select class="form-select" name="yearOfStudy">
                                <option value="">All Years</option>
                                <option value="1st Year">1st Year</option>
                                <option value="2nd Year">2nd Year</option>
                                <option value="3rd Year">3rd Year</option>
                                <option value="4th Year">4th Year</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Registered After Date</label>
                        <input class="form-input" type="date" name="registeredAfter"/>
                    </div>

                    <div class="form-group" style="display: flex; align-items: center; gap: 12px; margin-top: 16px;">
                        <input type="checkbox" id="last3Hackathons" name="last3Hackathons" value="true" style="width: 22px; height: 22px; accent-color: var(--accent); cursor: pointer;"/>
                        <label for="last3Hackathons" class="label-sm text-muted" style="cursor: pointer; font-size: 13px;">Limit export to participants of <strong>Last 3 Hackathons</strong></label>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 24px;">
                        <span class="material-symbols-outlined">download</span>
                        DOWNLOAD FILTERED CSV ⚡
                    </button>
                </form>
            </div>
        </div>

    </main>

    <%@ include file="footer.jspf" %>

<script>
function openExportModal() {
    document.getElementById('exportModal').style.display = 'flex';
}
function closeExportModal() {
    document.getElementById('exportModal').style.display = 'none';
}
</script>
</body>
</html>
