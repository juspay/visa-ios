import Foundation

struct Constants {
    enum HexColors {
        static let bgPremierWeak = "FAF3E6"
        static let surfaceWeakest = "F5F7F8"
        static let primary = "BA9252"
        static let primaryGold = "BF711E"
        
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
        static let sheild = "Sheild"
        static let arrowDown = "ArrowDown"
        static let calendar = "Calendar"
        static let calendargray = "CalendarGray"
        static let shareYellow = "ShareYellow"
        static let user = "User"
        static let usergray = "UserGray"
        static let userSVG = "UserSVG"
        static let frame = "Frame"
        static let minus = "Minus"
        static let plus = "Plus"
        static let clock = "Clock"
        static let check = "Check"
        static let greenTick = "green_tick"
        static let mapWhite = "MapWhite"
        
        static let print = "Print"
        static let download = "Download"
        static let Share = "Share"
        static let map = "Map"
        static let mapGray = "MapGray"
        static let saving = "Saving"
        static let savingGray = "SavingGray"
        static let checkBoxFilled = "CheckBoxFilled"
        static let checkBox = "CheckBox"
        static let star = "Star"
        static let filter = "Filters"
        static let starWhite = "StarWhite"
        static let wishlist = "Wishlist"
        static let wishlistWhite = "WishlistWhite"
        static let nature = "Nature"
        static let starEmpty = "StarEmpty"
        static let shrek = "Shrek"
        static let searchIcon = "Search"
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
        static let backButton = "BackButton"
        static let logos  = "Logos"
        static let bookingBash = "BookingBashLogo"
        static let vector = "Vector"
        static let mobile = "mobile"
        static let currency = "Currency"
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
        static let noPackagesAvailable = "No packages available"
    }
    
    enum BookingStatusScreenConstants {
        static let supplierContactTitle = "Supplier provider details"
        static let contactDetails = "Support Contact Details"
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
        static let loadingCancellationReasons = "Loading cancellation reasons..."
        static let failedToLoadCancellationReasons = "Failed to load cancellation reasons: %@"
        static let retry = "Retry"
        static let noCancellationReasonsAvailable = "No cancellation reasons available"
        
        static let bookingIdKey = "Booking ID"
        static let cancelBookingFailed = "Failed to cancel booking."
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
        static let consentBoxError = "Please agree to the Terms & Conditions and Privacy Policy before continuing."
        
    }
    
    enum DetailScreenConstants {
        static let startingFrom = "Starting from"
        static let tickets = "Tickets"
        static let perPerson = "/Person"
        static let viewCancellationPolicy = "Refer cancellation policy for details"
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
        static let exploreDestinations = "Explore destinations"
        static let loadMore = "Load More..."
        static let viewAll = "View All"
        static let searchDestination = "Search Destination..."
        static let cancelBookingText = "Do you want to skip the booking?"
        static let skip = "Yes, Skip"
        static let stay = "Stay"
        static let exploreDestinationsHeaderText = "Explore destinations"
        static let exploreCitiesHeaderText = "Explore cities"
        static let epicExperiencesHeader = "Epic experiences worldwide"
        static let epicExperiences = "Epic experiences"
    }
    
    enum Font {
        static let openSansBold = "OpenSans-Bold"
        static let openSansRegular = "OpenSans-Regular"
        static let openSansSemiBold = "OpenSans-SemiBold"
        static let lexendBold = "Lexend-Bold"
        static let lexendMedium = "Lexend-Medium"
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
        static let siteId = "68b585760e65320801973737"
        static let sso_siteKey =  "6894a033d9fde373304f80dewxyz"
    }
    
    enum ErrorMessages {
        static let failedToDecode = "Failed to decode: %@"
        static let failedToDecrypt = "Failed to decrypt: %@"
        static let decodingError = "Failed to decode"
        static let decryptionError = "Failed to decrypt"
        static let networkError = "Network request failed"
        static let invalidResponse = "Invalid response received"
        static let dataParsingError = "Failed to parse data"
        static let unexpectedError = "An unexpected error occurred"
        static let invalidURL = "Invalid URL"
        static let invalidResponseFormat = "Invalid response format:"
        static let invalidCountryCodeOrMobile = "Invalid country code or Mobile Number."
        static let emptyMobileNumber = "Please enter a mobile number."
        static let noDataInResponse = "Oops! No data in response"
        static let somethingWentWrong = "Oops! something went wrong."
        static let noResultsFound = "Oops! no results found."
        static let noResultsFoundDescription = "We didn’t find anything.. Try adjusting your search."

        
    }
    
    enum ExperienceHomeViewConstants {
        static let loadingExperience = "Loading Experiences"
        static let hasAgreedToPrivacy = "hasAgreedToPrivacy"
    }
    
    enum ExperienceHomeConstants {
        // Default API values
        static let defaultCheckInDate = "2025-10-24"
        static let defaultCheckOutDate = "2025-10-25"
        static let defaultCurrency = "AED"
        static let defaultClientId = ""
        static let defaultEnquiryId = ""
        
