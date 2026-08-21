// Service worker for Safari Web Extension
// Runs only when needed, unloads automatically on iOS

import { CONFIG } from './constants.js';

// Track redirects to avoid loops with enhanced state tracking
const redirectedTabs = new Map();

// Fallback: Manual redirect if content script doesn't catch it
browser.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
    if (changeInfo.url && changeInfo.url.includes('tiktok.com')) {
        const url = new URL(changeInfo.url);
        if (url.search) {
            const tabState = redirectedTabs.get(tabId);
            const now = Date.now();

            // Enhanced redirect loop prevention with state tracking
            if (tabState) {
                const timeSinceRedirect = now - tabState.lastRedirect;
                const redirectCount = tabState.count;

                // Prevent redirect if:
                // 1. Within threshold AND
                // 2. Same URL AND
                // 3. Redirect count below maximum (allow retries for legitimate cases)
                if (timeSinceRedirect < CONFIG.REDIRECT_LOOP_PREVENTION_MS &&
                    tabState.url === changeInfo.url &&
                    redirectCount < CONFIG.MAX_REDIRECTS_PER_WINDOW) {
                    return;
                }

                // Reset if different URL or enough time has passed
                if (timeSinceRedirect > CONFIG.REDIRECT_RESET_WINDOW_MS || tabState.url !== changeInfo.url) {
                    redirectedTabs.set(tabId, {
                        lastRedirect: now,
                        url: changeInfo.url,
                        count: 1
                    });
                } else {
                    // Increment count for same URL within window
                    redirectedTabs.set(tabId, {
                        lastRedirect: now,
                        url: changeInfo.url,
                        count: redirectCount + 1
                    });
                }
            } else {
                // First redirect for this tab
                redirectedTabs.set(tabId, {
                    lastRedirect: now,
                    url: changeInfo.url,
                    count: 1
                });
            }

            const cleanUrl = `${url.protocol}//${url.host}${url.pathname}${url.hash || ''}`;

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

// X/Twitter -> xcancel.com redirect (opt-in, off by default).
// The "xcancel_redirect_rules" ruleset is declared disabled in manifest.json;
// this keeps its enabled state in sync with the user's stored preference.
async function syncXcancelRuleset() {
    const stored = await browser.storage.local.get({ [CONFIG.XCANCEL_STORAGE_KEY]: false });
    const enabled = stored[CONFIG.XCANCEL_STORAGE_KEY] === true;

    try {
        await browser.declarativeNetRequest.updateEnabledRulesets({
            enableRulesetIds: enabled ? [CONFIG.XCANCEL_RULESET_ID] : [],
            disableRulesetIds: enabled ? [] : [CONFIG.XCANCEL_RULESET_ID]
        });
        await browser.storage.local.set({ [CONFIG.XCANCEL_SYNC_ERROR_KEY]: null });
    } catch (error) {
        console.error('Failed to sync xcancel redirect ruleset:', error);
        // Surfaced in the popup so a failure here isn't invisible to the user.
        await browser.storage.local.set({
            [CONFIG.XCANCEL_SYNC_ERROR_KEY]: String((error && error.message) || error)
        });
    }
}

// Re-sync on every service worker startup, since MV3 workers unload and restart frequently.
syncXcancelRuleset();

browser.storage.onChanged.addListener((changes, areaName) => {
    if (areaName === 'local' && CONFIG.XCANCEL_STORAGE_KEY in changes) {
        syncXcancelRuleset();
    }
});
