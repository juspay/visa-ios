//
//  BookingResponse.swift
//  VisaActivity
//
//  Created by praveen on 04/09/25.
//
import Foundation

// MARK: - Response

struct BookingResponse: Codable {
    let status: Bool
    let status_code: Int
    let data: BookingData
}

struct BookingListRequest: Codable {
    let email: String
    let site_id: String
}

struct BookingData: Codable {
    let count: Int
    let bookings: [Booking]

    enum CodingKeys: String, CodingKey {
        case count
        case bookings
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
        bookings = try container.decodeIfPresent([Booking].self, forKey: .bookings) ?? []
    }
}

// MARK: - Booking
struct Booking: Codable, Identifiable {
    var id: String { orderNo }  // for SwiftUI List / Identifiable
    let orderNo: String
    let bookingRef: String
    let status: TransactionStatus
    let productTitle: String
    let productCode: String
    let travelDate: Date
    let currency: String
    let createdDate: Date
    let travellers: TransactionTravellerInfo
    let price: TransactionPriceDetails
    let supplierName: String? // Add supplierName property
    let bookingDate: Date  // alias for createdDate
    
    enum CodingKeys: String, CodingKey {
        case orderNo = "order_no"
        case bookingRef = "booking_ref"
        case status
        case productTitle = "product_title"
        case productCode = "product_code"
        case travelDate = "travel_date"
        case currency
        case createdDate = "created_date"
        case travellers
        case price
        case supplierName = "supplier_name" // Add supplierName coding key
    }
    
    // MARK: - Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        orderNo = try container.decode(String.self, forKey: .orderNo)
        bookingRef = try container.decode(String.self, forKey: .bookingRef)
        productTitle = try container.decode(String.self, forKey: .productTitle)
        productCode = try container.decode(String.self, forKey: .productCode)
        currency = try container.decode(String.self, forKey: .currency)
        let statusString = try container.decode(String.self, forKey: .status)
        status = TransactionStatus(rawValue: statusString.uppercased()) ?? .pending
        let travelDateString = try container.decode(String.self, forKey: .travelDate)
        let createdDateString = try container.decode(String.self, forKey: .createdDate)
        
        // Parse travel date (simple date format like "2025-09-12")
        let travelDateFormatter = DateFormatter()
        travelDateFormatter.dateFormat = "yyyy-MM-dd"
        travelDateFormatter.timeZone = TimeZone.current
        travelDate = travelDateFormatter.date(from: travelDateString) ?? Date()
        
        // Parse created date (ISO 8601 format with time)
        let createdDateFormatter = ISO8601DateFormatter()
        createdDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        createdDate = createdDateFormatter.date(from: createdDateString) ?? Date()
        bookingDate = createdDate
        travellers = try container.decode(TransactionTravellerInfo.self, forKey: .travellers)
        price = try container.decode(TransactionPriceDetails.self, forKey: .price)
        // Decode supplierName if present
        supplierName = try container.decodeIfPresent(String.self, forKey: .supplierName)
    }
    
    // MARK: - Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(orderNo, forKey: .orderNo)
        try container.encode(bookingRef, forKey: .bookingRef)
        try container.encode(status.rawValue, forKey: .status)
        try container.encode(productTitle, forKey: .productTitle)
        try container.encode(productCode, forKey: .productCode)
        try container.encode(currency, forKey: .currency)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        try container.encode(formatter.string(from: travelDate), forKey: .travelDate)
        try container.encode(formatter.string(from: createdDate), forKey: .createdDate)
        
        // Travellers
        try container.encode(travellers, forKey: .travellers)
        
        // Price
        try container.encode(price, forKey: .price)
    }
}

// MARK: - Transaction Traveller Info
struct TransactionTravellerInfo: Codable {
    let adults: Int
    let children: Int
    let total: Int
}

// MARK: - Transaction Price Details
struct TransactionPriceDetails: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let strikeout: TransactionStrikeoutPrice?
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

// MARK: - Transaction Strikeout Price
struct TransactionStrikeoutPrice: Codable {
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
}

// MARK: - Status
enum TransactionStatus: String, Codable {
    case confirmed = "CONFIRMED"
    case pending = "PENDING"
    case cancelled = "CANCELLED"
    case completed = "COMPLETED"
}

// MARK: - Tabs
enum TransactionTab: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case Upcoming
    case Completed
    case Cancelled
}

// MARK: - Helpers
extension Booking {
    var travellerText: String {
        var parts: [String] = []
        if travellers.adults > 0 { parts.append("\(travellers.adults) Adult\(travellers.adults > 1 ? "s" : "")") }
        if travellers.children > 0 { parts.append("\(travellers.children) Child\(travellers.children > 1 ? "ren" : "")") }
        return parts.joined(separator: ", ")
    }
    
    var timeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: createdDate)
    }
    
    // Convenience properties for accessing traveller data
    var adults: Int { travellers.adults }
    var children: Int { travellers.children }
    var totalTravellers: Int { travellers.total }
    
    // Savings calculation from price data
    var savings: Decimal? {
        guard let strikeout = price.strikeout else { return nil }
        return Decimal(strikeout.savingPercentage)
    }
}
