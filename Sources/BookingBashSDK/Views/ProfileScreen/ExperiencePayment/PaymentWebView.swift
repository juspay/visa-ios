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
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            let urlString = url.absoluteString.lowercased()
            if urlString.contains("success") {
                decisionHandler(.cancel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.parent.shouldNavigateToConfirmation = true
                }
                return
            }
            decisionHandler(.allow)
        }
    }
}
