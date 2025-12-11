# URL Cleaning Rules

This document explains the tracking parameter removal rules for each supported platform.

## How It Works

TokCleaner uses Safari's `declarativeNetRequest` API to remove tracking parameters from URLs **before** the page loads. The rules are defined in `rules.json` and are platform-specific to ensure we only remove tracking parameters while preserving functional parameters.

### Architecture

1. **declarativeNetRequest** (rules.json): Handles all URL parameter cleaning
   - Runs before the page loads
   - Platform-specific rules for selective parameter removal
   - Fast and efficient (built into Safari)

2. **content.js**: Only shows confirmation banner
   - Does NOT modify URLs
   - Shows visual feedback when tracking was removed

3. **background.js**: Minimal service worker
   - Initializes extension
   - Available for future features

**Important**: All URL cleaning is done by declarativeNetRequest rules. The content script and background script do NOT remove parameters.

## Platform-Specific Rules

### Rule ID 1: TikTok
**Domains**: `tiktok.com`, `vm.tiktok.com`

**Removed Parameters**:
- `is_from_webapp` - Tracks whether link was opened from web app
- `sender_device` - Identifies the device that shared the link
- `u_code` - User tracking code
- `refer`, `referer_url`, `referer_video_id` - Referrer tracking
- `_r`, `_t` - Internal tracking codes
- `checksum` - Verification tracking
- `sec_uid` - Secondary user ID for tracking
- `share_app_id`, `share_link_id`, `share_author_id` - Share tracking
- `social_share_type` - How the link was shared
- `tt_from` - TikTok source tracking

**Preserved Parameters**: All functional parameters (video ID is in the path, not query)

---

### Rule ID 2: YouTube
**Domains**: `youtube.com`, `youtu.be`

**Removed Parameters**:
- `si` - Share identifier tracking
- `feature` - Feature tracking (e.g., "share", "youtu.be")
- `kw` - Keyword tracking
- `app` - App tracking
- `fbclid` - Facebook click identifier
- `gclid` - Google click identifier

**Preserved Parameters**:
- ✅ `v` - Video ID (essential - specifies which video to play)
- ✅ `t` - Timestamp (functional - starts video at specific time)
- ✅ `list` - Playlist ID (functional)
- ✅ `index` - Playlist index (functional)

**Note**: YouTube's `v` parameter is essential and must never be removed. Similarly, `t` for timestamps (e.g., `t=123s`) is functional, not tracking.

---

### Rule ID 3: Instagram
**Domains**: `instagram.com`, `instagr.am`

**Removed Parameters**:
- `igshid` - Instagram share ID (tracking)
- `igsh` - Instagram share hash (tracking)
- `img_index` - Image index in carousel (sometimes tracking-related)

**Preserved Parameters**: Post/reel IDs are in the path, not query parameters

---

### Rule ID 4: Facebook
**Domains**: `facebook.com`, `fb.me`

**Removed Parameters**:
- `fbclid` - Facebook click identifier
- `mibextid` - Mobile in-browser extension ID (tracking)

**Preserved Parameters**: Post IDs and functional parameters are typically in the path

---

### Rule ID 5: Twitter/X
**Domains**: `twitter.com`, `x.com`, `t.co`

**Removed Parameters**:
- `s` - Share tracking code
- `t` - Tweet tracking code

**Preserved Parameters**: Tweet IDs are in the path

---

### Rule ID 6: LinkedIn
**Domains**: `linkedin.com`, `lnkd.in`

**Removed Parameters**:
- `trk` - Tracking parameter
- `trkInfo` - Detailed tracking information
- `refId` - Referrer identifier
- `originalReferer` - Original referrer tracking

**Preserved Parameters**: Post and profile IDs are in the path

---

### Rule ID 7: Reddit
**Domains**: `reddit.com`, `redd.it`

**Removed Parameters**:
- `ref` - Referrer tracking
- `ref_source` - Referrer source tracking
- `share` - Share tracking

**Preserved Parameters**: Post IDs and functional parameters are in the path

---

### Rule ID 100: Universal Tracking Parameters
**Applies to**: All supported platforms

**Removed Parameters**:
- `utm_source`, `utm_medium`, `utm_campaign`, `utm_term`, `utm_content` - Google Analytics UTM parameters
- `fbclid` - Facebook click identifier (cross-platform)
- `gclid` - Google click identifier (cross-platform)
- `msclkid` - Microsoft click identifier (cross-platform)
- `_ga` - Google Analytics tracking
- `mc_cid`, `mc_eid` - Mailchimp tracking

**Note**: This rule runs on all platforms and catches common cross-platform tracking parameters.

---

## Adding New Rules

When adding rules for a new platform:

1. **Research the platform's URL structure**:
   - Identify which parameters are functional (required for content to load)
   - Identify which parameters are tracking-only

2. **Test thoroughly**:
   - Ensure functional parameters are preserved
   - Verify tracking parameters are removed
   - Test various URL patterns (posts, videos, profiles, etc.)

3. **Add platform-specific rule**:
   - Use a unique rule ID
   - Set priority to 1
   - List only tracking parameters in `removeParams`

4. **Update universal rule** (Rule ID 100):
   - Add new platform domains to the `urlFilter`

## Examples

### YouTube - Correct Behavior

**Before**:
```
https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=42s&si=abc123&feature=share
```

**After**:
```
https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=42s
```

✅ Preserved: `v` (video ID), `t` (timestamp)
❌ Removed: `si` (tracking), `feature` (tracking)

### TikTok - Correct Behavior

**Before**:
```
https://www.tiktok.com/@user/video/123?is_from_webapp=1&sender_device=pc&utm_source=share
```

**After**:
```
https://www.tiktok.com/@user/video/123
```

✅ Video ID is in the path (preserved)
❌ Removed: All tracking parameters

## Testing Rules

To test if rules are working:

1. Open a URL with tracking parameters in Safari
2. The extension should redirect to the clean URL
3. Check the address bar - tracking parameters should be gone
4. Verify content still loads correctly

## Common Pitfalls

⚠️ **Don't remove functional parameters**: Always research what parameters are required for content to load

⚠️ **Test edge cases**: Some platforms use parameters differently in different contexts

⚠️ **Priority matters**: If rules conflict, higher priority (lower number) wins

⚠️ **URL patterns**: Use wildcards carefully - `*youtube.com/*` matches all paths
