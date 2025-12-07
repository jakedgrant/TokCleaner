//
//  ContentView.swift
//  iOS (App)
//
//  Created by Jake Grant on 11/7/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Setup", systemImage: "gear") {
                NavigationStack {
                    SetupView()
                        .navigationTitle("TokCleaner")
                        .navigationBarTitleDisplayMode(.large)
                }
            }
            .accessibilityLabel("Setup Instructions")
            .accessibilityHint("Learn how to enable the TokCleaner extension")
            .accessibilityIdentifier("setupTab")

            Tab("How It Works", systemImage: "info.circle") {
                NavigationStack {
                    HowItWorksView()
                        .navigationTitle("How It Works")
                        .navigationBarTitleDisplayMode(.large)
                }
            }
            .accessibilityLabel("How TokCleaner Works")
            .accessibilityHint("Learn about features and privacy")
            .accessibilityIdentifier("howItWorksTab")

            Tab("More", systemImage: "ellipsis") {
                NavigationStack {
                    MoreView()
                        .navigationTitle("More")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .accessibilityLabel("More")
            .accessibilityHint("About TokCleaner, share, and review")
            .accessibilityIdentifier("moreTab")
        }
        .tabViewStyle(.tabBarOnly)
    }
}

#Preview {
    ContentView()
}
