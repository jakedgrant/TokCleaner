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
            // Setup Tab
            NavigationView {
                SetupView()
                    .navigationTitle("Tok Cleaner")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Setup", systemImage: "gear")
            }
            .accessibilityLabel("Setup Instructions")
            .accessibilityHint("Learn how to enable the Tok Cleaner extension")
            .accessibilityIdentifier("setupTab")

            // How It Works Tab
            NavigationView {
                HowItWorksView()
                    .navigationTitle("Tok Cleaner")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("How It Works", systemImage: "info.circle")
            }
            .accessibilityLabel("How Tok Cleaner Works")
            .accessibilityHint("Learn about features and privacy")
            .accessibilityIdentifier("howItWorksTab")
        }
    }
}

#Preview {
    ContentView()
}
