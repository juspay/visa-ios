
import Foundation

// MARK: - Root
struct DetailExperienceApiResponse: Codable {
    let status: Bool
    let statusCode: Int
    var data: DetailResponseData?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

// MARK: - ResponseData
struct DetailResponseData: Codable {
    let trackId: String?
    let uid: String?
    let info: DetailInfo
    let price: DetailPrice

    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case uid
        case info
        case price
    }
}

// MARK: - Info
struct DetailInfo: Codable {
    let title: String
    let available: Bool
    let additionalInfo: [DetailAdditionalInfo]
    let inclusions: [DetailInclusion]
    let exclusions: [DetailExclusion]
    let thumbnail: String
    let description: String
    let duration: DetailDuration
    let ageBands: [DetailAgeBand]
    let bookingQuestions: [String]
    let cancellationPolicy: DetailCancellationPolicy
    let language, defaultLanguage: String
    let tourGrades: [DetailTourGrade]
    let ticketInfo: DetailTicketInfo? // Made optional
    let communicationChannel: DetailCommunicationChannel
    let region, city, country, confirmationType: String
    let bookingRequirements: DetailBookingRequirements
    let pickupLocation: [String]
    let itinerary: DetailItinerary?  // Made optional
    let supplierInfo: DetailSupplierInfo
    let reviews: DetailReviews
    let ratings: Double
    let reviewCount: Int
    let languageName: String

    enum CodingKeys: String, CodingKey {
        case title, available
        case additionalInfo = "additional_info"
        case inclusions, exclusions, thumbnail, description, duration
        case ageBands = "age_bands"
        case bookingQuestions = "booking_questions"
        case cancellationPolicy = "cancellation_policy"
        case language
        case defaultLanguage = "default_language"
        case tourGrades = "tour_grades"
        case ticketInfo = "ticket_info"
        case communicationChannel = "communication_channel"
        case region, city, country
        case confirmationType = "confirmation_type"
        case bookingRequirements = "booking_requirements"
        case pickupLocation = "pickup_location"
        case itinerary
        case supplierInfo = "supplier_info"
        case reviews, ratings
        case reviewCount = "review_count"
        case languageName = "language_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        available = try container.decode(Bool.self, forKey: .available)
        additionalInfo = try container.decode([DetailAdditionalInfo].self, forKey: .additionalInfo)
        inclusions = try container.decode([DetailInclusion].self, forKey: .inclusions)
        exclusions = try container.decode([DetailExclusion].self, forKey: .exclusions)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        description = try container.decode(String.self, forKey: .description)
        duration = try container.decode(DetailDuration.self, forKey: .duration)
        ageBands = try container.decode([DetailAgeBand].self, forKey: .ageBands)
        bookingQuestions = (try? container.decode([String].self, forKey: .bookingQuestions)) ?? []
        cancellationPolicy = try container.decode(DetailCancellationPolicy.self, forKey: .cancellationPolicy)
        language = (try? container.decode(String.self, forKey: .language)) ?? ""
        defaultLanguage = (try? container.decode(String.self, forKey: .defaultLanguage)) ?? ""
        tourGrades = (try? container.decode([DetailTourGrade].self, forKey: .tourGrades)) ?? []
        ticketInfo = try? container.decode(DetailTicketInfo.self, forKey: .ticketInfo)
        communicationChannel = (try? container.decode(DetailCommunicationChannel.self, forKey: .communicationChannel)) ?? DetailCommunicationChannel()
        region = (try? container.decode(String.self, forKey: .region)) ?? ""
        city = (try? container.decode(String.self, forKey: .city)) ?? ""
        country = (try? container.decode(String.self, forKey: .country)) ?? ""
        confirmationType = (try? container.decode(String.self, forKey: .confirmationType)) ?? ""
        bookingRequirements = try container.decode(DetailBookingRequirements.self, forKey: .bookingRequirements)
        pickupLocation = (try? container.decode([String].self, forKey: .pickupLocation)) ?? []
        itinerary = try? container.decode(DetailItinerary.self, forKey: .itinerary)
        supplierInfo = try container.decode(DetailSupplierInfo.self, forKey: .supplierInfo)
        reviews = try container.decode(DetailReviews.self, forKey: .reviews)
        reviewCount = try container.decode(Int.self, forKey: .reviewCount)
        languageName = (try? container.decode(String.self, forKey: .languageName)) ?? ""
        
