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

                // Title
                VStack(spacing: 8) {
                    Text("How It Works")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Automatic link cleaning in Safari")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 8)

                // Feature Cards
                FeatureCard(
                    icon: "link.circle.fill",
                    color: .blue,
                    title: "Automatic Cleaning",
                    description: "When you click a TikTok link, TokCleaner instantly removes tracking parameters before the page loads."
                )

                FeatureCard(
                    icon: "eye.slash.fill",
                    color: .purple,
                    title: "What Gets Removed",
                    description: "Tracking IDs, referrer codes, analytics tokens, and other parameters that track where you came from and how you share links."
                )

                FeatureCard(
                    icon: "bolt.fill",
                    color: .orange,
                    title: "Lightning Fast",
                    description: "Links are cleaned instantly in the background. You won't notice any delay—just cleaner, more private URLs."
                )

                FeatureCard(
                    icon: "checkmark.shield.fill",
                    color: .green,
                    title: "Always Working",
                    description: "Once enabled, TokCleaner works automatically on all TikTok links. No need to open the app again."
                )

                // Example Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Example")
                        .font(.headline)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading, spacing: 12) {
                        // Before
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                Text("Before")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }

                            Text("tiktok.com/@user/video/123?is_from_webapp=1&sender_device=pc&utm_source=share")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                        }

                        // Arrow
                        HStack {
                            Spacer()
                            Image(systemName: "arrow.down")
                                .foregroundColor(.secondary)
                                .font(.title3)
                            Spacer()
                        }

                        // After
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                Text("After")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }

                            Text("tiktok.com/@user/video/123")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.primary)
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(20)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.horizontal, 20)

                // Privacy Section
                VStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: "lock.shield.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        Text("Your Privacy")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }

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
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .padding(.horizontal, 20)

                Spacer()
                    .frame(height: 20)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Feature Card Component
struct FeatureCard: View {
    let icon: String
    let color: Color
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Privacy Point Component
struct PrivacyPoint: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 24)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()
        }
    }
}
