# Supported Platforms Configuration

This document explains how to add or remove supported social media platforms in TokCleaner.

## Single Source of Truth

All supported platforms are defined in **`constants.js`** in the `SUPPORTED_PLATFORMS` object:

```javascript
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
```

## Currently Supported Platforms

- **TikTok**: tiktok.com, vm.tiktok.com
- **Instagram**: instagram.com, instagr.am
- **YouTube**: youtube.com, youtu.be
- **Facebook**: facebook.com, fb.me
- **Twitter/X**: twitter.com, x.com, t.co
- **LinkedIn**: linkedin.com, lnkd.in
- **Reddit**: reddit.com, redd.it

## Adding a New Platform

To add support for a new platform (e.g., Snapchat):

### 1. Update `constants.js`

Add the new platform to the `SUPPORTED_PLATFORMS` object:

```javascript
const SUPPORTED_PLATFORMS = {
    // ... existing platforms ...

    // Snapchat
    snapchat: 'snapchat.com',
    snapchatShort: 'snap.com'  // Add shortened URL if applicable
};
```

### 2. Update `manifest.json`

Add the platform to **both** `host_permissions` and `content_scripts.matches`:

```json
{
    "host_permissions": [
        "*://*.tiktok.com/*",
        "*://*.instagram.com/*",
        // ... existing platforms ...
        "*://*.snapchat.com/*",
        "*://*.snap.com/*"
    ],
    "content_scripts": [
        {
            "matches": [
                "*://*.tiktok.com/*",
                "*://*.instagram.com/*",
                // ... existing platforms ...
                "*://*.snapchat.com/*",
                "*://*.snap.com/*"
            ],
            "js": ["constants.js", "content.js"],
            "run_at": "document_start"
        }
    ]
}
```

### 3. Update `rules.json`

Add URL rewriting rules for the new platform in `rules.json`. See [RULES.md](RULES.md) for detailed documentation on creating platform-specific rules.

**Important**: Only remove tracking parameters, never functional parameters! Research the platform's URL structure first to identify which parameters are required for content to load.

### 4. That's it!

The following files will automatically use the new platform:
- ✅ `background.js` - Uses `CONFIG.SUPPORTED_PLATFORMS` to check URLs
- ✅ `popup.js` - Uses `CONFIG.SUPPORTED_PLATFORMS` to check if current page is supported
- ✅ `content.js` - Will run on the new platform via manifest.json matches

## Removing a Platform

To remove support for a platform:

1. Remove it from `SUPPORTED_PLATFORMS` in `constants.js`
2. Remove it from `host_permissions` in `manifest.json`
3. Remove it from `content_scripts.matches` in `manifest.json`
4. Remove any platform-specific rules from `rules.json`

## Files That Reference Platforms

### Automatically Updated (via constants.js)
- `background.js` - Fallback redirect handler
- `popup.js` - Current page status checker

### Manually Updated
- `manifest.json` - Permissions and content script matches
- `rules.json` - Declarative net request rules

## Why This Matters

By centralizing platform configuration:
- **Easy maintenance**: Add/remove platforms in one place
- **Consistency**: All JavaScript code uses the same list
- **Scalability**: Easy to expand to more platforms
- **Documentation**: Clear source of truth for what's supported