        // Search filter defaults
        static let defaultOffset = 0
        static let defaultSortName = "price"
        static let defaultSortType = "ASC"
        
        // Languages
        static let supportedLanguages = ["en", "ar"]
        
        // Feature flags
        static let featureFlags = [
            "free_cancellation",
            "special_offer",
            "private_tour",
            "skip_the_line",
            "likely_to_sell_out"
        ]
    }
    
    enum ColorConstants {
        static let strokeColor = "#B89B5E"
        static let fillColor = "#B89B5E"
    }
    
    enum SideMenuConstants {
        static let greetingText = "Hi %@!"
        static let myTransactions = "My Transactions"
        static let myBBProSavings = "My BB-Pro Savings"
        static let myFavorites = "My Favorites"
        static let myProfile = "My Profile"
        static let currency = "Currency"
        // Image names
        static let iconProfile = "VectorUser"
        static let iconTransactions = "ticket"
        static let iconSavings = "bag"
        static let iconFavorites = "heart"
        static let iconProfileMenu = "person"
        static let iconChevronRight = "chevron.right"
    }
    
    enum APIURLs {
        static let baseURL = "https://travelapi.bookingbash.com"
        static let decryptURL = "https://auth.bookingbash.com/decrypt"
        static let ssoLoginURL = baseURL + "/services/api/sso/2.0/login"
        static let autoSuggestBaseURL = baseURL + "/services/api/activities/2.0/autosuggest"
        static let searchBaseURL = baseURL + "/services/api/activities/2.0/search"
        static let homeBaseURL = baseURL + "/services/api/shared/2.0/home"
        static let availabilityUrl = baseURL +  "/services/api/activities/2.0/availability"

        
        static let bookingBaseURL = baseURL + "/services/api/activities/2.0/booking"
        static let bookingListURL = baseURL + "/services/api/activities/2.0/booking-list"
        static let transactionBaseURL = baseURL + "/services/api/activities/2.0/transaction"
        static let reviewDetailsURL = baseURL + "/services/api/activities/2.0/review-details"
        static let initBookURL = baseURL + "/services/api/activities/2.0/initbook"
        static let bookStatusURL = baseURL + "/services/api/activities/2.0/book"
        static let bookingDetailsURL = baseURL + "/services/api/activities/2.0/booking-details"
        static let cancelReasonURL = baseURL + "/services/api/activities/2.0/cancel-reason"
        static let cancelBookingURL = baseURL + "/services/api/activities/2.0/cancel"
        static let detailsBaseURL = baseURL + "/services/api/activities/2.0/details"
        static let imageListURL = baseURL + "/services/api/activities/2.0/image/list"
       
    }
    
    enum TransactionRowConstants {
        static let youAreSaving = "You are saving "
        static let bookingId = "Booking ID:"
        static let bookingDate = "Booking Date:"
        static let status = "Status"
        static let placeHolderImage = "PlaceHolderImage"
        static let systemPhoto = "photo"
        static let clock = "clock"
        static let calendar = "calendar"
        static let userGray = "UserGray"
        static let saving = "Saving"
        
        // MyTransactionView specific
        static let ticketSystemImage = "ticket"
        static let myTransactionsTitle = "My Transactions"
        static let docTextSystemImage = "doc.text"
        static let noBookingsFormat = "No %@ bookings"
    }
    
    enum API {
        static let reviewDetailsUID = "688a6ef2d3545f348d1c720a"
        static let reviewDetailsAvailabilityID = "cd23671ff9d16aa56eddaf8ebac71aeba2407881c5c33f65cbd4"
  
    }
    
    enum GuestDetailsFormConstants {
        static let addGuestDetails = "Guest  Details"
        static let requiredMark = "*"
        static let infoText = "We'll use this information to send you confirmation and updates about your booking."
        static let firstName = "First name"
        static let lastName = "Last name"
        static let weight = "Weight (in KG)"
        static let height = "Height (in CM)"
        static let passportNumber = "Passport number"
        static let enterLastName = "Enter last name"
        static let enterPassport = "Enter passport number"
        static let email = "Email"
        static let enterEmail = "Enter email id"
        static let mobile = "Mobile"
        static let enterMobileNumber = "Enter mobile number"
        static let saveTravelerDetails = "Save traveler details"
        static let specialRequest = "Special Request if any (optional)"
        static let title = "Title"
        static let mr = "Mr"
        static let ms = "Ms"
        static let mrs = "Mrs"
        static let enterFirstName = "Enter first name"
        static let selectNationality = "Select nationality"
        static let weightPlaceholder = "Enter weight in kg"
        static let heightPlaceholder = "Enter height in cm"
        static let nationalityLabel = "Nationality as per the passport"
        static let nationalities: [String] = [
            "American",
            "Indian",
            "British",
            "Australian"
        ]
        // SF Symbols
        static let systemNamePersonCircle = "person.circle"
        static let systemNameChevronUp = "chevron.up"
        static let systemNameChevronDown = "chevron.down"
        static let systemNameFlag = "flag"
        static let systemNameCheckmark = "checkmark"
        static let tourBookingOptions = [
            "I'd like to be picked up",
            "I'll make my own way to the meeting point",
            "I'll decide later"
        ]
        static let tourLanguages = [
            "Spanish – Guide",
            "English – Guide",
            "French – Guide",
            "German – Guide"
        ]
        static let tourBookingQuestionsTitle = "Tour booking questions"
        static let tourBookingQuestionsDescription = "You can make your own way to the meeting point or request pickup. If you're not sure, you can decide later."
        static let tourLanguageTitle = "Tour language"
        static let searchLocationPlaceholder = "Search location"
        static let passportExpiryDate = "Passport expiry date"
        static let dateOfBirth = "Date of Birth"
        static let dateFormatter = "dd/mm/yyyy"
    }
    
