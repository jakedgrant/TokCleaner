//
//  InfoCard.swift
//  TokCleaner
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

struct InfoCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let message: String
    let backgroundColor: Color

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.title3)
                    .accessibilityHidden(true)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(12)
        .padding(.top, 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(message)")
        .accessibilityAddTraits(.isStaticText)
    }
}

#Preview {
    VStack(spacing: 16) {
        InfoCard(
            icon: "checkmark.circle.fill",
            iconColor: Color("tcCyan"),
            title: "That's it!",
            message: "Once enabled, TokCleaner will automatically clean tracking parameters from social media links you visit in Safari.",
            backgroundColor: Color(.systemGray6)
        )

        InfoCard(
            icon: "exclamationmark.triangle.fill",
            iconColor: .orange,
            title: "Important",
            message: "Make sure to enable the extension in Safari settings for it to work.",
            backgroundColor: Color.orange.opacity(0.1)
        )
    }
    .padding()
}
