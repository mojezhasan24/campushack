<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CampusHack - Swipe Discovery ⚡</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />

    <style>
        :root {
            --like-color: #10b981;
            --like-gradient: linear-gradient(135deg, #10b981 0%, #059669 100%);
            --pass-color: #ef4444;
            --pass-gradient: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%);
            --super-color: #0ea5e9;
            --super-gradient: linear-gradient(135deg, #38bdf8 0%, #0284c7 100%);
        }

        .swipe-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: calc(100vh - 160px);
            position: relative;
            z-index: 2;
        }

        /* Card Container Stage */
        .stage {
            position: relative;
            width: 100%;
            max-width: 400px;
            height: 520px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 20px auto 0;
        }

        /* Card Stack Styling */
        .card {
            position: absolute;
            width: 92%;
            height: 100%;
            background: rgba(30, 41, 59, 0.95);
            backdrop-filter: blur(16px);
            border-radius: 28px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5), 
                        0 0 0 2px rgba(255, 255, 255, 0.1);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            cursor: grab;
            touch-action: none;
            will-change: transform, opacity;
            transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275), opacity 0.3s ease;
        }

        .card:active {
            cursor: grabbing;
        }

        /* Card Visual Header / Banner */
        .card-banner {
            height: 180px;
            position: relative;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            background-size: cover;
            background-position: center;
        }

        .card-banner::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(to bottom, rgba(15, 23, 42, 0.2) 0%, rgba(30, 41, 59, 1) 100%);
        }

        .card-badge {
            position: relative;
            z-index: 2;
            align-self: flex-start;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            backdrop-filter: blur(8px);
        }

        .badge-team {
            background: rgba(139, 92, 246, 0.3);
            color: #c084fc;
            border: 1px solid rgba(192, 132, 252, 0.4);
        }

        .badge-member {
            background: rgba(16, 185, 129, 0.3);
            color: #6ee7b7;
            border: 1px solid rgba(110, 231, 183, 0.4);
        }

        /* Swipe Stamps / Stickers */
        .stamp {
            position: absolute;
            top: 36px;
            padding: 8px 18px;
            border-radius: 12px;
            font-size: 2rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 2px;
            border: 4px solid;
            opacity: 0;
            z-index: 10;
            pointer-events: none;
            transition: opacity 0.1s ease;
        }

        .stamp-like {
            left: 24px;
            color: var(--like-color);
            border-color: var(--like-color);
            transform: rotate(-15deg);
        }

        .stamp-nope {
            right: 24px;
            color: var(--pass-color);
            border-color: var(--pass-color);
            transform: rotate(15deg);
        }

        /* Card Content Body */
        .card-content {
            padding: 16px 24px 24px;
            display: flex;
            flex-direction: column;
            flex: 1;
            justify-content: space-between;
            position: relative;
            z-index: 2;
        }

        .card-header h2 {
            font-size: 1.4rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 6px;
            line-height: 1.25;
        }

        .card-meta {
            display: flex;
            gap: 16px;
            color: #94a3b8;
            font-size: 0.85rem;
            margin-bottom: 14px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .card-description {
            font-size: 0.92rem;
            color: #cbd5e1;
            line-height: 1.5;
            margin-bottom: 16px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .card-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .tag {
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.08);
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 0.78rem;
            color: #94a3b8;
        }

        /* Bottom Controls Bar */
        .controls {
            width: 100%;
            max-width: 380px;
            padding: 24px 0;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            z-index: 10;
        }

        .btn-action {
            border: none;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 10px 20px rgba(0,0,0,0.3);
            transition: all 0.2s ease;
        }

        .btn-action:hover {
            transform: scale(1.1);
        }

        .btn-action:active {
            transform: scale(0.95);
        }

        .btn-small {
            width: 48px;
            height: 48px;
            background: rgba(255, 255, 255, 0.08);
            color: #94a3b8;
            border: 1px solid rgba(255,255,255,0.1);
        }

        .btn-large {
            width: 64px;
            height: 64px;
            font-size: 30px;
        }

        .btn-pass {
            background: rgba(244, 63, 94, 0.1);
            color: var(--pass-color);
            border: 2px solid rgba(244, 63, 94, 0.3);
        }

        .btn-pass:hover {
            background: var(--pass-gradient);
            color: white;
            border-color: transparent;
            box-shadow: 0 10px 25px rgba(244, 63, 94, 0.4);
        }

        .btn-like {
            background: rgba(16, 185, 129, 0.1);
            color: var(--like-color);
            border: 2px solid rgba(16, 185, 129, 0.3);
        }

        .btn-like:hover {
            background: var(--like-gradient);
            color: white;
            border-color: transparent;
            box-shadow: 0 10px 25px rgba(16, 185, 129, 0.4);
        }

        .btn-super {
            background: rgba(56, 189, 248, 0.1);
            color: var(--super-color);
            border: 2px solid rgba(56, 189, 248, 0.3);
        }

        .btn-super:hover {
            background: var(--super-gradient);
            color: white;
            border-color: transparent;
            box-shadow: 0 10px 25px rgba(56, 189, 248, 0.4);
        }

        /* Empty State */
        .empty-state {
            position: absolute;
            inset: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 32px;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.4s ease;
        }

        .empty-state.active {
            opacity: 1;
            pointer-events: auto;
        }

        .empty-icon {
            font-size: 64px;
            color: var(--accent);
            margin-bottom: 16px;
            animation: pulse 2s infinite;
        }

        .toast {
            position: fixed;
            top: 100px;
            left: 50%;
            transform: translateX(-50%) translateY(-20px);
            background: rgba(30, 41, 59, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.1);
            padding: 10px 20px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            opacity: 0;
            pointer-events: none;
            transition: all 0.3s ease;
            z-index: 100;
            color: #fff;
        }

        .toast.show {
            opacity: 1;
            transform: translateX(-50%) translateY(0);
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.9; }
            50% { transform: scale(1.1); opacity: 1; }
        }
    </style>
