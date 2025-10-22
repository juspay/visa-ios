//
//  AutoSuggestResponseModel.swift
//  VisaActivity
//
//  Created by Rohit Sankpal on 22/08/25.
//

import Foundation

// MARK: - Root Response
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

// MARK: - Destination
struct DestinationModel: Codable {
    let title: String
    let destinationType: Int
    let destinationId: String
    let locationName: String
    let city, state, region: String
//    let latLong: LatLong
    let image: String

    enum CodingKeys: String, CodingKey {
        case title
        case destinationType = "destination_type"
        case destinationId = "destination_id"
        case locationName = "location_name"
        case city, state, region
//        case latLong = "lat_long"
        case image
    }
}

// MARK: - LatLong
//struct LatLong: Codable {
//    let lat, lng: Double
//}
