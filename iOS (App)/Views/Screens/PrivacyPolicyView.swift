//
//  PrivacyPolicyView.swift
//  iOS (App)
//
//  Created by Jake Grant on 12/2/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @State private var privacyMarkdown: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if !privacyMarkdown.isEmpty {
                    Text(.init(privacyMarkdown))
                        .textSelection(.enabled)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            loadPrivacyPolicy()
        }
    }

    private func loadPrivacyPolicy() {
        guard let url = Bundle.main.url(forResource: "PRIVACY", withExtension: "md"),
              let markdown = try? String(contentsOf: url, encoding: .utf8) else {
            privacyMarkdown = "Privacy policy not found."
            return
        }

        privacyMarkdown = markdown
    }
}

#Preview {
    NavigationView {
        PrivacyPolicyView()
    }
}
