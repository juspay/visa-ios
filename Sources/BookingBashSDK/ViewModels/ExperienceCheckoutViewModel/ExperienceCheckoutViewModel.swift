import Foundation

struct TravellerInstance: Identifiable {
    let id = UUID()
    let bandId: String
    let displayTitle: String
    var fields: [FormField]
    var isValid: Bool = false
}

final class ExperienceCheckoutViewModel: ObservableObject {
    @Published var orderNo: String?
    @Published var paymentUrl: String?
    @Published var location: String?
    @Published var totalAmount: Double?
    @Published var shouldNavigateToPayment: Bool = false
    @Published var carousalData: [ExperienceDetailCarousalModel] = []
    @Published var selectedTravelDate: Date = Date()
    @Published var fairSummaryData: [FareItem] = []
    @Published var reviewResponse: ReviewTourDetailResponse?
    @Published var errorMessage: String?
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var showNoResultImage = false
    @Published var shouldNavigateToTerms = false
    @Published var shouldNavigateToPrivacy = false
    @Published var isLoading: Bool = false
    @Published var showErrorOverlay = false
    var errorStatusCode: Int? = nil
    @Published var experienceTitle: String = ""
    @Published var experienceDescription: String = ""
    @Published var savingsTextforFareBreakup: String = ""
    @Published var duration: String = ""
//    @Published var currency: String = "AED"
    @Published var cancellationPolicy: String = ""
    @Published var highlights: [InfoDetailModel] = []
    @Published var inclusions: [InfoDetailModel] = []
    @Published var exclusions: [InfoDetailModel] = []
    @Published var cancellationPolicyData: [InfoDetailModel] = []
    @Published var knowBeforeGo: [InfoDetailModel] = []
    @Published var meetingPoint: String = ""
    @Published var operatingDays: [String] = []
    @Published var allFeatures: [FeatureItem] = []
    
    @Published var bookingFields: [FormField] = []
    @Published var travellers: [TravellerInstance] = []
    // MARK: - Inputs
    @Published var questions: [TravellerBookingQuestionModel]? = nil
    @Published var pickupPointQuestion: PickupPointQuestion? = nil
    @Published var participants: [ParticipantCategory] = []
    
    // MARK: Pickup questions
    @Published var arrivalPickupModes: [PickupMode]? = nil
    @Published var departurePickupModes: [PickupMode]? = nil
    @Published var arrivalPickupFields: [FormField] = []
    @Published var departurePickupFields: [FormField] = []
    @Published var selectedArrivalMode: PickupMode? = nil {
        didSet {
            prepareArrivalQuestions()
        }
    }
    
    @Published var selectedDepartureMode: PickupMode? = nil {
        didSet {
            prepareDepartureQuestions()
        }
    }
    @Published var areAllFormsValid: Bool = false 
    
    let productId: String
    private var selectedPackage: Package?
    private var availabilityResponse: AvailabilityApiResponse?
    private var uid: String?
    private var availabilityKey: String?
    init(productId: String) {
        self.productId = productId
    }
    func setSelectedPackage(_ package: Package?) {
        self.selectedPackage = package
    }
    func setAvailabilityResponse(_ response: AvailabilityApiResponse?) {
        self.availabilityResponse = response
//        if let response = response {
//        }
    }
    func setUid(_ uid: String) {
        self.uid = uid
    }
    func setAvailabilityKey(_ key: String) {
        self.availabilityKey = key
    }
    var formattedTotalAmount: String {
        totalAmount.map {  $0.commaSeparated() } ?? "--"
    }
    func formattedSelectedDate(_ date: Date) -> String {
        DateFormatter.shortDateString(from: date)
    }
    func validateFields(guestDetails: GuestDetails) -> Bool {
        let allowedTitles = ["Mr", "Ms", "Mrs", "Dr"]
        let trimmedTitle = guestDetails.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty || !allowedTitles.contains(trimmedTitle) {
            return false
        }
        let trimmed = guestDetails.mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        guard MobileCodeData.allCodes.first(where: { $0.dialCode == guestDetails.mobileCountryCode && $0.maxCharLimit == guestDetails.mobileNumber.count }) != nil else {
            return false
        }
        return true
    }

