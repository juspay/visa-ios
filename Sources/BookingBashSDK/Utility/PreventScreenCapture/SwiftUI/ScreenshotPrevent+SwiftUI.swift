//
//  ScreenshotPrevent+SwiftUI.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 03/12/25.
//

import SwiftUI
import UIKit
import Combine

// MARK: - SwiftUI View for easier usage
@available(iOS 13.0, *)
public struct ScreenshotPrevent<Content: View>: View {

    private var isProtected: Bool
    private let content: () -> Content

    public init(isProtected: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.isProtected = isProtected
        self.content = content
    }

    public var body: some View {
        ZStack {
            if isProtected {
                Text("PRIVACY MODE ENABLED")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.center)
            }
            _ScreenshotPreventView(preventScreenCapture: isProtected) {
                content()
            }
            .ignoresSafeArea()
        }
    }
}
