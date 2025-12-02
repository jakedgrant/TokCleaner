//
//  MoreView.swift
//  iOS (App)
//
//  Created by Jake Grant on 12/1/25.
//

import SwiftUI

struct MoreView: View {
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return "Version \(version)"
    }
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 28) {
                    
                    // App Icon, Name, and Version
                    VStack(spacing: 16) {
                        OverlappingImages {
                            Image(systemName: "eraser.line.dashed.fill")
                                .font(.system(size: 64))
                        }
                        .accessibilityLabel("TokCleaner app icon")
                        
                        Text("TokCleaner")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(appVersion)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 8)
                    
                    // Thank You Message
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Thank you for using TokCleaner! We appreciate you taking the time to download and use our app to protect your privacy while browsing TikTok links.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("If you find TokCleaner useful, please consider sharing it with others and leaving a review on the App Store. Your support helps us continue improving the app!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 4)
                }
            }
            .listRowBackground(Color.clear)
            .listStyle(.plain)
            
            Section {
                // Action Buttons
                // Share Button
                ShareLink(item: URL(string: "https://apps.apple.com/app/tokcleaner/id<APP_ID>")!) {
                    HStack(spacing: 12) {
                        OverlappingImages {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title3)
                        }
                        
                        Text("Share TokCleaner")
                            .font(.headline)
                        
                        Spacer()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.primary)
                }
                .accessibilityLabel("Share TokCleaner")
                .accessibilityHint("Opens share sheet to share the app with others")
                
                // Review Button
                Button(action: {
                    openAppStoreReview()
                }) {
                    HStack(spacing: 12) {
                        OverlappingImages {
                            Image(systemName: "star")
                                .font(.title3)
                        }
                        
                        Text("Rate on App Store")
                            .font(.headline)
                        
                        Spacer()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.primary)
                }
                .accessibilityLabel("Rate on App Store")
                .accessibilityHint("Opens the App Store to leave a review")
                
                
                // Privacy Policy Link
                NavigationLink(destination: PrivacyPolicyView()) {
                    HStack(spacing: 12) {
                        OverlappingImages {
                            Image(systemName: "hand.raised")
                                .font(.title3)
                        }
                        
                        Text("Privacy Policy")
                            .font(.headline)
                        
                        Spacer()
                    }
                }
                .accessibilityLabel("Privacy Policy")
                .accessibilityHint("View the privacy policy")
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("moreView")
    }
    
    private func openAppStoreReview() {
        // Replace <APP_ID> with your actual App Store ID
        if let url = URL(string: "https://apps.apple.com/app/id<APP_ID>?action=write-review") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationView {
        MoreView()
            .navigationTitle("TokCleaner")
            .navigationBarTitleDisplayMode(.large)
    }
}