    func isValidMobileNumber(guestDetails: GuestDetails) -> Bool {
        guard MobileCodeData.allCodes.first(where: { $0.dialCode == guestDetails.mobileCountryCode && $0.maxCharLimit == guestDetails.mobileNumber.count }) != nil else {
            return false
        }
        return true
    }
        
    func validateConcentBoxChecked(isConsentBoxChecked: Bool, guestDetails: GuestDetails) -> Bool {
        if !isConsentBoxChecked, !guestDetails.title.isEmpty, isValidMobileNumber(guestDetails: guestDetails)  {
            showToast(message: Constants.CheckoutPageConstants.consentBoxError)
            return false
        }
        return true
    }

    func handleTermsTapped() {
        shouldNavigateToTerms = true
    }
    func handlePrivacyTapped() {
        shouldNavigateToPrivacy = true
    }
    private func showToast(message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showToast = false
        }
    }
}

// MARK: - Fetch Data
extension ExperienceCheckoutViewModel {
    func fetchData() {
        fetchReviewDetails()
//        fetchImageList()
    }
    private func fetchReviewDetails() {
        guard let url = URL(string: Constants.APIURLs.reviewDetailsURL) else { return }
        let activityCode = selectedPackage?.activityCode ?? ""
        let requestAvailabilityId = "\(avalabulityUid)||\(availablityKey)"
        let requestBody = ReviewDetailsRequestModel(
            uid: detaislUid,
            availabilityId: requestAvailabilityId,
            quoteId: "",
            enquiryId: "",
            activityCode: activityCode,
            rateCode: subActivityCode,
            currency: currencyGlobal
        )
        let headers: [String: String] = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<ReviewTourDetailResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status == false || response.statusCode != 200 {
                        self.errorStatusCode = response.statusCode
                        self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                        self.showToast(message: self.errorMessage ?? "")
                        self.showErrorOverlay = true
                        self.showNoResultImage = true
                        return
                    }
                    if let status = response.status, status, let data = response.data {
                        self.totalAmount = data.price?.totalAmount
                        if let city = data.info?.city, !city.isEmpty, let country = data.info?.country, !country.isEmpty {
                            self.location = "\(city)-\(country)"
                        }
                        self.setUiData(responseData: data)
                        self.reviewResponse = response
                        self.getParticipantData(data: data)
                        if let bookingQuestions = response.data?.bookingQuestions  {
                            if let pickupPointQuestion = bookingQuestions.pickupPointQuestion {
                                self.pickupPointQuestion = pickupPointQuestion
                                if let arrivalModes = pickupPointQuestion.arrivalPickupMode, !arrivalModes.isEmpty {
                                    self.arrivalPickupModes = arrivalModes
                                }
                                    
                                if let departurePickupModes = pickupPointQuestion.departurePickupMode, !departurePickupModes.isEmpty {
                                    self.departurePickupModes = departurePickupModes
                                }
                            }
                            
                            if let travellerBookingQuestions = bookingQuestions.travellerBookingQuestions, !travellerBookingQuestions.isEmpty  {
                                self.questions = travellerBookingQuestions
                                self.prepareBookingQuestionsForm()
                            }
                        }
//                         self.updateCarouselData(from: data)
                        self.showNoResultImage = false
                    }  else {
                        self.errorMessage = "Unknown API error"
                        self.showToast(message: "Unknown API error")
                        self.showNoResultImage = true
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showToast(message: error.localizedDescription)
                    self.showNoResultImage = true
                }
            }
        }
    }

    func fetchImageList() {
        guard let url = URL(string: Constants.APIURLs.imageListURL) else {
            return
        }
        let activityCode = selectedPackage?.activityCode ?? productId
        let requestBody = ImageListRequest(activity_code: activityCode)
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
        ]
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<ImageListResponse, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    if let imageData = response.data {
                        self.updateCarouselWithImages(imageData: imageData)
                    }
