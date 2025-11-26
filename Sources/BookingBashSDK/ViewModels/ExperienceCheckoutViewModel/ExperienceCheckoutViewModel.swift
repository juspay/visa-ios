import Foundation
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
    @Published var currency: String = "AED"
    @Published var cancellationPolicy: String = ""
    @Published var highlights: [InfoDetailModel] = []
    @Published var inclusions: [InfoDetailModel] = []
    @Published var exclusions: [InfoDetailModel] = []
    @Published var cancellationPolicyData: [InfoDetailModel] = []
    @Published var knowBeforeGo: [InfoDetailModel] = []
    @Published var meetingPoint: String = ""
    @Published var operatingDays: [String] = []
    @Published var allFeatures: [FeatureItem] = []
    let productId: String
    private var selectedPackage: Package?
    private var availabilityResponse: AvailabilityApiResponse?
    private var uid: String?
    private var availabilityKey: String?
    init(productId: String) {
        self.productId = productId
    }
    func setSelectedPackage(_ package: Package) {
        self.selectedPackage = package
    }
    func setAvailabilityResponse(_ response: AvailabilityApiResponse?) {
        self.availabilityResponse = response
        if let response = response {
        }
    }
    func setUid(_ uid: String) {
        self.uid = uid
    }
    func setAvailabilityKey(_ key: String) {
        self.availabilityKey = key
    }
    var formattedTotalAmount: String {
        totalAmount.map { String(format: "%.2f", $0) } ?? "--"
    }
    func formattedSelectedDate(_ date: Date) -> String {
        DateFormatter.shortDateString(from: date)
    }
    func handlePayNowTapped(guestDetails: GuestDetails, isConsentBoxChecked: Bool) {
        let allowedTitles = ["Mr", "Ms", "Mrs", "Dr"]
        let trimmedTitle = guestDetails.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty || !allowedTitles.contains(trimmedTitle) {
            showToast(message: "Please select title")
            return
        }
        if let error = validateMobile(guestDetails.mobileNumber, forCode: guestDetails.mobileCountryCode) {
            showToast(message: error)
            return
        }
        guard isConsentBoxChecked else {
            showToast(message: Constants.CheckoutPageConstants.consentBoxError)
            return
        }
        isLoading = true
        initBook(guestDetails: guestDetails)
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
    func validateMobile(_ mobile: String, forCode code: String) -> String? {
        let trimmed = mobile.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return Constants.ErrorMessages.emptyMobileNumber }
        guard let selected = MobileCodeData.allCodes.first(where: { $0.dialCode == code }) else {
            return Constants.ErrorMessages.invalidCountryCodeOrMobile
        }
        guard trimmed.count == selected.maxCharLimit else {
            return "\(selected.name) mobile number should be exactly \(selected.maxCharLimit) digits."
        }
        return nil
    }
}

