

import SwiftUI
import Foundation


func requiredLabel(_ text: String) -> some View {
    HStack(spacing: 2) {
        Text(text)
            .font(.system(size: 16, weight: .semibold))
        Text("*")
            .foregroundColor(.red)
    }
}


// Custom modifier to execute an action only once when the view appears
extension View {
    /// Perform a given action when the view first appears.
    /// This action will only be executed once during the first appearance of the view.
    /// - Parameter action: The action to execute once when the view appears.
    /// - Returns: A view with the `onAppearOnce` modifier applied.
    func onAppearOnce(perform action: @escaping () -> Void) -> some View {
        self.modifier(OnAppearOnceModifier(action: action))
    }
}
