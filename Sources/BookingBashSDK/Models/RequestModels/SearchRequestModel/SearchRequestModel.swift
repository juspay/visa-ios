// MARK: - SearchRequest
struct SearchRequestModel: Codable {
    let destinationId: String
    let destinationType: Int
    let location: String
    let checkInDate: String
    let checkOutDate: String
    let currency: String
    let clientId: String
    let enquiryId: String
    let productCode: [String]
    var filters: SearchFilters
    
    enum CodingKeys: String, CodingKey {
        case destinationId = "destination_id"
        case destinationType = "destination_type"
        case location
        case checkInDate = "check_in_date"
        case checkOutDate = "check_out_date"
        case currency
        case clientId = "client_id"
        case enquiryId = "enquiry_id"
        case productCode = "product_code"
        case filters
    }
}

// MARK: - SearchFilters
struct SearchFilters: Codable {
    let limit: Int
    let offset: Int
    let priceRange: [Double]
    let rating: [Int]
    let duration: [Int]
    let reviewCount: [Int]
    var sort_by: SortBy
    let categories: [String]
    let language: [String]
    let itineraryType: [String]
    let ticketType: [String]
    let confirmationType: [String]
    let featureFlags: [String]
    let productCode: [String]
    
    enum CodingKeys: String, CodingKey {
        case limit, offset
        case priceRange = "price_range"
        case rating, duration
        case reviewCount = "review_count"
        case sort_by
        case categories, language
        case itineraryType = "itinerary_type"
        case ticketType = "ticket_type"
        case confirmationType = "confirmation_type"
        case featureFlags = "feature_flags"
        case productCode = "product_code"
    }
}

// MARK: - SortBy
struct SortBy: Codable {
    let name: String
    let type: String
}
