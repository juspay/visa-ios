import Foundation

var encryptedPayloadMain: String = ""
var firstName: String = ""
var lastName: String = ""
var aliasId: String = ""
var customerEmail: String = ""
var customerId: String = ""
var isDeeplink: Bool = false
var isEligible: Bool = false
var location: String = ""
var eligibilityLevel: Int = 0
var cardFirstSix: String = ""
var cardLastFour: String = ""
var offerTxnId: String = ""
var cardIssuerName: String = ""
var mobileCountryCode: String = ""
var mobileNumber: String = ""
var cardIssuerCountry: String = ""

//for get review data

var detaislUid: String = ""
var avalabulityUid: String = ""
var availablityKey : String = ""
var subActivityCode: String = ""

// Global variable to store age bands from details API for passing to availability view
var globalAgeBands: [DetailAgeBand] = []

//Terms and Conditions urls

var termsAndConditionsUrlGlobal: String = ""
var privacyPolicyUrlGlobal: String = ""

//SSO_Token and Session_ID

var ssoTokenGlobal: String = ""
var ssoSiteIdGlobal: String = ""

// Global callback for SDK exit - stored when ExperienceHomeView is first created
var globalOnFinishCallback: () -> Void = {
}
