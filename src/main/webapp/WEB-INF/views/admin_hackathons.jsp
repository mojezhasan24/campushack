<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Manage Hackathons ⚡</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Massive Background Typography -->
    <div class="watermark-bg" style="position: fixed; top: 120px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(8rem, 20vw, 18rem); color: rgba(255,230,0,0.03); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        EVENTS
    </div>

    <!-- Floating Decorative Shapes -->
    <span class="deco-shape animate-float animate-delay-1" style="top: 15%; right: 4%; font-size: 3rem;">🏆</span>
    <span class="deco-shape animate-wiggle animate-delay-2" style="top: 35%; left: 3%; font-size: 2.4rem;">⚡</span>
    <span class="deco-shape animate-bounce animate-delay-3" style="bottom: 18%; right: 2%; font-size: 2.8rem;">🎯</span>

    <main class="main-content" style="position: relative; z-index: 1;">

        <!-- Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; flex-wrap: wrap; gap: 16px;">
            <div>
                <span class="chip chip-tertiary animate-pulse-glow" style="margin-bottom: 10px; font-size: 11px;">
                    <span class="material-symbols-outlined icon-filled" style="font-size: 14px;">event</span> Event Operations Center
                </span>
                <h1 class="h1" style="margin-top: 4px;">MANAGE HACKATHONS <span class="gradient-text">🏆</span></h1>
                <p class="text-muted" style="font-size: 18px; font-weight: 500; margin-top: 6px;">Create, update, or soft-delete hackathons in the live database.</p>
            </div>
            <button onclick="openCreateModal()" class="btn btn-primary">
                <span class="material-symbols-outlined">add</span>
                CREATE HACKATHON 🚀
            </button>
        </div>

        <!-- Flash Alert Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert-banner success" style="margin-bottom: 24px;">
                <span class="material-symbols-outlined">check_circle</span>
                <span>${successMessage}</span>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert-banner error" style="margin-bottom: 24px;">
                <span class="material-symbols-outlined">error</span>
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <!-- Hackathon List Table -->
        <section class="glass-panel" style="overflow: hidden; border-color: var(--tertiary);">
            <div style="padding: 24px 32px; border-bottom: 4px solid var(--tertiary); background: rgba(255,230,0,0.15); display: flex; justify-content: space-between; align-items: center;">
                <h3 class="h3" style="color: #FFFFFF;">SYSTEM HACKATHON EVENTS</h3>
                <span class="chip chip-tertiary">${hackathons != null ? hackathons.size() : 0} TOTAL EVENTS</span>
            </div>

            <div style="overflow-x: auto;">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th>Dates</th>
                            <th>Deadline</th>
                            <th>Prize Pool</th>
                            <th>Max Size</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="h" items="${hackathons}">
                            <tr>
                                <td>
                                    <strong><a href="<c:url value='/hackathon/${h.id}'/>" style="color: var(--secondary); font-size: 1rem; font-weight: 800;">${h.title}</a></strong>
                                    <c:if test="${not empty h.coverImageUrl}">
                                        <div class="text-muted label-sm" style="font-size: 11px; text-overflow: ellipsis; max-width: 180px; overflow: hidden; white-space: nowrap;">${h.coverImageUrl}</div>
                                    </c:if>
                                </td>
                                <td><span class="chip chip-primary">${h.category}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${h.status == 'ACTIVE'}"><span class="chip chip-secondary animate-pulse-glow">ACTIVE 🔥</span></c:when>
                                        <c:when test="${h.status == 'UPCOMING'}"><span class="chip chip-tertiary">UPCOMING ⏳</span></c:when>
                                        <c:otherwise><span class="chip chip-error">COMPLETED 🏁</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div style="font-size: 13px; font-weight: 600;" class="text-muted">
                                        ${h.startDate} to ${h.endDate}
                                    </div>
                                </td>
                                <td><span class="text-muted label-sm" style="color: var(--tertiary);">${h.formattedRegistrationDeadline}</span></td>
                                <td><strong style="color: var(--secondary); font-size: 1.1rem;">${h.formattedPrizePool}</strong></td>
                                <td><span class="chip chip-quinary" style="font-size: 11px;">${h.maxTeamSize} max</span></td>
                                <td>
                                    <div style="display: flex; gap: 10px;">
                                        <button onclick="openEditModal(${h.id}, '${h.title}', '${h.category}', '${h.startDate}', '${h.endDate}', '${h.registrationDeadline}', ${h.prizePool}, ${h.maxTeamSize}, '${h.status}', '${h.coverImageUrl}')" class="btn btn-outline" style="padding: 6px 12px; font-size: 12px;">
                                            <span class="material-symbols-outlined" style="font-size: 16px;">edit</span> Edit
                                        </button>
                                        <button onclick="openDeleteConfirmModal(${h.id}, '${h.title}')" class="btn btn-danger" style="padding: 6px 12px; font-size: 12px;">
                                            <span class="material-symbols-outlined" style="font-size: 16px;">delete</span> Delete
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty hackathons}">
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 48px;" class="text-muted">
                                    No active hackathons found in the database. Click "Create Hackathon" above to add one.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- Create/Edit Hackathon Modal -->
        <div id="hackathonModal" style="display: none; position: fixed; inset: 0; background: rgba(13,13,26,0.9); backdrop-filter: blur(12px); z-index: 2000; justify-content: center; align-items: center; padding: 24px;">
            <div class="glass-panel pattern-checker" style="width: 100%; max-width: 580px; padding: 36px; border-color: var(--accent); box-shadow: 10px 10px 0 var(--tertiary), 20px 20px 0 var(--quinary); max-height: 90vh; overflow-y: auto;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                    <h3 class="h3" id="modalTitle" style="color: var(--accent);">CREATE NEW HACKATHON 🚀</h3>
                    <button onclick="closeHackathonModal()" style="background: none; border: 3px solid var(--accent); color: var(--accent); border-radius: 50%; width: 36px; height: 36px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-weight: 900;">
                        <span class="material-symbols-outlined">close</span>
                    </button>
                </div>

                <form action="<c:url value='/admin/hackathons/save'/>" method="POST" id="hackathonForm">
                    <input type="hidden" id="hId" name="id"/>

                    <div class="form-group">
                        <label class="form-label">Title</label>
                        <input class="form-input" id="hTitle" name="title" required placeholder="e.g. AI Innovation Summit 2024"/>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Category</label>
                        <input class="form-input" id="hCategory" name="category" required placeholder="e.g. Web3, AI, Cloud, Open Source"/>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Description</label>
                        <textarea class="form-textarea" id="hDescription" name="description" rows="3" required placeholder="Detailed hackathon guidelines..."></textarea>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label class="form-label">Start Date</label>
                            <input class="form-input" id="hStartDate" name="startDate" type="date" required/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">End Date</label>
                            <input class="form-input" id="hEndDate" name="endDate" type="date" required/>
                        </div>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label class="form-label">Registration Deadline</label>
                            <input class="form-input" id="hDeadline" name="registrationDeadline" type="date" required/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Status Override</label>
                            <select class="form-select" id="hStatus" name="status">
                                <option value="UPCOMING">UPCOMING</option>
                                <option value="ACTIVE">ACTIVE</option>
                                <option value="COMPLETED">COMPLETED</option>
                            </select>
                        </div>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label class="form-label">Prize Pool ($)</label>
                            <input class="form-input" id="hPrizePool" name="prizePool" type="number" step="0.01" required placeholder="5000"/>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Max Team Size</label>
                            <input class="form-input" id="hMaxTeamSize" name="maxTeamSize" type="number" required value="4"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Cover Image URL</label>
                        <input class="form-input" id="hCoverImageUrl" name="coverImageUrl" placeholder="https://images.unsplash.com/..."/>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 20px;" id="submitBtn">PUBLISH HACKATHON 🚀</button>
                </form>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div id="deleteConfirmModal" style="display: none; position: fixed; inset: 0; background: rgba(13,13,26,0.92); backdrop-filter: blur(12px); z-index: 2100; justify-content: center; align-items: center; padding: 24px;">
            <div class="glass-panel" style="width: 100%; max-width: 460px; padding: 36px; border-color: var(--quaternary); text-align: center; box-shadow: 10px 10px 0 var(--accent);">
                <div style="padding: 16px; border-radius: 50%; border: 3px solid var(--quaternary); background: rgba(255,107,53,0.15); display: inline-flex; margin-bottom: 20px;">
                    <span class="material-symbols-outlined" style="font-size: 36px; color: var(--quaternary);">warning</span>
                </div>
                <h3 class="h3" style="margin-bottom: 10px; color: var(--quaternary);">CONFIRM DELETE ⚠️</h3>
                <p class="text-muted label-sm" style="margin-bottom: 28px; font-size: 14px;" id="deleteWarningText">Are you sure you want to delete this hackathon?</p>

                <form id="deleteForm" method="POST">
                    <div style="display: flex; gap: 16px; justify-content: center;">
                        <button type="button" onclick="closeDeleteConfirmModal()" class="btn btn-outline" style="flex: 1;">CANCEL</button>
                        <button type="submit" class="btn btn-danger" style="flex: 1;">DELETE NOW 🗑️</button>
                    </div>
                </form>
            </div>
        </div>

    </main>

    <%@ include file="footer.jspf" %>

