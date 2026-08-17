# Privacy Policy for TokCleaner

**Last Updated:** August 17, 2026

## What Our Extension Does

TokCleaner is a Safari extension for iOS that removes tracking and query parameters from TikTok URLs to provide a cleaner, more private browsing experience. It also includes an optional, off-by-default feature that redirects x.com and twitter.com links to xcancel.com, an independent third-party viewer. This feature does nothing until you turn it on yourself.

## Data Collection

**We do not collect, store, or transmit any data whatsoever.**

- We do not collect information about the websites you visit
- We do not collect your browsing history
- We do not collect personal information
- We do not use cookies or tracking technologies
- We do not collect analytics or usage statistics

This applies to every feature of the extension, including the optional X/Twitter redirect described below.

## How the Extension Works

### TikTok link cleaning (always on)

Our extension uses Safari's declarativeNetRequest API to automatically remove query parameters (everything after the "?" in a URL) from TikTok links. This processing happens entirely on your device using Safari's built-in capabilities.

**Example:**
- Before: `https://www.tiktok.com/@user/video/123?ref=share&tracker=abc`
- After: `https://www.tiktok.com/@user/video/123`

### X/Twitter redirect to xcancel.com (optional, off by default)

TokCleaner can also redirect links to x.com, www.x.com, twitter.com, and www.twitter.com so they open on xcancel.com instead, preserving the page, post, and query string. This feature is turned off by default — it only runs if you switch it on using the toggle in the extension's popup (tap the TokCleaner icon in Safari's toolbar). Your choice is stored only in this browser, on your device, using Safari's extension storage; TokCleaner does not see or transmit it anywhere.

**Example (when enabled):**
- Before: `https://x.com/someuser/status/123?s=20`
- After: `https://xcancel.com/someuser/status/123?s=20`

If you turn this on, matching links open on **xcancel.com**, an independent, third-party website that TokCleaner does not run, control, or have any relationship with. Once you land on xcancel.com, that site's own practices — not this privacy policy — govern how it handles your visit. TokCleaner itself still does not collect, store, or transmit any data at any point in this process; redirecting your own browser to a different address is not the same as TokCleaner sending your data anywhere.

All URL processing for both features occurs locally on your device. No data leaves your device because of anything TokCleaner does, and we have no servers that receive any information.

## Permissions

The extension requests the following permissions:

- **Access to tiktok.com domains**: Required to detect and process TikTok URLs
- **Access to x.com and twitter.com domains**: Required only for the optional redirect feature described above; unused unless you turn that feature on
- **declarativeNetRequestWithHostAccess**: Required to modify URLs before they load
- **storage**: Required to remember whether you've turned the optional X/Twitter redirect on or off; stores a single on/off value locally on your device

These permissions are used solely for the purposes described in this policy.

## Third-Party Data Sharing

We do not share any data with third parties because we do not collect any data.

The one exception worth calling out explicitly: if you opt into the X/Twitter redirect feature, links you click will load on xcancel.com instead of x.com/twitter.com — exactly as if you had typed that address yourself. That is the intended, visible effect of a feature you chose to enable, not TokCleaner sharing your data; we do not send xcancel.com (or anyone else) any information about you.

## Children's Privacy

We do not knowingly collect any information from anyone, including children under the age of 13.

## Changes to This Privacy Policy

We may update this privacy policy from time to time. Any changes will be posted on this page with an updated "Last Updated" date.

## How to Disable

You can disable this extension at any time by:
1. Opening Settings on your iOS device
2. Navigating to Safari → Extensions
3. Toggling TokCleaner off

If you only want to turn off the optional X/Twitter redirect (and keep TikTok link cleaning on), open the TokCleaner popup from Safari's toolbar and switch that toggle off — no need to disable the whole extension.

## Contact

If you have any questions about this privacy policy, please contact:

**Email:** jake.d.grant@gmail.com

---

*This extension is not affiliated with, endorsed by, or associated with TikTok, ByteDance Ltd., X Corp., Twitter, or xcancel.com.*
