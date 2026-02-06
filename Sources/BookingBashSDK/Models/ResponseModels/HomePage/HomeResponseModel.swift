import Foundation

struct HomeResponseModel: Codable {
    let status: Bool
    let data: DataClass?

    enum CodingKeys: String, CodingKey {
        case status, data
    }
}

struct DataClass: Codable {
    let body: Body?
    let footer: Footer?

    enum CodingKeys: String, CodingKey {
        case body, footer
    }
}

// MARK: - Body
struct Body: Codable {
    let mobile: [MobileElement]?
}

// MARK: - Footer
struct Footer: Codable {
    let menu: [SocialmediaElement]

    enum CodingKeys: String, CodingKey {
        case menu
    }
}

// MARK: - SocialmediaElement
struct SocialmediaElement: Codable {
    let order: Int?
    let text: String?
    let url: String?
    let icon: String?
    let active: String?
}

// MARK: - MobileElement
struct MobileElement: Codable {
    let order: Int?
    let type: String
    let isNew: Int?
    let text, url, bannerData: String?
    let title, description: String?
    let data: [HomeFeatureActivityModel2]?

    enum CodingKeys: String, CodingKey {
        case order, type
        case isNew = "is_new"
        case text, url
        case bannerData = "banner_data"
        case title, description, data
    }
}

struct HomeFeatureActivityModel2: Codable {
    let name, destinationID, mobileBanner: String?
    let title: String?
    let destinationType: Int?
    let activityCode, destinationName: String?
    let thumbnail: String?
    let price: PriceOrString?

    enum CodingKeys: String, CodingKey {
        case name
        case destinationID = "destination_id"
        case mobileBanner = "mobile_banner"
        case title
        case destinationType = "destination_type"
        case activityCode = "activity_code"
        case destinationName = "destination_name"
        case thumbnail
        case price
    }
}

enum PriceOrString: Codable {
    case price(HomePriceModel)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let price = try? container.decode(HomePriceModel.self) {
            self = .price(price)
            return
        }
        
        if let str = try? container.decode(String.self) {
            self = .string(str)
            return
        }
        
        throw DecodingError.typeMismatch(
            PriceOrString.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected HomePriceModel or String for price")
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .price(let price):
            try container.encode(price)
        case .string(let str):
            try container.encode(str)
        }
    }
}

struct HomePriceModel: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let strikeout: HomeStrikeoutModel?
    let currency: String
    let roeBase: Double?
    let pricingModel: String?

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case strikeout
        case currency
        case roeBase = "roe_base"
        case pricingModel = "pricing_model"
    }
}

struct HomeStrikeoutModel: Codable {
    let baseRate: Double?
    let taxes: Double?
    let totalAmount: Double?
    let savingPercentage: Double?
    let savingAmount: Double?
    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case savingPercentage = "saving_percentage"
        case savingAmount = "saving_amount"
    }
}
