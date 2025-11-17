import Foundation

struct InfoItem: Identifiable {
    let id = UUID()
    let title: String
    let type: InfoType
}

enum InfoType {
    case highlights, included, excluded, cancellation, know, where_, reviews, photos
}
