//
//  Constants.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation

struct Constants {
    enum HexColors {
        static let bgPremierWeak = "FAF3E6"
        static let surfaceWeakest = "F5F7F8"
        static let primary = "BA9252"
        static let primaryStrong = "876A3B"
        static let secondary = "163049"
        static let blackStrong = "2F3438"
        static let neutral = "667077"
        static let neutralWeak = "D8DEE1"
        static let error = "F95757"
        static let blueShade = "163049"
        static let greenShade = "32B817"
    }
    
    enum Icons {
        static let arrowRight = "ArrowRight"
        static let arrowDown = "ArrowDown"
        static let calendar = "Calendar"
        static let user = "User"
        static let minus = "Minus"
        static let plus = "Plus"
        static let clock = "Clock"
        static let check = "Check"
        static let print = "Print"
        static let download = "Download"
        static let Share = "Share"
        static let map = "Map"
        static let saving = "Saving"
        static let checkBoxFilled = "CheckBoxFilled"
        static let checkBox = "CheckBox"
        static let star = "Star"
        static let wishlist = "Wishlist"
        static let nature = "Nature"
        static let starEmpty = "StarEmpty"
        static let shrek = "Shrek"
        static let searchIcon = "SearchIcon"
        static let xmark = "xmark"
        static let hamburger = "Hamburger"
        static let sarchIcon = "SearchIcon"
        static let activity = "Activity"
        static let radioButtonChecked = "RadioButtonChecked"
        static let radioButtonUnchecked = "RadioButtonUnchecked"
        static let filters = "Filters"
        static let wishlistFill = "WishlistFill"
        static let info = "Info"
        static let logoVisa = "logoVisa"
        static let searchNoResult = "SearchNoResult"
    }
    
    enum searchScreenConstants {
        static let noResultFound = "Oops! no results found."
        static let noResultFoundSubTitle = "We didn’t find anything. Try adjusting your search"
        static let clear = "Clear"
        static let searchResults = "Search Results"
        static let recentSearches = "Recent Searches"
        static let selectDestination = "Select Destination"
    }
    
    enum ExperiencePaymentConstants {
        static let total = "Total"
        static let aed = "AED"
        static let cardNumber = "Card Number"
        static let cardHolderName = "Card Holder Name"
        static let expiryDate = "Expired Date"
        static let cvv = "CVV"
        static let mandatory = "*"
        static let enterCVV = "Enter CVV no."
        static let payment = "Payment"
        static let subtitle = "Secure your booking - just enter your CVV to pay."
        static let payNow = "Pay now"
    }
    
    enum ExperienceListConstants {
        static let resetAll = "Reset All"
        static let showResults = "Show Results"
        static let pricePerPerson = "Price Per Person"
        static let min = "Min"
        static let max = "Max"
        static let aed = "AED"
        static let filters = "Filters"
        static let experienceFound = "%d experiences found"
        static let perPerson = "/Person"
        static let addedInFavorites = "Added in Favorites"
        static let searchExperiencesNear = "Search experiences near..."
        static let exploreExperiencesNear = "Explore experiences near and far"
    }
    
    enum AvailabilityScreenConstants {
        static let availability = "Availability"
        static let select = "Select"
        static let date = "Date"
        static let participants = "Participants"
        static let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        static let selectDate = "Select Date"
        static let today = "Today"
        static let tomorrow = "Tomorrow"
        static let bookThisExperience = "Book this Experience"
        static let total = "Total"
        static let optionsAvailable = "options available"
        static let maxTravelersFormat = "You can select up to %d travelers in total"
        static let aed = "AED"
        static let selectedParticipants = "Selected participants:"
    }
    
