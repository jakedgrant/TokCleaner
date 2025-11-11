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
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.title2)
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
        .padding(.horizontal, 20)
    }
}

