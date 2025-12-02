//
//  MoreView.swift
//  iOS (App)
//
//  Created by Jake Grant on 12/1/25.
//

import SwiftUI

struct MoreView: View {
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Spacer()
                    .frame(height: 20)
                    .accessibilityHidden(true)

                // App Icon, Name, and Version
                VStack(spacing: 16) {
                    OverlappingImages {
                        Image(systemName: "eraser.line.dashed.fill")
                            .font(.system(size: 64))
                    }
                    .accessibilityLabel("TokCleaner app icon")

                    Text("TokCleaner")
                        .font(.title)
                        .fontWeight(.bold)

                    Text(appVersion)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 8)

                // Thank You Message
                VStack(alignment: .leading, spacing: 16) {
                    Text("Thank you for using TokCleaner! We appreciate you taking the time to download and use our app to protect your privacy while browsing TikTok links.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    Text("If you find TokCleaner useful, please consider sharing it with others and leaving a review on the App Store. Your support helps us continue improving the app!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 4)

                // Action Buttons
                VStack(spacing: 12) {
                    // Share Button
                    ShareLink(item: URL(string: "https://apps.apple.com/app/tokcleaner/id<APP_ID>")!) {
                        HStack(spacing: 12) {
                            OverlappingImages {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                            }

                            Text("Share TokCleaner")
                                .font(.headline)

                            Spacer()
                        }
//                        .foregroundColor(.primary)
                        .padding(12)
//                        .background(Color(.systemBackground))
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color(.systemGray5), lineWidth: 1)
//                        )
                    }
                    .accessibilityLabel("Share TokCleaner")
                    .accessibilityHint("Opens share sheet to share the app with others")

                    // Review Button
                    Button(action: {
                        openAppStoreReview()
                    }) {
                        HStack(spacing: 12) {
                            OverlappingImages {
                                Image(systemName: "star")
                                    .font(.title3)
                            }

                            Text("Rate on App Store")
                                .font(.headline)

                            Spacer()
                        }
//                        .foregroundColor(.primary)
                        .padding(12)
//                        .background(Color(.systemBackground))
//                        .cornerRadius(12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color(.systemGray5), lineWidth: 1)
//                        )
                    }
                    .accessibilityLabel("Rate on App Store")
                    .accessibilityHint("Opens the App Store to leave a review")
                }

                // Privacy Policy Link
                NavigationLink(destination: PrivacyPolicyView()) {
                    HStack(spacing: 12) {
                        OverlappingImages {
                            Image(systemName: "hand.raised")
                                .font(.title3)
                        }

                        Text("Privacy Policy")
                            .font(.headline)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
//                    .foregroundColor(.primary)
                    .padding(16)
//                    .background(Color(.systemBackground))
//                    .cornerRadius(12)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 12)
//                            .stroke(Color(.systemGray5), lineWidth: 1)
//                    )
                }
                .accessibilityLabel("Privacy Policy")
                .accessibilityHint("View the privacy policy")

                Spacer()
                    .frame(height: 20)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 20)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("moreView")
    }

    private func openAppStoreReview() {
        // Replace <APP_ID> with your actual App Store ID
        if let url = URL(string: "https://apps.apple.com/app/id<APP_ID>?action=write-review") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationView {
        MoreView()
            .navigationTitle("TokCleaner")
            .navigationBarTitleDisplayMode(.large)
    }
}
