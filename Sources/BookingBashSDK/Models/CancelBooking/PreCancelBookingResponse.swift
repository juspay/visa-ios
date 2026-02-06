//
//  PreCancelBookingResponse.swift
//  VisaActivity
//

import Foundation

// MARK: - PreCancelBookingResponset
struct PreCancelBookingResponse: Codable {
    let status: Bool?
    let statusCode: Int?
    let data: CancelBookingDetails?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data, message
    }
}

// MARK: - CancelBookingDetails
struct CancelBookingDetails: Codable {
    let refundAmount: Double?
    let cancellationFee: Double?
    let totalAmount: Double?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case refundAmount = "refund_amount"
        case cancellationFee = "cancellation_fee"
        case totalAmount = "total_amount"
        case currency
    }
}

// MARK: - PreCancelBookingRequst
struct PreCancelBookingRequst: Codable {
    let orderNo: String
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case orderNo = "order_no"
        case currency
    }
}
