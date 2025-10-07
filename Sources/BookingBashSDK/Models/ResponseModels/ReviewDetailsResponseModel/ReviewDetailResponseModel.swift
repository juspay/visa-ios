//
//  ReviewDetailResponseModel.swift
//  VisaActivity
//
//  Created by Rohit Sankpal on 21/08/25.
//

import Foundation

// MARK: - Root Response
struct ReviewTourDetailResponse: Codable {
    let status: Bool
    let statusCode: Int
    var data: ReviewTourDetailData?

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status_code"
        case data
    }
}

// MARK: - ReviewTourDetailData
struct ReviewTourDetailData: Codable {
    let trackId: String
    let reviewUid: String
    let info: ReviewTourInfo
    let tourOption: ReviewTourOption
    let priceSummary: ReviewPriceSummary

    enum CodingKeys: String, CodingKey {
        case trackId = "track_id"
        case reviewUid = "review_uid"
        case info, tourOption = "tour_option", priceSummary = "price_summary"
    }
}

// MARK: - ReviewTourInfo
struct ReviewTourInfo: Codable {
    let title: String
    let available: Bool
    let additionalInfo: [String]
    let inclusions: [String]
    let exclusions: [String]
    let images: [ReviewTourImage]
    let thumbnail: String
    let description: String
    let durationHours: ReviewDurationHours
    let ageBands: [ReviewAgeBand]
    let cancellationPolicy: ReviewCancellationPolicy
    let language: String
    let defaultLanguage: String
    let tourGrades: [ReviewTourGrade]
    let ticketInfo: ReviewTicketInfo
    let locations: ReviewLocations
    let region, city, country, confirmationType: String
    let bookingRequirements: ReviewBookingRequirements
    let tags: [Int]
    let itinerary: ReviewItinerary
    let supplier: ReviewSupplier
    let reviews: ReviewReviews
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

// MARK: - ReviewTourImage
struct ReviewTourImage: Codable {
    let caption: String
    let url: String
}

// MARK: - ReviewDurationHours
struct ReviewDurationHours: Codable {
    let fromMinutes: Int
    let toMinutes: Int

    enum CodingKeys: String, CodingKey {
        case fromMinutes = "from_minutes"
        case toMinutes = "to_minutes"
    }
}

// MARK: - ReviewAgeBand
struct ReviewAgeBand: Codable {
    let sortOrder: Int
    let bandId, description, pluralDescription: String
    let ageFrom, ageTo: Int
    let adult, treatAsAdult: Bool
    let minTravelersPerBooking, maxTravelersPerBooking: Int
    let type, unitType: String

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
    let type, description: String
    let badWeatherCancellation, insufficientTravelersCancellations: Bool
    let cancellationPolicies: [ReviewCancellationRule]

    enum CodingKeys: String, CodingKey {
        case type, description
        case badWeatherCancellation = "bad_weather_cancellation"
        case insufficientTravelersCancellations = "insufficient_travelers_cancellations"
        case cancellationPolicies = "cancellation_policies"
    }
}

struct ReviewCancellationRule: Codable {
    let dayRangeMin: Int
    let dayRangeMax: Int?
    let charges: Int

    enum CodingKeys: String, CodingKey {
        case dayRangeMin = "day_range_min"
        case dayRangeMax = "day_range_max"
        case charges
    }
}

// MARK: - ReviewTourGrade
struct ReviewTourGrade: Codable {
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

// MARK: - ReviewTicketInfo
struct ReviewTicketInfo: Codable {
    let ticketTypes: [String]
    let ticketTypeDescription, ticketsPerBooking, ticketsPerBookingDescription: String

    enum CodingKeys: String, CodingKey {
        case ticketTypes = "ticket_types"
        case ticketTypeDescription = "ticket_type_description"
        case ticketsPerBooking = "tickets_per_booking"
        case ticketsPerBookingDescription = "tickets_per_booking_description"
    }
}

// MARK: - ReviewLocations
struct ReviewLocations: Codable {
    let start, end: [ReviewLocationDetail]
    let redemption: ReviewRedemption
    let travelerPickup: ReviewTravelerPickup

    enum CodingKeys: String, CodingKey {
        case start, end, redemption
        case travelerPickup = "traveler_pickup"
    }
}

struct ReviewLocationDetail: Codable {
    let location: String
    let description: String
}

struct ReviewRedemption: Codable {
    let redemptionType, specialInstructions: String

    enum CodingKeys: String, CodingKey {
        case redemptionType = "redemption_type"
        case specialInstructions = "special_instructions"
    }
}

struct ReviewTravelerPickup: Codable {
    let pickupOptionType: String
    let allowCustomTravelerPickup: Bool