    enum ExperienceListDetailViewConstants {
        // Text messages
        static let loading = "Loading..."
        static let loadingExperiences = "Loading experiences..."
        static let searchPlaceholder = "Search experiences near..."
        static let exploreExperiencesText = "Explore experiences near and far "
        static let noExperienceFound = "No experience found"
        static let experienceFoundSingular = "experience found"
        static let experienceFoundPlural = "experiences found"
        static let sortText = "Sort"
        // System Images
        static let chevronDown = "chevron.down"
    }
    
    enum ExperienceDestinationDetailViewConstants {
        static let destinationName = "Dubai"
        static let searchPlaceholder = "Search Burj Khalifa"
        static let chooseYourVibe = "Choose your vibe"
        static let saveBigFunPass = "Save Big with a Fun Pass"
        static let waterParksExperiences = "Water Parks & Experiences"
        static let trendingExperiences = "Trending experiences"
    }
    
    enum TourBookingQuestionsConstants {
        static let tourSpecific = "Tour Specific"
        static let tourLanguage = "Tour language"
        static let specialRequest = "Special Request if any (optional)"
        static let arrivalTransferMode = "Arrival Transfer Mode"
        static let pickUpLocation = "Pick Up Location"
        static let enterYourPickupLocation = "Enter Your Pickup Location"
        static let arrivalFlightNo = "Arrival Flight No."
        static let arrivalAirlines = "Arrival Airlines"
        static let arrivalTime = "Arrival Time"
        static let disembarkationTime = "Disembarkation Time"
        static let arrivalDropOffLocation = "Arrival Drop Off Location"
        static let arrivalRailLine = "Arrival Rail Line"
        static let arrivalRailStation = "Arrival Rail Station"
        static let departureTransferMode = "Departure Transfer Mode"
        static let departurePickUpLocation = "Departure Pick Up Location"
        static let departureFlightNo = "Departure Flight No."
        static let departureAirlines = "Departure Airlines"
        static let departureTime = "Departure Time"
        static let boardingTime = "Boarding Time"
        static let departureDate = "Departure Date"
        static let departureRailLine = "Departure Rail Line"
        static let departureRailStation = "Departure Rail Station"
        static let cruiseShip = "Cruise Ship"
    }
    
    enum APIHeaders {
        static let contentTypeKey = "Content-Type"
        static let contentTypeValue = "application/json"
        static let tokenKey = "token"
        static let siteId = "site_id"
        static let trackId = "track_id"
        static let siteKey = "site_key"
        static let authorizationKey = "Authorization"
    }
    
    enum CancelBookingBottomSheetConstants {
        static let title = "Need to Cancel or Amend Your Booking?"
        static let subtitle = "For any cancellation or amendment requests, please reach out to us at the email or contact number provided below. Our team will be happy to assist you."
        static let emailLabel = "Email:"
        static let emailValue = "reservations@bookingbash.com"
        static let telLabel = "Tel:"
        static let telValue = "+97148348696"
        static let backButton = "Back"
        static let imageName = "cancelBottomSheet"
    }
    
    enum ExperiencePassesCardViewConstants {
        static let fareSummary = "Fare summary"
        static let discount = "Discount"
        static let total = "Total"
        static let pricesInclusiveOfTaxes = "Prices inclusive of taxes"
        static let moreInfo = Constants.SharedConstants.moreInfo
        static let lessInfo = Constants.SharedConstants.lessInfo
        static let bookThisExperience = Constants.AvailabilityScreenConstants.bookThisExperience
    }
    
    enum PrivacyPolicyConstants {
        static let title = "Your privacy is our\nresponsibility"
        static let useOfPersonalData = "Use of Your Personal data"
        static let personalDataDescription = "We’ll use your personal data (e.g., name, email) to create an account for BookingBash and send you transactional emails related to your bookings."
        static let consentText = "By clicking \"I Agree,\" you consent to this use of your data."
        static let exitButton = "Exit"
        static let agreeButton = "I Agree"
    }
}
