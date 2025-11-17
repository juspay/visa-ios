import Foundation

struct InfoDetailModel: Identifiable {
    let id = UUID()
    let title: String
    var shortDesciption: String = ""
    let items: [String]
}
