//
//  HowItWorksView.swift
//  iOS (App)
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

struct HowItWorksView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isRegularWidth: Bool {
        horizontalSizeClass == .regular
    }

    private let cardSpacing: CGFloat = 16

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Title
                VStack(spacing: 8) {
                    Text("Automatic link cleaning in Safari")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 8)

                if isRegularWidth {
                    // iPad: 2-column mosaic layout
                    HStack(alignment: .top, spacing: cardSpacing) {
                        // Left column
                        VStack(spacing: cardSpacing) {
                            FeatureCard(
                                icon: "link.circle.fill",
                                title: "Automatic Cleaning",
                                description: "When you click a social media link, TokCleaner instantly removes tracking parameters before the page loads."
                            )
                            .accessibilityIdentifier("featureCard_0")

                            FeatureCard(
                                icon: "bolt.fill",
                                title: "Lightning Fast",
                                description: "Links are cleaned instantly in the background. You won't notice any delay—just cleaner, more private URLs."
                            )
                            .accessibilityIdentifier("featureCard_2")

                            FeatureCard(
                                icon: "safari.fill",
                                title: "No App Needed",
                                description: "Watch shared videos directly in Safari without downloading apps, helping you avoid the rabbit hole of endless scrolling and algorithm-driven content."
                            )
                            .accessibilityIdentifier("featureCard_4")

                            EmphasisCard(
                                icon: "lock.shield.fill",
                                iconColor: Color("tcCyan"),
                                title: "Your Privacy"
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
                        }
                        .frame(maxWidth: .infinity)

                        // Right column
                        VStack(spacing: cardSpacing) {
                            FeatureCard(
                                icon: "eye.slash.fill",
                                title: "What Gets Removed",
                                description: "Tracking IDs, referrer codes, analytics tokens, and other parameters that track where you came from and how you share links."
                            )
                            .accessibilityIdentifier("featureCard_1")

                            FeatureCard(
                                icon: "checkmark.shield.fill",
                                title: "Always Working",
                                description: "Once enabled, TokCleaner works automatically on all social media links. No need to open the app again."
                            )
                            .accessibilityIdentifier("featureCard_3")

                            URLComparisonCard(
                                title: "Example",
                                beforeLabel: "Before",
                                beforeURL: "socialmedia.com/video/123?is_from_webapp=1&sender_device=pc&utm_source=share",
                                afterLabel: "After",
                                afterURL: "socialmedia.com/video/123"
                            )
                            .accessibilityIdentifier("urlComparisonCard_example")
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    // iPhone: Single column layout
                    VStack(spacing: cardSpacing) {
                        FeatureCard(
                            icon: "link.circle.fill",
                            title: "Automatic Cleaning",
                            description: "When you click a social media link, TokCleaner instantly removes tracking parameters before the page loads."
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
                            description: "Once enabled, TokCleaner works automatically on all social media links. No need to open the app again."
                        )
                        .accessibilityIdentifier("featureCard_3")

                        FeatureCard(
                            icon: "safari.fill",
                            title: "No App Needed",
                            description: "Watch shared videos directly in Safari without downloading apps, helping you avoid the rabbit hole of endless scrolling and algorithm-driven content."
                        )
                        .accessibilityIdentifier("featureCard_4")

                        URLComparisonCard(
                            title: "Example",
                            beforeLabel: "Before",
                            beforeURL: "socialmedia.com/video/123?is_from_webapp=1&sender_device=pc&utm_source=share",
                            afterLabel: "After",
                            afterURL: "socialmedia.com/video/123"
                        )
                        .accessibilityIdentifier("urlComparisonCard_example")

                        EmphasisCard(
                            icon: "lock.shield.fill",
                            iconColor: Color("tcCyan"),
                            title: "Your Privacy"
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
                    }
                }

                Spacer()
                    .frame(height: 20)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 20)
        }
        .accessibilityElement(children: .contain)
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
