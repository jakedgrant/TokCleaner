# Complete Guide to Publishing Safari Extensions on iOS

Your Safari extension can redirect TikTok URLs to SeeTikTok using Apple's declarativeNetRequest API, but success requires navigating iOS-specific requirements, mandatory privacy manifests since May 2024, and strict App Store review guidelines. This comprehensive guide covers every step from Xcode project creation through App Store approval.

## Version requirements and critical timeline

**Current environment context:** As of November 2025, the latest versions are iOS 18 (not iOS 26) and Xcode 16 (with 16.3 in beta). **Privacy manifests became mandatory on May 1, 2024** - submissions without proper PrivacyInfo.xcprivacy files are automatically rejected. Your TikTok redirect extension requires Safari 16.4+ for redirect capabilities and ideally Safari 17+ for path preservation using regexSubstitution.

## Step 1: Create Safari extension project in Xcode

### Method A: New project from template (recommended)

Launch Xcode 16 and create a new project using the Safari Extension App template. Navigate to the **Multiplatform** tab and select **"Safari Extension App"**. Configure your project with a descriptive Product Name like "TikTok Redirector" and set your Organization Identifier in reverse domain notation (e.g., com.yourcompany.tiktokredirect). Choose Swift as the language.

This template creates a complete project structure with both iOS and macOS targets by default, including a containing app, pre-configured extension with manifest.json, sample scripts, and all necessary boilerplate code. The extension's bundle identifier must follow the pattern `{app-bundle-id}.extension` - for example, if your app is `com.company.app`, the extension must be `com.company.app.SafariExtension`.

### Method B: Add to existing project

If you already have an iOS app, navigate to File → New → Target and select **"Safari Extension"** (not "Safari Extension App"). Name your extension and Xcode will create a new extension target within your existing project, including the SafariWebExtensionHandler.swift bridge file and Resources folder for web content.

### Method C: Convert existing web extension

For developers with existing Chrome or Firefox extensions, use the Safari Web Extension Converter tool:

```bash
xcrun safari-web-extension-converter /path/to/extension/
```

This command wraps your web extension into a native app project and creates both iOS and macOS targets automatically. Use the `--rebuild-project` flag to add iOS support to an existing macOS-only Safari extension project.

## Step 2: Project structure and file organization

Your Xcode project contains several critical components organized in a specific hierarchy that determines how your extension functions.

### Core directory structure

```
TikTokRedirect/
├── Shared (App)/                    
│   ├── Resources/                   # Container app UI
│   │   ├── Main.html               
│   │   ├── Script.js
│   │   └── Style.css
│   └── Assets.xcassets/            # App icons
│
├── Shared (Extension)/              
│   ├── Resources/                   # ALL extension web files
│   │   ├── manifest.json           # Extension configuration
│   │   ├── background.js           # Background service worker
│   │   ├── rules.json              # declarativeNetRequest rules
│   │   └── images/                 # Extension icons
│   │       ├── icon-48.png
│   │       ├── icon-96.png
│   │       └── icon-128.png
│   │
│   └── SafariWebExtensionHandler.swift  # Native bridge
│
├── iOS (App)/                       
│   ├── Info.plist
│   ├── PrivacyInfo.xcprivacy       # MANDATORY privacy manifest
│   └── Assets.xcassets/
│
└── iOS (Extension)/                 
    ├── Info.plist
    └── PrivacyInfo.xcprivacy       # Separate manifest for extension
```

### Understanding the container app relationship

Safari extensions on iOS must be bundled within a native iOS app - they cannot exist standalone. The containing app serves as the distribution vehicle and provides user-facing functionality for extension setup and configuration. While the app can be minimal (just a shell with help screens), **App Store Review Guidelines Section 4.4 require apps to include "some functionality, such as help screens and settings interfaces where possible."** Apps that are merely empty wrappers risk rejection.

At runtime, the extension and app can communicate bidirectionally through App Groups for data sharing. The extension can send messages to the native app via the SafariWebExtensionHandler, but cannot proactively initiate messages to JavaScript - it only responds to requests initiated from the extension's JavaScript code.

## Step 3: Required entitlements and capabilities for Safari extensions

### Mandatory entitlements file configuration

