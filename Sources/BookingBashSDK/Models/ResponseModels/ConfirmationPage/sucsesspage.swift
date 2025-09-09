//
//  sucsesspage.swift
//  VisaActivity
//
//  Created by praveen on 04/09/25.
//

import Foundation

// MARK: - Root Response
struct SuccessPageResponse: Codable {
    let status: Bool
    let statusCode: Int
    let data: SuccessPageData

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

// MARK: - SuccessPageData
struct SuccessPageData: Codable {
    let trackId: String
    let msg: String
    let productInfo: SuccessProductInfo
    let travellerInfo: SuccessTravellerInfo
    let bookingResponse: [SuccessBookingResponse]
    let orderNo: String
    let bookingDetails: SuccessBookingDetails
    let myEarning: SuccessEarning

    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case msg
        case productInfo = "product_info"
        case travellerInfo = "traveller_info"
        case bookingResponse = "booking_response"
        case orderNo = "order_no"
        case bookingDetails = "booking_details"
        case myEarning = "my_earning"
    }
}

// MARK: - SuccessProductInfo
struct SuccessProductInfo: Codable {
    let title: String
    let currency: String
    let available: Bool
    let additionalInfo: [String]
    let inclusions: [String]
    let exclusions: [String]
    let images: [SuccessProductImage]
    let thumbnail: String
    let description: String
    let price: SuccessProductPrice
    let merchantNetPrice: Double
    let duration: String
    let supplierDuration: SuccessSupplierDuration
    let agebands: [SuccessAgeBand]
    let cancellationPolicy: SuccessCancellationPolicy
    let cancellationPolicyString: String
    let cancellationTime: [String]
    let activityCode: String
    let questions: [String]
    let bookingQuestions: [String]
    let language: String
    let defaultLanguage: String
    let merchantCancellable: Bool
    let tourGrades: [SuccessTourGrade]
    let ticketInfo: SuccessTicketInfo
    let logistics: SuccessLogistics
    let region: String
    let city: String
    let country: String
    let bookingConfirmationSettings: SuccessBookingConfirmationSettings
    let bookingRequirements: SuccessBookingRequirements
    let tags: [Int]
    let destinations: [String]
    let itinerary: SuccessItinerary
    let translationInfo: SuccessTranslationInfo
    let supplier: SuccessSupplier
    let supplierName: String
    let reviews: SuccessReviews
    let ratings: Int
    let reviewCount: Int
    let supplierCode: String
    let providerSupplierName: String
    let trackId: String
    let priceFormatted: String?
    let roeBase: Double
    let currencySymbol: String
    let languageName: String
    let tourDetail: [SuccessTourDetail]
    let pickupDtl: SuccessPickupDetail
    let languageDtl: SuccessLanguageDetail
    let gstDtl: SuccessGSTDetail

    enum CodingKeys: String, CodingKey {
        case title, currency, available
        case additionalInfo = "additional_info"
        case inclusions, exclusions, images, thumbnail, description, price
        case merchantNetPrice = "merchant_net_price"
        case duration
        case supplierDuration = "supplier_duration"
        case agebands
        case cancellationPolicy = "cancellationPolicy"
        case cancellationPolicyString = "cancellation_policy"
        case cancellationTime = "cancellation_time"
        case activityCode = "activity_code"
        case questions
        case bookingQuestions = "booking_questions"
        case language
        case defaultLanguage = "default_language"
        case merchantCancellable = "merchant_cancellable"
        case tourGrades = "tour_grades"
        case ticketInfo = "ticket_info"
        case logistics, region, city, country
        case bookingConfirmationSettings = "booking_confirmation_settings"
        case bookingRequirements = "booking_requirements"
        case tags, destinations, itinerary
        case translationInfo = "translation_info"
        case supplier
        case supplierName = "supplier_name"
        case reviews, ratings
        case reviewCount = "review_count"
        case supplierCode = "supplier_code"
        case providerSupplierName = "provider_supplier_name"
        case trackId = "track_id"
        case priceFormatted = "price_formatted"
        case roeBase = "roe_base"
        case currencySymbol = "currency_symbol"
        case languageName = "language_name"
        case tourDetail = "tour_detail"
        case pickupDtl = "pickup_dtl"
        case languageDtl = "language_dtl"
        case gstDtl = "gst_dtl"
    }
}

// MARK: - SuccessProductImage
struct SuccessProductImage: Codable {
    let caption: String
    let url: String
}

