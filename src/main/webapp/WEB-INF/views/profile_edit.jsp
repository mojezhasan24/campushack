<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Edit Profile &amp; Availability 👤</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <script src="<c:url value='/js/main.js'/>" defer></script>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Watermark -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(255,58,242,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        EDIT
    </div>

    <main class="main-content" style="position: relative; z-index: 1; max-width: 840px; margin: 0 auto;">
        
        <div style="margin-bottom: 24px; text-align: center;">
            <span class="chip chip-primary animate-pulse-glow" style="margin-bottom: 8px;">
                <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 14px;">manage_accounts</span> STUDENT PROFILE
            </span>
            <h1 class="h1" style="font-size: 2.2rem; color: #FFF;">
                EDIT YOUR <span class="gradient-text">PROFILE &amp; AVAILABILITY ⚡</span>
            </h1>
        </div>

        <div class="glass-panel pattern-checker" style="padding: 32px; border-color: var(--accent); border-radius: 24px;">
            
            <form action="<c:url value='/profile/edit'/>" method="POST" style="display: flex; flex-direction: column; gap: 18px;">
                
                <!-- "Looking for Team" Toggle Banner -->
                <div style="padding: 18px 20px; background: rgba(0,245,212,0.12); border: 3px solid var(--secondary); border-radius: 18px; display: flex; align-items: center; justify-content: space-between; gap: 16px;">
                    <div>
                        <h4 class="h4" style="color: var(--secondary); margin-bottom: 2px;">🟢 "LOOKING FOR A TEAM" AVAILABILITY</h4>
                        <p class="text-muted label-sm" style="font-size: 11px;">Make your profile discoverable to team leaders searching for teammates.</p>
                    </div>
                    <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; font-weight: 800; color: #FFF;">
                        <input type="checkbox" name="lookingForTeam" value="true" ${profile.lookingForTeam ? 'checked' : ''} style="width: 20px; height: 20px; accent-color: var(--secondary);"/>
                        ENABLE
                    </label>
                </div>

                <!-- Academic Info -->
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 14px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="college">College / Institute</label>
                        <input class="form-input" id="college" name="college" type="text" value="${profile.college}" required/>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="branch">Branch</label>
                        <input class="form-input" id="branch" name="branch" type="text" value="${profile.branch}" required/>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="course">Year / Degree</label>
                        <input class="form-input" id="course" name="course" type="text" value="${profile.course}" required/>
                    </div>
                </div>

                <!-- Technical Skills & Stack -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="skills">Skills (Comma separated)</label>
                        <input class="form-input" id="skills" name="skills" type="text" value="${profile.skills}" placeholder="React, Java, Python, Figma" required/>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="techStack">Primary Tech Stack</label>
                        <input class="form-input" id="techStack" name="techStack" type="text" value="${profile.techStack}" placeholder="Full Stack Web, AI/ML" required/>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label" for="experienceYears">Years of Software Development Experience</label>
                    <input class="form-input" id="experienceYears" name="experienceYears" type="number" min="0" max="10" value="${profile.experienceYears}" required/>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label" for="bio">Short Bio</label>
                    <textarea class="form-textarea" id="bio" name="bio" rows="3" placeholder="Tell team leads about your passion and project experience...">${profile.bio}</textarea>
                </div>

                <!-- Links -->
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 14px;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="github">GitHub Profile URL</label>
                        <input class="form-input" id="github" name="github" type="url" value="${profile.github}" placeholder="https://github.com/username"/>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="linkedin">LinkedIn Profile URL</label>
                        <input class="form-input" id="linkedin" name="linkedin" type="url" value="${profile.linkedin}" placeholder="https://linkedin.com/in/username"/>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="portfolio">Portfolio Website URL</label>
                        <input class="form-input" id="portfolio" name="portfolio" type="url" value="${profile.portfolio}" placeholder="https://myportfolio.dev"/>
                    </div>
                </div>

                <!-- Featured Projects -->
                <div class="form-group" style="margin-bottom: 0;">
                    <label class="form-label" for="projects">Featured Projects (Name &amp; description)</label>
                    <textarea class="form-textarea" id="projects" name="projects" rows="2" placeholder="e.g. MedAI (AI Diagnostics), SmartHack (Hackathon portal)...">${profile.projects}</textarea>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary animate-pulse-glow" style="width: 100%; margin-top: 10px; padding: 14px;">
                    <span class="material-symbols-outlined animate-wiggle">save</span>
                    SAVE PROFILE &amp; AVAILABILITY 🚀
                </button>
            </form>
        </div>
    </main>

    <%@ include file="footer.jspf" %>
</body>
</html>
