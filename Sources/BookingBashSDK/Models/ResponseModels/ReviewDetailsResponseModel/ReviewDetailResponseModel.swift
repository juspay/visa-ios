import Foundation

// MARK: - ReviewTourDetailResponse
struct ReviewTourDetailResponse: Codable {
    let status: Bool?
    let statusCode: Int?
    var data: ReviewTourDetailData?
    let error: ReviewAPIError?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data = "data"
        case error
    }
}

struct ReviewAPIError: Codable {
    let type: String
    let code: String
    let statusCode: Int
    let details: String

    enum CodingKeys: String, CodingKey {
        case type, code
        case statusCode = "status_code"
        case details
    }
}

struct ReviewTourDetailData: Codable {
    let trackId: String?
    let reviewUid: String?
    let info: ReviewTourInfo?
    let tourOption: ReviewTourOption?
    let price: ReviewPriceSummary?
    let questions: [String]?
    let bookingQuestions: BookingQuestion?
    let travelerPickup: ReviewTravelerPickup?

    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case reviewUid = "review_uid"
        case info
        case tourOption = "tour_option"
        case price
        case questions
        case bookingQuestions = "booking_questions"
        case travelerPickup = "traveler_pickup"
    }
}

struct PGPrice: Codable {
    let totalAmount: Double?
    let currency: String?
    let currencyName: String?
    
    enum CodingKeys: String, CodingKey {
        case totalAmount = "total_amount"
        case currency
        case currencyName = "currency_name"
    }
}

