
import Foundation

struct Experience: Identifiable, Equatable {
    let id = UUID()
    let imageURL: String
    let country: String
    let title: String
    let originalPrice: Int
    let discount: Int
    let finalPrice: Int
    let productCode: String
    let currency: String
    
}
