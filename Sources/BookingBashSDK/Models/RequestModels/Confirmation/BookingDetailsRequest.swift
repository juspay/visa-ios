//
//  BookingDetailsRequest.swift
//  VisaActivity
//
//  Created by system on 15/10/25.
//

struct BookingDetailsRequest: Codable {
    let bookingId: String
    
    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
    }
}