</head>
<body style="display: flex; flex-direction: column; min-height: 100vh; position: relative;">

    <%@ include file="header.jspf" %>

    <!-- Watermark Background -->
    <div class="watermark-bg" style="position: fixed; top: 110px; left: 50%; transform: translateX(-50%); font-family: var(--font-display); font-size: clamp(6rem, 18vw, 16rem); color: rgba(0,245,212,0.035); pointer-events: none; white-space: nowrap; z-index: 0; user-select: none;">
        SWIPE MATCH
    </div>

    <!-- Toast Notification -->
    <div id="toast" class="toast">
        <span id="toast-icon" class="material-symbols-outlined" style="font-size: 18px;">info</span>
        <span id="toast-message">Action executed</span>
    </div>

    <main class="main-content swipe-wrapper">

        <div style="text-align: center; margin-bottom: 8px;">
            <span class="chip chip-secondary animate-pulse-glow" style="margin-bottom: 8px;">
                <span class="material-symbols-outlined icon-filled animate-wiggle" style="font-size: 14px;">local_fire_department</span> MATCHMAKER MODE
            </span>
            <h1 class="h2" style="color: #FFF; font-size: clamp(1.8rem, 3.5vw, 2.5rem);">
                SWIPE OPPORTUNITIES <span class="gradient-text">🔥</span>
            </h1>
            <p class="text-muted" style="font-size: 15px; margin-top: 4px;">
                Swipe right to express interest, swipe left to pass.
            </p>
        </div>

        <!-- Main Card Swiping Stage -->
        <div class="stage" id="stage">
            <!-- Empty State Container -->
            <div class="empty-state" id="empty-state">
                <span class="material-symbols-outlined empty-icon">saved_search</span>
                <h3 style="color: #FFF; font-size: 1.5rem; margin-bottom: 8px;">All Caught Up!</h3>
                <p style="color: #94a3b8; font-size: 0.95rem; margin-bottom: 24px;">You've reviewed all available hackathons and team requests.</p>
                <button class="btn btn-primary" id="btn-reload" style="border-radius: 30px; padding: 12px 28px;">
                    <span class="material-symbols-outlined">refresh</span>
                    REFRESH FEED 🚀
                </button>
            </div>
        </div>

        <!-- Bottom Action Controls -->
        <div class="controls">
            <button class="btn-action btn-small" id="btn-rewind" title="Rewind last swipe">
                <span class="material-symbols-outlined">replay</span>
            </button>
            <button class="btn-action btn-large btn-pass" id="btn-pass" title="Pass (Swipe Left)">
                <span class="material-symbols-outlined">close</span>
            </button>
            <button class="btn-action btn-small btn-super" id="btn-super" title="Super Like (Swipe Up)">
                <span class="material-symbols-outlined">star</span>
            </button>
            <button class="btn-action btn-large btn-like" id="btn-like" title="Like (Swipe Right)">
                <span class="material-symbols-outlined">favorite</span>
            </button>
        </div>

    </main>

    <%@ include file="footer.jspf" %>

    <!-- JavaScript Logic -->
    <script>
        const SAMPLE_OPPORTUNITIES = [
            {
                id: 1,
                title: "AI for Social Impact Hackathon",
                description: "Build innovative AI solutions addressing climate change, renewable energy, and sustainable tech.",
                badge: "Team Needed",
                badgeType: "team",
                location: "Delhi | Online",
                date: "Oct 15-17",
                gradient: "linear-gradient(135deg, #4f46e5, #7c3aed)",
                tags: ["Python", "TensorFlow", "ESG", "$10,000 Prize"]
            },
            {
                id: 2,
                title: "Looking for Full-stack Dev",
                description: "Need a high-velocity MERN/Spring Boot developer to spearhead backend architecture for a fintech project.",
                badge: "Looking for Member",
                badgeType: "member",
                location: "Remote",
                date: "Immediate",
                gradient: "linear-gradient(135deg, #059669, #10b981)",
                tags: ["React", "Spring Boot", "PostgreSQL", "Fintech"]
            },
            {
                id: 3,
                title: "CyberSecurity Breach 4.0",
                description: "48-hour intense ethical hacking and CTF challenge. Looking for cryptography enthusiasts and reverse engineers.",
                badge: "Team Needed",
                badgeType: "team",
                location: "Bengaluru | Hybrid",
                date: "Nov 02-04",
                gradient: "linear-gradient(135deg, #dc2626, #9333ea)",
                tags: ["CTF", "Security", "Rust", "Crypto"]
            },
            {
                id: 4,
                title: "UI/UX Designer Wanted",
                description: "Design-oriented founder looking for a Figma wizard to craft stunning glassmorphism interfaces for campus app.",
                badge: "Looking for Member",
                badgeType: "member",
                location: "On-Campus",
                date: "Next Week",
                gradient: "linear-gradient(135deg, #db2777, #ca8a04)",
                tags: ["Figma", "Design System", "Mobile UI", "Prototyping"]
            }
        ];

        class OpportunityAPI {
            static async fetchOpportunities() {
                await new Promise(resolve => setTimeout(resolve, 250));
                return [...SAMPLE_OPPORTUNITIES];
            }

            static async sendSwipeDecision(cardId, action) {
                console.log(`[API] Swipe card ${cardId} -> ${action}`);
                return { success: true, cardId, action };
            }
        }

        class SwipeApp {
            constructor() {
                this.stage = document.getElementById('stage');
                this.emptyState = document.getElementById('empty-state');
                this.btnPass = document.getElementById('btn-pass');
                this.btnLike = document.getElementById('btn-like');
                this.btnSuper = document.getElementById('btn-super');
                this.btnRewind = document.getElementById('btn-rewind');
                this.btnReload = document.getElementById('btn-reload');

                this.opportunities = [];
                this.history = [];
                this.cardElements = [];
                this.isAnimating = false;

                this.init();
            }

            async init() {
                this.bindEvents();
                await this.loadCards();
            }

            async loadCards() {
                this.opportunities = await OpportunityAPI.fetchOpportunities();
                this.renderCards();
            }

            renderCards() {
                const existingCards = this.stage.querySelectorAll('.card');
                existingCards.forEach(c => c.remove());
                this.cardElements = [];

                if (this.opportunities.length === 0) {
                    this.emptyState.classList.add('active');
                    return;
                }

                this.emptyState.classList.remove('active');
                const visibleCount = Math.min(4, this.opportunities.length);
                
                for (let i = visibleCount - 1; i >= 0; i--) {
                    const data = this.opportunities[i];
                    const cardEl = this.createCardElement(data);
                    this.stage.appendChild(cardEl);
                    this.cardElements.unshift(cardEl);
                }

                this.updateStackPositions();
                this.attachDragHandlers();
            }

            createCardElement(data) {
                const card = document.createElement('div');
                card.className = 'card';
                card.dataset.id = data.id;

                const tagsHtml = data.tags.map(t => `<span class="tag">${t}</span>`).join('');

                card.innerHTML = `
                    <div class="stamp stamp-like">LIKE</div>
                    <div class="stamp stamp-nope">NOPE</div>
                    <div class="card-banner" style="background: ${data.gradient};">
                        <span class="card-badge ${data.badgeType === 'team' ? 'badge-team' : 'badge-member'}">
                            ${data.badge}
                        </span>
                    </div>
                    <div class="card-content">
                        <div>
                            <div class="card-header">
                                <h2>${data.title}</h2>
                            </div>
                            <div class="card-meta">
                                <div class="meta-item">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">location_on</span>
                                    ${data.location}
                                </div>
                                <div class="meta-item">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">schedule</span>
                                    ${data.date}
                                </div>
                            </div>
                            <p class="card-description">${data.description}</p>
                        </div>
                        <div class="card-tags">
                            ${tagsHtml}
                        </div>
                    </div>
                `;

                return card;
            }

            updateStackPositions() {
                this.cardElements.forEach((card, index) => {
                    if (index === 0) {
                        card.style.transform = `translate3d(0, 0, 0) scale(1)`;
                        card.style.opacity = '1';
                        card.style.zIndex = '5';
                        card.style.pointerEvents = 'auto';
                    } else if (index < 3) {
                        const translateY = index * 14;
                        const scale = 1 - (index * 0.05);
                        card.style.transform = `translate3d(0, ${translateY}px, 0) scale(${scale})`;
                        card.style.opacity = `${1 - index * 0.2}`;
                        card.style.zIndex = `${5 - index}`;
                        card.style.pointerEvents = 'none';
                    } else {
                        card.style.transform = `translate3d(0, 42px, 0) scale(0.85)`;
                        card.style.opacity = '0';
                        card.style.zIndex = '0';
                        card.style.pointerEvents = 'none';
                    }
                });
            }

            attachDragHandlers() {
                const topCard = this.cardElements[0];
                if (!topCard) return;

                let startX = 0, startY = 0, currentX = 0, currentY = 0, isDragging = false;
                const stampLike = topCard.querySelector('.stamp-like');
                const stampNope = topCard.querySelector('.stamp-nope');

                const onStart = (e) => {
                    if (this.isAnimating) return;
                    isDragging = true;
                    topCard.style.transition = 'none';
                    startX = e.type.includes('touch') ? e.touches[0].pageX : e.pageX;
                    startY = e.type.includes('touch') ? e.touches[0].pageY : e.pageY;
                };

                const onMove = (e) => {
                    if (!isDragging) return;
                    const pageX = e.type.includes('touch') ? e.touches[0].pageX : e.pageX;
                    const pageY = e.type.includes('touch') ? e.touches[0].pageY : e.pageY;

                    currentX = pageX - startX;
                    currentY = pageY - startY;

                    const rotate = currentX * 0.08;
                    topCard.style.transform = `translate3d(${currentX}px, ${currentY}px, 0) rotate(${rotate}deg)`;

                    const maxDist = 120;
                    if (currentX > 0) {
                        stampLike.style.opacity = Math.min(currentX / maxDist, 1);
                        stampNope.style.opacity = 0;
                    } else {
                        stampNope.style.opacity = Math.min(Math.abs(currentX) / maxDist, 1);
                        stampLike.style.opacity = 0;
                    }
                };

                const onEnd = () => {
                    if (!isDragging) return;
                    isDragging = false;
                    topCard.style.transition = 'transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275), opacity 0.3s ease';

                    const threshold = 100;
                    if (currentX > threshold) {
                        this.swipeCard('right');
                    } else if (currentX < -threshold) {
                        this.swipeCard('left');
                    } else if (currentY < -threshold) {
                        this.swipeCard('up');
                    } else {
                        topCard.style.transform = `translate3d(0, 0, 0) scale(1)`;
                        stampLike.style.opacity = 0;
                        stampNope.style.opacity = 0;
                    }
                    startX = 0; startY = 0; currentX = 0; currentY = 0;
                };

                topCard.onmousedown = onStart;
                topCard.ontouchstart = onStart;
                window.onmousemove = onMove;
                window.ontouchmove = onMove;
                window.onmouseup = onEnd;
                window.ontouchend = onEnd;
            }

            async swipeCard(direction) {
                if (this.isAnimating || this.cardElements.length === 0) return;
                this.isAnimating = true;

                const topCard = this.cardElements.shift();
                const cardData = this.opportunities.shift();

                this.history.push({ cardData, element: topCard, direction });

                const stampLike = topCard.querySelector('.stamp-like');
                const stampNope = topCard.querySelector('.stamp-nope');

                topCard.style.transition = 'transform 0.5s ease, opacity 0.4s ease';

                let flyX = 0, flyY = 0, rotate = 0;
                let toastMsg = "";

                if (direction === 'right') {
                    flyX = window.innerWidth || 500;
                    rotate = 25;
                    stampLike.style.opacity = 1;
                    toastMsg = `Liked "${cardData.title}"`;
                } else if (direction === 'left') {
                    flyX = -(window.innerWidth || 500);
                    rotate = -25;
                    stampNope.style.opacity = 1;
                    toastMsg = `Passed on "${cardData.title}"`;
                } else if (direction === 'up') {
                    flyY = -(window.innerHeight || 700);
                    stampLike.style.opacity = 1;
                    toastMsg = `Super Liked "${cardData.title}"! 🔥`;
                }

                topCard.style.transform = `translate3d(${flyX}px, ${flyY}px, 0) rotate(${rotate}deg)`;
                topCard.style.opacity = '0';

                OpportunityAPI.sendSwipeDecision(cardData.id, direction);
                this.showToast(toastMsg, direction === 'right' ? 'favorite' : direction === 'left' ? 'close' : 'star');

                setTimeout(() => {
                    topCard.remove();
                    this.updateStackPositions();
                    this.attachDragHandlers();
                    this.isAnimating = false;

                    if (this.opportunities.length === 0) {
                        this.emptyState.classList.add('active');
                    }
                }, 300);
            }

            rewindLastSwipe() {
                if (this.isAnimating || this.history.length === 0) {
                    this.showToast("Nothing to rewind", "info");
                    return;
                }

                this.isAnimating = true;
                const last = this.history.pop();

                this.opportunities.unshift(last.cardData);
                const cardEl = this.createCardElement(last.cardData);

                cardEl.style.transition = 'none';
                cardEl.style.transform = `translate3d(0, -100px, 0) scale(0.9)`;
                cardEl.style.opacity = '0';

                this.stage.appendChild(cardEl);
                this.cardElements.unshift(cardEl);
                this.emptyState.classList.remove('active');

                setTimeout(() => {
                    cardEl.style.transition = 'transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275), opacity 0.3s ease';
                    this.updateStackPositions();
                    this.attachDragHandlers();
                    this.isAnimating = false;
                    this.showToast(`Restored "${last.cardData.title}"`, "replay");
                }, 50);
            }

            bindEvents() {
                this.btnPass.addEventListener('click', () => this.swipeCard('left'));
                this.btnLike.addEventListener('click', () => this.swipeCard('right'));
                this.btnSuper.addEventListener('click', () => this.swipeCard('up'));
                this.btnRewind.addEventListener('click', () => this.rewindLastSwipe());
                this.btnReload.addEventListener('click', () => this.loadCards());
            }

            showToast(message, icon = 'info') {
                const toast = document.getElementById('toast');
                const toastMsg = document.getElementById('toast-message');
                const toastIcon = document.getElementById('toast-icon');

                toastMsg.innerText = message;
                toastIcon.innerText = icon;

                toast.classList.add('show');
                clearTimeout(this.toastTimeout);
                this.toastTimeout = setTimeout(() => {
                    toast.classList.remove('show');
                }, 2200);
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            new SwipeApp();
        });
    </script>
</body>
</html>