    enum BookingStatusScreenConstants {
        static let supplierContactTitle = "Supplier provider details"
        static let contactDetails = "Contact Details"
        static let cancelBooking = "Cancel Booking"
        static let calendar = "Calendar"
        static let addItineraryToCalendar = "Add  Itinerary to Calendar"
        static let backToHome = "Back to Home"
        static let refundable = "Refundable"
        static let forSupplierVoucher = "For supplier voucher"
        static let clickHere = "Click here"
        static let viewDetails = "View Details"
        static let amountPaid = "Amount Paid"
        static let aed = "AED"
        static let cancellationFee = "Cancellation Fee"
        static let totalRefunded = "Total amount to be refunded"
        static let refundAmount = "Refund Amount"
        static let refundText = "The amount will be refunded in your account in 2–5 working days"
        static let cancelNow = "Cancel now"
        static let dot = "•"
        static let experienceDetails = "Experience details"
        static let totalAmountPaid = "Total Amount Paid"
        static let savingFormat = "You are saving %@ AED"
        static let fareSummary = "Fare summary"
        static let pricesWithTaxes = "Prices inclusive of taxes"
        static let refundDetails = "Refund details"
        static let refundProcessed = "Refund Processed"
        static let deduction = "Deduction"
        static let totalRefundProcessed = "Total refund processed"
        static let selectCancellationReason = "Select cancellation reason"
        static let selectedReason = "Selected reason:"
    }
    
    enum CheckoutPageConstants {
        static let agree = "I agree to the "
        static let termsConditions = "Terms and Conditions"
        static let andText = " and "
        static let privacyPolicy = "Privacy Policy"
        static let checkoutHeaderText = "Add guest details & review booking"
        static let total = "Total"
        static let termsAndConditionsTapped = "Terms and condition tapped"
        static let privacyPolicyTapped = "Privacy policy tapped"
        static let saveContinue = "Save & Continue"
    }
    
    enum DetailScreenConstants {
        static let startingFrom = "Starting from"
        static let perPerson = "/Person"
        static let viewCancellationPolicy = "View cancellation policy"
        static let MostPopularDays = "Most popular days"
        static let reviewsText = "Reviews (%d)"
        static let sortBy = "Sort by: "
        static let mostRelevant = "Most Relevant"
        static let sort = "Sort"
        static let similarExperiences = "Similar experiences"
        static let travelerPhotos = "Traveler Photos"
    }
    
    enum HomeScreenConstants {
        static let aed = "AED"
        static let youSave = "You save %d%%"
        static let perPersonText = "/Person"
        static let exploreDestinations = "Explore Destinations"
        static let loadMore = "Load More..."
        static let viewAll = "View All"
        static let searchDestination = "Search Destination..."
        static let cancelBookingText = "Do you want to skip the booking?"
        static let skip = "Yes, Skip"
        static let stay = "Stay"
        static let exploreDestinationsHeaderText = "Explore destinations"
        static let epicExperiencesHeader = "Epic experiences, worldwide"
    }

    enum Font {
        static let openSansBold = "OpenSans-Bold"
        static let openSansRegular = "OpenSans-Regular"
        static let openSansSemiBold = "OpenSans-SemiBold"
    }
    
    enum NavigationId {
        static let experienceDetailView = "ExperienceDetailView"
        static let availabilitySelectionMainView = "AvailabilitySelectionMainView"
        static let experienceCheckoutView = "ExperienceCheckoutView"
        static let experiencePaymentView = "ExperiencePaymentView"
        static let paymentWebView = "PaymentWebView"
        static let infoScreen = "InfoScreen"
        static let allDestinations = "AllDestinations"
        static let experienceListDetailView = "ExperienceListDetailView"
        static let filterScreenView = "FilterScreenView"
        static let experienceBookingStatusScreenView = "ExperienceBookingStatusScreenView"
    }
    
    enum SharedConstants {
        static let lessInfo = "Less info"
        static let moreInfo = "More info"
        static let next = "Next"
        static let readLess = "Read less"
        static let readMore = "Read more"
        static let viewLess = "View less"
        static let viewMore = "View more"
        static let botoomSheetScrollId = "scroll"
    }
}
