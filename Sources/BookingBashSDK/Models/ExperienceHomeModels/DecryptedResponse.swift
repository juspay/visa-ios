import Foundation

struct DecryptedResponse: Codable {
    let verified: Bool
    let payload: Payload
}

struct Payload: Codable {
    let offerTxnId: String
    let lastName: String
    let cardIssuerName: String
    let mobileCountryCode: String
    let mobileNumber: String
    let isDeeplink: Bool
    let eligibilityLevel: Int
    let cardLastFour: String
    let firstName: String
    let aliasId: String
    let cardIssuerCountry: String
    let customerEmail: String
    let customerId: String
    let isEligible: Bool
    let location: String
    let cardFirstSix: String
}
