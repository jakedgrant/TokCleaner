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
                        .navigationTitle("Paramless")
                        .navigationBarTitleDisplayMode(.large)
                }
            }
            .accessibilityLabel("Setup Instructions")
            .accessibilityHint("Learn how to enable the Paramless extension")
            .accessibilityIdentifier("setupTab")

            Tab("How It Works", systemImage: "info.circle") {
                NavigationStack {
                    HowItWorksView()
                        .navigationTitle("How It Works")
                        .navigationBarTitleDisplayMode(.large)
                }
            }
            .accessibilityLabel("How Paramless Works")
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
            .accessibilityHint("About Paramless, share, and review")
            .accessibilityIdentifier("moreTab")
        }
        .tabViewStyle(.tabBarOnly)
    }
}

#Preview {
    ContentView()
}
