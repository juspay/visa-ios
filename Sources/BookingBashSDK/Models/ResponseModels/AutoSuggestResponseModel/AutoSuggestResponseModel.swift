import Foundation

struct AutoSuggestDestinationApiResponse: Codable {
    let status: Bool
    let statusCode: Int
    var data: [DestinationModel]

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

struct DestinationModel: Codable {
    let title: String
    let destinationType: Int
    let destinationId: String
    let locationName: String
    let city, state, region: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case title
        case destinationType = "destination_type"
        case destinationId = "destination_id"
        case locationName = "location_name"
        case city, state, region
        case image
    }
}