// Enum to handle both ReviewBookingQuestion object and String in booking_questions
//enum ReviewBookingQuestionOrString: Codable {
//    case question(ReviewBookingQuestion)
//    case string(String)
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let question = try? container.decode(ReviewBookingQuestion.self) {
//            self = .question(question)
//        } else if let string = try? container.decode(String.self) {
//            self = .string(string)
//        } else {
//            throw DecodingError.typeMismatch(
//                ReviewBookingQuestionOrString.self,
//                DecodingError.Context(
//                    codingPath: decoder.codingPath,
//                    debugDescription: "Expected ReviewBookingQuestion or String"
//                )
//            )
//        }
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .question(let question):
//            try container.encode(question)
//        case .string(let string):
//            try container.encode(string)
//        }
//    }
//}

// MARK: - ReviewTourInfo
struct ReviewTourInfo: Codable {
    let title: String?
    let activityCode: String?
    let available: Bool?
    let additionalInfo: [ReviewAdditionalInfo]?
    let inclusions: [ReviewInclusion]?
    let exclusions: [ReviewExclusion]?
    let thumbnail: String?
    let description: String?
    let duration: ReviewDuration?
    let ageBands: [ReviewAgeBand]?
//    let language: String?
//    let defaultLanguage: String?
    let reviews: ReviewReviews?
    let ratings: Double?
    let reviewCount: Double?
    let cancellationPolicy: ReviewCancellationPolicy?
    let itinerary: ReviewItinerary?
    let pickupLocation: [String]?
    let tourGrades: [ReviewTourGrade]?
    let ticketInfo: ReviewTicketInfo?
    let locations: ReviewLocations?
    let region: String?
    let city: String?
    let country: String?
    let confirmationType: String?
    let communicationChannel: AnyCodable?
    let bookingRequirements: ReviewBookingRequirements?
    let supplier: ReviewSupplier?
    let supplierCode: String?
//    let languageName: String?

    enum CodingKeys: String, CodingKey {
        case title
        case activityCode = "activity_code"
        case available
        case additionalInfo = "additional_info"
        case inclusions
        case exclusions
        case thumbnail
        case description
        case duration
        case ageBands = "age_bands"
//        case language
//        case defaultLanguage = "default_language"
        case reviews
        case ratings
        case reviewCount = "review_count"
        case cancellationPolicy = "cancellation_policy"
        case itinerary
        case pickupLocation = "pickup_location"
        case tourGrades = "tour_grades"
        case ticketInfo = "ticket_info"
        case locations
        case region, city, country
        case confirmationType = "confirmation_type"
        case communicationChannel = "communication_channel"
        case bookingRequirements = "booking_requirements"
        case supplier
        case supplierCode = "supplier_code"
//        case languageName = "language_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        activityCode = try container.decodeIfPresent(String.self, forKey: .activityCode)
        available = try container.decodeIfPresent(Bool.self, forKey: .available)
        additionalInfo = try container.decodeIfPresent([ReviewAdditionalInfo].self, forKey: .additionalInfo)
        inclusions = try container.decodeIfPresent([ReviewInclusion].self, forKey: .inclusions)
        exclusions = try container.decodeIfPresent([ReviewExclusion].self, forKey: .exclusions)
        thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        duration = try container.decodeIfPresent(ReviewDuration.self, forKey: .duration)
        ageBands = try container.decodeIfPresent([ReviewAgeBand].self, forKey: .ageBands)
//        language = try container.decodeIfPresent(String.self, forKey: .language)
//        defaultLanguage = try container.decodeIfPresent(String.self, forKey: .defaultLanguage)
        reviews = try container.decodeIfPresent(ReviewReviews.self, forKey: .reviews)
        ratings = try container.decodeIfPresent(Double.self, forKey: .ratings)
        reviewCount = try container.decodeIfPresent(Double.self, forKey: .reviewCount)
        cancellationPolicy = try container.decodeIfPresent(ReviewCancellationPolicy.self, forKey: .cancellationPolicy)
        itinerary = try container.decodeIfPresent(ReviewItinerary.self, forKey: .itinerary)
        pickupLocation = try container.decodeIfPresent([String].self, forKey: .pickupLocation)
        tourGrades = try container.decodeIfPresent([ReviewTourGrade].self, forKey: .tourGrades)
        ticketInfo = try container.decodeIfPresent(ReviewTicketInfo.self, forKey: .ticketInfo)
        locations = try container.decodeIfPresent(ReviewLocations.self, forKey: .locations)
        region = try container.decodeIfPresent(String.self, forKey: .region)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        confirmationType = try container.decodeIfPresent(String.self, forKey: .confirmationType)
        communicationChannel = try container.decodeIfPresent(AnyCodable.self, forKey: .communicationChannel)
        bookingRequirements = try container.decodeIfPresent(ReviewBookingRequirements.self, forKey: .bookingRequirements)
        supplier = try container.decodeIfPresent(ReviewSupplier.self, forKey: .supplier)
        supplierCode = try container.decodeIfPresent(String.self, forKey: .supplierCode)
//        languageName = try container.decodeIfPresent(String.self, forKey: .languageName)
    }
}

// MARK: - AnyCodable helper for Any? type
struct AnyCodable: Codable {
    let value: Any?
    
    init(_ value: Any?) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.value = nil
        } else if let bool = try? container.decode(Bool.self) {
            self.value = bool
        } else if let int = try? container.decode(Int.self) {
            self.value = int
        } else if let double = try? container.decode(Double.self) {
            self.value = double
        } else if let string = try? container.decode(String.self) {
            self.value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            self.value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.value = dictionary.mapValues { $0.value }
        } else {
            self.value = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if value == nil {
            try container.encodeNil()
        } else {
            throw EncodingError.invalidValue(value as Any, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "AnyCodable encoding not fully implemented"))
        }
    }
}

// MARK: - ReviewAdditionalInfo
struct ReviewAdditionalInfo: Codable {
    let type: String?
    let description: String?
}

// MARK: - ReviewInclusion
struct ReviewInclusion: Codable {
    let category: String?
    let categoryDescription: String?
    let type: String?
    let typeDescription: String?
    let description: String?
    let otherDescription: String?

    enum CodingKeys: String, CodingKey {
        case category
        case categoryDescription = "category_description"
        case type
        case typeDescription = "type_description"
        case description
        case otherDescription = "other_description"
    }
}

// MARK: - ReviewExclusion
struct ReviewExclusion: Codable {
    let category: String?
    let categoryDescription: String?
    let type: String?
    let typeDescription: String?
    let description: String?
    let otherDescription: String?

    enum CodingKeys: String, CodingKey {
        case category
        case categoryDescription = "category_description"
        case type
        case typeDescription = "type_description"
        case description
        case otherDescription = "other_description"
    }
}