//                    else {
//                        if let reviewData = self.reviewResponse?.data {
//                            self.carousalData = [ExperienceDetailCarousalModel(imageUrl: reviewData.info?.thumbnail ?? "")]
//                        }
//                    }
                case .failure(_):
                    if let reviewData = self.reviewResponse?.data {
                        self.carousalData = [ExperienceDetailCarousalModel(imageUrl: reviewData.info?.thumbnail ?? "")]
                    }
                }
            }
        }
    }
    private func updateCarouselWithImages(imageData: ImageListData) {
        var carouselImages: [ExperienceDetailCarousalModel] = []
        let nonCoverImages = imageData.result.filter { !$0.isCover }
        for imageResult in nonCoverImages {
            let bestVariant = imageResult.variant.first { variant in
                (variant.width == 720 && variant.height == 480) ||
                (variant.width == 674 && variant.height == 446)
            } ?? imageResult.variant.first { variant in
                variant.width >= 400 && variant.height >= 300
            } ?? imageResult.variant.first
            if let variant = bestVariant {
                let carouselItem = ExperienceDetailCarousalModel(imageUrl: variant.url)
                carouselImages.append(carouselItem)
            }
        }
        if !carouselImages.isEmpty {
            carousalData = carouselImages
        }
//        else {
//            if let reviewData = reviewResponse?.data {
//                carousalData = [ExperienceDetailCarousalModel(imageUrl: reviewData.info?.thumbnail ?? "")]
//            }
//        }
    }
    private func updateCarouselData(from data: ReviewTourDetailData) {
        if let thumbnail = data.info?.thumbnail, !thumbnail.isEmpty {
            carousalData = [ExperienceDetailCarousalModel(imageUrl: thumbnail)]
        }
    }
    func setUiData(responseData: ReviewTourDetailData?) {
        guard let data = responseData else {
            return
        }
        fairSummaryData.removeAll()
        if let price = data.price {
            if let pricePerAges = price.pricePerAge {
                for item in pricePerAges {
                    if let bandId = item.bandId,
                       let count = item.count,
                       let bandTotal = item.bandTotal,
                       let perPriceTraveller = item.perPriceTraveller {
                        let descriptionText: String
                        if bandId.lowercased().contains("adult") {
                            descriptionText = count > 1 ? "Adults" : "Adult"
                        } else if bandId.lowercased().contains("child") || bandId.lowercased().contains("children") {
                            descriptionText = count > 1 ? "Children" : "Child"
                        } else if bandId.lowercased().contains("family") {
                            descriptionText = count > 1 ? "Families" : "Family"
                        } else if bandId.lowercased().contains("person") {
                            descriptionText = count > 1 ? "People" : "Person"
                        }  else if bandId.lowercased().contains("custom") {
                            descriptionText = "Custom"
                        } else {
                            descriptionText = count == 1 ? bandId.capitalized : "\(bandId.capitalized)s"
                        }
                        let leftText = "\(Int(count)) \(descriptionText) x \(price.currency ?? "AED") \(perPriceTraveller.commaSeparated())"
                        let rightText = "\(price.currency ?? "AED") \(bandTotal.commaSeparated())"
                        fairSummaryData.append(
                            FareItem(title: leftText, value: rightText, isDiscount: false)
                        )
                    }
                }
            }
            if let taxes = price.taxes, taxes > 0 {
                fairSummaryData.append(FareItem(
                    title: "Taxes and fees",
                    value: "\(price.currency ?? "AED") \(taxes.commaSeparated()))",
                    isDiscount: false
                ))
            }
            if let strikeout = price.strikeout,
               let originalAmount = strikeout.totalAmount,
               let currentAmount = price.totalAmount,
               originalAmount > currentAmount {
                fairSummaryData.append(FareItem(
                    title: "Discount",
                    value: "- \(data.price?.currency ?? "AED") \(strikeout.savingAmount?.commaSeparated() ?? "0.00")",
                    isDiscount: true
                ))
                savingsTextforFareBreakup = "You are saving \(data.price?.currency ?? "AED") \(strikeout.savingAmount?.commaSeparated() ?? "0.00")"
            } else {
                savingsTextforFareBreakup = "You are saving \(data.price?.currency ?? "AED") \(String(format: "%.2f", 0.0)) "
                fairSummaryData.append(FareItem(
                    title: "Discount",
                    value: "- \(data.price?.currency ?? "AED") 0.00",
                    isDiscount: true
                ))
            }
        }
        experienceTitle = data.info?.title ?? ""
        experienceDescription = data.info?.description ?? ""
        duration = data.info?.duration?.display ?? ""
//        currency = data.price?.currency ?? "AED"
        cancellationPolicy = data.info?.cancellationPolicy?.description ?? ""
        var locationParts: [String] = []
        if let city = data.info?.city, !city.isEmpty {
            locationParts.append(city)
        }
        if let country = data.info?.country, !country.isEmpty {
            locationParts.append(country)
        }
        location = locationParts.joined(separator: ", ")
        var features: [FeatureItem] = []
        let durationDisplay = data.info?.duration?.display ?? ""
        if !durationDisplay.isEmpty {
            features.append(FeatureItem(iconName: "clock.fill", title: durationDisplay))
        }
        allFeatures = features
        var cancellationItems: [String] = []
        if let description = data.info?.cancellationPolicy?.description, !description.isEmpty {
            cancellationItems.append(description)
        }
        if let refundEligibility = data.info?.cancellationPolicy?.refundEligibility {
            for refund in refundEligibility {
                if let maxDays = refund.dayRangeMax {
                    let item = "\(refund.percentageRefundable ?? 0)% refund if cancelled between \(refund.dayRangeMin ?? 0) and \(maxDays) days before"
                    cancellationItems.append(item)
                } else {
                    let item = "\(refund.percentageRefundable ?? 0)% refund if cancelled \(refund.dayRangeMin ?? 0)+ days before"
                    cancellationItems.append(item)
                }
            }
        }
        if cancellationItems.isEmpty {
            cancellationItems.append("Free cancellation available")
            cancellationItems.append("Cancel up to 24 hours before the experience starts for a full refund")
        }
        cancellationPolicyData = [
            InfoDetailModel(title: "Cancellation Policy", items: cancellationItems.filter { !$0.isEmpty })
        ]
        let inclusionsArray = data.info?.inclusions ?? []
        var inclusionItems = inclusionsArray.compactMap { inclusion -> String? in
            if let description = inclusion.description, !description.isEmpty, description != "Other" {
                return description
            } else if let otherDescription = inclusion.otherDescription, !otherDescription.isEmpty, otherDescription != "Other" {
                return otherDescription
            } else if let categoryDescription = inclusion.categoryDescription, !categoryDescription.isEmpty, categoryDescription != "Other" {
                return categoryDescription
            } else if let typeDescription = inclusion.typeDescription, !typeDescription.isEmpty, typeDescription != "Other" {
                return typeDescription
            } else {
                let category = inclusion.category ?? ""
                let fallback: String
                switch category.uppercased() {
                case "TRANSPORT", "TRANSPORTATION":
                    fallback = "Transportation included"
                case "GUIDE":
                    fallback = "Professional guide included"
                case "FOOD", "MEALS":
                    fallback = "Meals included"
                case "ADMISSION", "ENTRY":
                    fallback = "Admission tickets included"
                case "EQUIPMENT":
                    fallback = "Equipment provided"
                default:
                    if !category.isEmpty {
                        fallback = category.capitalized + " included"
                    } else {
                        return nil
                    }
                }
                return fallback
            }
        }
        if inclusionItems.isEmpty {
            inclusionItems = [
                "Professional guide",
                "All entrance fees",
                "Transportation as per itinerary",
                "Complimentary refreshments"
            ]
        }
        inclusions = [InfoDetailModel(title: "What's Included", items: inclusionItems)]
        let exclusionsArray = data.info?.exclusions ?? []
        var exclusionItems = exclusionsArray.compactMap { exclusion -> String? in
            if let description = exclusion.description, !description.isEmpty, description != "Other" {
                return description
            } else if let otherDescription = exclusion.otherDescription, !otherDescription.isEmpty, otherDescription != "Other" {
                return otherDescription
            } else if let categoryDescription = exclusion.categoryDescription, !categoryDescription.isEmpty, categoryDescription != "Other" {
                return categoryDescription
            } else if let typeDescription = exclusion.typeDescription, !typeDescription.isEmpty, typeDescription != "Other" {
                return typeDescription
            } else {
                let category = exclusion.category ?? ""
                let fallback: String
                switch category.uppercased() {
                case "TRANSPORT", "TRANSPORTATION":
                    fallback = "Transportation not included"
                case "GUIDE":
                    fallback = "Personal guide not included"
                case "FOOD", "MEALS", "MEAL":
                    fallback = "Food and drinks not included"
                case "ADMISSION", "ENTRY", "TICKET":
                    fallback = "Additional entrance fees not included"
                case "EQUIPMENT", "GEAR":
                    fallback = "Personal equipment not provided"
                case "INSURANCE":
                    fallback = "Travel insurance not included"
                case "GRATUITY", "TIP", "TIPS":
                    fallback = "Gratuities not included"
                case "HOTEL", "ACCOMMODATION":
                    fallback = "Hotel pickup/drop-off not included"
                case "SOUVENIR", "SHOPPING":
                    fallback = "Souvenirs and personal purchases not included"
                case "OTHER":
                    fallback = "Additional services not included"
                default:
                    if !category.isEmpty {
                        fallback = category.capitalized + " not included"
                    } else {
                        return nil
                    }
                }
                return fallback
            }
        }
        if !exclusionItems.isEmpty {
            exclusions = [InfoDetailModel(title: "What's Excluded", items: exclusionItems)]
        }
        let additionalInfoArray = data.info?.additionalInfo ?? []
        var highlightItems: [String] = []
        if !additionalInfoArray.isEmpty {
            highlightItems = additionalInfoArray.compactMap { info in
                let description = info.description ?? ""
                return description.isEmpty ? nil : description
            }
        }
        if !highlightItems.isEmpty {
            highlights = [InfoDetailModel(title: "Highlights", items: highlightItems)]
        }

        var knowBeforeGoItems: [String] = []
        if let ticketInfo = data.info?.ticketInfo {
            if let ticketDescription = ticketInfo.ticketTypeDescription, !ticketDescription.isEmpty {
                knowBeforeGoItems.append(ticketDescription)
            }
            if let ticketsPerBooking = ticketInfo.ticketsPerBookingDescription, !ticketsPerBooking.isEmpty {
                knowBeforeGoItems.append(ticketsPerBooking)
            }
        }
        if !knowBeforeGoItems.isEmpty {
            knowBeforeGo = [
                InfoDetailModel(title: "Know before you go", items: knowBeforeGoItems.filter { !$0.isEmpty })
            ]
        }
        meetingPoint = ""
        operatingDays = []
    }
}

