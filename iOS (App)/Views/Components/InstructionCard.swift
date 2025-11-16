//
//  InstructionCard.swift
//  iOS (App)
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

struct InstructionCard: View {
    let icon: String
    let title: String
    let steps: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                OverlappingImages {
                    Image(systemName: icon)
                        .font(.title2)
                }

                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            // Steps
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(Color.accentColor)
                            .cornerRadius(12)

                        Text(step)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
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
    .padding()
}
