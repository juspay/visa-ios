
struct AvailabilityRequest: Codable {
    let activityCode: String
    let currency: String
    let checkInDate: String
    let travelerDetails: [TravelerDetail]
    
    enum CodingKeys: String, CodingKey {
        case activityCode = "activity_code"
        case currency
        case checkInDate = "check_in_date"
        case travelerDetails = "traveler_details"
    }
}

struct TravelerDetail: Codable {
    let ageBand: String
    let travelerCount: Int

    enum CodingKeys: String, CodingKey {
        case ageBand = "age_band"
        case travelerCount = "traveler_count"
    }
}