Create or edit your entitlements files (one for the app, one for the extension) with these essential entries:

**YourExtension.entitlements (REQUIRED):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.app-sandbox</key>
    <true/>
    <key>com.apple.security.network.client</key>
    <true/>
    <key>com.apple.security.application-groups</key>
    <array>
        <string>group.com.yourcompany.tiktokredirect</string>
    </array>
</dict>
</plist>
```

**Critical requirement:** The `com.apple.security.app-sandbox` entitlement must be set to true. Extensions will not appear in Safari settings if sandboxing is disabled. Network client access enables the extension to make HTTP requests, while App Groups allow data sharing between the containing app and extension.

### Xcode capabilities configuration

In Xcode, select your extension target and navigate to the Signing & Capabilities tab. Enable these capabilities:

**App Sandbox** - Turn on and enable "Outgoing Connections (Client)" for network requests. This allows your extension to communicate with external servers if needed.

**App Groups** - Enable and create a group identifier following the format `group.{your-bundle-id}`. Both the main app target and extension target must use the identical App Group identifier. This configuration must also be registered in your Apple Developer account under Certificates, Identifiers & Profiles.

Access shared data in your code using:

```swift
let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.tiktokredirect")
sharedDefaults?.set(true, forKey: "redirectEnabled")
```

## Step 4: Implementing URL redirect with declarativeNetRequest

### manifest.json configuration (Manifest V3)

Create your extension's manifest.json file in the `Shared (Extension)/Resources/` directory:

```json
{
  "manifest_version": 3,
  "name": "TikTok to SeeTikTok Redirect",
  "version": "1.0.0",
  "description": "Automatically redirects TikTok links to SeeTikTok",
  
  "icons": {
    "48": "images/icon-48.png",
    "96": "images/icon-96.png",
    "128": "images/icon-128.png"
  },
  
  "declarative_net_request": {
    "rule_resources": [
      {
        "id": "tiktok_redirect_rules",
        "enabled": true,
        "path": "rules.json"
      }
    ]
  },
  
  "permissions": [
    "declarativeNetRequestWithHostAccess"
  ],
  
  "host_permissions": [
    "*://*.tiktok.com/*"
  ],
  
  "background": {
    "service_worker": "background.js",
    "type": "module"
  },
  
  "action": {
    "default_icon": "images/icon-48.png",
    "default_title": "TikTok Redirect"
  }
}
```

**Critical permission requirement:** Use `declarativeNetRequestWithHostAccess` (not just `declarativeNetRequest`) for redirect actions. This permission was introduced in Safari 16.4 and is mandatory for URL modifications. The `host_permissions` array must explicitly list the source domains being redirected.

**iOS-specific requirement:** The background section must use a service worker with `"type": "module"` rather than a persistent background page. iOS requires non-persistent backgrounds that load only when needed and unload after idle periods, dramatically reducing memory usage.

### rules.json - Redirect rule definitions

Create `rules.json` in the same Resources directory:

```json
[
  {
    "id": 1,
    "priority": 1,
    "action": {
      "type": "redirect",
      "redirect": {
        "regexSubstitution": "https://www.seetiktok.com\\1"
      }
    },
    "condition": {
      "regexFilter": "^https?://(?:www\\.)?tiktok\\.com(/.*)?$",
      "resourceTypes": ["main_frame"]
    }
  },
  {
    "id": 2,
    "priority": 1,
    "action": {
      "type": "redirect",
      "redirect": {
        "regexSubstitution": "https://www.seetiktok.com\\1"
      }
    },
    "condition": {
      "regexFilter": "^https?://m\\.tiktok\\.com(/.*)?$",
      "resourceTypes": ["main_frame"]
    }
  },
  {
    "id": 3,
    "priority": 1,
    "action": {
      "type": "redirect",
      "redirect": {
        "regexSubstitution": "https://www.seetiktok.com\\1"
      }
    },
    "condition": {
      "regexFilter": "^https?://vm\\.tiktok\\.com(/.*)?$",
      "resourceTypes": ["main_frame"]
    }
  }
]
```

**Understanding regexSubstitution:** This feature preserves URL paths and query parameters during redirection. The pattern `\\1` references the first capture group in the regex (everything after the domain). **This requires Safari 17+ / iOS 17+.** For older iOS versions (15.4-16.x), use static URL redirects without path preservation:

```json
"redirect": {
  "url": "https://www.seetiktok.com"
}
```

**Resource types:** Using `"main_frame"` limits redirects to top-level page navigation. Add `"sub_frame"` to also redirect embedded iframes.

### background.js implementation

Create a minimal service worker for extension initialization:

```javascript
// Service worker for Safari Web Extension
// Runs only when needed, unloads automatically on iOS

