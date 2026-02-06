//
//  ScreenshotPreventingView+Hosting.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 03/12/25.
//

import SwiftUI
import UIKit
import Combine

// MARK: - UIViewController that detects screenshots and screen recording
@available(iOS 13.0, *)
final class ScreenshotPreventingHostingViewController<Content: View>: UIViewController {

    private let content: () -> Content
    private let wrapperView = ScreenshotPreventingView()

    var preventScreenCapture: Bool = true {
        didSet {
            wrapperView.preventScreenCapture = preventScreenCapture
        }
    }

    init(preventScreenCapture: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.preventScreenCapture = preventScreenCapture
        self.content = content
        super.init(nibName: nil, bundle: nil)

        setupUI()
        wrapperView.preventScreenCapture = preventScreenCapture
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        view.addSubview(wrapperView)
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wrapperView.topAnchor.constraint(equalTo: view.topAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let hostVC = UIHostingController(rootView: content())
        hostVC.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(hostVC)
        wrapperView.setup(contentView: hostVC.view)
        hostVC.didMove(toParent: self)
    }
}
