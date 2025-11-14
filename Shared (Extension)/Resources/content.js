// Content script runs on TikTok pages at document_start (earliest possible)

// Check if URL has query parameters and redirect IMMEDIATELY
const url = new URL(window.location.href);
if (url.search) {
    // Build clean URL
    const cleanUrl = `${url.protocol}//${url.host}${url.pathname}${url.hash || ''}`;

    // Redirect immediately before page renders
    window.location.replace(cleanUrl);
} else {
    // Only show banner after DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', showBanner);
    } else {
        showBanner();
    }
}

// Ensure styles are added only once to prevent memory leaks
function ensureStyles() {
    // Check if styles already exist
    const existingStyle = document.getElementById('tokcleaner-styles');
    if (!existingStyle) {
        const style = document.createElement('style');
        style.id = 'tokcleaner-styles';
        style.textContent = `
            @keyframes slideDown {
                from {
                    transform: translateY(-100%);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            @keyframes slideUp {
                from {
                    transform: translateY(0);
                    opacity: 1;
                }
                to {
                    transform: translateY(-100%);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    }
}

function showBanner() {
    // Ensure styles exist (only creates once)
    ensureStyles();

    // Show banner briefly to confirm extension is working
    const banner = document.createElement('div');
    banner.id = 'tokcleaner-banner';
    banner.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        background: #000000;
        color: #ffffff;
        padding: 14px;
        text-align: center;
        z-index: 999999;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        font-size: 14px;
        font-weight: 600;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
        border-bottom: 2px solid #fe2c55;
        animation: slideDown 0.3s ease-out;
    `;

    banner.innerHTML = `
        <div style="display: flex; align-items: center; justify-content: center; gap: 8px;">
            <span style="font-size: 18px;">🧹</span>
            <span>Tracking parameters removed</span>
        </div>
    `;

    document.body.appendChild(banner);

    // Fade out and remove banner after configured duration
    setTimeout(() => {
        banner.style.animation = 'slideUp 0.3s ease-in';
        setTimeout(() => banner.remove(), 300);
    }, window.TOKCLEANER_CONFIG?.BANNER_DISPLAY_MS || 2500);
}
