import Foundation

// MARK: - SuccessPageResponse
struct BookingDetailsResponse: Codable {
    let status: Bool
    let statusCode: Int?
    let data: SuccessPageData?
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

// MARK: - SuccessPageData
struct SuccessPageData: Codable {
    let trackId: String?
    let msg: String?
    let orderNo: String?
    let bookingDetails: SuccessBookingDetails?
    let travellerInfo: SuccessTravellerInfo?
    let myEarning: SuccessEarning?
    let supportContact: SupportContact?
    
    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case msg
        case orderNo = "order_no"
        case bookingDetails = "booking_details"
        case travellerInfo = "traveller_info"
        case myEarning = "my_earning"
        case supportContact = "support_contact"
    }
}

// MARK: - SuccessBookingDetails
struct SuccessBookingDetails: Codable {
    let orderNo: String?
    let enqRefId: String?
    let bookingType: String?
    let bookingStatus: String?
    let productType: String?
    let whitelableId: String?
    let baseCurrency: String?
    let bookingCurrency: String?
    let totalBookingAmount: Double?
    let baseBookingAmount: Double?
    let supplierTotalAmount: String?
    let supplierBaseAmount: String?
    let supplierTaxesAmount: String?
    let supplierCurrency: String?
    let roe: Double?
    let roeSite: Double?
    let paymentOrderId: String?
    let supplierId: String?
    let supplierTransactionId: String?
    let supplierCommission: String?
    let pgStatus: String?
    let productInfo: SuccessProductInfo?
    let emailSent: Bool?
    let smsSent: Bool?
    let remark: String?
    let travellerInfo: SuccessTravellerInfo?
    let mop: Int?
    let pgBypass: Bool?
    let BOUNZ: BounzInfo?
    let couponRes: String?
    let totalAgentEarning: Double?
    let agentMarkupAmount: Double?
    let agentMarkup: String?
    let localTaxes: Double?
    let quotationId: String?
    let price: SuccessProductPrice?
    let quotesRefId: String?
    let agentCancelPolicy: String?
    let agentTermsCondition: String?
    let bookBy: String?
    let loyalityType: String?
    let orgHierarchy: [String: String]?
    let orgId: String?
    let orgName: String?
    let orgType: String?
    let businessType: String?
    let bookerName: String?
    let rootOrgId: String?
    let assistBookbyEmail: String?
    let assistBookbyId: String?
    let emailToTrv: Bool?
    let projectCode: String?
    let projectName: String?
    let trackId: String?
    let createdAt: String?
    let updatedAt: String?
    let pgTransactionId: String?
    let bookingRef: String?
    let isPayment: Bool?
    
    enum CodingKeys: String, CodingKey {
        case orderNo = "order_no"
        case enqRefId = "enq_ref_id"
        case bookingType = "booking_type"
        case bookingStatus = "booking_status"
        case productType = "product_type"
        case whitelableId = "whitelable_id"
        case baseCurrency = "base_currency"
        case bookingCurrency = "booking_currency"
        case totalBookingAmount = "total_booking_amount"
        case baseBookingAmount = "base_booking_amount"
        case supplierTotalAmount = "supplier_total_amount"
        case supplierBaseAmount = "supplier_base_amount"
        case supplierTaxesAmount = "supplier_taxes_amount"
        case supplierCurrency = "supplier_currency"
        case roe
        case roeSite = "roe_site"
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
        case pgBypass
        case BOUNZ
        case couponRes = "coupon_res"
        case totalAgentEarning = "total_agent_earning"
        case agentMarkupAmount = "agent_markup_amount"
        case agentMarkup = "agent_markup"
        case localTaxes = "local_taxes"
        case quotationId = "quotation_id"
        case price
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
        case pgTransactionId = "pg_transaction_id"
        case bookingRef = "booking_ref"
        case isPayment
    }
}

// MARK: - BounzInfo
struct BounzInfo: Codable {
    let accuralBounz: Double?
    let redeemBounz: Double?
    let bounzError: String?
    let redeemBounzAmount: Double?
    
