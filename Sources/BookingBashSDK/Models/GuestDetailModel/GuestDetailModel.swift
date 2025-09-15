//
//  GuestDetailModel.swift
//  VisaActivity
//
//  Created by apple on 05/09/25.
//

struct GuestDetails {
    var title: String = "Mr"
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var mobileCountryCode: String = ""
    var mobileNumber: String = ""
    var saveTravelerDetails: Bool = false
    var specialRequest: String = ""
}
extension GuestDetails {
    init(from payload: Payload) {
        self.title = "" // default or you can decide based on payload
        self.firstName = payload.firstName
        self.lastName = payload.lastName
        self.email = payload.customerEmail
        self.mobileCountryCode = payload.mobileCountryCode
        self.mobileNumber = payload.mobileNumber
        self.saveTravelerDetails = false
        self.specialRequest = ""
    }
}
