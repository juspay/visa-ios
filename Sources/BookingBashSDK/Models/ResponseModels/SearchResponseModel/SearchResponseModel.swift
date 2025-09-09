//
//  SearchResponseModel.swift
//  VisaActivity
//
//  Created by Rohit Sankpal on 22/08/25.
//

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

    enum CodingKeys: String, CodingKey {
        case searchId = "search_id"
        case trackId = "track_id"
        case count, result
    }
}

// MARK: - SearchResult
struct SearchResultModel: Codable {
    let productCode: String
    let title: String
    let shortDescription: String
    let price: PriceDetails
    let rating: Double
    let reviewCount: Int
    let durationHours: DurationHoursModel?
    let destinationId: String
    let destinationName: String
    let specialOfferAvailable: Bool
    let confirmationType: String
    let itineraryType: String
    let featureFlags: [String]
    let categories: [Category]?

    enum CodingKeys: String, CodingKey {
        case productCode = "product_code"
        case title
        case shortDescription = "short_description"
        case price, rating
        case reviewCount = "review_count"
        case durationHours = "duration_hours"
        case destinationId = "destination_id"
        case destinationName = "destination_name"
        case specialOfferAvailable = "special_offer_available"
        case confirmationType = "confirmation_type"
        case itineraryType = "itinerary_type"
        case featureFlags = "feature_flags"
        case categories
    }
}

// MARK: - PriceDetails
struct PriceDetails: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let strikeout: Strikeout?
    let currency: String
    let roeBase: Double

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case strikeout, currency
        case roeBase = "roe_base"
    }
}

// MARK: - Strikeout
struct Strikeout: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let savingPercentage: Int

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case savingPercentage = "saving_percentage"
    }
}

// MARK: - DurationHours
struct DurationHoursModel: Codable {
    let from: Int
    let to: Int
}

// MARK: - Category
struct Category: Codable {
    let name: String
    let tagId: Int
    let parentIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case name
        case tagId = "tag_id"
        case parentIds = "parent_ids"
    }
}
