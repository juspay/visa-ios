struct ReviewDetailsRequestModel: Codable {
    let uid: String
    let availabilityId: String
    let quoteId: String
    let enquiryId: String
    let activityCode: String
    let rateCode: String
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case availabilityId = "availability_id"
        case quoteId = "quote_id"
        case enquiryId = "enquiry_id"
        case activityCode = "activity_code"
        case rateCode = "rate_code"
        case currency
    }
}