browser.runtime.onInstalled.addListener((details) => {
  console.log('TikTok Redirect extension installed:', details.reason);
});

// Optional: Display redirect count as badge (if supported)
if (browser.declarativeNetRequest?.setExtensionActionOptions) {
  browser.declarativeNetRequest.setExtensionActionOptions({
    displayActionCountAsBadgeText: true
  });
}
```

**iOS behavior:** Background pages must follow an event-driven architecture. Register all event listeners at the top level rather than inside functions. Avoid global variables for state persistence - use the storage API instead, as the background page unloads after approximately 30 seconds of inactivity.

### Safari-specific limitations and workarounds

Safari's implementation of declarativeNetRequest has notable constraints compared to Chrome and Firefox. The `redirect.transform` property for URL transformations has limited or broken support. Safari restricts custom header modifications to known headers like User-Agent and Origin. **Most critically, declarativeNetRequest may not work reliably in iOS Simulator** - always test on real devices.

If you need to support Safari versions before 17 without path preservation, or encounter issues with declarativeNetRequest, implement a fallback using content scripts:

```javascript
// content.js - inject at document_start
if (window.location.hostname.includes('tiktok.com')) {
  const newUrl = window.location.href.replace(
    /^https?:\/\/(www\.|m\.|vm\.)?tiktok\.com/,
    'https://www.seetiktok.com'
  );
  window.location.replace(newUrl);
}
```

Add this to manifest.json:

```json
"content_scripts": [{
  "matches": ["*://*.tiktok.com/*"],
  "js": ["content.js"],
  "run_at": "document_start"
}]
```

This approach works on all Safari versions but may cause a brief page flash before redirecting and uses more resources than declarativeNetRequest.

## Step 5: Testing and debugging Safari extensions on iOS

### iOS Simulator testing setup

Select your extension target (not the main app target) from Xcode's scheme selector. Choose an iOS Simulator device like iPhone 15 Pro or iPad Pro from the device menu. Build and run with ⌘R.

Safari launches automatically in the simulator with your extension temporarily installed. Navigate to Settings app → Safari → Extensions and toggle your extension ON. Enable "Allow in Private Browsing" if you want the extension active in private tabs.

**Critical limitation:** declarativeNetRequest features may not work correctly in iOS Simulator. Declarative rules sometimes fail to apply, leading to false negatives during testing. Always validate functionality on real iOS devices before considering testing complete.

### Real device testing configuration

Physical device testing requires proper provisioning. Connect your iPhone or iPad via USB cable. Unlock the device and tap "Trust This Computer" when prompted. In Xcode, select your device from the device menu and click Run.

After installation, enable the extension manually: Settings → Safari → Extensions → toggle your extension ON. Configure website access permissions - you can choose "Always Allow," "Ask," or specific domain access. For testing, "Always Allow" provides the smoothest experience.

**Enable Web Inspector on device:** Settings → Safari → Advanced → toggle "Web Inspector" ON. This critical setting allows you to debug the extension using Safari's developer tools on your Mac.

### Debugging with Safari Web Inspector

Web Inspector is your primary debugging tool for extension JavaScript. On your Mac, open Safari and enable the Develop menu: Safari → Settings → Advanced → check "Show Develop menu in menu bar."

Connect your iOS device via USB or run the iOS Simulator. In Safari's Develop menu, hover over your device name. You'll see available debugging targets including "Extension Background Page" for background scripts, the extension popup window, and any web pages with content scripts injected.

Select "Extension Background Page" to view console output from background.js, set breakpoints in JavaScript code, and inspect the extension's background page state. For content scripts, navigate to a webpage where your extension is active and select that page from the Develop menu.

**Console logging strategy:**

```javascript
// Background script
console.log('Redirect rule applied:', ruleId);
console.error('Failed to redirect:', error);

