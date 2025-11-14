//
//  OverlappingImages.swift
//  TokCleaner (iOS)
//
//  Created by Jake Grant on 11/12/25.
//

import SwiftUI

struct OverlappingImages<Content: View>: View {
    
    let content: Content
    let offset: CGFloat
    
    init(
        offset: CGFloat = 1.0,
        @ViewBuilder content: () -> Content
    ) {
        self.offset = offset
        self.content = content()
    }
    
    var body: some View {
        
        ZStack(alignment: .center) {
            content
                .foregroundStyle(Color.tcCyan)
                .offset(y: -offset)
            
            content
                .foregroundStyle(Color.tcPink)
                .offset(x: offset)
                .blendMode(.plusDarker)
        }
        .compositingGroup()
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