// MARK: - Init Booking
extension ExperienceCheckoutViewModel {
    func initBook(guestDetails: GuestDetails? = nil) {
        isLoading = true
        guard let url = URL(string: Constants.APIURLs.initBookURL) else {
            errorMessage = Constants.ErrorMessages.invalidURL
            showToast(message: errorMessage ?? "")
            isLoading = false
            return
        }
        guard let reviewUid = reviewResponse?.data?.reviewUid, !reviewUid.isEmpty else {
            errorMessage = "Review UID not available. Please try again."
            showToast(message: "Review UID not available. Please try again.")
            isLoading = false
            return
        }
        let bookingDetails = InitBookingDetails(
            uid: reviewUid,
            quotation_id: "",
            coupon_code: "",
            applied_bounz: 0,
            pg_mode: "pg",
            special_request: "",
            local_taxes_fee: 0
        )
        let contactDetails = InitContactDetails(
            title: guestDetails?.title ?? "",
            first_name: guestDetails?.firstName ?? "",
            last_name: guestDetails?.lastName ?? "",
            email: guestDetails?.email ?? "",
            code: guestDetails?.mobileCountryCode ?? "91",
            mobile: guestDetails?.mobileNumber ?? ""
        )
        let languageDetails = InitLanguageDetails(
            type: "GUIDE",
            language: "en",
            legacy_guide: "en/SERVICE_GUIDE",
            name: "English"
        )
        let collectedAnswers = collectAllBookingAnswers()
        let travellerDetail = InitTravellerDetail(
            title: guestDetails?.title ?? "Mr",
            show_title: false,
            first_name: guestDetails?.firstName ?? "",
            last_name: guestDetails?.lastName ?? "",
            dob: "",
            height: "",
            weight: "",
            weight_unit: "kg",
            height_unit: "ft",
            age_band: "ADULT",
            passport_no: "",
            passport_exp: "",
            passport_nationality: "",
            passport_nationality_name: ""
        )
        let bookingQuestion = InitBookingQuestion(
            traveller_details: [travellerDetail],
            booking_questions_answers: collectedAnswers
        )
        let requestBody = InitBookRequest(
            booking_details: bookingDetails,
            contact_details: contactDetails,
            language_details: languageDetails,
            booking_question: bookingQuestion
        )
        let headers: [String: String] = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<InitBookResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let status = response.status, status, let data = response.data {
                        if let bookingId = data.booking_id {
                            self.orderNo = bookingId
                            if let successUrl = data.success_url {
                                self.paymentUrl = successUrl
                            }
                            self.shouldNavigateToPayment = true
                            return
                        } else {
                            self.showToast(message: "Booking failed, please try again")
                            self.errorMessage = "Booking ID not received"
                        }
                    } else if let error = response.error {
                        self.showToast(message: "Booking failed, please try again")
                        self.errorMessage = error.details
                    } else {
                        self.showToast(message: "Booking failed, please try again")
                        self.errorMessage = "Unknown error occurred"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                self.showToast(message: "Booking failed, please try again")
                self.isLoading = false
            }
        }
    }
}