        // Handle ratings as either Int or Double
        if let ratingsInt = try? container.decode(Int.self, forKey: .ratings) {
            ratings = Double(ratingsInt)
        } else if let ratingsDouble = try? container.decode(Double.self, forKey: .ratings) {
            ratings = ratingsDouble
        } else if let ratingsString = try? container.decode(String.self, forKey: .ratings),
                  let ratingsValue = Double(ratingsString) {
            ratings = ratingsValue
        } else {
            ratings = 0.0
        }
    }
}

// MARK: - Additional Info
struct DetailAdditionalInfo: Codable {
    let type: String
    let description: String
}

// MARK: - Inclusion
struct DetailInclusion: Codable {
    let category: String
    let categoryDescription: String
    let type: String
    let typeDescription: String
    let otherDescription: String?
    let description: String?  // Made optional

    enum CodingKeys: String, CodingKey {
        case category
        case categoryDescription = "category_description"
        case type
        case typeDescription = "type_description"
        case otherDescription = "other_description"
        case description
    }
}

// MARK: - Exclusion
struct DetailExclusion: Codable {
    let category: String
    let categoryDescription: String
    let type: String
    let typeDescription: String
    let otherDescription: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case category
        case categoryDescription = "category_description"
        case type
        case typeDescription = "type_description"
        case otherDescription = "other_description"
        case description
    }
}

// MARK: - Duration
struct DetailDuration: Codable {
    let from: Int
    let to: Int
    let display: String
}

// MARK: - Communication Channel
struct DetailCommunicationChannel: Codable {
    // Empty object in the response
}

// MARK: - Price
struct DetailPrice: Codable {
    let pricingModel: String
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let currency: String
    let roeBase: Double
    let priceType: String
    let strikeout: DetailStrikeout

    enum CodingKeys: String, CodingKey {
        case pricingModel = "pricing_model"
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case currency
        case roeBase = "roe_base"
        case priceType = "price_type"
        case strikeout
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pricingModel = try container.decode(String.self, forKey: .pricingModel)
        currency = try container.decode(String.self, forKey: .currency)
        priceType = try container.decode(String.self, forKey: .priceType)
        strikeout = try container.decode(DetailStrikeout.self, forKey: .strikeout)
        
        // Handle baseRate as either Int, Double, or String
        if let baseRateDouble = try? container.decode(Double.self, forKey: .baseRate) {
            baseRate = baseRateDouble
        } else if let baseRateInt = try? container.decode(Int.self, forKey: .baseRate) {
            baseRate = Double(baseRateInt)
        } else if let baseRateString = try? container.decode(String.self, forKey: .baseRate),
                  let baseRateValue = Double(baseRateString) {
            baseRate = baseRateValue
        } else {
            baseRate = 0.0
        }
        
        // Handle taxes as either Int, Double, or String
        if let taxesDouble = try? container.decode(Double.self, forKey: .taxes) {
            taxes = taxesDouble
        } else if let taxesInt = try? container.decode(Int.self, forKey: .taxes) {
            taxes = Double(taxesInt)
        } else if let taxesString = try? container.decode(String.self, forKey: .taxes),
                  let taxesValue = Double(taxesString) {
            taxes = taxesValue
        } else {
            taxes = 0.0
        }
        
