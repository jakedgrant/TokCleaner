//
//  StyledText.swift
//  iOS (App)
//
//  Created by Jake Grant on 12/1/25.
//

import SwiftUI

/// A view that renders text with embedded SF Symbols and highlighted text effects.
///
/// Syntax:
/// - SF Symbols: `{{symbol_name}}` - Renders an inline SF Symbol
/// - Highlighted text: `**text**` - Applies a highlight effect with overlapping cyan/pink rectangles
///
/// Example: "Tap the {{checkmark.circle}} **Done** button"
struct StyledText: View {
    let text: String
    let font: Font

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    init(_ text: String, font: Font = .subheadline) {
        self.text = text
        self.font = font
    }

    var body: some View {
        parseText()
            .font(font)
    }

    private func parseText() -> some View {
        var components: [AnyView] = []
        var currentIndex = text.startIndex

        // Pattern: {{symbol}} or **highlight**
        let symbolPattern = /\{\{([^}]+)\}\}/
        let highlightPattern = /\*\*([^*]+)\*\*/

        while currentIndex < text.endIndex {
            let remainingText = String(text[currentIndex...])

            // Check for symbol pattern
            if let symbolMatch = try? symbolPattern.firstMatch(in: remainingText) {
                let matchRange = symbolMatch.range
                let matchStart = text.index(currentIndex, offsetBy: remainingText.distance(from: remainingText.startIndex, to: matchRange.lowerBound))

                // Add any text before the match
                if currentIndex < matchStart {
                    let plainText = String(text[currentIndex..<matchStart])
                    components.append(AnyView(Text(plainText)))
                }

                // Add the symbol with overlapping effect
                let symbolName = String(symbolMatch.1)
                components.append(AnyView(
                    symbolImageView(symbolName)
                ))

                // Move index past the match
                currentIndex = text.index(currentIndex, offsetBy: remainingText.distance(from: remainingText.startIndex, to: matchRange.upperBound))
                continue
            }

            // Check for highlight pattern
            if let highlightMatch = try? highlightPattern.firstMatch(in: remainingText) {
                let matchRange = highlightMatch.range
                let matchStart = text.index(currentIndex, offsetBy: remainingText.distance(from: remainingText.startIndex, to: matchRange.lowerBound))

                // Add any text before the match
                if currentIndex < matchStart {
                    let plainText = String(text[currentIndex..<matchStart])
                    components.append(AnyView(Text(plainText)))
                }

                // Add the highlighted text
                let highlightedText = String(highlightMatch.1)
                components.append(AnyView(highlightedTextView(highlightedText)))

                // Move index past the match
                currentIndex = text.index(currentIndex, offsetBy: remainingText.distance(from: remainingText.startIndex, to: matchRange.upperBound))
                continue
            }

            // No more patterns found, add remaining text
            let plainText = String(text[currentIndex...])
            components.append(AnyView(Text(plainText)))
            break
        }

        return HStack(spacing: 0) {
            ForEach(0..<components.count, id: \.self) { index in
                components[index]
            }
        }
    }

    private func symbolImageView(_ symbolName: String) -> some View {
        Group {
            if reduceMotion {
                // Simplified version for users with motion sensitivity
                Image(systemName: symbolName)
                    .font(font)
                    .foregroundStyle(Color.tcCyan)
            } else {
                // Full overlapping effect
                ZStack(alignment: .center) {
                    Image(systemName: symbolName)
                        .font(font)
                        .foregroundStyle(Color.tcCyan)
                        .offset(y: -0.8)

                    Image(systemName: symbolName)
                        .font(font)
                        .foregroundStyle(Color.tcPink)
                        .offset(x: 0.8)
                        .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
                }
                .compositingGroup()
            }
        }
        .bold()
        .accessibilityLabel(symbolName.replacingOccurrences(of: ".", with: " "))
    }

    private func highlightedTextView(_ text: String) -> some View {
        Group {
            if reduceMotion {
                // Simplified version for users with motion sensitivity
                Text(text)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                    .fontWeight(.semibold)
                    .background(Color.tcCyan)
                    .cornerRadius(4)
            } else {
                // Highlight effect with overlapping rectangles
                Text(text)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                    .blendMode(colorScheme == .dark ? .plusDarker : .plusLighter)
                    .fontWeight(.semibold)
                    .background {
                        ZStack(alignment: .center) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.tcCyan)
                                .offset(y: -0.8)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.tcPink)
                                .offset(x: 0.8)
                                .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
                        }
                        .compositingGroup()
                    }
            }
        }
        .bold()
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        StyledText("Tap the {{checkmark.circle}} button")
        StyledText("Enable **TokCleaner** extension")
        StyledText("Tap the {{aA}} icon and select **Manage Extensions**")
        StyledText("Turn on **Allow Extension**")
    }
    .padding()
}
