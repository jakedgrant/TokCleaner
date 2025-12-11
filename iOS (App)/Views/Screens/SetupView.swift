//
//  SetupView.swift
//  iOS (App)
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

struct SetupView: View {
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
                    Text("Choose one of the methods below to enable the extension")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 8)

                if isRegularWidth {
                    // iPad: 2-column mosaic layout for instruction cards
                    HStack(alignment: .top, spacing: cardSpacing) {
                        // Left column
                        InstructionCard(
                            icon: "gear",
                            title: "Via Settings App",
                            steps: [
                                "Open the Settings app",
                                "Scroll down to {{square.grid.3x3.square}} **Apps**",
                                "Scroll down and tap {{safari.fill}} **Safari**",
                                "Tap **Extensions**",
                                "Tap {{eraser.line.dashed.fill}} **TokCleaner**",
                                "Turn on 'Allow Extension'",
                            ]
                        )
                        .accessibilityIdentifier("instructionCard_settings")
                        .frame(maxWidth: .infinity)

                        // Right column
                        InstructionCard(
                            icon: "safari",
                            title: "Via Safari",
                            steps: [
                                "Open **Safari** and visit any social media site",
                                "Tap the {{text.page}} icon in the address bar",
                                "Tap {{puzzlepiece.extension}} **Manage Extensions**",
                                "Enable **TokCleaner**",
                                "Tap the {{checkmark}} **button**",
                                "Tap {{eraser.line.dashed.fill}} **TokCleaner**",
                                "Tap **Always Allow...**",
                            ]
                        )
                        .accessibilityIdentifier("instructionCard_safari")
                        .frame(maxWidth: .infinity)
                    }

                    // Full-width completion card
                    InfoCard(
                        icon: "checkmark.circle.fill",
                        iconColor: .green,
                        title: "That's it!",
                        message: "Once enabled, TokCleaner will automatically clean tracking parameters from social media links you visit in Safari.",
                        backgroundColor: Color(.systemGray6)
                    )
                    .accessibilityIdentifier("infoCard_completion")
                } else {
                    // iPhone: Single column layout
                    VStack(spacing: cardSpacing) {
                        // Method 1: Settings App
                        InstructionCard(
                            icon: "gear",
                            title: "Via Settings App",
                            steps: [
                                "Open the Settings app",
                                "Scroll down to {{square.grid.3x3.square}} **Apps**",
                                "Scroll down and tap {{safari.fill}} **Safari**",
                                "Tap **Extensions**",
                                "Tap {{eraser.line.dashed.fill}} **TokCleaner**",
                                "Turn on 'Allow Extension'",
                            ]
                        )
                        .accessibilityIdentifier("instructionCard_settings")

                        // Method 2: Safari Extensions Menu
                        InstructionCard(
                            icon: "safari",
                            title: "Via Safari",
                            steps: [
                                "Open **Safari** and visit any social media site",
                                "Tap the {{text.page}} icon in the address bar",
                                "Tap {{puzzlepiece.extension}} **Manage Extensions**",
                                "Enable **TokCleaner**",
                                "Tap the {{checkmark}} **button**",
                                "Tap {{eraser.line.dashed.fill}} **TokCleaner**",
                                "Tap **Always Allow...**",
                            ]
                        )
                        .accessibilityIdentifier("instructionCard_safari")

                        // Additional Note
                        InfoCard(
                            icon: "checkmark.circle.fill",
                            iconColor: .green,
                            title: "That's it!",
                            message: "Once enabled, TokCleaner will automatically clean tracking parameters from social media links you visit in Safari.",
                            backgroundColor: Color(.systemGray6)
                        )
                        .accessibilityIdentifier("infoCard_completion")
                    }
                }

                Spacer()
                    .frame(height: 20)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 20)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("setupView")
    }
}

#Preview {
    NavigationView {
        SetupView()
            .navigationTitle("TokCleaner")
            .navigationBarTitleDisplayMode(.large)
    }
}