// Content script
console.log('Page URL:', window.location.href);
alert('Extension activated'); // Quick visual confirmation on device
```

### TestFlight beta distribution

TestFlight provides the best testing experience for real-world validation before App Store submission. Archive your app in Xcode (Product → Archive), then upload to App Store Connect. Submit the build for TestFlight review (typically 1-3 days). Once approved, invite up to 10,000 external testers via email or public link.

Testers install via the TestFlight app and must manually enable your extension in Safari settings. TestFlight builds show detailed extension errors in Settings → Safari → Extensions, making it easier to diagnose configuration issues. Web Inspector works with TestFlight builds for debugging extension JavaScript.

### Common testing issues and solutions

**Extension not appearing in Settings:** Verify app sandboxing is enabled in entitlements. Check that both targets are using automatic code signing. Confirm bundle identifiers follow the proper parent-child relationship.

**Redirect rules not applying:** Test on real devices, not simulator. Verify Safari version supports your features (16.4+ for redirects, 17+ for regexSubstitution). Check console for rule validation errors. Confirm host_permissions matches source domains exactly.

**Background page errors:** Ensure `"persistent": false` in manifest for iOS. Register event listeners at top level, not inside functions. Don't rely on global variables - use storage API for persistent data.

## Step 6: Code signing and provisioning profile requirements

### Development certificate and signing configuration

Enable automatic code signing for both targets (app and extension) during development. Select each target in Xcode, navigate to Signing & Capabilities, check "Automatically manage signing," and select your Team. Xcode handles certificate selection and provisioning profile generation automatically.

Your Apple Developer Program membership ($99/year) provides development certificates. **Each target requires its own provisioning profile.** The extension's bundle identifier must extend the app's identifier - for example, if your app is `com.company.tiktokredirect`, the extension must be `com.company.tiktokredirect.SafariExtension`.

### Creating App IDs and provisioning profiles

In the Apple Developer portal at developer.apple.com, navigate to Certificates, Identifiers & Profiles. Create two App IDs:

**Main App ID:** `com.company.tiktokredirect`
- Enable App Groups capability
- Create or select App Group: `group.com.company.tiktokredirect`

**Extension ID:** `com.company.tiktokredirect.SafariExtension`
- Enable App Groups capability
- Select the same App Group as the main app

For development testing, create Development Provisioning Profiles for each App ID. Include your development certificate and add UDID identifiers for all test devices. Download and install the profiles (Xcode → Preferences → Accounts → Download Manual Profiles, or let automatic signing handle it).

### Distribution profiles for App Store

When preparing for App Store submission, create App Store Distribution profiles. Generate an App Store Distribution certificate (distinct from your Development certificate). Create one distribution profile for the main app and another for the extension, both using the App Store Distribution certificate.

**Critical distinction:** Development certificates and profiles are only valid for testing on registered devices. App Store Distribution profiles are required for final submission and do not include device UDIDs. Ad Hoc profiles are useful for TestFlight but not required - TestFlight accepts App Store Distribution profiles.

## Step 7: App Store submission process and requirements

### Privacy manifest creation (MANDATORY since May 1, 2024)

Privacy manifests are no longer optional. All apps submitted to the App Store must include a PrivacyInfo.xcprivacy file or face automatic rejection. Create this file in Xcode: File → New → iOS → Resource → App Privacy. **You need two privacy manifests** - one for the main app target and one for the extension target.

**PrivacyInfo.xcprivacy structure:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    
    <key>NSPrivacyTrackingDomains</key>
    <array/>
    
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
        <!-- Only if you collect data -->
    </array>
    
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <!-- Required Reason APIs you use -->
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

**For your TikTok redirect extension specifically:** Set `NSPrivacyTracking` to false since you're not tracking users. Leave `NSPrivacyTrackingDomains` empty. If you're only redirecting URLs without collecting or storing any user data, leave `NSPrivacyCollectedDataTypes` empty. Declare any Required Reason APIs you use - for example, if you use UserDefaults for settings, include the UserDefaults category with reason code CA92.1 (accessing user defaults from your app or app extension).

**Verification:** In Xcode 15+, after archiving your app, click "Generate Privacy Report" to validate your privacy manifest. This report shows all APIs used and flags any missing Required Reason API declarations.

### Privacy Policy requirements

A privacy policy is legally required and must be hosted on your website (Apple doesn't host policies). The policy URL goes into App Store Connect metadata and must be accessible before app download. You must also link to the policy within your app's settings or about section.

**Essential policy elements for URL redirect extensions:**

Your policy must disclose that your extension redirects URLs from TikTok to SeeTikTok. Explicitly state whether you collect information about redirected URLs (you likely don't). Clarify whether any browsing history is stored locally or transmitted externally. Confirm that all processing occurs locally on the device. State clearly that you do not share data with third parties. Provide instructions for users to disable the extension if desired.

**Sample privacy policy language:**
"Our extension automatically redirects www.tiktok.com URLs to www.seetiktok.com. We do not collect, store, or transmit any information about the websites you visit. All URL redirection occurs locally on your device. No browsing data leaves your device. We do not share any information with third parties."

### App Store Connect metadata and assets

Create your app listing in App Store Connect with these required elements:

**App name** (30 character limit) - Choose a clear, descriptive name like "TikTok to SeeTikTok Redirect" that doesn't infringe on trademarks. Avoid using "TikTok" prominently if you don't have permission, as trademark violations are a common rejection reason.

**Description** - Clearly explain what your extension does: "Automatically redirects TikTok links to SeeTikTok when you browse in Safari. Simply enable the extension in Settings, and all TikTok URLs will open in SeeTikTok instead."

**Screenshots** - Must show your app and extension IN USE, not just title screens or logos. Capture the extension settings screen, the containing app's help interface, and optionally a before/after demonstration of the redirect functionality. Required sizes for iOS:
- 6.7": 1290 x 2796 pixels (iPhone 15 Pro Max)
- 6.5": 1284 x 2778 pixels (iPhone 14 Plus)
- 5.5": 1242 x 2208 pixels (iPhone 8 Plus)

**Keywords** - Use relevant search terms like "tiktok, redirect, seetiktok, browser, extension, safari" but avoid trademark stuffing or repetition.

**Support URL** - Provide a functional support website or contact page.

**Privacy Policy URL** - Link to your hosted privacy policy (mandatory).

### App Review Guidelines for Safari extensions

**Section 4.4.2 is critical:** Safari extensions must run on the current version of Safari. They may not interfere with System or Safari UI elements and must never include malicious or misleading content. **"Safari extensions should not claim access to more websites than strictly necessary to function."**

For your TikTok redirect extension, request only `*://*.tiktok.com/*` in host_permissions, not all websites. Your containing app must include functional help screens or settings interfaces - a completely empty wrapper app will be rejected. **Violations of Section 4.4.2 can lead to removal from the Apple Developer Program**, not just app rejection.

