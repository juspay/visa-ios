import Foundation

// MARK: - Safe Double Decoding Extension
extension KeyedDecodingContainer {
    func decodeSafeDouble(forKey key: Key) throws -> Double {
        // Try to decode as Double first
        if let doubleValue = try? decode(Double.self, forKey: key) {
            if doubleValue.isFinite && !doubleValue.isNaN {
                return doubleValue
            }
        }
        
        // Try to decode as Int
        if let intValue = try? decode(Int.self, forKey: key) {
            return Double(intValue)
        }
        
        // Try to decode as String and convert to Double
        if let stringValue = try? decode(String.self, forKey: key) {
            if let doubleFromString = Double(stringValue) {
                if doubleFromString.isFinite && !doubleFromString.isNaN {
                    return doubleFromString
                }
            }
        }
        
        // If all else fails, return 0.0
        return 0.0
    }
    
    func decodeSafeDoubleIfPresent(forKey key: Key) throws -> Double? {
        guard contains(key) else { return nil }
        return try decodeSafeDouble(forKey: key)
    }
}

// MARK: - SearchResponse
struct SearchResponseModel: Codable {
    let status: Bool
    let statusCode: Int
    var data: SearchDataModel?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

// MARK: - SearchData
struct SearchDataModel: Codable {
    let searchId: String
    let trackId: String
    let count: Int
    let result: [SearchResultModel]
    let filters: SearchFiltersResponse?

    enum CodingKeys: String, CodingKey {
        case searchId = "search_id"
        case trackId = "track_id"
        case count, result, filters
    }
}

// MARK: - SearchResult
struct SearchResultModel: Codable {
    let activityCode: String
    let title: String
    let shortDescription: String
    let thumbnail: String
    let price: PriceDetails
    let rating: Double
    let reviewCount: Int
    let duration: DurationModel
    let destinationId: String
    let destinationName: String
    let specialOfferAvailable: Bool
    let confirmationType: String
    let itineraryType: String
    let featureFlags: [String]
    let categories: [Int]

    enum CodingKeys: String, CodingKey {
        case activityCode = "activity_code"
        case title
        case shortDescription = "short_description"
        case thumbnail
        case price, rating
        case reviewCount = "review_count"
        case duration
        case destinationId = "destination_id"
        case destinationName = "destination_name"
        case specialOfferAvailable = "special_offer_available"
        case confirmationType = "confirmation_type"
        case itineraryType = "itinerary_type"
        case featureFlags = "feature_flags"
        case categories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        activityCode = try container.decode(String.self, forKey: .activityCode)
        title = try container.decode(String.self, forKey: .title)
        shortDescription = try container.decode(String.self, forKey: .shortDescription)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        price = try container.decode(PriceDetails.self, forKey: .price)
        
        // Use safe double decoding for rating
        rating = try container.decodeSafeDouble(forKey: .rating)
        
        reviewCount = try container.decode(Int.self, forKey: .reviewCount)
        duration = try container.decode(DurationModel.self, forKey: .duration)
        destinationId = try container.decode(String.self, forKey: .destinationId)
        destinationName = try container.decode(String.self, forKey: .destinationName)
        specialOfferAvailable = try container.decode(Bool.self, forKey: .specialOfferAvailable)
        confirmationType = try container.decode(String.self, forKey: .confirmationType)
        itineraryType = try container.decode(String.self, forKey: .itineraryType)
        featureFlags = try container.decode([String].self, forKey: .featureFlags)
        categories = try container.decode([Int].self, forKey: .categories)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(activityCode, forKey: .activityCode)
        try container.encode(title, forKey: .title)
        try container.encode(shortDescription, forKey: .shortDescription)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(price, forKey: .price)
        try container.encode(rating, forKey: .rating)
        try container.encode(reviewCount, forKey: .reviewCount)
        try container.encode(duration, forKey: .duration)
        try container.encode(destinationId, forKey: .destinationId)
        try container.encode(destinationName, forKey: .destinationName)
        try container.encode(specialOfferAvailable, forKey: .specialOfferAvailable)
        try container.encode(confirmationType, forKey: .confirmationType)
        try container.encode(itineraryType, forKey: .itineraryType)
        try container.encode(featureFlags, forKey: .featureFlags)
        try container.encode(categories, forKey: .categories)
    }
}

// MARK: - PriceDetails
struct PriceDetails: Codable {
    let pricingModel: String
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let strikeout: Strikeout?
    let currency: String
    let roeBase: Double

    enum CodingKeys: String, CodingKey {
        case pricingModel = "pricing_model"
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case strikeout, currency
        case roeBase = "roe_base"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pricingModel = try container.decode(String.self, forKey: .pricingModel)
        
