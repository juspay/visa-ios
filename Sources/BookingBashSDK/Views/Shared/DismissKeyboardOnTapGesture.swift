//
//  DismissKeyboardOnTapGesture.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 28/01/26.
//

import SwiftUI
import UIKit

struct DismissKeyboardOnTapGesture: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
}

extension UIApplication {
    // to Dismiss Keyboard
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    // Method to dismiss the keyboard when tapping anywhere on the view
    func dismissKeyboardOnTap() -> some View {
        // Apply a custom ViewModifier to detect taps and dismiss the keyboard
        self.modifier(DismissKeyboardOnTapGesture())
    }
}
