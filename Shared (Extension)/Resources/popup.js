// Debug logging utility
const debugLog = [];
function log(message, data = null) {
    const entry = `[${new Date().toLocaleTimeString()}] ${message}`;
    debugLog.push(data ? `${entry}: ${JSON.stringify(data, null, 2)}` : entry);
    updateDebugDisplay();
    console.log(message, data);
}

function updateDebugDisplay() {
    const debugElement = document.getElementById('debug-log');
    if (debugElement) {
        debugElement.textContent = debugLog.join('\n');
    }
}

// Check API availability
async function checkAPIs() {
    const apiStatus = document.getElementById('api-status');

    if (!browser.declarativeNetRequest) {
        apiStatus.textContent = '❌ declarativeNetRequest API not available';
        apiStatus.style.color = 'red';
        log('ERROR: declarativeNetRequest API not available');
        return false;
    }

    apiStatus.textContent = '✅ declarativeNetRequest API available';
    apiStatus.style.color = 'green';
    log('declarativeNetRequest API is available');
    return true;
}

// Check rules status
async function checkRules() {
    const rulesStatus = document.getElementById('rules-status');

    try {
        // Check if we can access enabled rulesets
        const enabledRulesets = await browser.declarativeNetRequest.getEnabledRulesets();
        log('Enabled rulesets', enabledRulesets);

        if (enabledRulesets.includes('tiktok_redirect_rules')) {
            rulesStatus.textContent = `✅ Rules loaded: ${enabledRulesets.join(', ')}`;
            rulesStatus.style.color = 'green';
        } else {
            rulesStatus.textContent = `⚠️ Rules NOT loaded. Found: ${enabledRulesets.join(', ') || 'none'}`;
            rulesStatus.style.color = 'orange';
        }

        // Try to get dynamic and session rules
        try {
            const dynamicRules = await browser.declarativeNetRequest.getDynamicRules();
            log('Dynamic rules', dynamicRules);
        } catch (e) {
            log('Could not get dynamic rules', e.message);
        }

        try {
            const sessionRules = await browser.declarativeNetRequest.getSessionRules();
            log('Session rules', sessionRules);
        } catch (e) {
            log('Could not get session rules', e.message);
        }
    } catch (error) {
        rulesStatus.textContent = `❌ Error checking rules: ${error.message}`;
        rulesStatus.style.color = 'red';
        log('Error checking rules', error);
    }
}

// Get current tab info
async function getCurrentTabInfo() {
    const currentUrlDiv = document.getElementById('current-url');

    try {
        const tabs = await browser.tabs.query({ active: true, currentWindow: true });
        if (tabs.length > 0) {
            const url = tabs[0].url;
            currentUrlDiv.textContent = url;
            log('Current tab URL', url);

            // Check if it's a TikTok URL with params
            if (url.includes('tiktok.com')) {
                const urlObj = new URL(url);
                if (urlObj.search) {
                    currentUrlDiv.style.color = 'orange';
                    currentUrlDiv.textContent += '\n⚠️ Has query parameters!';
                    log('TikTok URL has query parameters', urlObj.search);
                } else {
                    currentUrlDiv.style.color = 'green';
                    currentUrlDiv.textContent += '\n✅ Clean (no params)';
                    log('TikTok URL is clean');
                }
            }
        }
    } catch (error) {
        currentUrlDiv.textContent = `Error: ${error.message}`;
        log('Error getting current tab', error);
    }
}

// Test URL cleaning
document.addEventListener('DOMContentLoaded', async () => {
    log('Popup loaded');

    // Run checks
    await checkAPIs();
    await checkRules();
    await getCurrentTabInfo();

    // Test button
    document.getElementById('test-btn').addEventListener('click', async () => {
        const resultDiv = document.getElementById('test-result');
        const testUrl = 'https://www.tiktok.com/@test/video/123456?is_from_webapp=1&sender_device=pc';

        resultDiv.textContent = 'Opening test URL in new tab...';
        log('Testing with URL', testUrl);

        try {
            // Open in new tab - the rules should intercept and clean it
            const tab = await browser.tabs.create({ url: testUrl, active: false });
            log('Created test tab', tab.id);

            // Wait a bit then check the actual URL
            setTimeout(async () => {
                const updatedTab = await browser.tabs.get(tab.id);
                const finalUrl = updatedTab.url;
                log('Final URL after redirect', finalUrl);

                if (finalUrl.includes('?')) {
                    resultDiv.textContent = `❌ FAILED: URL still has params\n${finalUrl}`;
                    resultDiv.style.color = 'red';
                } else {
                    resultDiv.textContent = `✅ SUCCESS: Params removed\n${finalUrl}`;
                    resultDiv.style.color = 'green';
                }

                // Close the test tab
                await browser.tabs.remove(tab.id);
            }, 2000);
        } catch (error) {
            resultDiv.textContent = `Error: ${error.message}`;
            resultDiv.style.color = 'red';
            log('Test error', error);
        }
    });
});
