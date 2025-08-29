//
//  Color+Hex.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

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