<script>
function openCreateModal() {
    document.getElementById('modalTitle').textContent = 'CREATE NEW HACKATHON 🚀';
    document.getElementById('hId').value = '';
    document.getElementById('hackathonForm').reset();
    document.getElementById('submitBtn').textContent = 'PUBLISH HACKATHON 🚀';
    document.getElementById('hackathonModal').style.display = 'flex';
}

function openEditModal(id, title, category, startDate, endDate, deadline, prizePool, maxTeamSize, status, coverUrl) {
    document.getElementById('modalTitle').textContent = 'EDIT HACKATHON ✏️';
    document.getElementById('hId').value = id;
    document.getElementById('hTitle').value = title;
    document.getElementById('hCategory').value = category;
    document.getElementById('hStartDate').value = startDate;
    document.getElementById('hEndDate').value = endDate;
    document.getElementById('hDeadline').value = deadline;
    document.getElementById('hPrizePool').value = prizePool;
    document.getElementById('hMaxTeamSize').value = maxTeamSize;
    document.getElementById('hStatus').value = status;
    document.getElementById('hCoverImageUrl').value = coverUrl || '';
    document.getElementById('submitBtn').textContent = 'SAVE CHANGES ⚡';
    document.getElementById('hackathonModal').style.display = 'flex';
}

function closeHackathonModal() {
    document.getElementById('hackathonModal').style.display = 'none';
}

function openDeleteConfirmModal(id, title) {
    document.getElementById('deleteWarningText').textContent = 'Are you sure you want to soft-delete "' + title + '"? If teams exist, deletion will be blocked.';
    document.getElementById('deleteForm').action = '<c:url value="/admin/hackathons/delete/"/>' + id;
    document.getElementById('deleteConfirmModal').style.display = 'flex';
}

function closeDeleteConfirmModal() {
    document.getElementById('deleteConfirmModal').style.display = 'none';
}
</script>
</body>
</html>
