import Foundation

struct ExperienceListModel: Identifiable {
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
}