    enum CodingKeys: String, CodingKey {
        case pickupOptionType = "pickup_option_type"
        case allowCustomTravelerPickup = "allow_custom_traveler_pickup"
    }
}

// MARK: - ReviewBookingRequirements
struct ReviewBookingRequirements: Codable {
    let minTravelersPerBooking, maxTravelersPerBooking: Int
    let requiresAdultForBooking: Bool

    enum CodingKeys: String, CodingKey {
        case minTravelersPerBooking = "min_travelers_per_booking"
        case maxTravelersPerBooking = "max_travelers_per_booking"
        case requiresAdultForBooking = "requires_adult_for_booking"
    }
}

// MARK: - ReviewItinerary
struct ReviewItinerary: Codable {
    let itineraryType: String
    let skipTheLine, privateTour: Bool
    let durationHours: ReviewDurationHours
    let itineraryItems: [ReviewItineraryItem]

    enum CodingKeys: String, CodingKey {
        case itineraryType = "itinerary_type"
        case skipTheLine = "skip_the_line"
        case privateTour = "private_tour"
        case durationHours = "duration_hours"
        case itineraryItems = "itinerary_items"
    }
}

struct ReviewItineraryItem: Codable {
    let pointOfInterestLocation: ReviewPointOfInterestLocation
    let passByWithoutStopping: Bool
    let admissionIncluded, description: String

    enum CodingKeys: String, CodingKey {
        case pointOfInterestLocation = "point_of_interest_location"
        case passByWithoutStopping = "pass_by_without_stopping"
        case admissionIncluded = "admission_included"
        case description
    }
}

struct ReviewPointOfInterestLocation: Codable {
    let location: ReviewPOILocation
    let attractionId: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case location
        case attractionId = "attraction_id"
        case name
    }
}

struct ReviewPOILocation: Codable {
    let ref: String
}

// MARK: - ReviewSupplier
struct ReviewSupplier: Codable {
    let name, reference: String
}

// MARK: - ReviewReviews
struct ReviewReviews: Codable {
    let reviewCountTotals: [ReviewCountTotal]
    let totalReviews, combinedAverageRating: Int

    enum CodingKeys: String, CodingKey {
        case reviewCountTotals = "review_count_totals"
        case totalReviews = "total_reviews"
        case combinedAverageRating = "combined_average_rating"
    }
}

struct ReviewCountTotal: Codable {
    let rating, count: Int
}

// MARK: - ReviewTourOption
struct ReviewTourOption: Codable {
    let availabilityId, supplierCode: String
    let priceSummary: ReviewPriceSummary
    let rates: [ReviewRate]

    enum CodingKeys: String, CodingKey {
        case availabilityId = "availability_id"
        case supplierCode = "supplier_code"
        case priceSummary = "price_summary"
        case rates
    }
}

// MARK: - ReviewPriceSummary
struct ReviewPriceSummary: Codable {
    let baseRate, taxes, totalAmount: Double
    let currency: String
    let commissionAmount: Double?
    let roeBase: Double?
    let strikeout: ReviewStrikeout?

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case commissionAmount = "commission_amount"
        case totalAmount = "total_amount"
        case currency
        case roeBase = "roe_base"
        case strikeout
    }
}

// MARK: - ReviewStrikeout
struct ReviewStrikeout: Codable {
    let baseRate, taxes, totalAmount: Double
    let savingPercentage: Int

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case totalAmount = "total_amount"
        case savingPercentage = "saving_percentage"
    }
}

// MARK: - ReviewRate
struct ReviewRate: Codable {
    let description, time, rateCode: String
    let available: Bool
    let price: ReviewRatePrice
    let labels: [String]

    enum CodingKeys: String, CodingKey {
        case description, time
        case rateCode = "rate_code"
        case available, price, labels
    }
}

// MARK: - ReviewRatePrice
struct ReviewRatePrice: Codable {
    let baseRate, taxes, commissionAmount, totalAmount: Double
    let currency: String
    let pricePerAgeBand: [ReviewPricePerAgeBand]
    let supplierPriceDetails: ReviewSupplierPriceDetails

    enum CodingKeys: String, CodingKey {
        case baseRate = "base_rate"
        case taxes
        case commissionAmount = "commission_amount"
        case totalAmount = "total_amount"
        case currency
        case pricePerAgeBand = "price_per_age_band"
        case supplierPriceDetails = "supplier_price_details"
    }
}

struct ReviewPricePerAgeBand: Codable {
    let ageBand: String
    let travelerCount: Int
    let pricePerTraveler, totalBandPrice: Double

    enum CodingKeys: String, CodingKey {
        case ageBand = "age_band"
        case travelerCount = "traveler_count"
        case pricePerTraveler = "price_per_traveler"
        case totalBandPrice = "total_band_price"
    }
}