// MARK: - ReviewDuration
struct ReviewDuration: Codable {
    let from: Int?
    let to: Int?
    let display: String?
}

// MARK: - ReviewAgeBand
struct ReviewAgeBand: Codable {
    let sortOrder: Double?
    let bandId: String?
    let description: String?
    let pluralDescription: String?
    let ageFrom: Double?
    let ageTo: Double?
    let adult: Bool?
    let treatAsAdult: Bool?
    let minTravelersPerBooking: Double?
    let maxTravelersPerBooking: Double?
    let type: String?
    let unitType: String?

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

// MARK: - ReviewCancellationPolicy
struct ReviewCancellationPolicy: Codable {
    let type: String?
    let description: String?
    let cancelIfBadWeather: Bool?
    let cancelIfInsufficientTravelers: Bool?
    let refundEligibility: [ReviewRefundEligibility]?

    enum CodingKeys: String, CodingKey {
        case type, description
        case cancelIfBadWeather = "cancel_if_bad_weather"
        case cancelIfInsufficientTravelers = "cancel_if_insufficient_travelers"
        case refundEligibility = "refund_eligibility"
    }
}

struct ReviewRefundEligibility: Codable {
    let dayRangeMin: Double?
    let dayRangeMax: Double?
    let percentageRefundable: Double?

    enum CodingKeys: String, CodingKey {
        case dayRangeMin = "day_range_min"
        case dayRangeMax = "day_range_max"
        case percentageRefundable = "percentage_refundable"
    }
}

// MARK: - ReviewTourGrade
struct ReviewTourGrade: Codable {
    let sortOrder: Double?
    let currencyCode: String?
    let gradeTitle: String?
    let gradeCode: String?
    let gradeDescription: String?
    let langServices: String?
    let gradeDepartureTime: String?
    let priceFrom: String?

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

// MARK: - ReviewTicketInfo
struct ReviewTicketInfo: Codable {
    let ticketTypes: [String]?
    let ticketTypeDescription: String?
    let ticketsPerBooking: String?
    let ticketsPerBookingDescription: String?

    enum CodingKeys: String, CodingKey {
        case ticketTypes = "ticket_types"
        case ticketTypeDescription = "ticket_type_description"
        case ticketsPerBooking = "tickets_per_booking"
        case ticketsPerBookingDescription = "tickets_per_booking_description"
    }
}

// MARK: - ReviewLocations
struct ReviewLocations: Codable {
    let start: [ReviewLocationDetail]?
    let end: [ReviewLocationDetail]?
    let redemption: ReviewRedemption?
    let travelerPickup: ReviewTravelerPickup?

    enum CodingKeys: String, CodingKey {
        case start, end, redemption
        case travelerPickup = "traveler_pickup"
    }
}

struct ReviewLocationDetail: Codable {
    let location: String?
    let description: String?
}

struct ReviewRedemption: Codable {
    let redemptionType: String?
    let specialInstructions: String?

    enum CodingKeys: String, CodingKey {
        case redemptionType = "redemption_type"
        case specialInstructions = "special_instructions"
    }
}

struct ReviewTravelerPickup: Codable {
    let pickupOptionType: String?
    let allowCustomTravelerPickup: Bool?

    enum CodingKeys: String, CodingKey {
        case pickupOptionType = "pickup_option_type"
        case allowCustomTravelerPickup = "allow_custom_traveler_pickup"
    }
}

// MARK: - ReviewBookingRequirements
struct ReviewBookingRequirements: Codable {
    let minTravelersPerBooking: Double?
    let maxTravelersPerBooking: Double?
    let requiresAdultForBooking: Bool?

    enum CodingKeys: String, CodingKey {
        case minTravelersPerBooking = "min_travelers_per_booking"
        case maxTravelersPerBooking = "max_travelers_per_booking"
        case requiresAdultForBooking = "requires_adult_for_booking"
    }
}

// MARK: - ReviewItinerary
struct ReviewItinerary: Codable {
    let itineraryType: String?
    let skipTheLine: Bool?
    let privateTour: Bool?
//    let durationHours: ReviewDurationHours?
    let itineraryItems: [ReviewItineraryItem]?

