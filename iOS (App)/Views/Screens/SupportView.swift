//
//  SupportView.swift
//  iOS (App)
//
//  Created by Jake Grant on 12/2/25.
//

import SwiftUI

struct SupportView: View {
    @State private var supportMarkdown: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if !supportMarkdown.isEmpty {
                    Text(.init(supportMarkdown))
                        .textSelection(.enabled)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .navigationTitle("Support")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            loadSupport()
        }
    }

    private func loadSupport() {
        guard let url = Bundle.main.url(forResource: "SUPPORT", withExtension: "md"),
              let markdown = try? String(contentsOf: url, encoding: .utf8) else {
            supportMarkdown = "Support information not found."
            return
        }

        supportMarkdown = markdown
    }
}

#Preview {
    NavigationView {
        SupportView()
    }
}
