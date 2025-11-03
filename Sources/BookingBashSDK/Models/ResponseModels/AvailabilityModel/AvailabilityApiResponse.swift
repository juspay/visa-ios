import Foundation

struct AvailabilityApiResponse: Codable {
    let status: Bool
    let statusCode: Int
    let data: AvailabilityData?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

struct AvailabilityData: Codable {
    let trackId: String?  // Made optional to handle failed responses with empty data
    let uid: String?      // Made optional to handle failed responses with empty data
    let count: Int?       // Made optional to handle failed responses with empty data
    let result: [AvailabilityItem]?  // Made optional to handle failed responses with empty data

    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case uid
        case count
        case result
    }
}

struct AvailabilityItem: Codable {
    let availabilityId: String
    let availabilityKey: String
    let subActivityName: String
    let subActivityDescription: String
    let rates: [AvailabilityRate]

    enum CodingKeys: String, CodingKey {
        case availabilityId = "availability_id"
        case availabilityKey = "availability_key"
        case subActivityName = "sub_activity_name"
        case subActivityDescription = "sub_activity_description"
        case rates
    }
}

struct AvailabilityRate: Codable {
    let available: Bool
    let time: String
    let commission: Double
    let subActivityCode: String?
    let price: AvailabilityPrice

    enum CodingKeys: String, CodingKey {
        case available, time, commission
        case subActivityCode = "sub_activity_code"
        case price
    }
}

struct AvailabilityPrice: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let currency: String
    let priceType: String
    let strikeout: StrikeoutPrice?
    let pricePerAge: [PricePerAge]

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case currency
        case priceType = "price_type"
        case strikeout
        case pricePerAge = "price_per_age"
    }
}

struct StrikeoutPrice: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let savingAmount: Double

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case savingAmount = "saving_amount"
    }
}

struct PricePerAge: Codable {
    let bandId: String
    let perPriceTraveller: Double
    let count: Int
    let bandTotal: Double

    enum CodingKeys: String, CodingKey {
        case bandId = "band_id"
        case perPriceTraveller = "per_price_traveller"
        case count
        case bandTotal = "band_total"
    }
}