// MARK: - SuccessProductPrice
struct SuccessProductPrice: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let strikeout: SuccessStrikeout
    let currency: String
    let roeBase: Double

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case strikeout, currency
        case roeBase = "roe_base"
    }
}

// MARK: - SuccessStrikeout
struct SuccessStrikeout: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let savingPercentage: Int

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case savingPercentage = "saving_percentage"
    }
}

// MARK: - SuccessSupplierDuration
struct SuccessSupplierDuration: Codable {
    let variableDurationFromMinutes: Int
    let variableDurationToMinutes: Int
}

// MARK: - SuccessAgeBand
struct SuccessAgeBand: Codable {
    let sortOrder: Int
    let bandId: String
    let description: String
    let pluralDescription: String
    let ageFrom: Int
    let ageTo: Int
    let adult: Bool
    let treatAsAdult: Bool
    let minTravelersPerBooking: Int
    let maxTravelersPerBooking: Int
    let type: String
    let unitType: String

    enum CodingKeys: String, CodingKey {
        case sortOrder = "sort_order"
        case bandId = "band_id"
        case description
        case pluralDescription = "plural_description"
        case ageFrom = "age_from"
        case ageTo = "age_to"
        case adult
        case treatAsAdult = "treat_as_adult"
        case minTravelersPerBooking = "min_travelers_per_booking"
        case maxTravelersPerBooking = "max_travelers_per_booking"
        case type
        case unitType = "unit_type"
    }
}

// MARK: - SuccessCancellationPolicy
struct SuccessCancellationPolicy: Codable {
    let type: String
    let description: String
    let badWeatherCancellation: Bool
    let insufficientTravelersCancellations: Bool
    let cancellationPolicies: [SuccessCancellationRule]

    enum CodingKeys: String, CodingKey {
        case type, description
        case badWeatherCancellation = "bad_weather_cancellation"
        case insufficientTravelersCancellations = "insufficient_travelers_cancellations"
        case cancellationPolicies = "cancellation_policies"
    }
}

// MARK: - SuccessCancellationRule
struct SuccessCancellationRule: Codable {
    let dayRangeMin: Int
    let charges: Int

    enum CodingKeys: String, CodingKey {
        case dayRangeMin = "day_range_min"
        case charges
    }
}

// MARK: - SuccessTourGrade
struct SuccessTourGrade: Codable {
    let sortOrder: Int
    let currencyCode: String
    let gradeTitle: String
    let gradeCode: String
    let gradeDescription: String
    let langServices: String?
    let gradeDepartureTime: String
    let priceFrom: String

    enum CodingKeys: String, CodingKey {
        case sortOrder = "sort_order"
        case currencyCode = "currency_code"
        case gradeTitle = "grade_title"
        case gradeCode = "grade_code"
        case gradeDescription = "grade_description"
        case langServices = "lang_services"
        case gradeDepartureTime = "grade_departure_time"
        case priceFrom = "price_from"
    }
}

// MARK: - SuccessTicketInfo
struct SuccessTicketInfo: Codable {
    let ticketTypes: [String]
    let ticketTypeDescription: String
    let ticketsPerBooking: String
    let ticketsPerBookingDescription: String

    enum CodingKeys: String, CodingKey {
        case ticketTypes = "ticket_types"
        case ticketTypeDescription = "ticket_type_description"
        case ticketsPerBooking = "tickets_per_booking"
        case ticketsPerBookingDescription = "tickets_per_booking_description"
    }
}

// MARK: - SuccessLogistics
struct SuccessLogistics: Codable {
    // Empty object in response
}

// MARK: - SuccessBookingConfirmationSettings
struct SuccessBookingConfirmationSettings: Codable {
    // Empty object in response
}

// MARK: - SuccessBookingRequirements
struct SuccessBookingRequirements: Codable {
    let minTravelersPerBooking: Int
    let maxTravelersPerBooking: Int
    let requiresAdultForBooking: Bool

    enum CodingKeys: String, CodingKey {
        case minTravelersPerBooking = "min_travelers_per_booking"
        case maxTravelersPerBooking = "max_travelers_per_booking"
        case requiresAdultForBooking = "requires_adult_for_booking"
    }
}

// MARK: - SuccessItinerary
struct SuccessItinerary: Codable {
    let itineraryType: String
    let skipTheLine: Bool
    let privateTour: Bool
    let durationHours: SuccessDurationHours
    let itineraryItems: [SuccessItineraryItem]

