import Foundation

struct PaymentApiResponse: Codable {
    let status: Bool
    let statusCode: Int
    let data: PaymentData?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

struct PaymentData: Codable {
    let trackId: String
    let msg: String
    let productInfo: ProductInfo
    let travellerInfo: TravellerInfo
    let bookingResponse: [ConfirmationBookingResponse]
    let orderNo: String
    let bookingDetails: BookingDetails
    let myEarning: MyEarning

    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case msg
        case productInfo = "product_info"
        case travellerInfo = "traveller_info"
        case bookingResponse = "booking_response"
        case orderNo = "order_no"
        case bookingDetails = "booking_details"
        case myEarning = "my_earning"
    }
}

struct ProductInfo: Codable {
    let title: String
    let currency: String
    let available: Bool
    let additionalInfo: [String]
    let inclusions: [String]
    let exclusions: [String]
    let images: [ProductImage]
    let thumbnail: String
    let description: String
    let price: ProductPrice

    enum CodingKeys: String, CodingKey {
        case title, currency, available
        case additionalInfo = "additional_info"
        case inclusions, exclusions, images, thumbnail, description, price
    }
}

struct ProductImage: Codable {
    let caption: String
    let url: String
}

struct ProductPrice: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let currency: String

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case currency
    }
}

struct TravellerInfo: Codable {
    let travelDate: String
    let title: String
    let firstName: String
    let lastName: String
    let code: String
    let mobile: String
    let email: String
    let totalTraveller: Int
    let totalAdult: Int
    let totalChild: Int
    let totalInfant: Int
    let totalSenior: Int
    let totalYouth: Int
    let totalFare: Double
    let tourCode: String

    enum CodingKeys: String, CodingKey {
        case travelDate = "travel_date"
        case title
        case firstName = "first_name"
        case lastName = "last_name"
        case code, mobile, email
        case totalTraveller = "total_traveller"
        case totalAdult = "total_adult"
        case totalChild = "total_child"
        case totalInfant = "total_infant"
        case totalSenior = "total_senior"
        case totalYouth = "total_youth"
        case totalFare = "total_fare"
        case tourCode = "tour_code"
    }
}

struct ConfirmationBookingResponse: Codable {
    let code: String
    let message: String
    let timestamp: String
    let trackingId: String

    enum CodingKeys: String, CodingKey {
        case code, message, timestamp
        case trackingId = "tracking_id"
    }
}

struct BookingDetails: Codable {
    let id: String
    let agentEmail: String
    let siteId: String
    let orderNo: String
    let bookingStatus: String
    let pgStatus: String
    let productInfo: BookingProductInfo
    let travellerInfo: BookingTravellerInfo
    let isPayment: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case agentEmail = "agent_email"
        case siteId = "site_id"
        case orderNo = "order_no"
        case bookingStatus = "booking_status"
        case pgStatus = "pg_status"
        case productInfo = "product_info"
        case travellerInfo = "traveller_info"
        case isPayment
    }
}

struct BookingProductInfo: Codable {
    let activityCode: String
    let title: String
    let currency: String

    enum CodingKeys: String, CodingKey {
        case activityCode = "activity_code"
        case title, currency
    }
}

struct BookingTravellerInfo: Codable {
    let firstname: String
    let lastname: String
    let email: String
    let mobile: String
    let code: String
    let traveldate: String
    let travellers: Int
    let totalAdult: Int
    let totalChild: Int

    enum CodingKeys: String, CodingKey {
        case firstname, lastname, email, mobile, code, traveldate, travellers
        case totalAdult = "total_adult"
        case totalChild = "total_child"
    }
}

struct MyEarning: Codable {
    let agentMarkup: Double
    let totalFare: Double
    let type: String

    enum CodingKeys: String, CodingKey {
        case agentMarkup = "agent_markup"
        case totalFare = "total_fare"
        case type
    }
}
