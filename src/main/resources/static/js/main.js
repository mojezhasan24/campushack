/* CampusHack Client-Side JavaScript */

document.addEventListener('DOMContentLoaded', () => {
    console.log('CampusHack Design System Loaded ⚡');
    initPasswordToggles();
    initCustomDropdowns();
});

/* ============================================================
   AUTOMATED MAXIMALIST CUSTOM DROPDOWN COMPONENT
   ============================================================ */
function initCustomDropdowns() {
    const selects = document.querySelectorAll('select.form-select');
    selects.forEach(select => {
        if (select.dataset.customized === "true") return;
        select.dataset.customized = "true";

        // Hide raw select
        select.style.display = 'none';

        // Create container wrapper
        const container = document.createElement('div');
        container.className = 'custom-select-container';

        // Read initial selected option
        const initialOpt = select.options[select.selectedIndex] || select.options[0];
        const initialText = initialOpt ? initialOpt.textContent : 'Select option';

        // Create trigger button
        const trigger = document.createElement('div');
        trigger.className = 'custom-select-trigger';
        trigger.innerHTML = `
            <span class="trigger-label">${initialText}</span>
            <span class="material-symbols-outlined icon-chevron">expand_more</span>
        `;

        // Create glass menu popover
        const menu = document.createElement('div');
        menu.className = 'custom-select-menu';

        // Populate options
        Array.from(select.options).forEach((opt, idx) => {
            const optDiv = document.createElement('div');
            optDiv.className = 'custom-select-option' + (idx === select.selectedIndex ? ' selected' : '');
            optDiv.innerHTML = `
                <span>${opt.textContent}</span>
                <span class="material-symbols-outlined icon-check" style="font-size: 16px; opacity: ${idx === select.selectedIndex ? 1 : 0};">check</span>
            `;

            optDiv.addEventListener('click', (e) => {
                e.stopPropagation();
                select.selectedIndex = idx;
                select.value = opt.value;

                // Update UI
                trigger.querySelector('.trigger-label').textContent = opt.textContent;
                menu.querySelectorAll('.custom-select-option').forEach((el, i) => {
                    if (i === idx) {
                        el.classList.add('selected');
                        el.querySelector('.icon-check').style.opacity = 1;
                    } else {
                        el.classList.remove('selected');
                        el.querySelector('.icon-check').style.opacity = 0;
                    }
                });

                closeMenu();

                // Trigger change event for reactive forms
                select.dispatchEvent(new Event('change', { bubbles: true }));
            });

            menu.appendChild(optDiv);
        });

        // Toggle open/close
        function openMenu() {
            // Close other open menus
            document.querySelectorAll('.custom-select-menu.open').forEach(m => {
                if (m !== menu) {
                    m.classList.remove('open');
                    if (m.previousElementSibling) m.previousElementSibling.classList.remove('active');
                }
            });
            menu.classList.add('open');
            trigger.classList.add('active');
        }

        function closeMenu() {
            menu.classList.remove('open');
            trigger.classList.remove('active');
        }

        trigger.addEventListener('click', (e) => {
            e.stopPropagation();
            if (menu.classList.contains('open')) {
                closeMenu();
            } else {
                openMenu();
            }
        });

        // Insert container right after native select
        select.parentNode.insertBefore(container, select.nextSibling);
        container.appendChild(trigger);
        container.appendChild(menu);

        // Keep label updated if select.value changes programmatically
        select.addEventListener('change', () => {
            const curOpt = select.options[select.selectedIndex];
            if (curOpt) {
                trigger.querySelector('.trigger-label').textContent = curOpt.textContent;
                menu.querySelectorAll('.custom-select-option').forEach((el, i) => {
                    if (i === select.selectedIndex) {
                        el.classList.add('selected');
                        el.querySelector('.icon-check').style.opacity = 1;
                    } else {
                        el.classList.remove('selected');
                        el.querySelector('.icon-check').style.opacity = 0;
                    }
                });
            }
        });
    });

    // Close menus on outside click
    document.addEventListener('click', (e) => {
        if (!e.target.closest('.custom-select-container')) {
            document.querySelectorAll('.custom-select-menu.open').forEach(m => {
                m.classList.remove('open');
                if (m.previousElementSibling) m.previousElementSibling.classList.remove('active');
            });
        }
    });
}

function initPasswordToggles() {
    const toggleButtons = document.querySelectorAll('.toggle-password');
    toggleButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const input = btn.previousElementSibling;
            if (input && input.type === 'password') {
                input.type = 'text';
                btn.querySelector('.material-symbols-outlined').textContent = 'visibility_off';
            } else if (input) {
                input.type = 'password';
                btn.querySelector('.material-symbols-outlined').textContent = 'visibility';
            }
        });
    });
}

// Utility for AJAX API Calls
async function apiRequest(url, method = 'GET', data = null) {
    const options = {
        method: method,
        headers: {
            'Content-Type': 'application/json'
        }
    };
    if (data) {
        options.body = JSON.stringify(data);
    }

    try {
        const response = await fetch(url, options);
        const responseData = await response.json();
        if (!response.ok) {
            throw new Error(responseData.message || 'An error occurred during request processing.');
        }
        return responseData;
    } catch (err) {
        console.error('API Request Error:', err);
        throw err;
    }
}
