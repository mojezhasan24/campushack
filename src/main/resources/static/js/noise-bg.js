// noise-bg.js

document.addEventListener('DOMContentLoaded', () => {
    // Check if the user prefers reduced motion
    const isReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (isReducedMotion) return;

    // Cache elements in an array on load to skip DOM queries per frame
    const noiseElements = Array.from(document.querySelectorAll('.noise-bg'));
    if (noiseElements.length === 0) return;

    let startTime = performance.now();
    let animationFrameId;

    // Store last values to only update if changed by > 0.1%
    const lastValues = new Map();

    function animate() {
        // Pause animation when tab is hidden
        if (document.hidden) {
            animationFrameId = requestAnimationFrame(animate);
            return;
        }

        const time = (performance.now() - startTime) * 0.001; 

        // Calculate positions once per frame
        const x1 = 50 + Math.cos(time * 0.8) * 35;
        const y1 = 50 + Math.sin(time * 0.8) * 35;
        
        const x2 = 50 + Math.cos(time * 0.5 + Math.PI) * 40;
        const y2 = 50 + Math.sin(time * 0.5 + Math.PI) * 40;
        
        const x3 = 50 + Math.cos(time * 1.2 + Math.PI/2) * 25;
        const y3 = 50 + Math.sin(time * 1.2 + Math.PI/2) * 25;

        noiseElements.forEach((el) => {
            const elData = lastValues.get(el) || { x1: -1, y1: -1, x2: -1, y2: -1, x3: -1, y3: -1 };

            // Only update CSS vars if changed by > 0.1
            if (Math.abs(elData.x1 - x1) > 0.1 || Math.abs(elData.y1 - y1) > 0.1) {
                el.style.setProperty('--grad1-x', `${x1.toFixed(1)}%`);
                el.style.setProperty('--grad1-y', `${y1.toFixed(1)}%`);
                elData.x1 = x1;
                elData.y1 = y1;
            }
            if (Math.abs(elData.x2 - x2) > 0.1 || Math.abs(elData.y2 - y2) > 0.1) {
                el.style.setProperty('--grad2-x', `${x2.toFixed(1)}%`);
                el.style.setProperty('--grad2-y', `${y2.toFixed(1)}%`);
                elData.x2 = x2;
                elData.y2 = y2;
            }
            if (Math.abs(elData.x3 - x3) > 0.1 || Math.abs(elData.y3 - y3) > 0.1) {
                el.style.setProperty('--grad3-x', `${x3.toFixed(1)}%`);
                el.style.setProperty('--grad3-y', `${y3.toFixed(1)}%`);
                elData.x3 = x3;
                elData.y3 = y3;
            }

            if (!lastValues.has(el)) {
                lastValues.set(el, elData);
            }
        });

        animationFrameId = requestAnimationFrame(animate);
    }
    
    animationFrameId = requestAnimationFrame(animate);
    
    // Additional event listener for visibility change just to be safe
    let pauseTime = 0;
    document.addEventListener("visibilitychange", () => {
        if (document.hidden) {
            pauseTime = performance.now();
        } else {
            if (pauseTime > 0) {
                startTime += (performance.now() - pauseTime);
                pauseTime = 0;
            }
        }
    });
});
