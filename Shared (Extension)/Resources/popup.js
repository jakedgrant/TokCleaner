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

            // Check if it's a supported social media page
            if (url.includes('tiktok.com') || url.includes('instagram.com') || url.includes('youtube.com')) {
                const urlObj = new URL(url);

                if (urlObj.search) {
                    // Has query parameters (shouldn't happen if extension works)
                    pageStatus.className = 'page-info social';
                    pageIcon.textContent = '⚠️';
                    pageMessage.textContent = 'Social media page with tracking parameters detected';
                } else {
                    // Clean URL
                    pageStatus.className = 'page-info clean';
                    pageIcon.textContent = '✓';
                    pageMessage.textContent = 'Social media page is clean';
                }
            } else {
                // Not a supported social media page
                pageStatus.className = 'page-info';
                pageIcon.textContent = '📍';
                pageMessage.textContent = 'Not a supported social media page';
            }
        }
    } catch (error) {
        pageMessage.textContent = 'Unable to check current page';
    }
}

// Test functionality
document.addEventListener('DOMContentLoaded', async () => {
    // Check status on load
    await checkExtensionStatus();
    await checkCurrentPage();

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