struct ReviewSupplierPriceDetails: Codable {
    let currency: String
    let totalPrice, netPrice, partnerNetPrice, bookingFee: Double
    let partnerTotalPrice: Double
    let pricePerAgeBand: [ReviewPricePerAgeBand]

    enum CodingKeys: String, CodingKey {
        case currency
        case totalPrice = "total_price"
        case netPrice = "net_price"
        case partnerNetPrice = "partner_net_price"
        case bookingFee = "booking_fee"
        case partnerTotalPrice = "partner_total_price"
        case pricePerAgeBand = "price_per_age_band"
    }
}


//// MARK: - Root
//struct TourOptionApiResponse: Codable {
//    let status: Bool
//    let statusCode: Int
//    var data: TourOptionData?
//
//    enum CodingKeys: String, CodingKey {
//        case status
//        case statusCode = "status_code"
//        case data
//    }
//}
//
//// MARK: - Data
//struct TourOptionData: Codable {
//    let trackId: String
//    let reviewUid: String
//    let info: TourInfo
//    let tourOption: TourOption
//    let priceSummary: TourPriceSummary
//
//    enum CodingKeys: String, CodingKey {
//        case trackId = "track_id"
//        case reviewUid = "review_uid"
//        case info
//        case tourOption = "tour_option"
//        case priceSummary = "price_summary"
//    }
//}
//
//// MARK: - Tour Info
//struct TourInfo: Codable {
//    let title: String
//    let available: Bool
//    let additionalInfo, inclusions, exclusions: [String]
//    let images: [TourImage]
//    let thumbnail: String
//    let description: String
//    let durationHours: DurationHours
//    let ageBands: [AgeBand]
//    let cancellationPolicy: CancellationPolicy
//    let language, defaultLanguage: String
//    let tourGrades: [TourGrade]
//    let ticketInfo: TicketInfoModel
//    let locations: Locations
//    let region, city, country, confirmationType: String
//    let bookingRequirements: BookingRequirements
//    let tags: [Int]
//    let itinerary: Itinerary
//    let supplier: Supplier
//    let reviews: Reviews
//    let ratings, reviewCount: Int
//    let supplierCode, languageName: String
//
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
//// MARK: - Tour Image
//struct TourImage: Codable {
//    let caption: String
//    let url: String
//}
//
//// MARK: - Ticket Info
//struct TicketInfoModel: Codable {
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
//struct Locations: Codable {
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
//struct LocationData: Codable {
//    let location: String
//    let description: String
//}
//
//struct Redemption: Codable {
//    let redemptionType, specialInstructions: String
//
//    enum CodingKeys: String, CodingKey {
//        case redemptionType = "redemption_type"
//        case specialInstructions = "special_instructions"
//    }
//}
//
//struct TravelerPickup: Codable {
//    let pickupOptionType: String
//    let allowCustomTravelerPickup: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case pickupOptionType = "pickup_option_type"
//        case allowCustomTravelerPickup = "allow_custom_traveler_pickup"
//    }
//}
//
//// MARK: - Booking Requirements
//struct BookingRequirements: Codable {
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
//struct Itinerary: Codable {
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
//struct ItineraryItem: Codable {
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
//struct PointOfInterestLocation: Codable {
//    let location: RefLocation
//    let attractionId: Int
//    let name: String
//
//    enum CodingKeys: String, CodingKey {
//        case location
//        case attractionId = "attraction_id"
//        case name
//    }
//}
//
//struct RefLocation: Codable {
//    let ref: String
//}
//
//// MARK: - Supplier
//struct Supplier: Codable {
//    let name, reference: String
//}
//
//// MARK: - Reviews
//struct Reviews: Codable {
//    let reviewCountTotals: [ReviewCountTotal]
//    let totalReviews, combinedAverageRating: Int
//
//    enum CodingKeys: String, CodingKey {
//        case reviewCountTotals = "review_count_totals"
//        case totalReviews = "total_reviews"
//        case combinedAverageRating = "combined_average_rating"
//    }
//}
//
//struct ReviewCountTotal: Codable {
//    let rating, count: Int
//}
//
//// MARK: - Tour Option
//struct TourOption: Codable {
//    let availabilityId, supplierCode: String
//    let priceSummary: TourPriceSummary
//    let rates: [TourRate]
//
//    enum CodingKeys: String, CodingKey {
//        case availabilityId = "availability_id"
//        case supplierCode = "supplier_code"
//        case priceSummary = "price_summary"
//        case rates
//    }
//}
//
//// MARK: - Price Summary
//struct TourPriceSummary: Codable {
//    let baseRate, taxes, totalAmount: Double
//    let currency: String
//    let roeBase: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case baseRate = "base_rate"
//        case taxes
//        case totalAmount = "total_amount"
//        case currency
//        case roeBase = "roe_base"
//    }
//}
//
//// MARK: - Tour Rate
//struct TourRate: Codable {
//    let description: String
//    let time, rateCode: String
//    let available: Bool
//    let price: TourPriceModel
//    let labels: [String]
//
//    enum CodingKeys: String, CodingKey {
//        case description, time
//        case rateCode = "rate_code"
//        case available, price, labels
//    }
//}
//
//// MARK: - Tour Price
//struct TourPriceModel: Codable {
//    let baseRate, taxes, commissionAmount, totalAmount: Double
//    let currency: String
//    let pricePerAgeBand: [TourPricePerAgeBand]
//    let supplierPriceDetails: SupplierPriceDetailsModel
//
//    enum CodingKeys: String, CodingKey {
//        case baseRate = "base_rate"
//        case taxes
//        case commissionAmount = "commission_amount"
//        case totalAmount = "total_amount"
//        case currency
//        case pricePerAgeBand = "price_per_age_band"
//        case supplierPriceDetails = "supplier_price_details"
//    }
//}
//
//// MARK: - Price Per Age Band
//struct TourPricePerAgeBand: Codable {
//    let ageBand: String
//    let travelerCount: Int
//    let pricePerTraveler, totalBandPrice: Double
//
//    enum CodingKeys: String, CodingKey {
//        case ageBand = "age_band"
//        case travelerCount = "traveler_count"
//        case pricePerTraveler = "price_per_traveler"
//        case totalBandPrice = "total_band_price"
//    }
//}
//
//// MARK: - Supplier Price Details
//struct SupplierPriceDetailsModel: Codable {
//    let currency: String
//    let totalPrice, netPrice, partnerNetPrice, bookingFee, partnerTotalPrice: Double
//    let pricePerAgeBand: [TourPricePerAgeBand]
//
//    enum CodingKeys: String, CodingKey {
//        case currency
//        case totalPrice = "total_price"
//        case netPrice = "net_price"
//        case partnerNetPrice = "partner_net_price"
//        case bookingFee = "booking_fee"
//        case partnerTotalPrice = "partner_total_price"
//        case pricePerAgeBand = "price_per_age_band"
//    }
//}
//
//// MARK: - Root
//struct TourOptionApiResponse: Codable {
//    let status: Bool
//    let statusCode: Int
//    var data: TravelResponseData?
//
//    enum CodingKeys: String, CodingKey {
//        case status
//        case statusCode = "status_code"
//        case data
//    }
//}
//
//// MARK: - ResponseData
//struct TravelResponseData: Codable {
//    let trackId, uid: String
//    let info: Info
//    let price: Price
//    let tourOption: TourOption?
//    let priceSummary: Price?           // root level price_summary
//
//    enum CodingKeys: String, CodingKey {
//        case trackId = "track_id"
//        case uid
//        case info
//        case price
//        case tourOption = "tour_option"
//        case priceSummary = "price_summary"
//    }
//}
//
//// MARK: - TourOption
//struct TourOption: Codable {
//    let availabilityId: String
//    let supplierCode: String
//    let priceSummary: Price
//    let rates: [TourRate]
//
//    enum CodingKeys: String, CodingKey {
//        case availabilityId = "availability_id"
//        case supplierCode = "supplier_code"
//        case priceSummary = "price_summary"
//        case rates
//    }
//}
//
//// MARK: - TourRate
//struct TourRate: Codable {
//    let description: String
//    let time, rateCode: String
//    let available: Bool
//    let price: TourPrice
//    let labels: [String]
//
//    enum CodingKeys: String, CodingKey {
//        case description, time
//        case rateCode = "rate_code"
//        case available, price, labels
//    }
//}
//
//// MARK: - TourPrice
//struct TourPrice: Codable {
//    let baseRate, taxes, commissionAmount, totalAmount: Double
//    let currency: String
//    let pricePerAgeBand: [TourPricePerAgeBand]
//    let supplierPriceDetails: SupplierPriceDetails
//
//    enum CodingKeys: String, CodingKey {
//        case baseRate = "base_rate"
//        case taxes
//        case commissionAmount = "commission_amount"
//        case totalAmount = "total_amount"
//        case currency
//        case pricePerAgeBand = "price_per_age_band"
//        case supplierPriceDetails = "supplier_price_details"
//    }
//}
//
//// MARK: - TourPricePerAgeBand
//struct TourPricePerAgeBand: Codable {
//    let ageBand: String
//    let travelerCount: Int
//    let pricePerTraveler, totalBandPrice: Double
//
//    enum CodingKeys: String, CodingKey {
//        case ageBand = "age_band"
//        case travelerCount = "traveler_count"
//        case pricePerTraveler = "price_per_traveler"
//        case totalBandPrice = "total_band_price"
//    }
//}
