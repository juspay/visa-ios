//
//  GuestDetailModel.swift
//  VisaActivity
//
//  Created by apple on 05/09/25.
//

import Foundation

struct GuestDetails {
    var title: String = "Title"
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var mobileCountryCode: String = ""
    var mobileNumber: String = ""
}

extension GuestDetails {
    init(from payload: Payload) {
        self.title = ""
        self.firstName = payload.firstName
        self.lastName = payload.lastName
        self.email = payload.customerEmail
        self.mobileCountryCode = payload.mobileCountryCode
        self.mobileNumber = payload.mobileNumber
    }
}
