//
//  FeatureCard.swift
//  TokCleaner
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

// MARK: - Feature Card Component
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            OverlappingImages {
                Image(systemName: icon)
                    .font(.title2)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
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
    }
}

#Preview {
    VStack(spacing: 16) {
        FeatureCard(
            icon: "link.circle.fill",
            title: "Automatic Cleaning",
            description: "When you click a TikTok link, TokCleaner instantly removes tracking parameters before the page loads."
        )

        FeatureCard(
            icon: "eye.slash.fill",
            title: "What Gets Removed",
            description: "Tracking IDs, referrer codes, analytics tokens, and other parameters that track where you came from."
        )
    }
    .padding()
}
