// Service worker for Safari Web Extension
// Runs only when needed, unloads automatically on iOS

browser.runtime.onInstalled.addListener((details) => {
    console.log('TokCleaner extension installed:', details.reason);
});

// Optional: Display redirect count as badge (if supported)
if (browser.declarativeNetRequest?.setExtensionActionOptions) {
    browser.declarativeNetRequest.setExtensionActionOptions({
        displayActionCountAsBadgeText: true
    });
}
