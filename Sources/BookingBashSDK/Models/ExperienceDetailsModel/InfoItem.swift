import Foundation

struct InfoItem: Identifiable {
    let id = UUID()
    let title: String
    let type: InfoType
}

enum InfoType {
    case highlights, included, excluded, cancellation, where_, reviews, photos, know_before_you_go
}