**Section 2.5.18 prohibits** including marketing, advertising, or in-app purchases within the extension itself (these are only allowed in the main app binary).

### Age ratings and content declarations

Complete the age rating questionnaire in App Store Connect honestly. Apple assigns ratings based on your responses. For a simple URL redirect extension that doesn't expose mature content, you'll likely receive a 4+ rating.

**New rating system (late 2024):** Apple introduced 13+, 16+, and 18+ ratings in addition to the previous 4+ and 9+ options. All apps were automatically migrated to the new system. Your screenshots and app icon must be appropriate for 4+ rating even if your app is rated higher.

For each content category (violence, profanity, sexual content, drug references, etc.), select None, Infrequent/Mild, or Frequent/Intense. Be truthful - reviewers test your app and will reject if content doesn't match declarations.

### Archiving and uploading for review

Select your main app scheme (not the extension scheme) in Xcode. Choose "Any iOS Device" from the device menu. Click Product → Archive. When the archive completes, the Organizer window appears showing your archive.

Click "Distribute App" and select "App Store Connect" as the distribution method. Choose "Upload" and enable automatic signing. Xcode validates your app, checks entitlements, verifies privacy manifests, and uploads the binary to App Store Connect.

In App Store Connect, complete all metadata fields, add screenshots, enter your privacy policy URL, answer all privacy questions, and submit for review. Include detailed notes in "App Review Notes" explaining how the extension works and how reviewers can test it.

