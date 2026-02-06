import Foundation

struct GuestDetails {
    var title: String = ""
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
