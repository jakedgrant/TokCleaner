//
//  ViewController.swift
//  Shared (App)
//
//  Created by Jake Grant on 11/7/25.
//

import SwiftUI
import WebKit

#if os(macOS)
import SafariServices
#endif

let extensionBundleIdentifier = "com.jacobgrant.TokCleaner.Extension"

// MARK: - SwiftUI View
struct ContentView: View {
    var body: some View {
        WebView()
            .ignoresSafeArea()
    }
}

// MARK: - WebView Representable
struct WebView: View {
    #if os(iOS)
    var body: some View {
        WebViewRepresentable()
    }
    #elseif os(macOS)
    var body: some View {
        WebViewRepresentable()
    }
    #endif
}

#if os(iOS)
struct WebViewRepresentable: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.configuration.userContentController.add(context.coordinator, name: "controller")

        if let url = Bundle.main.url(forResource: "Main", withExtension: "html"),
           let resourceURL = Bundle.main.resourceURL {
            webView.loadFileURL(url, allowingReadAccessTo: resourceURL)
        }

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // No updates needed
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("show('ios')")
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            // iOS doesn't need to handle messages
        }
    }
}
#elseif os(macOS)
struct WebViewRepresentable: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.configuration.userContentController.add(context.coordinator, name: "controller")

        if let url = Bundle.main.url(forResource: "Main", withExtension: "html"),
           let resourceURL = Bundle.main.resourceURL {
            webView.loadFileURL(url, allowingReadAccessTo: resourceURL)
        }

        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        // No updates needed
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("show('mac')")

            SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
                guard let state = state, error == nil else {
                    return
                }

                DispatchQueue.main.async {
                    if #available(macOS 13, *) {
                        webView.evaluateJavaScript("show('mac', \(state.isEnabled), true)")
                    } else {
                        webView.evaluateJavaScript("show('mac', \(state.isEnabled), false)")
                    }
                }
            }
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if (message.body as! String != "open-preferences") {
                return
            }

            SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { error in
                guard error == nil else {
                    return
                }

                DispatchQueue.main.async {
                    NSApp.terminate(nil)
                }
            }
        }
    }
}
#endif
