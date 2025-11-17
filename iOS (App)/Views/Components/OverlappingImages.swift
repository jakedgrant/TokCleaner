//
//  OverlappingImages.swift
//  TokCleaner (iOS)
//
//  Created by Jake Grant on 11/12/25.
//

import SwiftUI

struct OverlappingImages<Content: View>: View {

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    let content: Content
    let offset: CGFloat

    init(
        offset: CGFloat = 1.2,
        @ViewBuilder content: () -> Content
    ) {
        self.offset = offset
        self.content = content()
    }

    var body: some View {
        Group {
            if reduceMotion {
                // Simplified version for users with motion sensitivity
                content
                    .foregroundStyle(Color.tcCyan)
            } else {
                // Full overlapping effect for standard viewing
                ZStack(alignment: .center) {
                    content
                        .foregroundStyle(Color.tcCyan)
                        .offset(y: -offset)

                    content
                        .foregroundStyle(Color.tcPink)
                        .offset(x: offset)
                        .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
                }
                .compositingGroup()
            }
        }
        .accessibilityHidden(true)  // Hide decorative visual effect from VoiceOver
    }
}

#Preview {
    VStack {
        OverlappingImages {
            Image("link.circle.fill")
                .font(.title2)
        }
        Spacer()
    }
}