        // Handle totalAmount as either Int, Double, or String
        if let totalAmountDouble = try? container.decode(Double.self, forKey: .totalAmount) {
            totalAmount = totalAmountDouble
        } else if let totalAmountInt = try? container.decode(Int.self, forKey: .totalAmount) {
            totalAmount = Double(totalAmountInt)
        } else if let totalAmountString = try? container.decode(String.self, forKey: .totalAmount),
                  let totalAmountValue = Double(totalAmountString) {
            totalAmount = totalAmountValue
        } else {
            totalAmount = 0.0
        }
        
        // Handle roeBase as either Int, Double, or String
        if let roeBaseDouble = try? container.decode(Double.self, forKey: .roeBase) {
            roeBase = roeBaseDouble
        } else if let roeBaseInt = try? container.decode(Int.self, forKey: .roeBase) {
            roeBase = Double(roeBaseInt)
        } else if let roeBaseString = try? container.decode(String.self, forKey: .roeBase),
                  let roeBaseValue = Double(roeBaseString) {
            roeBase = roeBaseValue
        } else {
            roeBase = 0.0
        }
    }
}

// MARK: - Strikeout
struct DetailStrikeout: Codable {
    let baseRate: Double
    let taxes: Double
    let totalAmount: Double
    let savingPercentage: Double
    let savingAmount: Double

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case savingPercentage = "saving_percentage"
        case savingAmount = "saving_amount"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle baseRate as either Int, Double, or String
        if let baseRateDouble = try? container.decode(Double.self, forKey: .baseRate) {
            baseRate = baseRateDouble
        } else if let baseRateInt = try? container.decode(Int.self, forKey: .baseRate) {
            baseRate = Double(baseRateInt)
        } else if let baseRateString = try? container.decode(String.self, forKey: .baseRate),
                  let baseRateValue = Double(baseRateString) {
            baseRate = baseRateValue
        } else {
            baseRate = 0.0
        }
        
        // Handle taxes as either Int, Double, or String
        if let taxesDouble = try? container.decode(Double.self, forKey: .taxes) {
            taxes = taxesDouble
        } else if let taxesInt = try? container.decode(Int.self, forKey: .taxes) {
            taxes = Double(taxesInt)
        } else if let taxesString = try? container.decode(String.self, forKey: .taxes),
                  let taxesValue = Double(taxesString) {
            taxes = taxesValue
        } else {
            taxes = 0.0
        }
        
        // Handle totalAmount as either Int, Double, or String
        if let totalAmountDouble = try? container.decode(Double.self, forKey: .totalAmount) {
            totalAmount = totalAmountDouble
        } else if let totalAmountInt = try? container.decode(Int.self, forKey: .totalAmount) {
            totalAmount = Double(totalAmountInt)
        } else if let totalAmountString = try? container.decode(String.self, forKey: .totalAmount),
                  let totalAmountValue = Double(totalAmountString) {
            totalAmount = totalAmountValue
        } else {
            totalAmount = 0.0
        }
        
        // Handle savingPercentage as either Int, Double, or String
        if let savingPercentageDouble = try? container.decode(Double.self, forKey: .savingPercentage) {
            savingPercentage = savingPercentageDouble
        } else if let savingPercentageInt = try? container.decode(Int.self, forKey: .savingPercentage) {
            savingPercentage = Double(savingPercentageInt)
        } else if let savingPercentageString = try? container.decode(String.self, forKey: .savingPercentage),
                  let savingPercentageValue = Double(savingPercentageString) {
            savingPercentage = savingPercentageValue
        } else {
            savingPercentage = 0.0
        }
        
        // Handle savingAmount as either Int, Double, or String
        if let savingAmountDouble = try? container.decode(Double.self, forKey: .savingAmount) {
            savingAmount = savingAmountDouble
        } else if let savingAmountInt = try? container.decode(Int.self, forKey: .savingAmount) {
            savingAmount = Double(savingAmountInt)
        } else if let savingAmountString = try? container.decode(String.self, forKey: .savingAmount),
                  let savingAmountValue = Double(savingAmountString) {
            savingAmount = savingAmountValue
        } else {
            savingAmount = 0.0
        }
    }
}

