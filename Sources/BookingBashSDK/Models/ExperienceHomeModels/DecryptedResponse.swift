import Foundation

struct DecryptedResponse: Codable {
    let verified: Bool
    let payload: Payload
}

struct Payload: Codable {
    let firstName: String
    let lastName: String
    let aliasId: String
    let customerEmail: String
    let customerId: String
    let isDeeplink: Bool
    let isEligible: Bool
    let location: String
    let eligibilityLevel: Int
    let cardFirstSix: String
    let cardLastFour: String
}
