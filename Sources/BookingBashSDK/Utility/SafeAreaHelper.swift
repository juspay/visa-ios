//
//  SafeAreaHelper.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation
import UIKit

struct SafeAreaHelper {
    static func bottomInset() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }

        return window.safeAreaInsets.bottom
    }
}
