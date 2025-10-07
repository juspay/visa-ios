//
//  ExperiencePayment.swift
//  VisaActivity
//
//  Created by Prav on 25/08/25.
//

import SwiftUI
import WebKit

// SwiftUI wrapper for WKWebView
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
        
    }
}

// Main view that uses WebView
struct ExperiencePaymentView: View {
    var body: some View {
        WebView(url: URL(string: "https://test-payment.bookingbash.com")!)
            .ignoresSafeArea()
    }
}

#Preview {
    ExperiencePaymentView()
}
