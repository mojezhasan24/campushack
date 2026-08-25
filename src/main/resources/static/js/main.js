/* CampusHack Client-Side JavaScript */

document.addEventListener('DOMContentLoaded', () => {
    console.log('CampusHack Design System Loaded ⚡');
    initAdminTheme();
    initPasswordToggles();
    initCustomDropdowns();
});

/* ============================================================
   ADMIN THEME TOGGLE (Dopamine vs Professional Minimalist)
   ============================================================ */
function initAdminTheme() {
    const savedTheme = localStorage.getItem('campushack_admin_theme');
    if (savedTheme === 'professional') {
        document.body.classList.add('theme-professional');
        updateAdminThemeButton(true);
    } else {
        document.body.classList.remove('theme-professional');
        updateAdminThemeButton(false);
    }
}

function toggleAdminTheme() {
    const isPro = document.body.classList.toggle('theme-professional');
    if (isPro) {
        localStorage.setItem('campushack_admin_theme', 'professional');
    } else {
        localStorage.setItem('campushack_admin_theme', 'dopamine');
    }
    updateAdminThemeButton(isPro);
}

function updateAdminThemeButton(isPro) {
    const btnText = document.getElementById('adminThemeToggleText');
    const btnIcon = document.getElementById('adminThemeToggleIcon');
    if (btnText && btnIcon) {
        if (isPro) {
            btnText.textContent = 'DOPAMINE 🎨';
            btnIcon.textContent = 'palette';
        } else {
            btnText.textContent = 'PRO MODE 👔';
            btnIcon.textContent = 'style';
        }
    }
}

/* ============================================================
   AUTOMATED MAXIMALIST CUSTOM DROPDOWN COMPONENT
   ============================================================ */
function initCustomDropdowns() {
    const selects = document.querySelectorAll('select.form-select');
    selects.forEach(select => {
        if (select.dataset.customized === "true") return;
        select.dataset.customized = "true";

        // Hide raw select but keep it accessible for form validation
        select.style.position = 'absolute';
        select.style.opacity = '0';
        select.style.width = '1px';
        select.style.height = '1px';
        select.style.pointerEvents = 'none';

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
        if (select.options.length === 0) {
            const emptyOpt = document.createElement('div');
            emptyOpt.className = 'custom-select-option disabled';
            emptyOpt.style.opacity = '0.6';
            emptyOpt.style.cursor = 'not-allowed';
            emptyOpt.textContent = 'No options available';
            menu.appendChild(emptyOpt);
        } else {
            Array.from(select.options).forEach((opt, idx) => {
                const optDiv = document.createElement('div');
                const isSelected = idx === select.selectedIndex;
                const isDisabled = opt.disabled;
                
                optDiv.className = 'custom-select-option' + 
                    (isSelected ? ' selected' : '') + 
                    (isDisabled ? ' disabled' : '');

                if (isDisabled) {
                    optDiv.style.opacity = '0.5';
                    optDiv.style.cursor = 'not-allowed';
                }

                optDiv.innerHTML = `
                    <span>${opt.textContent}</span>
                    <span class="material-symbols-outlined icon-check" style="font-size: 16px; opacity: ${isSelected ? 1 : 0};">check</span>
                `;

                if (!isDisabled) {
                    optDiv.addEventListener('click', (e) => {
                        e.stopPropagation();
                        select.selectedIndex = idx;
                        select.value = opt.value;

                        // Update UI
                        trigger.querySelector('.trigger-label').textContent = opt.textContent;
                        menu.querySelectorAll('.custom-select-option').forEach((el, i) => {
                            if (i === idx) {
                                el.classList.add('selected');
                                const check = el.querySelector('.icon-check');
                                if (check) check.style.opacity = '1';
                            } else {
                                el.classList.remove('selected');
                                const check = el.querySelector('.icon-check');
                                if (check) check.style.opacity = '0';
                            }
                        });

                        closeMenu();

                        // Trigger change event for reactive forms
                        select.dispatchEvent(new Event('change', { bubbles: true }));
                    });
                }

                menu.appendChild(optDiv);
            });
        }

        // Toggle open/close
        function openMenu() {
            document.querySelectorAll('.custom-select-menu.open').forEach(m => {
                if (m !== menu) {
                    m.classList.remove('open');
                    if (m.previousElementSibling) m.previousElementSibling.classList.remove('active');
                    const otherContainer = m.closest('.custom-select-container');
                    if (otherContainer) otherContainer.style.zIndex = '';
                    const otherPanel = m.closest('.glass-panel');
                    if (otherPanel) otherPanel.style.zIndex = '';
                }
            });
            menu.classList.add('open');
            trigger.classList.add('active');
            container.style.zIndex = '9999';
            const panel = container.closest('.glass-panel');
            if (panel) panel.style.zIndex = '999';
        }

        function closeMenu() {
            menu.classList.remove('open');
            trigger.classList.remove('active');
            container.style.zIndex = '';
            const panel = container.closest('.glass-panel');
            if (panel) panel.style.zIndex = '';
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
                        const check = el.querySelector('.icon-check');
                        if (check) check.style.opacity = '1';
                    } else {
                        el.classList.remove('selected');
                        const check = el.querySelector('.icon-check');
                        if (check) check.style.opacity = '0';
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
