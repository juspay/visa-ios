//
//  PriceCheckResponse.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 23/01/26.
//

import Foundation

struct PriceCheckRequest: Codable {
    let siteId: String
    let activityCode: String
    let currency: String
    let checkInDate: String
    let availabilityCacheUID: String
    let availabilityId: String
    let availabilityKey: String
    let detailUID: String
    let rateCode: String
    let activityExternalCode: String
    let travelerDetails: [TravelerDetailsRequest]

    enum CodingKeys: String, CodingKey {
        case siteId = "site_id"
        case activityCode = "activity_code"
        case currency
        case checkInDate = "check_in_date"
        case availabilityCacheUID = "availability_cache_uid"
        case availabilityId = "availability_id"
        case availabilityKey = "availability_key"
        case detailUID = "detail_uid"
        case rateCode = "rate_code"
        case travelerDetails = "traveler_details"
        case activityExternalCode = "activity_external_code"
    }
}

struct TravelerDetailsRequest: Codable {
    let ageBand: String
    let travelerCount: Int

    enum CodingKeys: String, CodingKey {
        case ageBand = "age_band"
        case travelerCount = "traveler_count"
    }
}

// MARK: - PriceCheckResponse
struct PriceCheckResponse: Codable {
    let status: Bool
    let statusCode: Int?
    let data: PriceCheckModel?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

// MARK: - DataClass
struct PriceCheckModel: Codable {
    let priceStatus: String?
    let priceChanged: Bool?
    let currentPrice, oldPrice: PriceData?
    let availabilityStatus, trackID, priceChangeReason, unavailabilityReason: String?

    enum CodingKeys: String, CodingKey {
        case priceStatus = "price_status"
        case priceChanged = "price_changed"
        case currentPrice = "current_price"
        case oldPrice = "old_price"
        case availabilityStatus = "availability_status"
        case trackID = "track_id"
        case priceChangeReason = "price_change_reason"
        case unavailabilityReason = "unavailability_reason"
    }
}

// MARK: - PriceData
struct PriceData: Codable {
    let currency: String?
    let totalAmount, baseRate: Double?
    let taxes, netRate: Int?
    let currencySymbol: String?

    enum CodingKeys: String, CodingKey {
        case currency
        case totalAmount = "total_amount"
        case baseRate = "base_rate"
        case taxes
        case netRate = "net_rate"
        case currencySymbol = "currency_symbol"
    }
}
