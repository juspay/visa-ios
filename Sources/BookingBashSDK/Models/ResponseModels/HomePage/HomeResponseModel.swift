import Foundation

struct HomeResponseModel: Codable {
    let status: Bool
    let statusCode: Int
    let data: HomeDataModel
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

struct HomeDataModel: Codable {
    let popularDestinations: [HomeDestinationModel]
    let featuredActivities: [HomeFeatureActivityModel]
    let pageUrls: HomePageUrlsModel
    let currency: String
    enum CodingKeys: String, CodingKey {
        case popularDestinations = "popular_destinations"
        case featuredActivities = "featured_activities"
        case pageUrls = "page_urls"
        case currency
    }
}

struct HomeDestinationModel: Codable {
    let title: String
    let destinationType: Int
    let destinationId: String
    let locationName: String
    let city: String
    let state: String
    let region: String
    let latLong: HomeLatLongModel?
    let image: String
    enum CodingKeys: String, CodingKey {
        case title
        case destinationType = "destination_type"
        case destinationId = "destination_id"
        case locationName = "location_name"
        case city
        case state
        case region
        case latLong = "lat_long"
        case image
    }
}

struct HomeLatLongModel: Codable {
    let lat: Double
    let lng: Double
}

struct HomeFeatureActivityModel: Codable {
    let activityCode: String?
    let title: String
    let shortDescription: String?
    let thumbnail: String
    let price: HomePriceModel
    let rating: Int
    let reviewCount: Int
    let durationHours: HomeDurationHoursModel
    let destinationId: String
    let destinationName: String
    let specialOfferAvailable: Bool
    let confirmationType: String?
    let itineraryType: String?
    let featureFlags: [String]?
    let categories: [HomeCategoryModel]?
    let productId: String?
    enum CodingKeys: String, CodingKey {
        case activityCode = "activity_code"
        case title
        case shortDescription = "short_description"
        case thumbnail
        case price
        case rating
        case reviewCount = "review_count"
        case durationHours = "duration_hours"
        case destinationId = "destination_id"
        case destinationName = "destination_name"
        case specialOfferAvailable = "special_offer_available"
        case confirmationType = "confirmation_type"
        case itineraryType = "itinerary_type"
        case featureFlags = "feature_flags"
        case categories
        case productId = "product_id"
    }
}

struct HomeCategoryModel: Codable {
    let name: String?
    let tagId: Int?
    let parentIds: [Int]?
    enum CodingKeys: String, CodingKey {
        case name
        case tagId = "tag_id"
        case parentIds = "parent_ids"
    }
}

struct HomePriceModel: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let strikeout: HomeStrikeoutModel?
    let currency: String
    let roeBase: Double
    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case strikeout
        case currency
        case roeBase = "roe_base"
    }
}

struct HomeStrikeoutModel: Codable {
    let baseRate: Double?
    let taxes: Double?
    let totalAmount: Double?
    let savingPercentage: Int?
    let savingAmount: Double?
    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case savingPercentage = "saving_percentage"
        case savingAmount = "saving_amount"
    }
}

struct HomeDurationHoursModel: Codable {
    let from: Int
    let to: Int
}

struct HomePageUrlsModel: Codable {
    let termsAndConditions: String
    let privacyPolicy: String
    enum CodingKeys: String, CodingKey {
        case termsAndConditions = "terms_and_conditions"
        case privacyPolicy = "privacy_policy"
    }
}