    enum CodingKeys: String, CodingKey {
        case itineraryType = "itinerary_type"
        case skipTheLine = "skip_the_line"
        case privateTour = "private_tour"
//        case durationHours = "duration_hours"
        case itineraryItems = "itinerary_items"
    }
}

struct ReviewItineraryItem: Codable {
    let pointOfInterestLocation: ReviewPointOfInterestLocation?
    let duration: ReviewItineraryDuration?
    let passByWithoutStopping: Bool?
    let admissionIncluded: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case pointOfInterestLocation = "point_of_interest_location"
        case duration
        case passByWithoutStopping = "pass_by_without_stopping"
        case admissionIncluded = "admission_included"
        case description
    }
}

struct ReviewItineraryDuration: Codable {
    let fixedDurationInMinutes: Int?
    
    enum CodingKeys: String, CodingKey {
        case fixedDurationInMinutes = "fixed_duration_in_minutes"
    }
}

struct ReviewPointOfInterestLocation: Codable {
    let location: ReviewPOILocation?
    let attractionId: Double?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case location
        case attractionId = "attraction_id"
        case name
    }
}

struct ReviewPOILocation: Codable {
    let ref: String?
}

// MARK: - ReviewSupplier
struct ReviewSupplier: Codable {
    let name: String?
    let reference: String?
}

// MARK: - ReviewReviews
struct ReviewReviews: Codable {
    let reviewCountTotals: [ReviewCountTotal]?
    let totalReviews: Double?
    let combinedAverageRating: Double?

    enum CodingKeys: String, CodingKey {
        case reviewCountTotals = "review_count_totals"
        case totalReviews = "total_reviews"
        case combinedAverageRating = "combined_average_rating"
    }
}

struct ReviewCountTotal: Codable {
    let rating: Double?
    let count: Double?
}

// MARK: - ReviewTourOption
struct ReviewTourOption: Codable {
    let availabilityId: String?
    let supplierCode: String?
    let subActivityName: String?
    let subActivityDescription: String?
    let rates: [ReviewRate]?

    enum CodingKeys: String, CodingKey {
        case availabilityId = "availability_id"
        case supplierCode = "supplier_code"
        case subActivityName = "sub_activity_name"
        case subActivityDescription = "sub_activity_description"
        case rates
    }
}

// MARK: - ReviewRate
struct ReviewRate: Codable {
    let available: Bool?
    let time: String?
    let commission: Double?
    let subActivityCode: String?
    let price: ReviewRatePrice?
    let guestDetailRequired: String?
    let ismarkup : Bool?

    enum CodingKeys: String, CodingKey {
        case available, time
        case commission
        case subActivityCode = "sub_activity_code"
        case price
        case guestDetailRequired = "guest_detail_required"
        case ismarkup
    }
}

// MARK: - ReviewRatePrice
struct ReviewRatePrice: Codable {
    let pricingModel: String?
    let baseRate: Double?
    let taxes: Double?
    let totalAmount: Double?
    let currency: String?
    let priceType: String?
    let strikeout: ReviewStrikeout?
    let pricePerAge: [ReviewPricePerAge]?

    enum CodingKeys: String, CodingKey {
        case pricingModel = "pricing_model"
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case currency
        case priceType = "price_type"
        case strikeout
        case pricePerAge = "price_per_age"
    }
}

struct ReviewPricePerAge: Codable {
    let bandId: String?
    let perPriceTraveller: Double?
    let count: Double?
    let bandTotal: Double?

    enum CodingKeys: String, CodingKey {
        case bandId = "band_id"
        case perPriceTraveller = "per_price_traveller"
        case count
        case bandTotal = "band_total"
    }
}

struct ReviewStrikeout: Codable {
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

// MARK: - ReviewPriceSummary
struct ReviewPriceSummary: Codable {
    let baseRate: Double?
    let taxes: Double?
    let totalAmount: Double?
    let currency: String?
    let roeBase: Double?
    let pricePerAge: [ReviewPricePerAgeSummary]?
    let pricingModel: String?
    let priceType: String?
    let strikeout: ReviewStrikeout?
    let pgPrice: PGPrice?

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case currency
        case roeBase = "roe_base"
        case pricePerAge = "price_per_age"
        case pricingModel = "pricing_model"
        case priceType = "price_type"
        case strikeout
        case pgPrice = "pg_price"
    }
}

