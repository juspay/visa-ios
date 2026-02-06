import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        guard hex.count == 6,
              let int = UInt64(hex, radix: 16) else {
            self = Color.clear
            return
        }
        
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF)/255,
                  green: Double((hex >> 8) & 0xFF)/255,
                  blue: Double(hex & 0xFF)/255,
                  opacity: alpha)
    }
}
extension Color {
    static let uiNavy = Color(hex: 0x0F2846)
    static let tabAccent = Color(hex: 0xBE9757)
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE, dd MMM yyyy"
        return f
    }()
}

extension TransactionStatus {
    var color: Color {
        switch self {
        case .confirmed:
            return Color(hex: Constants.HexColors.greenShade)
        case .pending:
            return Color(hex: Constants.HexColors.yellowShade)
        case .cancelled:
            return Color(hex: Constants.HexColors.error)
        case .completed:
            return .blue
        case .failed:
            return Color(hex: Constants.HexColors.error)
        case .refunded:
            return Color(hex: Constants.HexColors.error)
        }
    }
}

