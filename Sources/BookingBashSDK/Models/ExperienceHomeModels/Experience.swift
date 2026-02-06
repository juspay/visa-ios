import Foundation

struct Experience: Identifiable, Equatable {
    let id = UUID()
    let imageURL: String
    let title: String
    let originalPrice: Double
    let discount: Double
    let finalPrice: Double
    let productCode: String
    let currency: String
    let pricingModel: String
}

