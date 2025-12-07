//
//  ContentView.swift
//  iOS (App)
//
//  Created by Jake Grant on 11/7/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 18.0, *) {
            // iOS 18+ uses new Tab API with top tab bar on iPad and full-screen content
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
        } else {
            // iOS 15-17 fallback with traditional TabView
            TabView {
                // Setup Tab
                NavigationView {
                    SetupView()
                        .navigationTitle("TokCleaner")
                        .navigationBarTitleDisplayMode(.large)
                }
                .tabItem {
                    Label("Setup", systemImage: "gear")
                }
                .accessibilityLabel("Setup Instructions")
                .accessibilityHint("Learn how to enable the TokCleaner extension")
                .accessibilityIdentifier("setupTab")

                // How It Works Tab
                NavigationView {
                    HowItWorksView()
                        .navigationTitle("How It Works")
                        .navigationBarTitleDisplayMode(.large)
                }
                .tabItem {
                    Label("How It Works", systemImage: "info.circle")
                }
                .accessibilityLabel("How TokCleaner Works")
                .accessibilityHint("Learn about features and privacy")
                .accessibilityIdentifier("howItWorksTab")

                // More Tab
                NavigationView {
                    MoreView()
                        .navigationTitle("More")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
                .accessibilityLabel("More")
                .accessibilityHint("About TokCleaner, share, and review")
                .accessibilityIdentifier("moreTab")
            }
        }
    }
}

#Preview {
    ContentView()
}
