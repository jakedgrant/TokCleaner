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

            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()
        }
    }
}
