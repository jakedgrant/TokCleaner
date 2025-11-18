//
//  URLComparisonCard.swift
//  TokCleaner
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

struct URLComparisonCard: View {
    let title: String
    let beforeLabel: String
    let beforeURL: String
    let afterLabel: String
    let afterURL: String

    @Environment(\.accessibilityIncreaseContrast) var increaseContrast

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: 12) {
                // Before
                URLDisplayBox(
                    icon: "xmark.circle.fill",
                    iconColor: .red,
                    label: beforeLabel,
                    url: beforeURL,
                    backgroundColor: Color.red.opacity(0.1),
                    accessibilityDescription: "Original URL with tracking parameters"
                )

                // Arrow
                HStack {
                    Spacer()
                    Image(systemName: "arrow.down")
                        .foregroundColor(.secondary)
                        .font(.title3)
                        .accessibilityHidden(true)
                    Spacer()
                }

                // After
                URLDisplayBox(
                    icon: "checkmark.circle.fill",
                    iconColor: .green,
                    label: afterLabel,
                    url: afterURL,
                    backgroundColor: Color.green.opacity(0.1),
                    accessibilityDescription: "Cleaned URL without tracking"
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(increaseContrast ? 0.15 : 0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: increaseContrast ? 2 : 1)
        )
    }
}

// MARK: - URL Display Box Sub-Component
private struct URLDisplayBox: View {
    let icon: String
    let iconColor: Color
    let label: String
    let url: String
    let backgroundColor: Color
    let accessibilityDescription: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.caption)
                    .accessibilityHidden(true)
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityDescription)

            Text(url)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(iconColor == .green ? .primary : .secondary)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(backgroundColor)
                .cornerRadius(8)
                .accessibilityLabel("URL: \(url)")
        }
    }
}

#Preview {
    URLComparisonCard(
        title: "Example",
        beforeLabel: "Before",
        beforeURL: "tiktok.com/@user/video/123?is_from_webapp=1&sender_device=pc&utm_source=share",
        afterLabel: "After",
        afterURL: "tiktok.com/@user/video/123"
    )
    .padding()
}
