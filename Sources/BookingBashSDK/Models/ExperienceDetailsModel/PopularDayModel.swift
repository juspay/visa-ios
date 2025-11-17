import Foundation

struct PopularDayModel: Identifiable {
    let id = UUID()
    let title: String
    let isHighlighted: Bool
}