// MARK: - DurationHours
struct DetailDurationHours: Codable {
    let fromMinutes, toMinutes: Int

    enum CodingKeys: String, CodingKey {
        case fromMinutes = "from_minutes"
        case toMinutes = "to_minutes"
    }
}

// MARK: - AgeBand
struct DetailAgeBand: Codable {
    let sortOrder: Int
    let bandID, description, pluralDescription: String
    let ageFrom, ageTo: Int
    let adult, treatAsAdult: Bool
    let minTravelersPerBooking, maxTravelersPerBooking: Int
    let type, unitType: String

    enum CodingKeys: String, CodingKey {
        case sortOrder = "sort_order"
        case bandID = "band_id"
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

// MARK: - CancellationPolicy
struct DetailCancellationPolicy: Codable {
    let type, description: String
    let cancelIfBadWeather, cancelIfInsufficientTravelers: Bool
    let refundEligibility: [DetailRefundEligibility]

    enum CodingKeys: String, CodingKey {
        case type, description
        case cancelIfBadWeather = "cancel_if_bad_weather"
        case cancelIfInsufficientTravelers = "cancel_if_insufficient_travelers"
        case refundEligibility = "refund_eligibility"
    }
}

struct DetailRefundEligibility: Codable {
    let dayRangeMin: Int
    let dayRangeMax: Int?
    let percentageRefundable: Int

    enum CodingKeys: String, CodingKey {
        case dayRangeMin = "day_range_min"
        case dayRangeMax = "day_range_max"
        case percentageRefundable = "percentage_refundable"
    }
}

// MARK: - TourGrade
struct DetailTourGrade: Codable {
    let sortOrder: Int
    let title: String
    let gradeCode: String
    let gradeDescription: String
    let langServices: String?
    let gradeDepartureTime: String
    let defaultLanguageCode: [DetailLanguageCode]

    enum CodingKeys: String, CodingKey {
        case sortOrder = "sort_order"
        case title
        case gradeCode = "grade_code"
        case gradeDescription = "grade_description"
        case langServices = "lang_services"
        case gradeDepartureTime = "grade_departure_time"
        case defaultLanguageCode = "default_language_code"
    }
}

// MARK: - Language Code
struct DetailLanguageCode: Codable {
    let type: String
    let language: String
    let legacyGuide: String

    enum CodingKeys: String, CodingKey {
        case type, language
        case legacyGuide = "legacy_guide"
    }
}

// MARK: - TicketInfo
struct DetailTicketInfo: Codable {
    let ticketTypes: [String]
    let ticketTypeDescription, ticketsPerBooking, ticketsPerBookingDescription: String

    enum CodingKeys: String, CodingKey {
        case ticketTypes = "ticket_types"
        case ticketTypeDescription = "ticket_type_description"
        case ticketsPerBooking = "tickets_per_booking"
        case ticketsPerBookingDescription = "tickets_per_booking_description"
    }
}

// MARK: - Locations
struct DetailLocations: Codable {
    let start, end: [DetailLocationData]
    let redemption: DetailRedemption
    let travelerPickup: DetailTravelerPickup

    enum CodingKeys: String, CodingKey {
        case start, end, redemption
        case travelerPickup = "traveler_pickup"
    }
}

struct DetailLocationData: Codable {
    let location: String
    let description: String
}

struct DetailRedemption: Codable {
    let redemptionType, specialInstructions: String

    enum CodingKeys: String, CodingKey {
        case redemptionType = "redemption_type"
        case specialInstructions = "special_instructions"
    }
}

struct DetailTravelerPickup: Codable {
    let pickupOptionType: String
    let allowCustomTravelerPickup: Bool