    enum CodingKeys: String, CodingKey {
        case itineraryType = "itinerary_type"
        case skipTheLine = "skip_the_line"
        case privateTour = "private_tour"
        case durationHours = "duration_hours"
        case itineraryItems = "itinerary_items"
    }
}

// MARK: - SuccessDurationHours
struct SuccessDurationHours: Codable {
    let fromMinutes: Int
    let toMinutes: Int

    enum CodingKeys: String, CodingKey {
        case fromMinutes = "from_minutes"
        case toMinutes = "to_minutes"
    }
}

// MARK: - SuccessItineraryItem
struct SuccessItineraryItem: Codable {
    let pointOfInterestLocation: SuccessPointOfInterestLocation
    let passByWithoutStopping: Bool
    let admissionIncluded: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case pointOfInterestLocation = "point_of_interest_location"
        case passByWithoutStopping = "pass_by_without_stopping"
        case admissionIncluded = "admission_included"
        case description
    }
}

// MARK: - SuccessPointOfInterestLocation
struct SuccessPointOfInterestLocation: Codable {
    let location: SuccessLocationReference
    let attractionId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case location
        case attractionId = "attraction_id"
        case name
    }
}

// MARK: - SuccessLocationReference
struct SuccessLocationReference: Codable {
    let ref: String
}

// MARK: - SuccessTranslationInfo
struct SuccessTranslationInfo: Codable {
    // Empty object in response
}

// MARK: - SuccessSupplier
struct SuccessSupplier: Codable {
    let name: String
    let reference: String
}

// MARK: - SuccessReviews
struct SuccessReviews: Codable {
    let reviewCountTotals: [SuccessReviewCountTotal]
    let totalReviews: Int
    let combinedAverageRating: Int

    enum CodingKeys: String, CodingKey {
        case reviewCountTotals = "review_count_totals"
        case totalReviews = "total_reviews"
        case combinedAverageRating = "combined_average_rating"
    }
}

// MARK: - SuccessReviewCountTotal
struct SuccessReviewCountTotal: Codable {
    let rating: Int
    let count: Int
}

// MARK: - SuccessTourDetail
struct SuccessTourDetail: Codable {
    let available: Bool
    let time: String
    let netRate: Double
    let currency: String
    let commission: Double
    let code: String
    let price: Double
    let partnerNetPrice: Double
    let bookingFee: Double
    let partnerTotalPrice: Double
    let priceBeforeDiscount: Double
    let pricePerAge: [SuccessPricePerAge]
    let supplierPrice: SuccessSupplierPrice
    let label: [SuccessLabel]
    let grandTotal: Double
    let basePrice: Double
    let markup: Double
    let totalMarkup: Double

    enum CodingKeys: String, CodingKey {
        case available, time
        case netRate = "net_rate"
        case currency, commission, code, price
        case partnerNetPrice = "partner_net_price"
        case bookingFee = "booking_fee"
        case partnerTotalPrice = "partner_total_price"
        case priceBeforeDiscount = "price_before_discount"
        case pricePerAge = "price_per_age"
        case supplierPrice = "supplier_price"
        case label
        case grandTotal = "grand_total"
        case basePrice = "base_price"
        case markup
        case totalMarkup = "total_markup"
    }
}

// MARK: - SuccessPricePerAge
struct SuccessPricePerAge: Codable {
    let bandId: String
    let perPriceTraveller: Double
    let count: Int
    let bandTotal: Double

    enum CodingKeys: String, CodingKey {
        case bandId = "band_id"
        case perPriceTraveller = "per_price_traveller"
        case count
        case bandTotal = "band_total"
    }
}

// MARK: - SuccessSupplierPrice
struct SuccessSupplierPrice: Codable {
    let pricePerAge: [SuccessPricePerAge]
    let price: Double
    let netRate: Double
    let partnerNetPrice: Double
    let bookingFee: Double
    let partnerTotalPrice: Double
    let currency: String

    enum CodingKeys: String, CodingKey {
        case pricePerAge = "price_per_age"
        case price
        case netRate = "net_rate"
        case partnerNetPrice = "partner_net_price"
        case bookingFee = "booking_fee"
        case partnerTotalPrice = "partner_total_price"
        case currency
    }
}

// MARK: - SuccessLabel
struct SuccessLabel: Codable {
    let displayable: Bool
    let displayName: String
    let chargesOn: SuccessChargesOn

    enum CodingKeys: String, CodingKey {
        case displayable
        case displayName = "display_name"
        case chargesOn = "charges_on"
    }
}

// MARK: - SuccessChargesOn
struct SuccessChargesOn: Codable {
    let grandTotal: Int

