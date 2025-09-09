//
//  PaymentWebView.swift
//  VisaActivity
//
//  Created by GitHub Copilot on 24/08/25.
//

import SwiftUI
import WebKit

struct PaymentWebView: UIViewRepresentable {
    var orderId: String
    let baseUrl: String = "https://payment.bookingbash.com/?order_no="
    @Binding var shouldNavigateToConfirmation: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let fullURL = "\(baseUrl)\(orderId)"
        print("Loading payment URL: \(fullURL)")
        
        guard let url = URL(string: fullURL) else {
            print("❌ Invalid URL: \(fullURL)")
            return
        }
        
        // Only load if not already loading the same URL
        if webView.url?.absoluteString != fullURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
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
            // Loading state can be handled in parent view if needed
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Loading state can be handled in parent view if needed
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Web view navigation failed: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            print("url\(url)")
            let urlString = url.absoluteString.lowercased()
            print("urlString\(urlString)\n")
            if urlString.contains("succeeded") {
                print("✅ Success URL detected, triggering navigation")
                decisionHandler(.allow)
                // Trigger navigation immediately without delay
                DispatchQueue.main.async {
                    self.parent.shouldNavigateToConfirmation = true
                }
                return
            }
            
            decisionHandler(.allow)
        }
    }
}
