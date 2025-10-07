//
//  ExperienceResponseModel.swift
//  VisaActivity
//
//  Created by Rohit Sankpal on 21/08/25.
//

import Foundation

// MARK: - Root
struct DetailExrienceApiResponse: Codable {
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
    let trackId, uid: String
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
    let additionalInfo: [String]
    let inclusions, exclusions: [String]
    let images: [DetailImageData]
    let thumbnail: String
    let description: String
    let durationHours: DetailDurationHours
    let ageBands: [DetailAgeBand]
    let cancellationPolicy: DetailCancellationPolicy
    let language, defaultLanguage: String
    let tourGrades: [DetailTourGrade]
    let ticketInfo: DetailTicketInfo
    let locations: DetailLocations
    let region, city, country, confirmationType: String
    let bookingRequirements: DetailBookingRequirements
    let tags: [Int]
    let itinerary: DetailItinerary
    let supplier: DetailSupplier
    let reviews: DetailReviews
    let ratings, reviewCount: Int
    let supplierCode, languageName: String

    enum CodingKeys: String, CodingKey {
        case title, available
        case additionalInfo = "additional_info"
        case inclusions, exclusions, images, thumbnail, description
        case durationHours = "duration_hours"
        case ageBands = "age_bands"
        case cancellationPolicy = "cancellation_policy"
        case language
        case defaultLanguage = "default_language"
        case tourGrades = "tour_grades"
        case ticketInfo = "ticket_info"
        case locations, region, city, country
        case confirmationType = "confirmation_type"
        case bookingRequirements = "booking_requirements"
        case tags, itinerary, supplier, reviews, ratings
        case reviewCount = "review_count"
        case supplierCode = "supplier_code"
        case languageName = "language_name"
    }
}

// MARK: - ImageData
struct DetailImageData: Codable {
    let caption: String
    let url: String
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
    let badWeatherCancellation, insufficientTravelersCancellations: Bool
    let cancellationPolicies: [DetailCancellationPolicyItem]

    enum CodingKeys: String, CodingKey {
        case type, description
        case badWeatherCancellation = "bad_weather_cancellation"
        case insufficientTravelersCancellations = "insufficient_travelers_cancellations"
        case cancellationPolicies = "cancellation_policies"
    }
}

struct DetailCancellationPolicyItem: Codable {
    let dayRangeMin: Int
    let dayRangeMax: Int?
    let charges: Int

    enum CodingKeys: String, CodingKey {
        case dayRangeMin = "day_range_min"
        case dayRangeMax = "day_range_max"
        case charges
    }
}

// MARK: - TourGrade
struct DetailTourGrade: Codable {
    let sortOrder: Int
    let currencyCode, gradeTitle, gradeCode, gradeDescription: String?
    let langServices: String?
    let gradeDepartureTime, priceFrom: String

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
    let durationHours: DetailDurationHours
    let itineraryItems: [DetailItineraryItem]

    enum CodingKeys: String, CodingKey {
        case itineraryType = "itinerary_type"
        case skipTheLine = "skip_the_line"
        case privateTour = "private_tour"
        case durationHours = "duration_hours"
        case itineraryItems = "itinerary_items"
    }
}

struct DetailItineraryItem: Codable {
    let pointOfInterestLocation: DetailPointOfInterestLocation
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

struct DetailPointOfInterestLocation: Codable {
    let location: DetailRefLocation
    let attractionID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case location
        case attractionID = "attraction_id"
        case name
    }
}

struct DetailRefLocation: Codable {
    let ref: String
}

// MARK: - Supplier
struct DetailSupplier: Codable {
    let name, reference: String
}

// MARK: - Reviews
struct DetailReviews: Codable {
    let reviewCountTotals: [DetailReviewCountTotal]
    let totalReviews, combinedAverageRating: Int

    enum CodingKeys: String, CodingKey {
        case reviewCountTotals = "review_count_totals"
        case totalReviews = "total_reviews"
        case combinedAverageRating = "combined_average_rating"
    }
}

struct DetailReviewCountTotal: Codable {
    let rating, count: Int
}

// MARK: - Price
struct DetailPrice: Codable {
    let baseRate, taxes, totalAmount: Int
    let currency: String
    let roeBase: Double

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case currency
        case roeBase = "roe_base"
    }
}