        // Use safe double decoding for all numeric fields
        baseRate = try container.decodeSafeDouble(forKey: .baseRate)
        taxes = try container.decodeSafeDouble(forKey: .taxes)
        totalAmount = try container.decodeSafeDouble(forKey: .totalAmount)
        roeBase = try container.decodeSafeDouble(forKey: .roeBase)
        
        strikeout = try container.decodeIfPresent(Strikeout.self, forKey: .strikeout)
        currency = try container.decode(String.self, forKey: .currency)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pricingModel, forKey: .pricingModel)
        try container.encode(baseRate, forKey: .baseRate)
        try container.encode(taxes, forKey: .taxes)
        try container.encode(totalAmount, forKey: .totalAmount)
        try container.encodeIfPresent(strikeout, forKey: .strikeout)
        try container.encode(currency, forKey: .currency)
        try container.encode(roeBase, forKey: .roeBase)
    }
}

// MARK: - Strikeout
struct Strikeout: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let savingPercentage: Double

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case savingPercentage = "saving_percentage"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Use safe double decoding for all numeric fields
        baseRate = try container.decodeSafeDouble(forKey: .baseRate)
        taxes = try container.decodeSafeDouble(forKey: .taxes)
        totalAmount = try container.decodeSafeDouble(forKey: .totalAmount)
        savingPercentage = try container.decodeSafeDouble(forKey: .savingPercentage)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseRate, forKey: .baseRate)
        try container.encode(taxes, forKey: .taxes)
        try container.encode(totalAmount, forKey: .totalAmount)
        try container.encode(savingPercentage, forKey: .savingPercentage)
    }
}

// MARK: - Duration
struct DurationModel: Codable {
    let from: Int
    let to: Int
    let name: String?
    let display: String?
    
    enum CodingKeys: String, CodingKey {
        case from, to, name, display
    }
}

// MARK: - SearchFiltersResponse
struct SearchFiltersResponse: Codable {
    let priceRange: PriceRange?
    let ratings: [RatingFilter]?
    let duration: [DurationFilter]?
    let reviewCount: [ReviewCountFilter]?
    let categories: [CategoryFilter]?
    let language: [String]?
    let itineraryType: [String]?
    let ticketType: [String]?
    let confirmationType: [ConfirmationTypeFilter]?
    let featureFlags: [FeatureFlagFilter]?
    let productCode: [ProductCodeFilter]?

    enum CodingKeys: String, CodingKey {
        case priceRange = "price_range"
        case ratings, duration
        case reviewCount = "review_count"
        case categories, language
        case itineraryType = "itinerary_type"
        case ticketType = "ticket_type"
        case confirmationType = "confirmation_type"
        case featureFlags = "feature_flags"
        case productCode = "product_code"
    }
}

// MARK: - Filter Models
struct PriceRange: Codable {
    let min: Double
    let max: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Use safe double decoding for min and max
        min = try container.decodeSafeDouble(forKey: .min)
        max = try container.decodeSafeDouble(forKey: .max)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(min, forKey: .min)
        try container.encode(max, forKey: .max)
    }
    
    enum CodingKeys: String, CodingKey {
        case min, max
    }
}

struct RatingFilter: Codable {
    let rating: Double
    let count: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Use safe double decoding for rating
        rating = try container.decodeSafeDouble(forKey: .rating)
        count = try container.decode(Int.self, forKey: .count)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rating, forKey: .rating)
        try container.encode(count, forKey: .count)
    }
    
    enum CodingKeys: String, CodingKey {
        case rating, count
    }
}

struct DurationFilter: Codable {
    let name: String
    let from: Int
    let to: Int
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case name, from, to, count
    }
}

struct ReviewCountFilter: Codable {
    let reviewCount: Int
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case reviewCount = "review_count"
        case count
    }
}

struct CategoryFilter: Codable {
    let categoryId: String
    let name: String?  // Make name optional to handle null values
    let child: [CategoryFilter]
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case name, child, count
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        categoryId = try container.decode(String.self, forKey: .categoryId)
        name = try container.decodeIfPresent(String.self, forKey: .name) // Handle null values
        child = try container.decode([CategoryFilter].self, forKey: .child)
        count = try container.decode(Int.self, forKey: .count)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(categoryId, forKey: .categoryId)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(child, forKey: .child)
        try container.encode(count, forKey: .count)
    }
}

struct ConfirmationTypeFilter: Codable {
    let confirmationType: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case confirmationType = "name"
        case count
    }
}

struct FeatureFlagFilter: Codable {
    let featureFlag: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case featureFlag = "name"
        case count
    }
}

struct ProductCodeFilter: Codable {
    let productCode: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case productCode = "name"
        case count
    }
}
