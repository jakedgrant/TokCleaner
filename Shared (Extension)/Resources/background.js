// Service worker for Safari Web Extension
// Runs only when needed, unloads automatically on iOS
//
// Note: URL parameter cleaning is handled by declarativeNetRequest rules in rules.json
// This background script is kept minimal and can be used for future features

import { CONFIG } from './constants.js';

// Extension initialization
console.log('TokCleaner background service worker initialized');
console.log('Supported platforms:', Object.values(CONFIG.SUPPORTED_PLATFORMS));

// Future: Add any background tasks here (e.g., stats tracking, settings sync, etc.)