//// MARK: - Root
//struct ExrienceApiResponse: Codable {
//    let status: Bool
//    let statusCode: Int
//    var data: ResponseData?
//
//    enum CodingKeys: String, CodingKey {
//        case status
//        case statusCode = "status_code"
//        case data
//    }
//}
//
//// MARK: - ResponseData
//struct ResponseData: Codable {
//    let trackId, uid: String
//    let info: Info
//    let price: Price
//
//    enum CodingKeys: String, CodingKey {
//        case trackId = "track_id"
//        case uid
//        case info
//        case price
//    }
//}
//
//// MARK: - Info
//struct Info: Codable {
//    let title: String
//    let available: Bool
//    let additionalInfo: [String]
//    let inclusions, exclusions: [String]
//    let images: [ImageData]
//    let thumbnail: String
//    let description: String
//    let durationHours: DurationHours
//    let ageBands: [AgeBand]
//    let cancellationPolicy: CancellationPolicy
//    let language, defaultLanguage: String
//    let tourGrades: [TourGrade]
//    let ticketInfo: TicketInfo
//    let locations: Locations
//    let region, city, country, confirmationType: String
//    let bookingRequirements: BookingRequirements
//    let tags: [Int]
//    let itinerary: Itinerary
//    let supplier: Supplier
//    let reviews: Reviews
//    let ratings, reviewCount: Int
//    let supplierCode, languageName: String
//    enum CodingKeys: String, CodingKey {
//        case title, available
//        case additionalInfo = "additional_info"
//        case inclusions, exclusions, images, thumbnail, description
//        case durationHours = "duration_hours"
//        case ageBands = "age_bands"
//        case cancellationPolicy = "cancellation_policy"
//        case language
//        case defaultLanguage = "default_language"
//        case tourGrades = "tour_grades"
//        case ticketInfo = "ticket_info"
//        case locations, region, city, country
//        case confirmationType = "confirmation_type"
//        case bookingRequirements = "booking_requirements"
//        case tags, itinerary, supplier, reviews, ratings
//        case reviewCount = "review_count"
//        case supplierCode = "supplier_code"
//        case languageName = "language_name"
//    }
//}
//
//// MARK: - ImageData
//struct ImageData: Codable {
//    let caption: String
//    let url: String
//}
//
//// MARK: - DurationHours
//struct DurationHours: Codable {
//    let fromMinutes, toMinutes: Int
//
//    enum CodingKeys: String, CodingKey {
//        case fromMinutes = "from_minutes"
//        case toMinutes = "to_minutes"
//    }
//}
//
//// MARK: - AgeBand
//struct AgeBand: Codable {
//    let sortOrder: Int
//    let bandID, description, pluralDescription: String
//    let ageFrom, ageTo: Int
//    let adult, treatAsAdult: Bool
//    let minTravelersPerBooking, maxTravelersPerBooking: Int
//    let type, unitType: String
//
//    enum CodingKeys: String, CodingKey {
//        case sortOrder = "sort_order"
//        case bandID = "band_id"
//        case description
//        case pluralDescription = "plural_description"
//        case ageFrom = "age_from"
//        case ageTo = "age_to"
//        case adult
//        case treatAsAdult = "treat_as_adult"
//        case minTravelersPerBooking = "min_travelers_per_booking"
//        case maxTravelersPerBooking = "max_travelers_per_booking"
//        case type
//        case unitType = "unit_type"
//    }
//}
//
//// MARK: - CancellationPolicy
//struct CancellationPolicy: Codable {
//    let type, description: String
//    let badWeatherCancellation, insufficientTravelersCancellations: Bool
//    let cancellationPolicies: [CancellationPolicyItem]
//
//    enum CodingKeys: String, CodingKey {
//        case type, description
//        case badWeatherCancellation = "bad_weather_cancellation"
//        case insufficientTravelersCancellations = "insufficient_travelers_cancellations"
//        case cancellationPolicies = "cancellation_policies"
//    }
//}
//
//struct CancellationPolicyItem: Codable {
//    let dayRangeMin: Int
//    let dayRangeMax: Int?
//    let charges: Int
//
//    enum CodingKeys: String, CodingKey {
//        case dayRangeMin = "day_range_min"
//        case dayRangeMax = "day_range_max"
//        case charges
//    }
//}
//
//// MARK: - TourGrade
//struct TourGrade: Codable {
//    let sortOrder: Int
//    let currencyCode, gradeTitle, gradeCode, gradeDescription: String
//    let langServices: String?
//    let gradeDepartureTime, priceFrom: String
//
//    enum CodingKeys: String, CodingKey {
//        case sortOrder = "sort_order"
//        case currencyCode = "currency_code"
//        case gradeTitle = "grade_title"
//        case gradeCode = "grade_code"
//        case gradeDescription = "grade_description"
//        case langServices = "lang_services"
//        case gradeDepartureTime = "grade_departure_time"
//        case priceFrom = "price_from"
//    }
//}
//
//// MARK: - TicketInfo
//struct TicketInfo: Codable {
//    let ticketTypes: [String]
//    let ticketTypeDescription, ticketsPerBooking, ticketsPerBookingDescription: String
//
//    enum CodingKeys: String, CodingKey {
//        case ticketTypes = "ticket_types"
//        case ticketTypeDescription = "ticket_type_description"
//        case ticketsPerBooking = "tickets_per_booking"
//        case ticketsPerBookingDescription = "tickets_per_booking_description"
//    }
//}
//
//// MARK: - Locations
//struct LocationsModel: Codable {
//    let start, end: [LocationData]
//    let redemption: Redemption
//    let travelerPickup: TravelerPickup
//
//    enum CodingKeys: String, CodingKey {
//        case start, end, redemption
//        case travelerPickup = "traveler_pickup"
//    }
//}
//
//struct LocationDataModel: Codable {
//    let location: String
//    let description: String
//}
//
//struct RedemptionModel: Codable {
//    let redemptionType, specialInstructions: String
//
//    enum CodingKeys: String, CodingKey {
//        case redemptionType = "redemption_type"
//        case specialInstructions = "special_instructions"
//    }
//}
//
//struct TravelerPickupModel: Codable {
//    let pickupOptionType: String
//    let allowCustomTravelerPickup: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case pickupOptionType = "pickup_option_type"
//        case allowCustomTravelerPickup = "allow_custom_traveler_pickup"
//    }
//}
//
//// MARK: - BookingRequirements
//struct BookingRequirementsModel: Codable {
//    let minTravelersPerBooking, maxTravelersPerBooking: Int
//    let requiresAdultForBooking: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case minTravelersPerBooking = "min_travelers_per_booking"
//        case maxTravelersPerBooking = "max_travelers_per_booking"
//        case requiresAdultForBooking = "requires_adult_for_booking"
//    }
//}
//
//// MARK: - Itinerary
//struct ItineraryModel: Codable {
//    let itineraryType: String
//    let skipTheLine, privateTour: Bool
//    let durationHours: DurationHours
//    let itineraryItems: [ItineraryItem]
//
//    enum CodingKeys: String, CodingKey {
//        case itineraryType = "itinerary_type"
//        case skipTheLine = "skip_the_line"
//        case privateTour = "private_tour"
//        case durationHours = "duration_hours"
//        case itineraryItems = "itinerary_items"
//    }
//}
//
//struct ItineraryItemModel: Codable {
//    let pointOfInterestLocation: PointOfInterestLocation
//    let passByWithoutStopping: Bool
//    let admissionIncluded: String
//    let description: String
//
//    enum CodingKeys: String, CodingKey {
//        case pointOfInterestLocation = "point_of_interest_location"
//        case passByWithoutStopping = "pass_by_without_stopping"
//        case admissionIncluded = "admission_included"
//        case description
//    }
//}
//
//struct PointOfInterestLocationModel: Codable {
//    let location: RefLocation
//    let attractionID: Int
//    let name: String
//
//    enum CodingKeys: String, CodingKey {
//        case location
//        case attractionID = "attraction_id"
//        case name
//    }
//}
//
//struct RefLocationModel: Codable {
//    let ref: String
//}
//
//// MARK: - Supplier
//struct SupplierModel: Codable {
//    let name, reference: String
//}
//
//// MARK: - Reviews
//struct ReviewsResponseModel: Codable {
//    let reviewCountTotals: [ReviewCountTotalModel]
//    let totalReviews, combinedAverageRating: Int
//
//    enum CodingKeys: String, CodingKey {
//        case reviewCountTotals = "review_count_totals"
//        case totalReviews = "total_reviews"
//        case combinedAverageRating = "combined_average_rating"
//    }
//}
//
//struct ReviewCountTotalModel: Codable {
//    let rating, count: Int
//}
//
//// MARK: - Price
//struct Price: Codable {
//    let baseRate, taxes, totalAmount: Int
//    let currency: String
//    let roeBase: Double
//
//    enum CodingKeys: String, CodingKey {
//        case baseRate = "base_rate"
//        case taxes
//        case totalAmount = "total_amount"
//        case currency
//        case roeBase = "roe_base"
//    }
//}