// MARK: - Fetch Data
extension ExperienceCheckoutViewModel {
    func fetchData() {
        fetchReviewDetails()
        fetchImageList()
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
            rateCode: subActivityCode
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
                        self.showErrorOverlay = true
                        self.showNoResultImage = true
                        return
                    }
                    if let status = response.status, status, let data = response.data {
                        self.totalAmount = data.price?.totalAmount
                        self.location = "\(data.info?.city ?? "")-\(data.info?.country ?? "")"
                        self.reviewResponse = response
                        self.setUiData(responseData: data)
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
            if let pricePerAges = reviewResponse?.data?.tourOption?.rates?.first?.price?.pricePerAge {
                for item in pricePerAges {
                    if let bandId = item.bandId,
                       let count = item.count,
                       let bandTotal = item.bandTotal,
                       let perPriceTraveller = item.perPriceTraveller {
                        let descriptionText = count > 1
                        ? "\(bandId.capitalized)s"
                        : bandId.capitalized
                        let leftText = "\(Int(count)) \(descriptionText) x AED \( perPriceTraveller)"
                        let rightText = "AED \( bandTotal )"
                        fairSummaryData.append(
                            FareItem(title: leftText, value: rightText, isDiscount: false)
                        )
                    }
                }
            }
            if let taxes = price.taxes, taxes > 0 {
                fairSummaryData.append(FareItem(
                    title: "Taxes and fees",
                    value: "AED \(String(format: "%.2f", taxes))",
                    isDiscount: false
                ))
            }
            if let strikeout = price.strikeout,
               let originalAmount = strikeout.totalAmount,
               let currentAmount = price.totalAmount,
               originalAmount > currentAmount {
                let discountAmount = originalAmount - currentAmount
                fairSummaryData.append(FareItem(
                    title: "Discount",
                    value: "- AED \(String(format: "%.2f", discountAmount))",
                    isDiscount: true
                ))
                savingsTextforFareBreakup = "You are saving AED \(String(format: "%.2f", discountAmount))"
            } else {
                savingsTextforFareBreakup = "You are saving AED \(String(format: "%.2f", 0.0)) "
                fairSummaryData.append(FareItem(
                    title: "Discount",
                    value: "- AED 0.00",
                    isDiscount: true
                ))
            }
        }
        experienceTitle = data.info?.title ?? ""
        experienceDescription = data.info?.description ?? ""
        duration = data.info?.duration?.display ?? ""
        currency = data.price?.currency ?? "AED"
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
        if exclusionItems.isEmpty {
            exclusionItems = [
                "Personal expenses",
                "Gratuities",
                "Food and beverages (unless specified)",
                "Travel insurance"
            ]
        }
        exclusions = [InfoDetailModel(title: "What's Excluded", items: exclusionItems)]
        let additionalInfoArray = data.info?.additionalInfo ?? []
        var highlightItems: [String] = []
        if !additionalInfoArray.isEmpty {
            highlightItems = additionalInfoArray.compactMap { info in
                let description = info.description ?? ""
                return description.isEmpty ? nil : description
            }
        }
        if highlightItems.isEmpty {
            highlightItems = [
                "Experience authentic local culture",
                "Visit iconic landmarks and hidden gems",
                "Learn from knowledgeable local guides",
                "Small group for personalized experience"
            ]
        }
        highlights = [InfoDetailModel(title: "Highlights", items: highlightItems)]
        var knowBeforeGoItems: [String] = []
        if let ticketInfo = data.info?.ticketInfo {
            if let ticketDescription = ticketInfo.ticketTypeDescription, !ticketDescription.isEmpty {
                knowBeforeGoItems.append(ticketDescription)
            }
            if let ticketsPerBooking = ticketInfo.ticketsPerBookingDescription, !ticketsPerBooking.isEmpty {
                knowBeforeGoItems.append(ticketsPerBooking)
            }
        }
        if knowBeforeGoItems.isEmpty {
            knowBeforeGoItems = [
                "Please arrive 15 minutes before the scheduled start time",
                "Comfortable walking shoes recommended",
                "Bring valid ID for verification",
                "Activity may be affected by weather conditions"
            ]
        }
        knowBeforeGo = [
            InfoDetailModel(title: "Know before you go", items: knowBeforeGoItems.filter { !$0.isEmpty })
        ]
        meetingPoint = ""
        operatingDays = []
    }
}


// MARK: - Init Booking
extension ExperienceCheckoutViewModel {
    func initBook(guestDetails: GuestDetails? = nil) {
        guard let url = URL(string: Constants.APIURLs.initBookURL) else {
            errorMessage = Constants.ErrorMessages.invalidURL
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
        let earningDetails = InitEarningDetails(
            agent_markup: 0,
            total_amount: Int(totalAmount ?? 0),
            type: "",
            display_markup: [:]
        )
        let gstDetails = InitGSTDetails(
            addr: "",
            org_name: "",
            email: "",
            gst_no: "",
            contact_no: "",
            isd_code: ""
        )
        let pickupDetails = InitPickupDetails(
            provider: "TRIPADVISOR",
            reference: "",
            name: "OTHER",
            address: "",
            city: "",
            country: "",
            pickup_type: "HOTEL",
            type: "FREETEXT"
        )
        let languageDetails = InitLanguageDetails(
            type: "GUIDE",
            language: "en",
            legacy_guide: "en/SERVICE_GUIDE",
            name: "English"
        )
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
        let arrivalDetail = InitTravelDetail(
            mode: "AIR",
            name: "",
            airline: "",
            flight_number: "",
            rail_line: "",
            station: "",
            port_name: "",
            terminal: "",
            hotel_name: "",
            address: "",
            date: "",
            time: "",
            reference_value: "",
            remarks: ""
        )
        let departureDetail = InitTravelDetail(
            mode: "RAIL",
            name: "",
            airline: "",
            flight_number: "",
            rail_line: "",
            station: "",
            port_name: "",
            terminal: "",
            hotel_name: "",
            address: "",
            date: "",
            time: "",
            reference_value: "",
            remarks: ""
        )
        let bookingQuestion = InitBookingQuestion(
            traveller_details: [travellerDetail],
            arrival: arrivalDetail,
            departure: departureDetail
        )
        let requestBody = InitBookRequest(
            booking_details: bookingDetails,
            contact_details: contactDetails,
            earning_details: earningDetails,
            gst_details: gstDetails,
            pickup_details: pickupDetails,
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
                        } else {
                            self.errorMessage = "Booking ID not received"
                        }
                    } else if let error = response.error {
                        self.errorMessage = error.details
                    } else {
                        self.errorMessage = "Unknown error occurred"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
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
