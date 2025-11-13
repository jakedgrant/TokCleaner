//
//  SetupView.swift
//  iOS (App)
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

struct SetupView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 20)

                // Title
                VStack(spacing: 8) {
                    Text("Enable the Extension")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Choose one of the methods below")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 8)

                // Method 1: Settings App
                InstructionCard(
                    icon: "gear",
                    title: "Via Settings App",
                    steps: [
                        "Open the Settings app",
                        "Scroll down and tap Safari",
                        "Tap Extensions",
                        "Enable TokCleaner"
                    ]
                )

                // Method 2: Safari Extensions Menu
                InstructionCard(
                    icon: "safari",
                    title: "Via Safari",
                    steps: [
                        "Open Safari and visit any website",
                        "Tap the aA icon in the address bar",
                        "Tap Manage Extensions",
                        "Enable TokCleaner"
                    ]
                )

                // Additional Note
                InfoCard(
                    icon: "checkmark.circle.fill",
                    iconColor: .green,
                    title: "That's it!",
                    message: "Once enabled, TokCleaner will automatically clean tracking parameters from all TikTok links you visit in Safari.",
                    backgroundColor: Color(.systemGray6)
                )

                Spacer()
                    .frame(height: 20)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    NavigationView {
        SetupView()
            .navigationTitle("TokCleaner")
            .navigationBarTitleDisplayMode(.large)
    }
}