// MARK: - Helpers
fileprivate extension DateFormatter {
    static func shortDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy"
        return formatter.string(from: date)
    }
    static func serverDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

extension Double {
    func formatToOneDecimal() -> String {
        return String(format: "%.1f", self)
    }
}

extension Double {
    func commaSeparated(locale: Locale = .current) -> String {
        let truncated = floor(self * 100) / 100   // ⬅️ truncate

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter.string(from: NSNumber(value: truncated)) ?? "\(truncated)"
    }
}

extension ExperienceCheckoutViewModel {
    func prepareBookingQuestionsForm() {
        let allSourceQuestions = questions ?? []
        let perBookingQuestions = allSourceQuestions.filter { $0.group == "PER_BOOKING" }
        let perTravelerQuestions = allSourceQuestions.filter { $0.group == "PER_TRAVELER" }

        bookingFields = []
        travellers = []
        
        var globalGuestCounter = 0

        for category in participants.sorted(by: { $0.sortOrder < $1.sortOrder }) {

            guard category.count > 0 else { continue }

            for _ in 1...Int(category.count) {
                globalGuestCounter += 1
                
                var questionsForThisGuest: [TravellerBookingQuestionModel] = []
                
                if globalGuestCounter == 1 {
                    questionsForThisGuest = perBookingQuestions + perTravelerQuestions
                } else {
                    questionsForThisGuest = perTravelerQuestions
                }

                let fields = questionsForThisGuest.map {
                    $0.toFormField()
                }

                var title = "Guest \(globalGuestCounter) - \(category.bandId.capitalized)"
                
                if globalGuestCounter == 1 {
                    title += " (Lead Traveler)"
                }

                let traveller = TravellerInstance(
                    bandId: category.bandId,
                    displayTitle: title,
                    fields: fields
                )
                travellers.append(traveller)
            }
        }
    }

