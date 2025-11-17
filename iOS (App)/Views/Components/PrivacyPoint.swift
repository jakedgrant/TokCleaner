//
//  PrivacyPoint.swift
//  TokCleaner
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

// MARK: - Privacy Point Component
struct PrivacyPoint: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 24)
                .accessibilityHidden(true)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        PrivacyPoint(
            icon: "iphone",
            text: "Everything happens on your device"
        )
        PrivacyPoint(
            icon: "wifi.slash",
            text: "No internet connection required"
        )
        PrivacyPoint(
            icon: "chart.bar.xaxis",
            text: "Zero data collection or analytics"
        )
        PrivacyPoint(
            icon: "eye.slash",
            text: "We can't see what you browse"
        )
    }
    .padding()
}
