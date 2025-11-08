//
//  ViewController.swift
//  Shared (App)
//
//  Created by Jake Grant on 11/7/25.
//

import SwiftUI

#if os(macOS)
import SafariServices
#endif

let extensionBundleIdentifier = "com.jacobgrant.TokCleaner.Extension"

// MARK: - SwiftUI View
struct ContentView: View {
    var body: some View {
        #if os(iOS)
        iOSContentView()
        #elseif os(macOS)
        MacOSContentView()
        #endif
    }
}

// MARK: - iOS View
#if os(iOS)
struct iOSContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("LargeIcon")
                .resizable()
                .frame(width: 128, height: 128)

            Text("You can turn on TokCleaner's Safari extension in Settings.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
    }
}
#endif

// MARK: - macOS View
#if os(macOS)
struct MacOSContentView: View {
    @State private var extensionEnabled: Bool? = nil
    @State private var useSettingsInsteadOfPreferences = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("LargeIcon")
                .resizable()
                .frame(width: 128, height: 128)

            if let enabled = extensionEnabled {
                if enabled {
                    Text(statusMessage(enabled: true))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                } else {
                    Text(statusMessage(enabled: false))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            } else {
                Text(statusMessage(enabled: nil))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Button(action: openSafariPreferences) {
                Text(buttonText)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .onAppear {
            checkExtensionStatus()
        }
    }

    private var buttonText: String {
        if useSettingsInsteadOfPreferences {
            return "Quit and Open Safari Settings…"
        } else {
            return "Quit and Open Safari Extensions Preferences…"
        }
    }

    private func statusMessage(enabled: Bool?) -> String {
        if useSettingsInsteadOfPreferences {
            if let enabled = enabled {
                if enabled {
                    return "TokCleaner's extension is currently on. You can turn it off in the Extensions section of Safari Settings."
                } else {
                    return "TokCleaner's extension is currently off. You can turn it on in the Extensions section of Safari Settings."
                }
            } else {
                return "You can turn on TokCleaner's extension in the Extensions section of Safari Settings."
            }
        } else {
            if let enabled = enabled {
                if enabled {
                    return "TokCleaner's extension is currently on. You can turn it off in Safari Extensions preferences."
                } else {
                    return "TokCleaner's extension is currently off. You can turn it on in Safari Extensions preferences."
                }
            } else {
                return "You can turn on TokCleaner's extension in Safari Extensions preferences."
            }
        }
    }

    private func checkExtensionStatus() {
        if #available(macOS 13, *) {
            useSettingsInsteadOfPreferences = true
        }

        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
            guard let state = state, error == nil else {
                return
            }

            DispatchQueue.main.async {
                extensionEnabled = state.isEnabled
            }
        }
    }

    private func openSafariPreferences() {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { error in
            guard error == nil else {
                return
            }

            DispatchQueue.main.async {
                NSApp.terminate(nil)
            }
        }
    }
}
#endif
