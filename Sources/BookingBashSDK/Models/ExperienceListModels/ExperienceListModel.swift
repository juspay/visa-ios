import Foundation

struct ExperienceListModel: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let rating: Double
    let reviewCount: Int
    let price: Double
    let strikeoutPrice: Double?
    let savingPercentage: Double?
    let imageName: String
    let productCode: String
    let currency: String
    
    static func == (lhs: ExperienceListModel, rhs: ExperienceListModel) -> Bool {
            return lhs.id == rhs.id
            // OR compare all necessary fields
        }
}