    enum CodingKeys: String, CodingKey {
        case accuralBounz = "accural_bounz"
        case redeemBounz = "redeem_bounz"
        case bounzError = "bounz_error"
        case redeemBounzAmount = "redeem_bounz_amount"
    }
}

// MARK: - SuccessTravellerInfo
struct SuccessTravellerInfo: Codable {
    let travelDate: String?
    let title: String?
    let firstName: String?
    let lastName: String?
    let code: String?
    let mobile: String?
    let email: String?
    let totalTraveller: Int?
    let totalAdult: Int?
    let totalChild: Int?
    let totalInfant: Int?
    let totalSenior: Int?
    let totalYouth: Int?
    let totalFare: Double?
    let tourCode: String?
    let travellerDetail: [SuccessTravellerDetail]?
    let specialRequest: String?
    let cancelFee: CancelFee?
    
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
        case cancelFee = "cancel_fee"
    }
}

// MARK: - SuccessTravellerDetail
struct SuccessTravellerDetail: Codable {
    let firstName: String?
    let lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

// MARK: - CancelFee
struct CancelFee: Codable {
    let activityCancellationFee, cancellationFee, discountAdjusted, otherFee: Double?
    let refundAmount: Double?
    let cancelFeeRefundAmount: Double?
    let totalAmount: Double?
    let pgCurrency: String?
    let pgRefundAmount: Double?

    enum CodingKeys: String, CodingKey {
        case activityCancellationFee = "activity_cancellation_fee"
        case cancellationFee = "cancellation_fee"
        case discountAdjusted = "discount_adjusted"
        case otherFee = "other_fee"
        case refundAmount
        case cancelFeeRefundAmount = "refund_amount"
        case totalAmount = "total_amount"
        case pgCurrency = "pg_currency"
        case pgRefundAmount = "pg_refund_amount"
    }
}

// MARK: - Inclusion
struct Inclusion: Codable {
    let category: String?
    let categoryDescription: String?
    let type: String?
    let typeDescription: String?
    let otherDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case category
        case categoryDescription = "category_description"
        case type
        case typeDescription = "type_description"
        case otherDescription = "other_description"
    }
}

// MARK: - Exclusion
struct Exclusion: Codable {
    let category: String?
    let categoryDescription: String?
    let type: String?
    let typeDescription: String?
    let otherDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case category
        case categoryDescription = "category_description"
        case type
        case typeDescription = "type_description"
        case otherDescription = "other_description"
    }
}

struct SuccessProductInfo: Codable {
    let activityCode: String?
    let title: String?
    let city: String?
    let country: String?
    let currency: String?
    let duration: String?
    let priceFormatted: String?
    let currencySymbol: String?
    let price: SuccessProductPrice?
    let inclusions: [Inclusion]?
    let exclusions: [Exclusion]?
    let additionalInfo: [AdditionalInfo]?
    let supplierName: String?
//    let supplierInfo: SupplierInfo?
    let providerSupplierName: String?
    let supplier: SupplierInfo?
    let pickupDetails: PickupDetail?
    let languageDetails: LanguageDetail?
    let cancellationPolicyString: String?
    let cancellationPolicy: CancellationPolicy?
    
    enum CodingKeys: String, CodingKey {
        case activityCode = "activity_code"
        case title, city, country, currency, duration
        case priceFormatted = "price_formatted"
        case price
        case currencySymbol = "currency_symbol"
        case additionalInfo = "additional_info"
        case inclusions, exclusions
        case supplierName = "supplier_name"
        case providerSupplierName = "provider_supplier_name"
        case supplier = "supplier_info"
        case pickupDetails = "pickup_details"
        case languageDetails = "language_details"
        case cancellationPolicyString = "cancellation_policy_string"
        case cancellationPolicy = "cancellation_policy"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        activityCode = try container.decodeIfPresent(String.self, forKey: .activityCode)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        currency = try container.decodeIfPresent(String.self, forKey: .currency)
        
        // Handle duration as either String or skip if it's a dictionary
        duration = try? container.decode(String.self, forKey: .duration)
        
