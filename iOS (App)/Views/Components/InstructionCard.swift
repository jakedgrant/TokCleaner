//
//  InstructionCard.swift
//  iOS (App)
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

// Custom alignment guide for aligning icon with step numbers
extension HorizontalAlignment {
    private enum StepIconAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.leading]
        }
    }

    static let stepIconAlignment = HorizontalAlignment(StepIconAlignment.self)
}

struct InstructionCard: View {
    let icon: String
    let title: String
    let steps: [String]

    @Environment(\.colorSchemeContrast) var increaseContrast

    var body: some View {
        VStack(alignment: .stepIconAlignment, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                OverlappingImages {
                    Image(systemName: icon)
                        .font(.title2)
                }
                .alignmentGuide(.stepIconAlignment) { d in d[HorizontalAlignment.center] }

                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .accessibilityAddTraits(.isHeader)

                Spacer()
            }

            // Steps
            VStack(alignment: .stepIconAlignment, spacing: 12) {
                ForEach(Array(steps.enumerated()), id: \.element) { index, step in
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .alignmentGuide(.stepIconAlignment) { d in d[HorizontalAlignment.center] }
                            .accessibilityHidden(true)

                        StyledText(step)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                    }
                    .accessibilityLabel("Step \(index + 1). \(stripMarkup(step))")
                    .accessibilityAddTraits(.isStaticText)
                }
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
    }

    /// Strips markup from text for accessibility labels
    private func stripMarkup(_ text: String) -> String {
        var result = text
        // Remove SF Symbol syntax {{symbol}}
        result = result.replacing(/\{\{[^}]+\}\}/, with: "")
        // Remove highlight syntax **text** and keep the text
        result = result.replacing(/\*\*([^*]+)\*\*/, with: { match in
            String(match.1)
        })
        return result.trimmingCharacters(in: .whitespaces)
    }
}

#Preview {
    VStack(spacing: 20) {
        InstructionCard(
            icon: "gear",
            title: "Via Settings App",
            steps: [
                "Open the {{gear}} **Settings** app",
                "Scroll down and tap **Safari**",
                "Tap {{puzzlepiece.extension}} **Extensions**",
                "Enable **TokCleaner**"
            ]
        )

        InstructionCard(
            icon: "safari",
            title: "With Symbols",
            steps: [
                "Tap the {{aA}} icon in Safari",
                "Select **Manage Extensions**",
                "Tap {{checkmark.circle}} to confirm"
            ]
        )
    }
    .padding()
}
