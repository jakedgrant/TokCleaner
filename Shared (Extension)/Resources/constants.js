// Extension configuration constants
// This file works as both an ES module and a global script for content scripts

// Supported social media platforms
// Single source of truth for all platform URLs
// Includes both main domains and common shortened/redirect URLs
const SUPPORTED_PLATFORMS = {
    // TikTok
    tiktok: 'tiktok.com',
    tiktokShort: 'vm.tiktok.com',

    // Instagram
    instagram: 'instagram.com',
    instagramShort: 'instagr.am',

    // YouTube
    youtube: 'youtube.com',
    youtubeShort: 'youtu.be',

    // Facebook
    facebook: 'facebook.com',
    facebookShort: 'fb.me',

    // Twitter/X
    twitter: 'twitter.com',
    x: 'x.com',
    twitterShort: 't.co',

    // LinkedIn
    linkedin: 'linkedin.com',
    linkedinShort: 'lnkd.in',

    // Reddit
    reddit: 'reddit.com',
    redditShort: 'redd.it'
};

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
    BANNER_DISPLAY_MS: 2500,

    // Supported platforms
    SUPPORTED_PLATFORMS
};

// Export for ES modules (background.js, popup.js)
export { CONFIG };

// Also define globally for content scripts
if (typeof window !== 'undefined') {
    window.TOKCLEANER_CONFIG = CONFIG;
}
