//
//  AvailabilityApiResponse.swift
//  VisaActivity
//
//  Created by Rohit Sankpal on 21/08/25.
//

import Foundation

// MARK: - Root
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

// MARK: - Data
struct AvailabilityData: Codable {
    let trackId: String
    let availabilities: [AvailabilityModel]

    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case availabilities
    }
}

// MARK: - Availability
struct AvailabilityModel: Codable {
    let availabilityId: String
    let supplierCode: String
    let priceSummary: PriceSummary
    let rates: [Rate]

    enum CodingKeys: String, CodingKey {
        case availabilityId = "availability_id"
        case supplierCode = "supplier_code"
        case priceSummary = "price_summary"
        case rates
    }
}

// MARK: - Price Summary
struct PriceSummary: Codable {
    let baseRate, taxes, commissionAmount, totalAmount: Double
    let currency: String

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case commissionAmount = "commission_amount"
        case totalAmount = "total_amount"
        case currency
    }
}

// MARK: - Rate
struct Rate: Codable {
    let description: String
    let time: String
    let rateCode: String
    let available: Bool
    let price: AvailibilityPrice
    let labels: [String]

    enum CodingKeys: String, CodingKey {
        case description, time
        case rateCode = "rate_code"
        case available, price, labels
    }
}

// MARK: - Price
struct AvailibilityPrice: Codable {
    let baseRate, taxes, commissionAmount, totalAmount: Double
    let currency: String
    let pricePerAgeBand: [PricePerAgeBand]
    let supplierPriceDetails: SupplierPriceDetails

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case commissionAmount = "commission_amount"
        case totalAmount = "total_amount"
        case currency
        case pricePerAgeBand = "price_per_age_band"
        case supplierPriceDetails = "supplier_price_details"
    }
}

// MARK: - Price Per Age Band
struct PricePerAgeBand: Codable {
    let ageBand: String
    let travelerCount: Int
    let pricePerTraveler, totalBandPrice: Double

    enum CodingKeys: String, CodingKey {
        case ageBand = "age_band"
        case travelerCount = "traveler_count"
        case pricePerTraveler = "price_per_traveler"
        case totalBandPrice = "total_band_price"
    }
}

// MARK: - Supplier Price Details
struct SupplierPriceDetails: Codable {
    let currency: String
    let totalPrice, netPrice, partnerNetPrice, bookingFee, partnerTotalPrice: Double
    let pricePerAgeBand: [PricePerAgeBand]

    enum CodingKeys: String, CodingKey {
        case currency
        case totalPrice = "total_price"
        case netPrice = "net_price"
        case partnerNetPrice = "partner_net_price"
        case bookingFee = "booking_fee"
        case partnerTotalPrice = "partner_total_price"
        case pricePerAgeBand = "price_per_age_band"
    }
}