    func getParticipantData(data: ReviewTourDetailData) {
            let selectedCounts = data.price?.pricePerAge ?? []
            
            let ageBandsMetadata = data.info?.ageBands ?? []
            
            var finalParticipants: [ParticipantCategory] = []
            
            for selection in selectedCounts {
                
                guard let bandId = selection.bandId,
                      let countDouble = selection.count,
                      countDouble > 0 else { continue }
                
                let count = Int(countDouble)
                
                if let meta = ageBandsMetadata.first(where: { $0.bandId == bandId }) {
                    
                    let category = ParticipantCategory(
                        type: meta.description ?? bandId,
                        ageRange: "(Age \(Int(meta.ageFrom ?? 0)) to \(Int(meta.ageTo ?? 0)))",
                        price: Int(selection.perPriceTraveller ?? 0),
                        count: count, // ✅ TAKEN FROM PRICE OBJECT (e.g., 2)
                        maxLimit: Int(meta.maxTravelersPerBooking ?? 99),
                        minLimit: Int(meta.minTravelersPerBooking ?? 0),
                        bandId: bandId,
                        sortOrder: Int(meta.sortOrder ?? 0),
                        isAdult: meta.adult ?? false
                    )
                    finalParticipants.append(category)
                    
                } else {
                    let category = ParticipantCategory(
                        type: bandId.capitalized,
                        ageRange: "",
                        price: Int(selection.perPriceTraveller ?? 0),
                        count: count, // ✅ TAKEN FROM PRICE OBJECT
                        maxLimit: 99,
                        minLimit: 0,
                        bandId: bandId,
                        sortOrder: 999, // Push to bottom if unknown
                        isAdult: bandId == "ADULT"
                    )
                    finalParticipants.append(category)
                }
            }
            
            self.participants = finalParticipants.sorted { $0.sortOrder < $1.sortOrder }
        }
}

