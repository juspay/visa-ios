import SwiftUI
@preconcurrency import WebKit

struct PaymentWebView: UIViewRepresentable {
    var orderId: String
    var paymentUrl: String
    @Binding var shouldNavigateToConfirmation: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Use paymentUrl if available, otherwise fall back to orderId
        let fullURL = !paymentUrl.isEmpty ? paymentUrl : orderId
        
        guard let url = URL(string: fullURL) else {
            print("❌ [PAYMENT WEBVIEW] Invalid URL: \(fullURL)")
            return
        }
        
        print("🔍 [PAYMENT WEBVIEW] Loading payment URL: \(fullURL)")
        
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
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            let urlString = url.absoluteString.lowercased()
            if urlString.contains("success") {
                print("✅ [PAYMENT WEBVIEW] Success URL detected: \(urlString)")
                // Cancel the WebView navigation to prevent race condition
                decisionHandler(.cancel)
                // Navigate to confirmation with a delay to ensure WebView state settles
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    print("✅ [PAYMENT WEBVIEW] Navigating to confirmation")
                    self.parent.shouldNavigateToConfirmation = true
                }
                return
            }
            decisionHandler(.allow)
        }
    }
}
