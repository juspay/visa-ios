//
//  ScreenshotPrevent+ViewModifier.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 03/12/25.
//

import SwiftUI
import UIKit

// MARK: - SwiftUI Wrapper for the controller
@available(iOS 13.0, *)
struct _ScreenshotPreventView<Content: View>: UIViewControllerRepresentable {

    typealias UIViewControllerType = ScreenshotPreventingHostingViewController<Content>
    
    private var preventScreenCapture: Bool
    private let content: () -> Content

    init(preventScreenCapture: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.preventScreenCapture = preventScreenCapture
        self.content = content
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        ScreenshotPreventingHostingViewController(preventScreenCapture: preventScreenCapture, content: content)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.preventScreenCapture = preventScreenCapture
    }
}
