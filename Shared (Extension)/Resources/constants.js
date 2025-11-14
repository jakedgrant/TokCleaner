// Extension configuration constants
// This file works as both an ES module and a global script for content scripts

const CONFIG = {
    // Redirect loop prevention: minimum time between redirects for the same tab (1 second)
    REDIRECT_LOOP_PREVENTION_MS: 1000,

    // Maximum redirects allowed within the loop prevention window
    MAX_REDIRECTS_PER_WINDOW: 3,

    // Time after which redirect counter resets (5 seconds)
    REDIRECT_RESET_WINDOW_MS: 5000,

    // Test page wait time before checking for redirect (2 seconds)
    TEST_REDIRECT_WAIT_MS: 2000,

    // Banner display duration (2.5 seconds)
    BANNER_DISPLAY_MS: 2500
};

// Export for ES modules (background.js, popup.js)
export { CONFIG };

// Also define globally for content scripts
if (typeof window !== 'undefined') {
    window.TOKCLEANER_CONFIG = CONFIG;
}
