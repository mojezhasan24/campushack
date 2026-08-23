<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>CampusHack - 404 Page Not Found</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh;">
    <%@ include file="../header.jspf" %>
    <main class="main-content" style="display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center;">
        <div class="glass-panel" style="padding: 48px; max-width: 480px; width: 100%;">
            <span class="material-symbols-outlined" style="font-size: 64px; color: var(--error);">sentiment_very_dissatisfied</span>
            <h1 class="h1" style="font-size: 36px; margin-top: 16px;">404 - Not Found</h1>
            <p class="text-muted" style="margin-top: 12px; margin-bottom: 24px;">The hackathon route or page you requested does not exist.</p>
            <a href="<c:url value='/dashboard'/>" class="btn btn-primary">Return to Dashboard</a>
        </div>
    </main>
    <%@ include file="../footer.jspf" %>
</body>
</html>
