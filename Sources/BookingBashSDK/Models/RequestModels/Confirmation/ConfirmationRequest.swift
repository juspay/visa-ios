//
//  ConfirmationRequest.swift
//  VisaActivity
//
//  Created by praveen on 04/09/25.
//

struct ConfirmationRequest: Codable {
    let orderNo: String
    let siteId: String

    enum CodingKeys: String, CodingKey {
        case orderNo = "order_no"
        case siteId = "site_id"
    }
}
