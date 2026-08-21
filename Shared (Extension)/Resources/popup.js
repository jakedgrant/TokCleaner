import { CONFIG } from './constants.js';

// Sanitize error messages to prevent information disclosure
function sanitizeErrorMessage(error) {
    // Log detailed error for debugging (console only, not shown to user)
    console.error('TokCleaner error:', error);

    // Return generic user-friendly message
    if (error.message.includes('permission')) {
        return '✗ Extension permissions need to be enabled in Safari settings.';
    } else if (error.message.includes('network') || error.message.includes('fetch')) {
        return '✗ Please check your internet connection.';
    } else if (error.message.includes('tab')) {
        return '✗ Unable to open test page. Please try manually.';
    } else {
        return '✗ An error occurred. Please reload the extension and try again.';
    }
}

// Safe DOM method to set status (prevents XSS)
function setStatus(element, isActive, text) {
    // Clear existing content
    element.textContent = '';

    // Create status dot
    const dot = document.createElement('span');
    dot.className = 'status-dot';
    if (!isActive) {
        dot.style.background = '#ff3b30';
    }

    // Add dot and text using safe DOM methods
    element.appendChild(dot);
    element.appendChild(document.createTextNode(text));
}

// Check extension status
async function checkExtensionStatus() {
    const statusElement = document.getElementById('extension-status');

    try {
        // Simple check - if we can access browser APIs, extension is working
        const permissions = await browser.permissions.getAll();

        // Use safe DOM method instead of innerHTML
        setStatus(statusElement, true, 'Active');
    } catch (error) {
        // Use safe DOM method instead of innerHTML
        setStatus(statusElement, false, 'Error');
    }
}

// Check current page
async function checkCurrentPage() {
    const pageStatus = document.getElementById('page-status');
    const pageIcon = pageStatus.querySelector('.page-icon');
    const pageMessage = document.getElementById('page-message');

    try {
        const tabs = await browser.tabs.query({ active: true, currentWindow: true });
        if (tabs.length > 0) {
            const url = tabs[0].url;

            // Check if it's a TikTok page
            if (url.includes('tiktok.com')) {
                const urlObj = new URL(url);

                if (urlObj.search) {
                    // Has query parameters (shouldn't happen if extension works)
                    pageStatus.className = 'page-info tiktok';
                    pageIcon.textContent = '⚠️';
                    pageMessage.textContent = 'TikTok page with tracking parameters detected';
                } else {
                    // Clean TikTok URL
                    pageStatus.className = 'page-info clean';
                    pageIcon.textContent = '✓';
                    pageMessage.textContent = 'TikTok page is clean';
                }
            } else {
                // Not a TikTok page
                pageStatus.className = 'page-info';
                pageIcon.textContent = '📍';
                pageMessage.textContent = 'Not a TikTok page';
            }
        }
    } catch (error) {
        pageMessage.textContent = 'Unable to check current page';
    }
}

// Read the stored X/Twitter -> xcancel.com preference and wire the toggle.
async function initXcancelToggle() {
    const toggle = document.getElementById('xcancel-toggle');
    const errorEl = document.getElementById('xcancel-toggle-error');
    if (!toggle) return;

    const showSyncError = (message) => {
        if (!errorEl) return;
        if (message) {
            errorEl.textContent = `⚠️ Redirect isn't active: ${message}`;
            errorEl.hidden = false;
        } else {
            errorEl.hidden = true;
        }
    };

    try {
        const stored = await browser.storage.local.get({
            [CONFIG.XCANCEL_STORAGE_KEY]: false,
            [CONFIG.XCANCEL_SYNC_ERROR_KEY]: null
        });
        toggle.checked = stored[CONFIG.XCANCEL_STORAGE_KEY] === true;
        if (toggle.checked) showSyncError(stored[CONFIG.XCANCEL_SYNC_ERROR_KEY]);
    } catch (error) {
        console.error('TokCleaner: failed to read xcancel redirect preference:', error);
    }

    // The background service worker updates the sync error after each toggle change.
    browser.storage.onChanged.addListener((changes, areaName) => {
        if (areaName === 'local' && CONFIG.XCANCEL_SYNC_ERROR_KEY in changes && toggle.checked) {
            showSyncError(changes[CONFIG.XCANCEL_SYNC_ERROR_KEY].newValue);
        }
    });

    toggle.addEventListener('change', async () => {
        try {
            await browser.storage.local.set({ [CONFIG.XCANCEL_STORAGE_KEY]: toggle.checked });
            if (!toggle.checked) showSyncError(null);
        } catch (error) {
            console.error('TokCleaner: failed to save xcancel redirect preference:', error);
            toggle.checked = !toggle.checked;
        }
    });
}

// Test functionality
document.addEventListener('DOMContentLoaded', async () => {
    // Check status on load
    await checkExtensionStatus();
    await checkCurrentPage();
    await initXcancelToggle();

    // Test button
    const testBtn = document.getElementById('test-btn');
    const resultDiv = document.getElementById('test-result');

    testBtn.addEventListener('click', async () => {
        const testUrl = 'https://www.tiktok.com/@tiktok/video/7016181462948326661?is_from_webapp=1&sender_device=pc';

        testBtn.disabled = true;
        testBtn.textContent = 'Testing...';
        resultDiv.className = 'show';
        resultDiv.textContent = 'Opening test page...';

        try {
            // Open test URL in background tab
            const tab = await browser.tabs.create({ url: testUrl, active: false });

            // Wait for redirect to complete
            await new Promise(resolve => setTimeout(resolve, CONFIG.TEST_REDIRECT_WAIT_MS));

            // Check if parameters were removed
            const updatedTab = await browser.tabs.get(tab.id);
            const finalUrl = updatedTab.url;

            // Close test tab
            await browser.tabs.remove(tab.id);

            // Show result
            if (finalUrl.includes('?')) {
                resultDiv.className = 'error show';
                resultDiv.textContent = '✗ Test failed - tracking parameters were not removed. Try reloading Safari.';
            } else {
                resultDiv.className = 'success show';
                resultDiv.textContent = '✓ Test passed - extension is working correctly!';
            }
        } catch (error) {
            resultDiv.className = 'error show';
            resultDiv.textContent = sanitizeErrorMessage(error);
        } finally {
            testBtn.disabled = false;
            testBtn.textContent = 'Run Test';
        }
    });
});