### Common rejection reasons and prevention

**Excessive website permissions** - Requesting "all websites" when only specific domains are needed. **Solution:** Request only `*://*.tiktok.com/*` for your redirect extension.

**Missing privacy manifest** - Error codes ITMS-91053, ITMS-91061, ITMS-91064 indicate missing or incorrect privacy declarations. **Solution:** Generate privacy report in Xcode to validate your manifest.

**Empty container app** - App wrapper has no functionality beyond launching Safari. **Solution:** Include help screens showing how to enable the extension, settings for user preferences, and an about section with support information.

**Trademark violations** - Using "TikTok" prominently without permission. **Solution:** Use descriptive names that don't imply official affiliation, like "URL Redirector for SeeTikTok."

**Review timeline:** Safari extension reviews typically take 2-5 days for new submissions, 1-3 days for updates. This is significantly slower than Chrome Web Store (minutes to hours) but faster than complex apps with in-app purchases.

## Step 8: iOS 18 and Xcode 16 specific considerations

### Current version reality check

**Correction on version numbers:** As of November 2025, iOS 18 is the current release (not iOS 26). iOS 18.2 is in beta with iOS 18.4 expected in coming months. Xcode 16 is current with Xcode 16.2 released and 16.3 in beta. All guidance in this document applies to iOS 18 and Xcode 16.

### Safari 18 and iOS 18 features

**Enhanced declarativeNetRequest support** - Safari 18 maintains support for Manifest V3 extensions with declarativeNetRequest. The regexSubstitution feature introduced in Safari 17 continues to work well for path-preserving redirects.

**Known performance issue:** iOS 18 exhibits a significant performance regression where declarativeNetRequest rules take approximately 2x longer to apply compared to iOS 17. This is a known bug that Apple is investigating. For simple redirect extensions like yours, the impact is minimal, but be aware if you have complex rule sets.

**Extension permission changes** - When Safari updates to a version where your extension requests MORE host permissions than before, iOS now automatically turns OFF the extension. Users must manually re-enable and grant new permissions. Design your permission requests carefully from the start to avoid this disruption.

### Xcode 16 improvements for extension development

**Better privacy manifest support** - Xcode 16 includes improved privacy manifest templates and validation. The "Generate Privacy Report" feature (Product → Archive → Generate Privacy Report) automatically identifies all APIs used and flags missing Required Reason API declarations.

**Enhanced Web Inspector** - Safari Technology Preview and Xcode 16 provide better debugging tools for service workers and extension background pages. Console logging is more reliable, and breakpoints in extension JavaScript work more consistently.

**Automated validation** - Xcode 16's submission validation catches more privacy manifest and entitlement issues before upload, reducing rejection rates due to configuration errors.

## Special considerations for URL redirect extensions

Your TikTok to SeeTikTok redirect extension has some specific implementation considerations beyond general Safari extension development.

**Minimal permission approach:** Only request `*://*.tiktok.com/*` in host_permissions. Avoid requesting broader permissions like `<all_urls>` or `*://*/*` as this will definitely trigger rejection under Section 4.4.2. Be prepared to explain in App Review Notes why you need access to tiktok.com domains specifically.

**Path and parameter preservation:** Using regexSubstitution ensures that paths and query parameters are preserved. A user visiting `https://www.tiktok.com/@user/video/1234?ref=share` will be redirected to `https://www.seetiktok.com/@user/video/1234?ref=share`. This preserves functionality and user experience, which reviewers appreciate.

**Testing redirect targets:** Verify that seetiktok.com can actually handle TikTok URL structures. Test various URL patterns: main domain (www.tiktok.com), mobile domain (m.tiktok.com), short links (vm.tiktok.com), user profiles, individual videos, and hashtag pages. Ensure your redirect doesn't break functionality.

