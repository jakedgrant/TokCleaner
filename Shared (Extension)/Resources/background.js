// Service worker for Safari Web Extension
// Runs only when needed, unloads automatically on iOS

browser.runtime.onInstalled.addListener((details) => {
    console.log('TokCleaner installed');
});

// Track redirects to avoid loops
const redirectedTabs = new Map();

// Fallback: Manual redirect if content script doesn't catch it
browser.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
    if (changeInfo.url && changeInfo.url.includes('tiktok.com')) {
        const url = new URL(changeInfo.url);
        if (url.search) {
            const lastRedirect = redirectedTabs.get(tabId);
            const now = Date.now();

            if (lastRedirect && (now - lastRedirect) < 1000) {
                return;
            }

            const cleanUrl = `${url.protocol}//${url.host}${url.pathname}${url.hash || ''}`;
            redirectedTabs.set(tabId, now);

            browser.tabs.update(tabId, { url: cleanUrl }).catch((error) => {
                console.error('Redirect failed:', error);
            });
        } else {
            redirectedTabs.delete(tabId);
        }
    }
});

// Clean up closed tabs
browser.tabs.onRemoved.addListener((tabId) => {
    redirectedTabs.delete(tabId);
});
