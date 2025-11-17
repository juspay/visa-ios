

import Foundation

struct FareItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let isDiscount: Bool
}