**User education:** Include clear instructions in your containing app explaining how to enable the extension and what it does. Consider adding a troubleshooting section for common issues like "extension not working" (usually means it's disabled in Settings).

**Privacy implications:** Since you're modifying user browsing behavior, emphasize in your privacy policy and app description that redirection happens entirely on-device with no data collection. This transparency builds trust and satisfies reviewer concerns.

## Official Apple documentation references

All guidance in this document derives from official Apple sources and developer documentation:

**Safari Web Extensions:** https://developer.apple.com/documentation/safariservices/safari-web-extensions - Complete API reference and development guides

**Creating a Safari Web Extension:** https://developer.apple.com/documentation/safariservices/creating-a-safari-web-extension - Step-by-step setup instructions

**Running Safari Web Extensions:** https://developer.apple.com/documentation/safariservices/running-your-safari-web-extension - Testing and debugging guidance

**App Store Review Guidelines:** https://developer.apple.com/app-store/review/guidelines/ - Section 4.4.2 covers Safari extensions specifically

**Privacy Manifest Files:** https://developer.apple.com/documentation/bundleresources/privacy_manifest_files - Required since May 2024

**Required Reason APIs:** https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api - API category declarations

**Safari Web Extension Packager:** https://developer.apple.com/documentation/safariservices/packaging-and-distributing-safari-web-extensions-with-app-store-connect - Alternative submission method for non-Mac developers

**WWDC21 - Meet Safari Web Extensions on iOS:** https://developer.apple.com/videos/play/wwdc2021/10104/ - iOS-specific development, debugging, responsive design

**WWDC21 - Explore Safari Web Extension Improvements:** https://developer.apple.com/videos/play/wwdc2021/10027/ - Non-persistent background pages and declarativeNetRequest

**WWDC23 - What's New in Safari Extensions:** https://developer.apple.com/videos/play/wwdc2023/10119/ - Per-site permissions and recent API updates

**WWDC23 - Get Started with Privacy Manifests:** https://developer.apple.com/videos/play/wwdc2023/10060/ - Privacy manifest requirements and implementation

**Safari Extensions Overview:** https://developer.apple.com/safari/extensions/ - Marketing and distribution information

## Quick reference checklist

**Before coding:**
- ✓ Apple Developer Program membership active ($99/year)
- ✓ Xcode 16 installed
- ✓ Test iOS devices registered in Developer Portal

**Project setup:**
- ✓ Safari Extension App template created or extension target added
- ✓ Bundle identifiers follow parent-child relationship
- ✓ Automatic code signing enabled for both targets
- ✓ App Groups capability configured identically for both targets
- ✓ Entitlements files include app sandbox and network access

**Implementation:**
- ✓ manifest.json uses Manifest V3 with declarativeNetRequestWithHostAccess
- ✓ host_permissions lists only necessary domains (*://*.tiktok.com/*)
- ✓ Background uses service worker, not persistent page
- ✓ rules.json contains redirect rules with regexSubstitution
- ✓ Extension icons provided in multiple sizes

**Privacy requirements:**
- ✓ PrivacyInfo.xcprivacy created for app target
- ✓ PrivacyInfo.xcprivacy created for extension target
- ✓ Privacy manifest added to Target Membership in Build Phases
- ✓ Required Reason APIs declared with approved reason codes
- ✓ Generate Privacy Report validates no errors
- ✓ Privacy policy created and hosted on your website
- ✓ Privacy policy URL added to App Store Connect

**Testing:**
- ✓ Extension tested on real iOS devices (not just simulator)
- ✓ Redirect works for all TikTok URL patterns
- ✓ Web Inspector shows no console errors
- ✓ Extension appears and enables in Settings → Safari → Extensions
- ✓ Tested in both normal and private browsing modes
- ✓ TestFlight beta testing completed with external users

**App Store Connect:**
- ✓ App name doesn't infringe trademarks
- ✓ Description clearly explains extension functionality
- ✓ Screenshots show app and extension in use
- ✓ Support URL functional
- ✓ Privacy Policy URL accessible
- ✓ Age rating questionnaire completed honestly
- ✓ App Review Notes explain how to test the extension

**Final validation:**
- ✓ Archive creates successfully in Xcode
- ✓ Privacy report generates without errors
- ✓ Upload to App Store Connect completes without warnings
- ✓ All metadata fields in App Store Connect completed
- ✓ Container app includes help/settings functionality (not empty wrapper)

This comprehensive guide provides everything needed to successfully implement and publish your TikTok to SeeTikTok redirect Safari extension on iOS. The process requires attention to detail across multiple Apple platforms and policies, but following these steps systematically ensures the highest likelihood of App Store approval.