struct ReviewPricePerAgeSummary: Codable {
    let bandId: String?
    let count: Double?
    let perPriceTraveller: Double?
    let type: String?
    let bandTotal: Double?

    enum CodingKeys: String, CodingKey {
        case bandId = "band_id"       // Matches JSON
        case count = "count"          // Matches JSON
        case perPriceTraveller = "per_price_traveller"
        case type
        case bandTotal = "band_total"
    }
}

//struct ReviewPricePerAgeSummary: Codable {
//    let ageBand: String?
//    let pricePerTraveller: Double?
//    let travellerCount: Double?
//    let totalAmount: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case ageBand = "age_band"
//        case pricePerTraveller = "price_per_traveller"
//        case travellerCount = "traveller_count"
//        case totalAmount = "total_amount"
//    }
//}

// MARK: - ReviewBookingQuestion
struct ReviewBookingQuestion: Codable {
    let id: String?
    let question: String?
    let type: String?
    let required: Bool?
    let options: [String]?
    let placeholder: String?
    
    enum CodingKeys: String, CodingKey {
        case id, question, type, required, options, placeholder
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        question = try container.decodeIfPresent(String.self, forKey: .question)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        options = try container.decodeIfPresent([String].self, forKey: .options)
        placeholder = try container.decodeIfPresent(String.self, forKey: .placeholder)
        
        // Handle required field that can be either Bool or String
        if let requiredBool = try? container.decodeIfPresent(Bool.self, forKey: .required) {
            required = requiredBool
        } else if let requiredString = try? container.decodeIfPresent(String.self, forKey: .required) {
            // Convert string to boolean (common API patterns: "true"/"false", "1"/"0", "yes"/"no")
            required = requiredString.lowercased() == "true" ||
                      requiredString == "1" ||
                      requiredString.lowercased() == "yes"
        } else {
            required = nil
        }
    }
}

// MARK: - ReviewCommunicationChannel
struct ReviewCommunicationChannel: Codable {}

// MARK: - BookingQuestion
struct BookingQuestion: Codable {
    let travellerBookingQuestions: [TravellerBookingQuestionModel]?
    let pickupPointQuestion: PickupPointQuestion?

    enum CodingKeys: String, CodingKey {
        case travellerBookingQuestions = "traveller_booking_questions"
        case pickupPointQuestion = "pickup_point_question"
    }
}


// MARK: - PickupPointQuestion
struct PickupPointQuestion: Codable {
    let arrivalPickupMode, departurePickupMode: [PickupMode]?
    let arrivalModeDetails, departureModeDetails: ModeDetails?

    enum CodingKeys: String, CodingKey {
        case arrivalPickupMode = "arrival_pickup_mode"
        case departurePickupMode = "departure_pickup_mode"
        case arrivalModeDetails = "arrival_mode_details"
        case departureModeDetails = "departure_mode_details"
    }
}

// MARK: - ModeDetails
struct ModeDetails: Codable {
    let hotel, flight, rail, sea: [TravellerBookingQuestionModel]?
}

// MARK: - Item
struct Item: Codable {
    let reference: String?
    let name: String?
    let pickupType: String?
    let price: Double?

    enum CodingKeys: String, CodingKey {
        case reference, name
        case pickupType = "pickup_type"
        case price
    }

    // Custom Decoding Logic to save you from the API's mess
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        reference = try container.decodeIfPresent(String.self, forKey: .reference)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        pickupType = try container.decodeIfPresent(String.self, forKey: .pickupType)
        
        // TRY DECODING PRICE AS DOUBLE OR STRING
        if let doublePrice = try? container.decodeIfPresent(Double.self, forKey: .price) {
            price = doublePrice
        } else if let stringPrice = try? container.decodeIfPresent(String.self, forKey: .price) {
            price = Double(stringPrice)
        } else {
            price = 0.0
        }
    }
}

// MARK: - PickupMode
struct PickupMode: Codable {
    let id, mode: String?
}
