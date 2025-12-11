//
//  SupportView.swift
//  iOS (App)
//
//  Created by Jake Grant on 12/2/25.
//

import SwiftUI
import UIKit

struct SupportView: View {
    @State private var supportMarkdown: String = ""

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if !supportMarkdown.isEmpty {
                        Text(.init(supportMarkdown))
                            .textSelection(.enabled)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
            }
            .navigationTitle("Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        openEmailWithDeviceInfo()
                    }) {
                        Label("Report an Issue", systemImage: "envelope.fill")
                    }
                    .buttonStyle(.glassProminent)
                }
            }
            .task {
                loadSupport()
            }
    }

    private func loadSupport() {
        guard let url = Bundle.main.url(forResource: "SUPPORT", withExtension: "md"),
              let markdown = try? String(contentsOf: url, encoding: .utf8) else {
            supportMarkdown = "Support information not found."
            return
        }

        supportMarkdown = markdown
    }

    private func openEmailWithDeviceInfo() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        let iosVersion = UIDevice.current.systemVersion
        let deviceIdentifier = getDeviceIdentifier()
        let deviceModelName = getDeviceModelName()

        let body = """


        ---
        Please describe your issue above this line.
        Include the social media link if relevant, and attach any screenshots.
        ---

        Device Information (automatically generated):
        • App Version: \(appVersion) (Build \(buildNumber))
        • iOS Version: \(iosVersion)
        • Device: \(deviceModelName)
        • Device Identifier: \(deviceIdentifier)
        """

        // Properly encode the body with line breaks preserved
        let encodedBody = body
            .replacingOccurrences(of: "\n", with: "%0D%0A")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let subject = "TokCleaner Support Request".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        if let url = URL(string: "mailto:support@tokcleaner.app?subject=\(subject)&body=\(encodedBody)") {
            UIApplication.shared.open(url)
        }
    }

    private func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

    private func getDeviceModelName() -> String {
        let identifier = getDeviceIdentifier()

        // Map common identifiers to human-readable names
        switch identifier {
        
        // iPhone 17 Series
        case "iPhone18,3": return "iPhone 17"
        case "iPhone18,1": return "iPhone 17 Pro"
        case "iPhone18,2": return "iPhone 17 Pro Max"
        case "iPhone18,4": return "iPhone Air"

        // iPhone 16 Series
        case "iPhone17,3": return "iPhone 16"
        case "iPhone17,4": return "iPhone 16 Plus"
        case "iPhone17,1": return "iPhone 16 Pro"
        case "iPhone17,2": return "iPhone 16 Pro Max"
        case "iPhone17,5": return "iPhone 16e"
            
        // iPhone 15 Series
        case "iPhone15,4": return "iPhone 15"
        case "iPhone15,5": return "iPhone 15 Plus"
        case "iPhone16,1": return "iPhone 15 Pro"
        case "iPhone16,2": return "iPhone 15 Pro Max"

        // iPhone 14 Series
        case "iPhone14,7": return "iPhone 14"
        case "iPhone14,8": return "iPhone 14 Plus"
        case "iPhone15,2": return "iPhone 14 Pro"
        case "iPhone15,3": return "iPhone 14 Pro Max"

        // iPhone 13 Series
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,4": return "iPhone 13 mini"
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"

        // iPhone 12 Series
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,1": return "iPhone 12 mini"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro Max"

        // iPhone SE
        case "iPhone12,8": return "iPhone SE (2nd generation)"
        case "iPhone14,6": return "iPhone SE (3rd generation)"

        // Simulator
        case "i386", "x86_64", "arm64":
            return "Simulator (\(identifier))"

        default:
            return identifier
        }
    }
}

#Preview {
    NavigationView {
        SupportView()
    }
}
