//
//  TermsAndPrivacyWebview.swift
//  VisaActivity
//
//  Created by Praveen on 16/10/25.
//

import SwiftUI
@preconcurrency import WebKit

struct TermsAndConditionsWebView: View {
    @Environment(\.dismiss) private var dismiss
    let url: String
    let title: String
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    
                    Text(title)
                        .font(.custom("Lexend-Medium", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                        .frame(width: 30) // Balance the back button
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: Constants.HexColors.blueShade))
                
                // WebView
                TermsWebViewRepresentable(url: url)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct TermsWebViewRepresentable: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let urlObj = URL(string: url) else {
            print("❌ [WEBVIEW] Invalid URL: \(url)")
            return
        }
        
        print("🔍 [WEBVIEW] Loading URL: \(url)")
        
        // Only load if not already loading the same URL
        if webView.url?.absoluteString != url {
            let request = URLRequest(url: urlObj)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("🔍 [WEBVIEW] Started loading")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("🔍 [WEBVIEW] Finished loading")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ [WEBVIEW] Failed to load: \(error.localizedDescription)")
        }
    }
}
