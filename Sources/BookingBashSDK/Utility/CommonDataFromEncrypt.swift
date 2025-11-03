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
//var encryptedPayloadMain: String = "eyJraWQiOiJrZXlfYjYzMzE2OGU3YmU0NDViYmIzOGZkMzJlMTk4YTVhOTYiLCJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAtMjU2In0.goOmHuNKUPy8ejLkRFamvWIsXPKSu1UPFkIs0M5_qJI0U5ngWevPAIejAPuw-Z8mf9HPrpLRKlx9DKkJLRlFbWME1VO_a_2-bOdXhwGDjQzxUV2trkdh9LGyRpXCCMTHzGOcOD7t9Zyf5qPKD9mhbMCXHK17kXfF6Z1oIn5jqbGGsbZyZwzCp33mkdthACbcC5Vm7wdFGuIjFMT8Hh6mi_Rb8HJMhk2KYbwpL_ylIbLVdBHgjxVpT_dlJ3Std6As2UaEMDk4vCJfNHQWX0rkxLmrHxFpKiAiBeTj-6HSXVtaKHYdwru09R9PyzRSOGICCIC22bEoHnhnkmcY6T5jBg.QUv_Z4crL9fafzX7.EuohLRgJoYyNBkRTX_6L4ygHguI0ENrG4kS7nnGvzHRmGhntgFAgUzPkgwAuX1PBqFWvWlKDuk_ZPXIEAiZto2Ig9I-FRMn3EpoZvUp_DE6J4DwcvOgu6_pcT87lof6ha9oPVptYpaST8riCr7WqMnNQrfuV47QY570l-xJcDEwu360qPlUkM3R-jHjyw2oGosJRBh8dZIsFEveUV5H4HJS9VdxlmVP21jYOxhIkseR0qygWD8Qh_SUn2Z0H_aSnz26_RPanClboCJOFT5zH26rmZIEAez7zSd17aW94TsFfOaEV3X9yLb8VWN5P5ipV-NtwtE8JApxMpLlfF1hPOm8GeVD3ijT9qe3DLrfKGbVEV855D5blKPoCNNLgZiThVDm_wMv5211TTasC9NISj3CPSVQ9VlPt16tA5LGHs6L0XWy9FSHZEoF6GdrnTatU5XSIqW0s-DV-Uyy3Aa5ecYb4N2gSwbNBTrIrsf8gECbulM1uvG41ROatEf4Qwc0VpbgbzFdLbfbBJyy4qhVGFupQSHR9CxtfiV7KMpqqvl8moiE35kYy3s_wF5R5ZAwpZZXiXfT6zOV36gEK9XhIRW61uO5MtWwfreOBTalh4QyHxGlRSCplOcXQJPs1lPYJCfsHKWHMbUtzDeNpWwUupfMAnNHXTw-L_x83Zpo7drl2UPGJrZ4KUcErvBbtee76pVYoOPU4VJsF-miQ4jV9LQ4jqLYecfiXOOONNgtfZbro9M1GeQ-gkpc3dpQv0xZLD0oAfT2GAn5b6imm_m8-baUAXZHnpsPX93TaxD0FSWSPZO6Ud-ixxuppXcPDOZcJ47gORlV1pu8dHT4Fg_6fuBqdatEVexE-Po0VzO_pX9ahpDQuweEWbZVueftvkjOc-_IJLP5km4ZQ-jx8etXihP1q4fC_7KKJcXU-tq4uBwKpIWpLvC-5OrXXtk3KIwJxwUkozVZJpbeWYIbjLRQZCfPpu4Hzcqanec86wj78QyATvO5F.ASYnqgMUQsMw0IJVOAoVDg"
