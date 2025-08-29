//
//  PaymentWebView.swift
//  VisaActivity
//
//  Created by GitHub Copilot on 24/08/25.
//

import SwiftUI
import WebKit

struct PaymentWebView: UIViewRepresentable {
    let url: String
    @Binding var shouldNavigateToConfirmation: Bool
    @State private var isLoading = false
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        
        // Configure web view settings
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: PaymentWebView
        
        init(_ parent: PaymentWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
            // Load blank page after initial load
            if let currentURL = webView.url?.absoluteString, currentURL != "about:blank" {
                webView.load(URLRequest(url: URL(string: "about:blank")!))
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
            print("Web view navigation failed: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            
            let urlString = url.absoluteString.lowercased()
            
            // Check if URL contains "success" - trigger navigation to confirmation page
            if urlString.contains("success") {
                decisionHandler(.allow)
                
                // Delay navigation to ensure smooth transition
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.parent.shouldNavigateToConfirmation = true
                }
                return
            }
            
            decisionHandler(.allow)
        }
    }
}