    enum CodingKeys: String, CodingKey {
        case grandTotal = "grand_total"
    }
}

// MARK: - SuccessPickupDetail
struct SuccessPickupDetail: Codable {
    let provider: String
    let reference: String
    let name: String
    let address: String
    let city: String
    let country: String
    let pickupType: String

    enum CodingKeys: String, CodingKey {
        case provider, reference, name, address, city, country
        case pickupType = "pickup_type"
    }
}

// MARK: - SuccessLanguageDetail
struct SuccessLanguageDetail: Codable {
    let type: String
    let language: String
    let legacyGuide: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case type, language
        case legacyGuide = "legacy_guide"
        case name
    }
}

// MARK: - SuccessGSTDetail
struct SuccessGSTDetail: Codable {
    let addr: String
    let orgName: String
    let email: String
    let gstNo: String
    let contactNo: String
    let isdCode: String

    enum CodingKeys: String, CodingKey {
        case addr
        case orgName = "org_name"
        case email
        case gstNo = "gst_no"
        case contactNo = "contact_no"
        case isdCode = "isd_code"
    }
}

// MARK: - SuccessTravellerInfo
struct SuccessTravellerInfo: Codable {
    let travelDate: String
    let title: String
    let firstName: String
    let lastName: String
    let code: String
    let mobile: String
    let email: String
    let totalTraveller: Int
    let totalAdult: Int
    let totalChild: Int
    let totalInfant: Int
    let totalSenior: Int
    let totalYouth: Int
    let totalFare: Double
    let tourCode: String
    let travellerDetail: [SuccessTravellerDetail]
    let specialRequest: String

    enum CodingKeys: String, CodingKey {
        case travelDate = "travel_date"
        case title
        case firstName = "first_name"
        case lastName = "last_name"
        case code, mobile, email
        case totalTraveller = "total_traveller"
        case totalAdult = "total_adult"
        case totalChild = "total_child"
        case totalInfant = "total_infant"
        case totalSenior = "total_senior"
        case totalYouth = "total_youth"
        case totalFare = "total_fare"
        case tourCode = "tour_code"
        case travellerDetail = "traveller_detail"
        case specialRequest = "special_request"
    }
}

// MARK: - SuccessTravellerDetail
struct SuccessTravellerDetail: Codable {
    let firstName: String
    let lastName: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

// MARK: - SuccessBookingResponse
struct SuccessBookingResponse: Codable {
    let code: String
    let message: String
    let timestamp: String
    let trackingId: String

