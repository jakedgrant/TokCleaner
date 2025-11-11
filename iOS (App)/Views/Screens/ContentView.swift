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
                    .navigationTitle("TokCleaner")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Setup", systemImage: "gear")
            }

            // How It Works Tab
            NavigationView {
                HowItWorksView()
                    .navigationTitle("TokCleaner")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("How It Works", systemImage: "info.circle")
            }
        }
    }
}