    enum CodingKeys: String, CodingKey {
        case pickupOptionType = "pickup_option_type"
        case allowCustomTravelerPickup = "allow_custom_traveler_pickup"
    }
}

// MARK: - BookingRequirements
struct DetailBookingRequirements: Codable {
    let minTravelersPerBooking, maxTravelersPerBooking: Int
    let requiresAdultForBooking: Bool

    enum CodingKeys: String, CodingKey {
        case minTravelersPerBooking = "min_travelers_per_booking"
        case maxTravelersPerBooking = "max_travelers_per_booking"
        case requiresAdultForBooking = "requires_adult_for_booking"
    }
}

// MARK: - Itinerary
struct DetailItinerary: Codable {
    let itineraryType: String
    let skipTheLine, privateTour: Bool
    let duration: DetailItineraryDuration?  // Made optional
    let itineraryItems: [DetailItineraryItem]

    enum CodingKeys: String, CodingKey {
        case itineraryType = "itinerary_type"
        case skipTheLine = "skip_the_line"
        case privateTour = "private_tour"
        case duration
        case itineraryItems = "itinerary_items"
    }
}

// MARK: - Itinerary Duration
struct DetailItineraryDuration: Codable {
    let variableDurationFromMinutes: Int?
    let variableDurationToMinutes: Int?
    let fixedDurationInMinutes: Int?

    enum CodingKeys: String, CodingKey {
        case variableDurationFromMinutes = "variable_duration_from_minutes"
        case variableDurationToMinutes = "variable_duration_to_minutes"
        case fixedDurationInMinutes = "fixed_duration_in_minutes"
    }
}

struct DetailItineraryItem: Codable {
    let pointOfInterestLocation: DetailPointOfInterestLocation
    let duration: DetailItemDuration
    let passByWithoutStopping: Bool
    let admissionIncluded: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case pointOfInterestLocation = "point_of_interest_location"
        case duration
        case passByWithoutStopping = "pass_by_without_stopping"
        case admissionIncluded = "admission_included"
        case description
    }
}

// MARK: - Item Duration
struct DetailItemDuration: Codable {
    let fixedDurationInMinutes: Int

    enum CodingKeys: String, CodingKey {
        case fixedDurationInMinutes = "fixed_duration_in_minutes"
    }
}

struct DetailPointOfInterestLocation: Codable {
    let location: DetailRefLocation
    let attractionID: Int?  // Made optional

    enum CodingKeys: String, CodingKey {
        case location
        case attractionID = "attraction_id"
    }
}

struct DetailRefLocation: Codable {
    let ref: String
}

// MARK: - Supplier Info
struct DetailSupplierInfo: Codable {
    let name: String
    let email: String
    let phone: String
    let reference: String
}

// MARK: - Reviews
struct DetailReviews: Codable {
    let reviewCountTotal: [DetailReviewCountTotal]
    let totalReviews: Int
    let combinedAverageRating: Double

    enum CodingKeys: String, CodingKey {
        case reviewCountTotal = "review_count_total"
        case totalReviews = "total_reviews"
        case combinedAverageRating = "combined_average_rating"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        reviewCountTotal = try container.decode([DetailReviewCountTotal].self, forKey: .reviewCountTotal)
        totalReviews = try container.decode(Int.self, forKey: .totalReviews)
        
        // Handle combinedAverageRating as either Int, Double, or String
        if let ratingDouble = try? container.decode(Double.self, forKey: .combinedAverageRating) {
            combinedAverageRating = ratingDouble
        } else if let ratingInt = try? container.decode(Int.self, forKey: .combinedAverageRating) {
            combinedAverageRating = Double(ratingInt)
        } else if let ratingString = try? container.decode(String.self, forKey: .combinedAverageRating),
                  let ratingValue = Double(ratingString) {
            combinedAverageRating = ratingValue
        } else {
            combinedAverageRating = 0.0
        }
    }
}

struct DetailReviewCountTotal: Codable {
    let rating, count: Int
}

