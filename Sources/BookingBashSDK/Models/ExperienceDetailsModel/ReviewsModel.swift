import Foundation

struct ReviewsModel: Identifiable {
    let id = UUID()
    let rating: Int
    let title: String
    let body: String
    let images: [String]
    let userName: String
    let date: String
}
