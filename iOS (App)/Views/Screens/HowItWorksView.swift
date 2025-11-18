//
//  HowItWorksView.swift
//  iOS (App)
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

struct HowItWorksView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Spacer()
                    .frame(height: 20)
                    .accessibilityHidden(true)

                // Title
                VStack(spacing: 8) {
                    Text("How It Works")
                        .font(.title)
                        .fontWeight(.bold)
                        .accessibilityAddTraits(.isHeader)

                    Text("Automatic link cleaning in Safari")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 8)

                // Feature Cards
                FeatureCard(
                    icon: "link.circle.fill",
                    title: "Automatic Cleaning",
                    description: "When you click a TikTok link, TokCleaner instantly removes tracking parameters before the page loads."
                )
                .accessibilityIdentifier("featureCard_0")

                FeatureCard(
                    icon: "eye.slash.fill",
                    title: "What Gets Removed",
                    description: "Tracking IDs, referrer codes, analytics tokens, and other parameters that track where you came from and how you share links."
                )
                .accessibilityIdentifier("featureCard_1")

                FeatureCard(
                    icon: "bolt.fill",
                    title: "Lightning Fast",
                    description: "Links are cleaned instantly in the background. You won't notice any delay—just cleaner, more private URLs."
                )
                .accessibilityIdentifier("featureCard_2")

                FeatureCard(
                    icon: "checkmark.shield.fill",
                    title: "Always Working",
                    description: "Once enabled, TokCleaner works automatically on all TikTok links. No need to open the app again."
                )
                .accessibilityIdentifier("featureCard_3")

                // Example Section
                URLComparisonCard(
                    title: "Example",
                    beforeLabel: "Before",
                    beforeURL: "tiktok.com/@user/video/123?is_from_webapp=1&sender_device=pc&utm_source=share",
                    afterLabel: "After",
                    afterURL: "tiktok.com/@user/video/123"
                )
                .accessibilityIdentifier("urlComparisonCard_example")

                // Privacy Section
                EmphasisCard(
                    icon: "lock.shield.fill",
                    iconColor: Color("tcCyan"),
                    title: "Your Privacy",
//                    gradientColors: [Color("tcPink").opacity(0.15), Color("tcCyan").opacity(0.15), ]
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        PrivacyPoint(
                            icon: "iphone",
                            text: "Everything happens on your device"
                        )
                        PrivacyPoint(
                            icon: "wifi.slash",
                            text: "No internet connection required"
                        )
                        PrivacyPoint(
                            icon: "chart.bar.xaxis",
                            text: "Zero data collection or analytics"
                        )
                        PrivacyPoint(
                            icon: "eye.slash",
                            text: "We can't see what you browse"
                        )
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isStaticText)
                }
                .accessibilityIdentifier("emphasisCard_privacy")

                Spacer()
                    .frame(height: 20)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 20)
        }
        .accessibilityIdentifier("howItWorksView")
    }
}

#Preview {
    NavigationView {
        HowItWorksView()
            .navigationTitle("TokCleaner")
            .navigationBarTitleDisplayMode(.large)
    }
}