extension ExperienceCheckoutViewModel {
    
    func prepareArrivalQuestions() {
        guard let details = pickupPointQuestion?.arrivalModeDetails else {
            self.arrivalPickupFields = []
            return
        }
        
        let rawQuestions = getQuestionsForArrival(mode: selectedArrivalMode, details: details)
        self.arrivalPickupFields = rawQuestions.map { $0.toFormField() }
    }
    
    func prepareDepartureQuestions() {
        guard let details = pickupPointQuestion?.departureModeDetails else {
            self.departurePickupFields = []
            return
        }
        
        let rawQuestions = getQuestionsForDeparture(mode: selectedDepartureMode, details: details)
        self.departurePickupFields = rawQuestions.map { $0.toFormField() }
    }
    
    // MARK: - Helpers for Mode Mapping
    
    private func getQuestionsForArrival(mode: PickupMode?, details: ModeDetails?) -> [TravellerBookingQuestionModel] {
        guard let modeString = mode?.mode else { return [] }
        switch modeString.uppercased() {
        case "AIR", "FLIGHT":
            return details?.flight ?? []
        case "RAIL", "TRAIN":
            return details?.rail ?? []
        case "SEA", "CRUISE":
            return details?.sea ?? []
        case "OTHER", "OTHERS", "HOTEL":
            return details?.hotel ?? []
        default:
            return []
        }
    }
    
    private func getQuestionsForDeparture(mode: PickupMode?, details: ModeDetails?) -> [TravellerBookingQuestionModel] {
        guard let modeString = mode?.mode else { return [] }
        
        switch modeString.uppercased() {
        case "AIR", "FLIGHT":
            return details?.flight ?? []
        case "RAIL", "TRAIN":
            return details?.rail ?? []
        case "SEA", "CRUISE":
            return details?.sea ?? []
        case "OTHER", "OTHERS", "HOTEL":
            return details?.hotel ?? []
        default:
            return []
        }
    }
}

extension ExperienceCheckoutViewModel {

    func validateTravellerForm(travellerId: UUID) {
        guard let index = travellers.firstIndex(where: { $0.id == travellerId }) else { return }
        
        var isFormValid = true
        
        for i in 0..<travellers[index].fields.count {
            let field = travellers[index].fields[i]
            travellers[index].fields[i].error = nil
            
            if field.isRequired {
                var isEmpty = false
                
                if field.type == .documentUpload {
                    isEmpty = (field.fileBase64?.isEmpty ?? true)
                } else {
                    // Standard Text Check
                    isEmpty = field.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }
                
                if isEmpty {
                    travellers[index].fields[i].error = "\(field.label) is required"
                    isFormValid = false
                }
            }
        }
        
        travellers[index].isValid = isFormValid
        checkAllFormsValid()
    }
    