        // Handle priceFormatted as either String or number
        if let priceFormattedString = try? container.decode(String.self, forKey: .priceFormatted) {
            priceFormatted = priceFormattedString
        } else if let priceFormattedNumber = try? container.decode(Double.self, forKey: .priceFormatted) {
            priceFormatted = String(priceFormattedNumber)
        } else {
            priceFormatted = nil
        }
        
        currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
        price = try container.decodeIfPresent(SuccessProductPrice.self, forKey: .price)
        inclusions = try container.decodeIfPresent([Inclusion].self, forKey: .inclusions)
        
        if let exclusionsArray = try? container.decode([Exclusion].self, forKey: .exclusions) {
            exclusions = exclusionsArray
        } else if let exclusionsStringArray = try? container.decode([String].self, forKey: .exclusions) {
            exclusions = exclusionsStringArray.map { stringValue in
                return Exclusion(
                    category: nil,
                    categoryDescription: nil,
                    type: nil,
                    typeDescription: nil,
                    otherDescription: stringValue
                )
            }
        } else {
            exclusions = nil
        }
        
        additionalInfo = try container.decodeIfPresent([AdditionalInfo].self, forKey: .additionalInfo)
        supplierName = try container.decodeIfPresent(String.self, forKey: .supplierName)
        providerSupplierName = try container.decodeIfPresent(String.self, forKey: .providerSupplierName)
        supplier = try container.decodeIfPresent(SupplierInfo.self, forKey: .supplier)
        pickupDetails = try container.decodeIfPresent(PickupDetail.self, forKey: .pickupDetails)
        languageDetails = try container.decodeIfPresent(LanguageDetail.self, forKey: .languageDetails)
        cancellationPolicyString = try container.decodeIfPresent(String.self, forKey: .cancellationPolicyString)
        cancellationPolicy = try container.decodeIfPresent(CancellationPolicy.self, forKey: .cancellationPolicy)
    }
}

struct AdditionalInfo: Codable {
    let type: String?
    let description: String?
}

// MARK: - SuccessProductPrice
struct SuccessProductPrice: Codable {
    let baseRate: Double?
    let taxes: Double?
    let totalAmount: Double?
    let pricePerAge: [PricePerAge]
    let strikeout: SuccessStrikeout?
    let currency: String?
    let roeBase: Double?
    let priceType: String?
    let pgPrice: PGPrice?

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case strikeout, currency
        case roeBase = "roe_base"
        case priceType = "price_type"
        case pricePerAge = "price_per_age"
        case pgPrice = "pg_price"
    }
}

// MARK: - SuccessStrikeout
struct SuccessStrikeout: Codable {
    let baseRate: Double?
    let taxes: Double?
    let totalAmount: Double?
    let savingPercentage: Double?
    let savingAmount: Double?
    
    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case savingPercentage = "saving_percentage"
        case savingAmount = "saving_amount"
    }
}

// MARK: - SupplierInfo
struct SupplierInfo: Codable {
    let name: String?
    let email: String?
    let phone: String?
}

// MARK: - PickupDetail
struct PickupDetail: Codable {
    let provider: String?
    let reference: String?
    let name: String?
    let address: String?
    let city: String?
    let country: String?
    let pickupType: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case provider, reference, name, address, city, country, type
        case pickupType = "pickuptype"
    }
}

// MARK: - LanguageDetail
struct LanguageDetail: Codable {
    let name: String?
}

// MARK: - CancellationPolicy
struct CancellationPolicy: Codable {
    let refundable, cancelIfBadWeather: Bool?
    let type, description: String?
    let cancelIfInsufficientTravelers: Bool?

    enum CodingKeys: String, CodingKey {
        case refundable
        case cancelIfBadWeather = "cancel_if_bad_weather"
        case type, description
        case cancelIfInsufficientTravelers = "cancel_if_insufficient_travelers"
    }
}

// MARK: - SuccessEarning
struct SuccessEarning: Codable {
    let agentMarkup: Double?
    let totalFare: Double?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case agentMarkup = "agent_markup"
        case totalFare = "total_fare"
        case type
    }
}

// MARK: - SupportContact
struct SupportContact: Codable {
    let email: String?
    let phone: String?
}
