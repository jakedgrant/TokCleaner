//
//  FeatureCard.swift
//  TokCleaner
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

// Custom alignment guide for aligning icon with title
extension VerticalAlignment {
    private enum TitleCenterAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }

    static let titleCenterAlignment = VerticalAlignment(TitleCenterAlignment.self)
}

// MARK: - Feature Card Component
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String

    @Environment(\.colorSchemeContrast) var increaseContrast

    var body: some View {
        HStack(alignment: .titleCenterAlignment, spacing: 16) {

            OverlappingImages {
                Image(systemName: icon)
                    .font(.title2)
            }
            .alignmentGuide(.titleCenterAlignment) { d in d[VerticalAlignment.center] }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .alignmentGuide(.titleCenterAlignment) { d in d[VerticalAlignment.center] }

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(increaseContrast == .increased ? 0.15 : 0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: increaseContrast == .increased ? 2 : 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(description)")
        .accessibilityAddTraits(.isStaticText)
    }
}

#Preview {
    VStack(spacing: 16) {
        FeatureCard(
            icon: "link.circle.fill",
            title: "Automatic Cleaning",
            description: "When you click a social media link, Paramless instantly removes tracking parameters before the page loads."
        )

        FeatureCard(
            icon: "eye.slash.fill",
            title: "What Gets Removed",
            description: "Tracking IDs, referrer codes, analytics tokens, and other parameters that track where you came from."
        )
    }
    .padding()
}
