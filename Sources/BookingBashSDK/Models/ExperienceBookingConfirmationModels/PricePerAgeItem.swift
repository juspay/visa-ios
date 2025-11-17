
import Foundation

struct PricePerAgeItem: Identifiable {
    let id = UUID()
    let ageBand: String
    let count: Int          
    let pricePerTraveller: Double
    let totalAmount: Double
}
