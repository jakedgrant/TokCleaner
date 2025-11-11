//
//  ContentView.swift
//  iOS (App)
//
//  Created by Jake Grant on 11/7/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("LargeIcon")
                .resizable()
                .frame(width: 128, height: 128)

            Text("You can turn on TokCleaner's Safari extension in Settings.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
    }
}
