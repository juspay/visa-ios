//
//  AvailabilityRequestModel.swift
//  VisaActivity
//
//  Created by Rohit Sankpal on 21/08/25.
//

struct AvailabilityRequest: Codable {
    let product_id: String
    let currency: String
    let check_in_date: String
    let traveler_details: [TravelerDetail]
}

struct TravelerDetail: Codable {
    let age_band: String
    let traveler_count: Int
}
