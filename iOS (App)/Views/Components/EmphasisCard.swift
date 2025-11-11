//
//  EmphasisCard.swift
//  TokCleaner
//
//  Created by Jake Grant on 11/11/25.
//

import SwiftUI

struct EmphasisCard: View {
    
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.green)
                    .font(.title2)
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                PrivacyPoint(
                    icon: "iphone",
                    text: "Everything happens on device"
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
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.1), Color.blue.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .padding(.horizontal, 20)
    }
}
                
