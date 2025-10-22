

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