    enum CodingKeys: String, CodingKey {
        case code, message, timestamp
        case trackingId = "tracking_id"
    }
}

// MARK: - SuccessBookingDetails
struct SuccessBookingDetails: Codable {
    let id: String
    let agentEmail: String
    let siteId: String
    let sessionID: String
    let useragent: String
    let ip: String
    let customerId: String
    let orderNo: String
    let enqRefId: String
    let bookingType: String
    let productType: String
    let whitelableId: String
    let baseCurrency: String
    let bookingCurrency: String
    let markup: Double
    let discount: Double
    let discountRuleId: String
    let customerRuleId: String
    let couponCode: String
    let totalBookingAmount: Double
    let baseBookingAmount: Double
    let supplierTotalAmount: String
    let supplierBaseAmount: String
    let supplierTaxesAmount: String
    let supplierCurrency: String
    let roe: Double
    let roeSite: Double
    let bookingStatus: String
    let paymentOrderId: String
    let supplierId: String
    let supplierTransactionId: String
    let supplierCommission: String
    let pgStatus: String
    let productInfo: SuccessBookingProductInfo
    let emailSent: Bool
    let smsSent: Bool
    let remark: String
    let travellerInfo: SuccessBookingTravellerInfo
    let mop: Int
    let pgBypass: Bool
    let bounz: SuccessBounz
    let couponRes: String?
    let totalAgentEarning: Double
    let agentMarkupAmount: Double
    let agentMarkup: String
    let localTaxes: Double
    let quotationId: String
    let quotesRefId: String
    let agentCancelPolicy: String
    let agentTermsCondition: String
    let bookBy: String?
    let loyalityType: String
    let orgHierarchy: SuccessOrgHierarchy
    let orgId: String?
    let orgName: String?
    let orgType: String?
    let businessType: String
    let bookerName: String
    let rootOrgId: String
    let assistBookbyEmail: String?
    let assistBookbyId: String?
    let emailToTrv: Bool
    let projectCode: String?
    let projectName: String?
    let trackId: String
    let createdAt: String
    let updatedAt: String
    let bookingRef: String
    let isPayment: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case agentEmail = "agent_email"
        case siteId = "site_id"
        case sessionID, useragent, ip
        case customerId = "customer_id"
        case orderNo = "order_no"
        case enqRefId = "enq_ref_id"
        case bookingType = "booking_type"
        case productType = "product_type"
        case whitelableId = "whitelable_id"
        case baseCurrency = "base_currency"
        case bookingCurrency = "booking_currency"
        case markup, discount
        case discountRuleId = "discount_rule_id"
        case customerRuleId = "customer_rule_id"
        case couponCode = "coupon_code"
        case totalBookingAmount = "total_booking_amount"
        case baseBookingAmount = "base_booking_amount"
        case supplierTotalAmount = "supplier_total_amount"
        case supplierBaseAmount = "supplier_base_amount"
        case supplierTaxesAmount = "supplier_taxes_amount"
        case supplierCurrency = "supplier_currency"
        case roe
        case roeSite = "roe_site"
        case bookingStatus = "booking_status"
        case paymentOrderId = "payment_order_id"
        case supplierId = "supplier_id"
        case supplierTransactionId = "supplier_transaction_id"
        case supplierCommission = "supplier_commission"
        case pgStatus = "pg_status"
        case productInfo = "product_info"
        case emailSent = "email_sent"
        case smsSent = "sms_sent"
        case remark
        case travellerInfo = "traveller_info"
        case mop
        case pgBypass = "pgBypass"
        case bounz = "BOUNZ"
        case couponRes = "coupon_res"
        case totalAgentEarning = "total_agent_earning"
        case agentMarkupAmount = "agent_markup_amount"
        case agentMarkup = "agent_markup"
        case localTaxes = "local_taxes"
        case quotationId = "quotation_id"
        case quotesRefId = "quotes_ref_id"
        case agentCancelPolicy = "agent_cancel_policy"
        case agentTermsCondition = "agent_terms_condition"
        case bookBy = "book_by"
        case loyalityType = "loyality_type"
        case orgHierarchy = "org_hierarchy"
        case orgId = "org_id"
        case orgName = "org_name"
        case orgType = "org_type"
        case businessType = "business_type"
        case bookerName = "booker_name"
        case rootOrgId = "root_org_id"
        case assistBookbyEmail = "assist_bookby_email"
        case assistBookbyId = "assist_bookby_id"
        case emailToTrv = "email_to_trv"
        case projectCode = "project_code"
        case projectName = "project_name"
        case trackId = "track_id"
        case createdAt, updatedAt
        case bookingRef = "booking_ref"
        case isPayment
    }
}

// MARK: - SuccessBookingProductInfo
struct SuccessBookingProductInfo: Codable {
    let activityCode: String
    let title: String
    let currency: String
    let activityId: String
    let city: String
    let country: String
    let trackId: String
    let price: SuccessProductPrice

    enum CodingKeys: String, CodingKey {
        case activityCode = "activity_code"
        case title, currency
        case activityId = "activity_id"
        case city, country
        case trackId = "track_id"
        case price
    }
}

// MARK: - SuccessBookingTravellerInfo
struct SuccessBookingTravellerInfo: Codable {
    let firstname: String
    let lastname: String
    let email: String
    let mobile: String
    let code: String
    let traveldate: String
    let travellers: Int
    let totalAdult: Int
    let totalChild: Int

    enum CodingKeys: String, CodingKey {
        case firstname, lastname, email, mobile, code, traveldate, travellers
        case totalAdult = "total_adult"
        case totalChild = "total_child"
    }
}

// MARK: - SuccessBounz
struct SuccessBounz: Codable {
    let accuralBounz: Double
    let redeemBounz: Double
    let bounzError: String
    let redeemBounzAmount: Double

    enum CodingKeys: String, CodingKey {
        case accuralBounz = "accural_bounz"
        case redeemBounz = "redeem_bounz"
        case bounzError = "bounz_error"
        case redeemBounzAmount = "redeem_bounz_amount"
    }
}

// MARK: - SuccessOrgHierarchy
struct SuccessOrgHierarchy: Codable {
    // Empty object in response
}

// MARK: - SuccessEarning
struct SuccessEarning: Codable {
    let agentMarkup: Double
    let totalFare: Double
    let type: String

    enum CodingKeys: String, CodingKey {
        case agentMarkup = "agent_markup"
        case totalFare = "total_fare"
        case type
    }
}
