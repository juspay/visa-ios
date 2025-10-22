//
//  SSOLoginResponseModel.swift
//  VisaActivity
//
//  Created by Praveen on 16/10/25.
//

import Foundation

// MARK: - SSO Login Response Model
struct SSOLoginResponseModel: Codable {
    let status: Bool
    let message: String
    let data: SSOLoginData
}

// MARK: - SSO Login Data
struct SSOLoginData: Codable {
    let status: Bool
    let loginType: String
    let accessToken: String
    let refreshToken: String
    let siteDecimalPlace: Int
    let userId: String
    let profileImage: String
    let orgId: String
    let siteUrl: String
    let cmsServices: CmsServices
    let showWallet: Bool
    let corporateDetail: CorporateDetail
    let firstName: String
    let lastName: String
    let email: String
    let type: String
    let orgs: [String]
    let otp: String?
    let loginFlow: String
    let openBooking: Bool
    let loyalty: Loyalty
    let siteId: String
    let countryCode: String
    let mobileNumber: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case status
        case loginType = "login_type"
        case accessToken = "accessToken"
        case refreshToken = "refreshToken"
        case siteDecimalPlace = "site_decimal_place"
        case userId = "user_id"
        case profileImage = "profile_image"
        case orgId = "org_id"
        case siteUrl = "site_url"
        case cmsServices = "cms_services"
        case showWallet = "show_wallet"
        case corporateDetail = "corporate_detail"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case type
        case orgs
        case otp
        case loginFlow = "login_flow"
        case openBooking = "open_booking"
        case loyalty
        case siteId = "site_id"
        case countryCode = "country_code"
        case mobileNumber = "mobile_number"
        case title
    }
}

// MARK: - CMS Services
struct CmsServices: Codable {
    // Add properties if needed based on actual response
}

// MARK: - Corporate Detail
struct CorporateDetail: Codable {
    // Add properties if needed based on actual response
}

// MARK: - Loyalty
struct Loyalty: Codable {
    let status: Bool
    let isGuest: Bool
    let pointsBalance: Int
    let services: [String]
    let preferences: Preferences
    let loyaltyDetails: LoyaltyDetails
    let auth: Auth
    let req: LoyaltyRequest
    
    enum CodingKeys: String, CodingKey {
        case status
        case isGuest = "is_guest"
        case pointsBalance = "points_balance"
        case services
        case preferences
        case loyaltyDetails = "loyalty_details"
        case auth
        case req
    }
}

// MARK: - Preferences
struct Preferences: Codable {
    let language: String
    let country: String
    let currency: String
}

// MARK: - Loyalty Details
struct LoyaltyDetails: Codable {
    let programCode: String
    let segmentCode: String
    let theme: String
    let vendorCode: String
    
    enum CodingKeys: String, CodingKey {
        case programCode = "program_code"
        case segmentCode = "segment_code"
        case theme
        case vendorCode = "vendor_code"
    }
}

// MARK: - Auth
struct Auth: Codable {
    let iat: Int
    let exp: Int
    let callbackUrl: String
    let orderToken: String
    
    enum CodingKeys: String, CodingKey {
        case iat
        case exp
        case callbackUrl = "callback_url"
        case orderToken = "order_token"
    }
}

// MARK: - Loyalty Request
struct LoyaltyRequest: Codable {
    let siteUrl: String
    let memberProfile: MemberProfile
    let loyaltyDetails: LoyaltyDetails
    let auth: Auth
    let services: [String]
    let preferences: Preferences
    let isGuest: Bool
    let clientSsoBody: String?
    
    enum CodingKeys: String, CodingKey {
        case siteUrl = "site_url"
        case memberProfile = "member_profile"
        case loyaltyDetails = "loyalty_details"
        case auth
        case services
        case preferences
        case isGuest = "is_guest"
        case clientSsoBody = "client_sso_body"
    }
}

// MARK: - Member Profile
struct MemberProfile: Codable {
    let memberId: String
    let title: String
    let firstName: String
    let lastName: String
    let email: String
    let isdCode: String
    let pointsBalance: Int
    
    enum CodingKeys: String, CodingKey {
        case memberId = "member_id"
        case title
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case isdCode = "isd_code"
        case pointsBalance = "points_balance"
    }
}
