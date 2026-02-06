//
//  CancelBookingAPIResponse.swift
//  VisaActivity
//

import Foundation

struct CancelBookingAPIResponse: Codable {
    let status: Bool?
    let data: CancelBookingData?
    let message: String?
    let statusCode: Int?
    let error: CancelBookingErrorResponse?

    enum CodingKeys: String, CodingKey {
        case status, data, message
        case statusCode = "status_code"
        case error
    }
}

// MARK: - CancelBookingData
struct CancelBookingData: Codable {
    let supplierConfirmationNo, cancellationCompletedTime, supplierCode: String?
    let cancellationSuccess: Bool?
    let refundAmount: Int?
    let cancellationInitiatedTime, bookingReferenceNo, supplierName, trackID: String?
    let clientReferenceNo, currency, status: String?

    enum CodingKeys: String, CodingKey {
        case supplierConfirmationNo = "supplier_confirmation_no"
        case cancellationCompletedTime = "cancellation_completed_time"
        case supplierCode = "supplier_code"
        case cancellationSuccess = "cancellation_success"
        case refundAmount = "refund_amount"
        case cancellationInitiatedTime = "cancellation_initiated_time"
        case bookingReferenceNo = "booking_reference_no"
        case supplierName = "supplier_name"
        case trackID = "track_id"
        case clientReferenceNo = "client_reference_no"
        case currency, status
    }
}

// MARK: - CancelBookingErrorResponse
struct CancelBookingErrorResponse: Codable {
    let code, details: String?
    let statusCode: Int?
    let type, stack: String?

    enum CodingKeys: String, CodingKey {
        case code, details
        case statusCode = "status_code"
        case type, stack
    }
}
