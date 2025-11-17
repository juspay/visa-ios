import Foundation

struct MobileCode: Identifiable, Codable {
    let id = UUID()
    let name: String
    let maxCharLimit: Int
    let countryCode: Int
    let dialCode: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case name
        case maxCharLimit = "max_char_limit"
        case countryCode = "country_code"
        case dialCode = "dial_code"
        case image
    }
}

