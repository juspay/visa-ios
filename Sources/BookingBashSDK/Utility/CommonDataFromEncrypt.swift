import Foundation

var encryptedPayload: String = "eyJraWQiOiJrZXlfYjYzMzE2OGU3YmU0NDViYmIzOGZkMzJlMTk4YTVhOTYiLCJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAtMjU2In0.COa6yK1yQ8QfSNM_0iLfFJr5-gFrY4i6adEuUgvIzU_otbWR-kFYm4COUAYw4dCfRovkdtn9V_1HjTqmrqZTSyif-PsINzJNeQO_fWdUEb9kIhyWRdxbUa8EG3VUfrBb9pG-wfJhKn_p8Ts8R4y-Aed95S57VHBu3W1XCfEODE2xe84xwgrH4qBPk30zMU7_uB1KV646pnfx7VgFyYErSAhyb0S5MtUc5IO__Voh58xEgYaqU1-4QWTz5eKx2xNH86f1nW2NaY17YyKumoTWq-A7w8S9CXFg5fhE9U2ktUtt_8AbRB0YTlP2MGLnfcz0cVcSa-5iR86pokPhcvYEug.OV_nZ-nPgx2aaw1s.sXpycaakqmcfkjjYRW1RzT2fs2oxCMElIj0MpcMZahBQFW6ilxF2EAuPTs0Gu2iJi3YMZbOLUGSKA8kvgKnDDIcwRINfCyk3NCaJAghdlBmDRhSMhN8JzRWFBRmZc3f--QkfSbRmJ-pvPQUmz1xIN1Kn39Ie9Hf-_0HGJiX7vN8PFq0LnR3K8LZX0ZFFAJHsJ_Pzl7I9c8HwWDb1B5_g05jUJVAGO3W5mtmYE-bOH7q0Egf_cPR8xkNh7Z5O0kR3ESVeEwmZcATJ5zY1mNn7px62JBeYgDLu_jOFHmemQ63edd_thtGz56GIUzgGGHffKVnBic2qv4K11io7Tz-nf7vDdIiydJYOt5ULn6IzFqLkYXF6_kI-yI8owbWdihwDXqsqRiy3PCNPa12GAlRow_U4cJSAXNtNVm1WgTsZSoa3T717vtBUT42fq8b_BO2q1lK1fGb8cc7162XTtqnoVbkBg8SFLbCGpYZ-9SDuQ7mr0pGl5aLhHMod_vx60BaXEfbpzvpNw-ujMI_Ekswt1qRiv02mAPRwhQLf5grbq8xQ-IpmaSz_9Lk-BE0CJbP3lYhYBNNv9VtxpnEQz7ani54lGR8vxlbfcumIHNIrX4-rbXQDD-AN5G_xONkT1eOiFQo0vOHEfKlQ7jyJQM3nmNv9wUvil4ySmAszw2_U_rne_mmIJ5slACLTG-kn17cfGnC62k3Ay9ssj886tIpHrQwoLxLnVCeMVxdc4boQYICVSHzfGoFClNlGl4b0m6Y7Rv3FnI6NTEka6roDzL5ahDHY9PGpjQ0R1WfsQkVaHbEhwKJwiopPWuNMN3LsQ3LQg1NU1gYgIByhbKoQbA7zAJkwvLxG10TjonWzyufExwxfhyJAd8mXwLjsGN2obWssm80Ak8gH8bbS312X_4W_3_BMYut_fzdg8BYfoNgjbeoD-iJ0Zhh1QTKDj-nMAAdW2lbvaMfjtAsRMtVxXvs4vkQwPDPL_M7FNPUPorB35nZNDPwcBgkTpfTpwXOYMalQKB15KY0ee718fpL3HH4fB9Iu7iE7tonsA0Hs3Gdlxg-w1NERlghwXGDM1P1_oUlAHYTq5oaQfBVeQesSV-oNzXI_wRC-tM-6S2Wuyw-8wkG0Vptiz9QlPlvcAsZ8czd-rtOoPEEeRV46bvUMVYX1OKways5URo2A-BsPkXI31Lus2z--MK674bNoWyvdWUR1N2HuNHDXP2WbbqsH8uMJskON8F14CUd_MQmD0QXlp6pNRjGO8796PUY0gvd6difapzOmirHOZ2nGYd_4wVtdfcVsDD5pTvWbYXH91o1Tdx5DdEU2V0Zl7g.INWbxRwJ6GzcHkturW8u6g"
var firstName: String = "John"
var lastName: String = "Doe"
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
var mobileCountryCode: String = "+91"
var mobileNumber: String = "9876543210"
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