    func checkAllFormsValid() {
        let areBookingFieldsValid = bookingFields.allSatisfy { field in
            if field.isRequired {
                return !field.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            return true
        }
        
        let areTravellersValid = travellers.allSatisfy { $0.isValid }
        
        self.areAllFormsValid = areBookingFieldsValid && areTravellersValid
    }
}

extension ExperienceCheckoutViewModel {
    func validatePickupDetails(selectedOption: PickupLocationType?) -> Bool {
        if let pickupPointQuestion = pickupPointQuestion, arrivalPickupModes?.isEmpty == false, departurePickupModes?.isEmpty == false {
            return true
        }
        guard selectedOption == .likeTobePickedUp else { return true }
        
        var isArrivalValid = true
        var isDepartureValid = true
        
        if let arrivalPickupModes = arrivalPickupModes, !arrivalPickupModes.isEmpty {
            for i in arrivalPickupFields.indices {
                let field = arrivalPickupFields[i]
                arrivalPickupFields[i].error = nil // Reset error
                
                if field.isRequired {
                    let isEmpty = field.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    if isEmpty {
                        arrivalPickupFields[i].error = "\(field.label) is required"
                        isArrivalValid = false
                    }
                }
            }
        }
        
        if let departurePickupModes = departurePickupModes, !departurePickupModes.isEmpty {
            for i in departurePickupFields.indices {
                let field = departurePickupFields[i]
                departurePickupFields[i].error = nil // Reset error
                
                if field.isRequired {
                    let isEmpty = field.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    if isEmpty {
                        departurePickupFields[i].error = "\(field.label) is required"
                        isDepartureValid = false
                    }
                }
            }
        }
        return isArrivalValid && isDepartureValid
    }
}

extension ExperienceCheckoutViewModel {
    /// Collects all answers from Travelers + Arrival + Departure + Modes
    func collectAllBookingAnswers() -> [bookingQuestionsDetails] {
        var allAnswers: [bookingQuestionsDetails] = []
        
        // MARK: 1. Map Traveler Questions
        for (index, traveler) in travellers.enumerated() {
            let travelerNumber = index + 1
            for field in traveler.fields {
                if let answerObj = createBookingAnswer(from: field, travelerNum: travelerNumber) {
                    allAnswers.append(answerObj)
                }
            }
        }
        
        // MARK: 2. Map Arrival Details
        for field in arrivalPickupFields {
            if let answerObj = createBookingAnswer(from: field, travelerNum: nil) {
                allAnswers.append(answerObj)
            }
        }
        
        // MARK: 3. Map Departure Details
        for field in departurePickupFields {
            if let answerObj = createBookingAnswer(from: field, travelerNum: nil) {
                allAnswers.append(answerObj)
            }
        }
        
        // MARK: 4. Map Selected Modes (Arrival/Departure)
        if let arrivalMode = selectedArrivalMode?.mode, !arrivalMode.isEmpty {
            let modeAnswer = bookingQuestionsDetails(
                question: "TRANSFER_ARRIVAL_MODE",
                answer: arrivalMode,
                unit: nil,
                travelerNum: nil
            )
            allAnswers.append(modeAnswer)
        }
        
        if let departureMode = selectedDepartureMode?.mode, !departureMode.isEmpty {
            let modeAnswer = bookingQuestionsDetails(
                question: "TRANSFER_DEPARTURE_MODE",
                answer: departureMode,
                unit: nil,
                travelerNum: nil
            )
            allAnswers.append(modeAnswer)
        }
        
        return allAnswers
    }
    
    // MARK: - Helper Logic
    
    private func createBookingAnswer(from field: FormField, travelerNum: Int?) -> bookingQuestionsDetails? {
        
        let effectiveTravelerNum: Int?
        if let group = field.group, group.caseInsensitiveCompare("PER_BOOKING") == .orderedSame {
            effectiveTravelerNum = nil
        } else {
            effectiveTravelerNum = travelerNum
        }

        // Handle Document Uploads
        if field.type == .documentUpload {
            // ✅ Send the Base64 String as the answer
            guard let base64 = field.fileBase64, !base64.isEmpty else { return nil }
            
            return bookingQuestionsDetails(
                question: field.id,
                answer: base64, // The API receives the actual Base64 data string here
                unit: nil,
                travelerNum: travelerNum
            )
        }

        // Handle Standard Fields (Text, Dropdowns, Date, etc.)
        guard !field.value.isEmpty else { return nil }
        
        var finalAnswer = field.value
        var finalUnit: String? = nil
        
        // Check Reference Logic
        if let reference = field.reference, !reference.isEmpty {
            if reference.caseInsensitiveCompare("other") == .orderedSame {
                // If user selected "Other" and typed text, send the text value + unit "FREETEXT"
                finalAnswer = field.value
                finalUnit = "FREETEXT"
            } else {
                // If user selected a standard option, send the Reference ID (e.g., "1", "2")
                finalAnswer = reference
                finalUnit = nil
            }
        }
        
        return bookingQuestionsDetails(
            question: field.id,
            answer: finalAnswer,
            unit: finalUnit,
            travelerNum: effectiveTravelerNum
        )
    }
}
