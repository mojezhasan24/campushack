// animated-list.js

document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('animatedListContainer');
    if (!container) return;

    // Use the real data injected from JSP, or a fallback if undefined
    let notifications = window.dashboardNotifications || [
        { name: "System Online", description: "Listening for new activity...", time: "Now", icon: "⚡", color: "#1E86FF" }
    ];
    
    // Reverse the array so the oldest items are inserted first 
    // (pushing them down) and the newest items are inserted last (staying at the top)
    notifications.reverse();
    
    let queueIndex = 0;
    const activeElements = [];
    
    function createNotificationElement(item) {
        const figure = document.createElement('figure');
        figure.className = 'animated-list-item';
        
        figure.innerHTML = `
            <div class="notification-layout">
                <div class="notification-icon-box" style="background-color: ${item.color}">
                    <span style="font-size: 1.125rem;">${item.icon}</span>
                </div>
                <div class="notification-content">
                    <figcaption class="notification-header">
                        <span style="font-size: 14px;">${item.name}</span>
                        <span style="margin: 0 4px;">·</span>
                        <span class="notification-time">${item.time}</span>
                    </figcaption>
                    <p class="notification-desc">${item.description}</p>
                </div>
            </div>
        `;
        return figure;
    }
    
    function pushNotification() {
        // Stop if tab is hidden to save performance
        if (document.hidden) return;

        // Stop completely if we've shown all notifications
        if (queueIndex >= notifications.length) {
            if (intervalId) clearInterval(intervalId);
            return;
        }

        const item = notifications[queueIndex];
        queueIndex++;
        
        // Wrapper for height animation (slides everything down)
        const wrapper = document.createElement('div');
        wrapper.className = 'animated-list-item-wrapper';
        
        const el = createNotificationElement(item);
        wrapper.appendChild(el);
        
        container.insertBefore(wrapper, container.firstChild);
        activeElements.unshift(wrapper);
        
        // Measure height dynamically
        wrapper.style.height = 'auto';
        const targetHeight = wrapper.offsetHeight;
        
        // Reset to 0 and flush CSS changes
        wrapper.style.height = '0px';
        void wrapper.offsetWidth; 
        
        // Trigger CSS transition
        wrapper.style.height = targetHeight + 'px';
        wrapper.classList.add('visible');
        
        // After transition completes, clean up fixed height to allow auto reflow if needed
        setTimeout(() => {
            if (wrapper.parentNode) {
                wrapper.style.height = 'auto';
            }
        }, 400);

        // Keep DOM clean by removing off-screen items (bottom items)
        if (activeElements.length > 8) {
            const removed = activeElements.pop();
            // Just drop them visually, they are behind the gradient mask anyway
            removed.style.opacity = '0';
            setTimeout(() => {
                if (removed.parentNode === container) {
                    container.removeChild(removed);
                }
            }, 400); 
        }
    }
    
    // Initial populates (staggered) up to the first 4 items, if they exist
    let delay = 0;
    const initialCount = Math.min(4, notifications.length);
    for (let i = 0; i < initialCount; i++) {
        setTimeout(pushNotification, delay);
        delay += 600;
    }
    
    // Add remaining items automatically every 3 seconds
    let intervalId = null;
    if (notifications.length > initialCount) {
        // Start the interval after the initial staggered items finish
        setTimeout(() => {
            intervalId = setInterval(pushNotification, 3000);
        }, delay);
    }
});
