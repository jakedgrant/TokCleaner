//
//  EmphasisCard.swift
//  TokCleaner
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

struct EmphasisCard<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    let gradientColors: [Color]
    let content: Content

    init(
        icon: String,
        iconColor: Color = .green,
        title: String,
        gradientColors: [Color] = [Color.green.opacity(0.1), Color.blue.opacity(0.1)],
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.gradientColors = gradientColors
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                
                OverlappingImages {
                    Image(systemName: icon)
                        .font(.title2)
                }
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
            }

            content
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

#Preview {
    EmphasisCard(
        icon: "lock.shield.fill",
        iconColor: Color("tcCyan"),
        title: "Your Privacy",
        gradientColors: [Color("tcCyan").opacity(0.15), Color("tcCyan").opacity(0.15)]
    ) {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "iphone")
                    .foregroundColor(.primary)
                    .frame(width: 24)
                Text("Everything happens on your device")
                    .font(.subheadline)
                Spacer()
            }
            HStack(spacing: 12) {
                Image(systemName: "wifi.slash")
                    .foregroundColor(.primary)
                    .frame(width: 24)
                Text("No internet connection required")
                    .font(.subheadline)
                Spacer()
            }
        }
    }
    .padding()
}

