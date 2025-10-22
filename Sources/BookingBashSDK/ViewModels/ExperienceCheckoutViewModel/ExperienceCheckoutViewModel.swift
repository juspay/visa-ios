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
    @Published var shouldNavigateToTerms = false
    @Published var shouldNavigateToPrivacy = false
    @Published var isLoading: Bool = false // Added property to track loading state
    
    // Additional UI data properties - Updated to match details page structure
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
    private var selectedPackage: Package? // Added to store the selected package from availability view
    private var availabilityResponse: AvailabilityApiResponse? // Added to store availability response for track_id
    private var uid: String? // Added to store uid from availability
    private var availabilityKey: String? // Added to store availabilityKey from availability
    
    init(productId: String) {
        self.productId = productId
    }
    
    // Method to set the selected package from the availability view
    func setSelectedPackage(_ package: Package) {
        self.selectedPackage = package
        // 🔍 LOG: Print package details when set
        print("🔍 [CHECKOUT] Setting selected package:")
        print("   - Package title: '\(package.title)'")
        print("   - subActivityCode: '\(package.subActivityCode ?? "nil")'")
        print("   - activityCode: '\(package.activityCode ?? "nil")'")
    }
    
    // Method to set the availability response to access track_id
    func setAvailabilityResponse(_ response: AvailabilityApiResponse?) {
        self.availabilityResponse = response
        // 🔍 LOG: Print availability response details
        if let response = response {
            print("🔍 [CHECKOUT] Setting availability response:")
            print("   - trackId: '\(response.data?.trackId ?? "nil")'")
            print("   - uid: '\(response.data?.uid ?? "nil")'")
        }
    }
    
    // Method to set the uid from the view
    func setUid(_ uid: String) {
        self.uid = uid
        print("🔍 [CHECKOUT] Setting uid: '\(uid)'")
    }
    
    // Method to set the availabilityKey from the view
    func setAvailabilityKey(_ key: String) {
        self.availabilityKey = key
        print("🔍 [CHECKOUT] Setting availabilityKey: '\(key)'")
    }
    
    var formattedTotalAmount: String {
        totalAmount.map { String(format: "%.2f", $0) } ?? "--"
    }
    
    func formattedSelectedDate(_ date: Date) -> String {
        DateFormatter.shortDateString(from: date)
    }
    
    func handlePayNowTapped(guestDetails: GuestDetails, isConsentBoxChecked: Bool) {
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
        print(Constants.CheckoutPageConstants.termsAndConditionsTapped)
        shouldNavigateToTerms = true
    }
    func handlePrivacyTapped() {
        print(Constants.CheckoutPageConstants.privacyPolicyTapped)
        shouldNavigateToPrivacy = true
    }
    
    private func showToast(message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
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
        // Fetch both review details and image list
        fetchReviewDetails()
        fetchImageList()
    }
    
    private func fetchReviewDetails() {
        guard let url = URL(string: Constants.APIURLs.reviewDetailsURL) else { return }
        
//        let rateCode = selectedPackage?.subActivityCode ?? ""
        let activityCode = selectedPackage?.activityCode ?? ""
        
        // Use dynamic values instead of constants
//        let requestUid = uid ?? Constants.API.reviewDetailsUID
        
        // Construct availabilityId as "uid||availabilityKey"
//        let requestAvailabilityId: String
//        if let uid = uid, let key = availabilityKey, !key.isEmpty {
//
//        } else {
//            requestAvailabilityId = Constants.API.reviewDetailsAvailabilityID
//        }
     let requestAvailabilityId = "\(avalabulityUid)||\(availablityKey)"
        
        let requestBody = ReviewDetailsRequestModel(
            uid: detaislUid,
            availabilityId: requestAvailabilityId,
            quoteId: "",
            enquiryId: "",
            activityCode: activityCode,
            rateCode: subActivityCode
        )
        
        print("🔍 [CHECKOUT] Review Details Request:")
  
      
        
        let headers: [String: String] = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
           Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
           Constants.APIHeaders.siteId: ssoSiteIdGlobal,
           Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
        print(requestBody)
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<ReviewTourDetailResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("🔍 [CHECKOUT] Review Details Response:")
                    print("   - status: \(response.status ?? false)")
                    print("   - statusCode: \(response.statusCode ?? 0)")
                    print(response.data?.reviewUid ?? "tatatatattat")

                    if let status = response.status, status, let data = response.data {
                        // Success: safe to use data
                        self.totalAmount = data.price?.totalAmount
                        self.location = "\(data.info?.city ?? "")-\(data.info?.country ?? "")"
                        self.reviewResponse = response
                        self.setUiData(responseData: data)
                        self.updateCarouselData(from: data)
                        print("✅ [CHECKOUT] Successfully processed ReviewTourDetailResponse")
                        print("   - Total Amount: \(data.price?.totalAmount ?? 0)")
                        print("   - Location: \(self.location ?? "N/A")")
                    } else if let error = response.error {
                        // API returned an error
                        self.errorMessage = error.details
                        self.showToast(message: error.details)
                        print("❌ [CHECKOUT] API Error: \(error.type) - \(error.details)")
                    } else {
                        self.errorMessage = "Unknown API error"
                        self.showToast(message: "Unknown API error")
                        print("❌ [CHECKOUT] Unknown API error, data empty")
                    }

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showToast(message: error.localizedDescription)
                    print("❌ [CHECKOUT] Network request failed: \(error.localizedDescription)")
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
        
        print("🖼️ Fetching image list for activity code: \(activityCode)")
        
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<ImageListResponse, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if let imageData = response.data {
                        self.updateCarouselWithImages(imageData: imageData)
                        print("🖼️ Successfully fetched \(imageData.count) images for carousel")
                    } else {
                        print("🖼️ No image data in response")
                        // Keep the existing single thumbnail image if no images from API
                        if let reviewData = self.reviewResponse?.data {
                            self.carousalData = [ExperienceDetailCarousalModel(imageUrl: reviewData.info?.thumbnail ?? "")]
                        }
                    }
                case .failure(let error):
                    print("🖼️ Failed to fetch images: \(error.localizedDescription)")
                    // Keep the existing single thumbnail image on failure
                    if let reviewData = self.reviewResponse?.data {
                        self.carousalData = [ExperienceDetailCarousalModel(imageUrl: reviewData.info?.thumbnail ?? "")]
                    }
                }
            }
        }
    }
    
    private func updateCarouselWithImages(imageData: ImageListData) {
        var carouselImages: [ExperienceDetailCarousalModel] = []
        
        // Process the image results
        for imageResult in imageData.result {
            // Find the best quality image for carousel display
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
        
        // Update carousel data with fetched images
        if !carouselImages.isEmpty {
            carousalData = carouselImages
            print("🖼️ Updated carousel with \(carouselImages.count) images")
        } else {
            // Fallback to thumbnail if no valid images found
            if let reviewData = reviewResponse?.data {
                carousalData = [ExperienceDetailCarousalModel(imageUrl: reviewData.info?.thumbnail ?? "")]
                print("🖼️ Using fallback thumbnail image")
            }
        }
    }

    // Method to update carousel data from review response
    private func updateCarouselData(from data: ReviewTourDetailData) {
        // Start with thumbnail from review data
        if let thumbnail = data.info?.thumbnail, !thumbnail.isEmpty {
            carousalData = [ExperienceDetailCarousalModel(imageUrl: thumbnail)]
            print("🖼️ [CHECKOUT] Updated carousel with thumbnail: \(thumbnail)")
        }
        
        // If you want to fetch more images, uncomment the line below
        // fetchImageList()
    }

    func setUiData(responseData: ReviewTourDetailData?) {
        guard let data = responseData else {
            print("❌ [CHECKOUT] setUiData called with nil data")
            return
        }
        
        print("🔍 [CHECKOUT] ========== Starting setUiData ==========")
        print("🔍 [CHECKOUT] Response data exists: \(data.info != nil)")
        
        // Print the entire API response structure for debugging
        print("🔍 [CHECKOUT] Full API Response Structure:")
        print("   - trackId: \(data.trackId ?? "nil")")
        print("   - reviewUid: \(data.reviewUid ?? "nil")")
        print("   - info exists: \(data.info != nil)")
        
        print(data.reviewUid ?? "")
        if let info = data.info {
            print("🔍 [CHECKOUT] Info Structure:")
            print("   - title: '\(info.title ?? "nil")'")
            print("   - additionalInfo count: \(info.additionalInfo?.count ?? 0)")
            print("   - inclusions count: \(info.inclusions?.count ?? 0)")
            print("   - exclusions count: \(info.exclusions?.count ?? 0)")
            print("   - cancellationPolicy exists: \(info.cancellationPolicy != nil)")
            print("   - ticketInfo exists: \(info.ticketInfo != nil)")
            print("   - duration exists: \(info.duration != nil)")
            
            // Print each additionalInfo item
            if let additionalInfo = info.additionalInfo {
                for (index, item) in additionalInfo.enumerated() {
                    print("   - additionalInfo[\(index)]: type='\(item.type ?? "nil")', description='\(item.description ?? "nil")'")
                }
            }
            
            // Print each inclusion item
            if let inclusions = info.inclusions {
                for (index, item) in inclusions.enumerated() {
                    print("   - inclusion[\(index)]: category='\(item.category ?? "nil")', description='\(item.description ?? "nil")'")
                }
            }
            
            // Print each exclusion item
            if let exclusions = info.exclusions {
                for (index, item) in exclusions.enumerated() {
                    print("   - exclusion[\(index)]: category='\(item.category ?? "nil")', description='\(item.description ?? "nil")'")
                }
            }
            
            // Print cancellation policy
            if let cancellationPolicy = info.cancellationPolicy {
                print("   - cancellationPolicy description: '\(cancellationPolicy.description ?? "nil")'")
                print("   - refundEligibility count: \(cancellationPolicy.refundEligibility?.count ?? 0)")
            }
        }
        
        fairSummaryData.removeAll()
        
        print("🔍 [CHECKOUT] ========== Processing Fare Summary ==========")
        print("🔍 [CHECKOUT] data.price exists: \(data.price != nil)")
        
        // Use data.price object directly (summary price at the top level)
        if let price = data.price {
            print("🔍 [CHECKOUT] Price object exists: true")
            print("🔍 [CHECKOUT] Base rate: \(price.baseRate ?? 0)")
            print("🔍 [CHECKOUT] Taxes: \(price.taxes ?? 0)")
            print("🔍 [CHECKOUT] Total amount: \(price.totalAmount ?? 0)")
            print("🔍 [CHECKOUT] Strikeout exists: \(price.strikeout != nil)")
            if let strikeout = price.strikeout {
                print("🔍 [CHECKOUT] Strikeout total: \(strikeout.totalAmount ?? 0)")
            }
            
            // Add base rate
//            if let baseRate = price.baseRate {
//                let leftText = "1 Adults x AED \(String(format: "%.1f", baseRate))"
//                let rightText = "AED \(String(format: "%.2f", baseRate))"
//
//                fairSummaryData.append(FareItem(
//                    title: leftText,
//                    value: rightText,
//                    isDiscount: false
//                ))
//                print("🔍 [CHECKOUT] ✅ Added base rate fare item: \(leftText) = \(rightText)")
//            }
            if let pricePerAges = reviewResponse?.data?.tourOption?.rates?.first?.price?.pricePerAge {
                            print("🔍 Found pricePerAge array with \(pricePerAges.count) items")

                            for item in pricePerAges {
                                if let bandId = item.bandId,
                                   let count = item.count,
                                   let bandTotal = item.bandTotal,
                                   let perPriceTraveller = item.perPriceTraveller {

                                    let descriptionText = count > 1
                                        ? "\(bandId.capitalized)s"
                                        : bandId.capitalized

                                    let leftText = "\(Int(count)) \(descriptionText) x AED \(String(format: "%.1f", perPriceTraveller))"
                                    let rightText = "AED \(String(format: "%.2f", bandTotal ))"

                                    fairSummaryData.append(
                                        FareItem(title: leftText, value: rightText, isDiscount: false)
                                    )

                                    print("✅ Added Fare Item → \(leftText) = \(rightText)")
                                } else {
                                    print("⚠️ Skipped one price item because of missing data: \(item)")
                                }
                            }
                        } else {
                            print("⚠️ No pricePerAge data found in tourOption rates")
                        }
            // Add taxes if available and greater than 0
            if let taxes = price.taxes, taxes > 0 {
                fairSummaryData.append(FareItem(
                    title: "Taxes and fees",
                    value: "AED \(String(format: "%.2f", taxes))",
                    isDiscount: false
                ))
                print("🔍 [CHECKOUT] ✅ Added taxes fare item: AED \(String(format: "%.2f", taxes))")
            }
            
            // Always show Discount (even if no strikeout price)
            if let strikeout = price.strikeout,
               let originalAmount = strikeout.totalAmount,
               let currentAmount = price.totalAmount,
               originalAmount > currentAmount {
                
                // Valid discount case
                let discountAmount = originalAmount - currentAmount
                fairSummaryData.append(FareItem(
                    title: "Discount",
                    value: "- AED \(String(format: "%.2f", discountAmount))",
                    isDiscount: true
                ))
                
                savingsTextforFareBreakup = "You saveing AED \(String(format: "%.2f", discountAmount))"
                print("🔍 [CHECKOUT] ✅ Added discount fare item: - AED \(String(format: "%.2f", discountAmount))")
                
            } else {
                // No strikeout or no discount, still append
                savingsTextforFareBreakup = "You are saving AED \(String(format: "%.2f", 0.0)) "

                fairSummaryData.append(FareItem(
                    title: "Discount",
                    value: "- AED 0.00",
                    isDiscount: true
                ))
                print("🔍 [CHECKOUT] ⚪ No strikeout price, added default discount item: - AED 0.00")
            }

        } else {
            print("❌ [CHECKOUT] No price object found in data!")
        }
        
        print("🔍 [CHECKOUT] Final fairSummaryData count: \(fairSummaryData.count)")
        for (index, item) in fairSummaryData.enumerated() {
            print("🔍 [CHECKOUT] Fare item [\(index)]: \(item.title) = \(item.value)")
        }
        print("🔍 [CHECKOUT] ========================================")
        
        // Set basic UI data properties
        experienceTitle = data.info?.title ?? ""
        experienceDescription = data.info?.description ?? ""
        duration = data.info?.duration?.display ?? ""
        currency = data.price?.currency ?? "AED"
        cancellationPolicy = data.info?.cancellationPolicy?.description ?? ""
        
        print("🔍 [CHECKOUT] Basic data populated:")
        print("   - Title: '\(experienceTitle)'")
        print("   - Duration: '\(duration)'")
        
        // Build location string from available data
        var locationParts: [String] = []
        if let city = data.info?.city, !city.isEmpty {
            locationParts.append(city)
        }
        if let country = data.info?.country, !country.isEmpty {
            locationParts.append(country)
        }
        location = locationParts.joined(separator: ", ")
        
        // Features - Add duration and other feature information
        var features: [FeatureItem] = []
        
        // Add duration if available
        let durationDisplay = data.info?.duration?.display ?? ""
        print("🔍 [CHECKOUT] Duration display: '\(durationDisplay)'")
        if !durationDisplay.isEmpty {
            features.append(FeatureItem(iconName: "clock.fill", title: durationDisplay))
            print("🔍 [CHECKOUT] ✅ Added duration feature: '\(durationDisplay)'")
        }
        
        allFeatures = features
        print("🔍 [CHECKOUT] Total Features count: \(allFeatures.count)")
        
        // Cancellation Policy - Include refund eligibility details like details page
        var cancellationItems: [String] = []
        if let description = data.info?.cancellationPolicy?.description, !description.isEmpty {
            cancellationItems.append(description)
            print("🔍 [CHECKOUT] Added cancellation description: '\(description)'")
        }
        
        // Add refund eligibility details if available
        if let refundEligibility = data.info?.cancellationPolicy?.refundEligibility {
            print("🔍 [CHECKOUT] Processing \(refundEligibility.count) refund eligibility items")
            for refund in refundEligibility {
                if let maxDays = refund.dayRangeMax {
                    let item = "\(refund.percentageRefundable ?? 0)% refund if cancelled between \(refund.dayRangeMin ?? 0) and \(maxDays) days before"
                    cancellationItems.append(item)
                    print("🔍 [CHECKOUT] Added refund item: '\(item)'")
                } else {
                    let item = "\(refund.percentageRefundable ?? 0)% refund if cancelled \(refund.dayRangeMin ?? 0)+ days before"
                    cancellationItems.append(item)
                    print("🔍 [CHECKOUT] Added refund item: '\(item)'")
                }
            }
        }
        
        // Add fallback cancellation policy if no data available
        if cancellationItems.isEmpty {
            cancellationItems.append("Free cancellation available")
            cancellationItems.append("Cancel up to 24 hours before the experience starts for a full refund")
            print("🔍 [CHECKOUT] Added fallback cancellation policy")
        }
        
        cancellationPolicyData = [
            InfoDetailModel(title: "Cancellation Policy", items: cancellationItems.filter { !$0.isEmpty })
        ]
        
        // Inclusions - Use sophisticated logic from details page with fallback descriptions
        let inclusionsArray = data.info?.inclusions ?? []
        print("🔍 [CHECKOUT] Processing inclusions count: \(inclusionsArray.count)")
        
        var inclusionItems = inclusionsArray.compactMap { inclusion -> String? in
            print("🔍 [CHECKOUT] Processing inclusion:")
            print("   - description: '\(inclusion.description ?? "nil")'")
            print("   - category: '\(inclusion.category ?? "nil")'")
            print("   - categoryDescription: '\(inclusion.categoryDescription ?? "nil")'")
            print("   - typeDescription: '\(inclusion.typeDescription ?? "nil")'")
            print("   - otherDescription: '\(inclusion.otherDescription ?? "nil")'")
            
            // Priority order: description -> otherDescription -> categoryDescription -> typeDescription
            if let description = inclusion.description, !description.isEmpty, description != "Other" {
                print("   ✅ Using description: '\(description)'")
                return description
            } else if let otherDescription = inclusion.otherDescription, !otherDescription.isEmpty, otherDescription != "Other" {
                print("   ✅ Using otherDescription: '\(otherDescription)'")
                return otherDescription
            } else if let categoryDescription = inclusion.categoryDescription, !categoryDescription.isEmpty, categoryDescription != "Other" {
                print("   ✅ Using categoryDescription: '\(categoryDescription)'")
                return categoryDescription
            } else if let typeDescription = inclusion.typeDescription, !typeDescription.isEmpty, typeDescription != "Other" {
                print("   ✅ Using typeDescription: '\(typeDescription)'")
                return typeDescription
            } else {
                // If all fields are "Other" or empty, create meaningful description from category
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
                        return nil // Skip if completely empty
                    }
                }
                print("   ✅ Using fallback: '\(fallback)' for category: '\(category)'")
                return fallback
            }
        }
        
        // Add fallback inclusions if no data available
        if inclusionItems.isEmpty {
            inclusionItems = [
                "Professional guide",
                "All entrance fees",
                "Transportation as per itinerary",
                "Complimentary refreshments"
            ]
            print("🔍 [CHECKOUT] Added fallback inclusions")
        }
        
        inclusions = [InfoDetailModel(title: "What's Included", items: inclusionItems)]
        
        // Exclusions - Use sophisticated logic from details page with fallback descriptions
        let exclusionsArray = data.info?.exclusions ?? []
        print("🔍 [CHECKOUT] Processing exclusions count: \(exclusionsArray.count)")
        
        var exclusionItems = exclusionsArray.compactMap { exclusion -> String? in
            print("🔍 [CHECKOUT] Processing exclusion:")
            print("   - description: '\(exclusion.description ?? "nil")'")
            print("   - category: '\(exclusion.category ?? "nil")'")
            print("   - categoryDescription: '\(exclusion.categoryDescription ?? "nil")'")
            print("   - typeDescription: '\(exclusion.typeDescription ?? "nil")'")
            print("   - otherDescription: '\(exclusion.otherDescription ?? "nil")'")
            
            // Priority order: description -> otherDescription -> categoryDescription -> typeDescription
            if let description = exclusion.description, !description.isEmpty, description != "Other" {
                print("   ✅ Using description: '\(description)'")
                return description
            } else if let otherDescription = exclusion.otherDescription, !otherDescription.isEmpty, otherDescription != "Other" {
                print("   ✅ Using otherDescription: '\(otherDescription)'")
                return otherDescription
            } else if let categoryDescription = exclusion.categoryDescription, !categoryDescription.isEmpty, categoryDescription != "Other" {
                print("   ✅ Using categoryDescription: '\(categoryDescription)'")
                return categoryDescription
            } else if let typeDescription = exclusion.typeDescription, !typeDescription.isEmpty, typeDescription != "Other" {
                print("   ✅ Using typeDescription: '\(typeDescription)'")
                return typeDescription
            } else {
                // If all fields are "Other" or empty, create meaningful description from category
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
                        return nil // Skip if completely empty
                    }
                }
                print("   ✅ Using fallback: '\(fallback)' for category: '\(category)'")
                return fallback
            }
        }
        
        // Add fallback exclusions if no data available
        if exclusionItems.isEmpty {
            exclusionItems = [
                "Personal expenses",
                "Gratuities",
                "Food and beverages (unless specified)",
                "Travel insurance"
            ]
            print("🔍 [CHECKOUT] Added fallback exclusions")
        }
        
        exclusions = [InfoDetailModel(title: "What's Excluded", items: exclusionItems)]
        
        // Highlights - Use additionalInfo from API response
        let additionalInfoArray = data.info?.additionalInfo ?? []
        print("🔍 [CHECKOUT] Processing additionalInfo for highlights count: \(additionalInfoArray.count)")
        
        var highlightItems: [String] = []
        if !additionalInfoArray.isEmpty {
            highlightItems = additionalInfoArray.compactMap { info in
                let description = info.description ?? ""
                print("🔍 [CHECKOUT] AdditionalInfo item: type='\(info.type ?? "nil")', description='\(description)'")
                return description.isEmpty ? nil : description
            }
        }
        
        // Add fallback highlights if no data available
        if highlightItems.isEmpty {
            highlightItems = [
                "Experience authentic local culture",
                "Visit iconic landmarks and hidden gems",
                "Learn from knowledgeable local guides",
                "Small group for personalized experience"
            ]
            print("🔍 [CHECKOUT] Added fallback highlights")
        }
        
        highlights = [InfoDetailModel(title: "Highlights", items: highlightItems)]
        
        // Know Before You Go - Use ticket info and additional information
        var knowBeforeGoItems: [String] = []
        
        // Add ticket info if available
        if let ticketInfo = data.info?.ticketInfo {
            print("🔍 [CHECKOUT] Processing ticketInfo:")
            print("   - ticketTypeDescription: '\(ticketInfo.ticketTypeDescription ?? "nil")'")
            print("   - ticketsPerBookingDescription: '\(ticketInfo.ticketsPerBookingDescription ?? "nil")'")
            
            if let ticketDescription = ticketInfo.ticketTypeDescription, !ticketDescription.isEmpty {
                knowBeforeGoItems.append(ticketDescription)
            }
            if let ticketsPerBooking = ticketInfo.ticketsPerBookingDescription, !ticketsPerBooking.isEmpty {
                knowBeforeGoItems.append(ticketsPerBooking)
            }
        } else {
            print("🔍 [CHECKOUT] No ticketInfo available")
        }
        
        // Add fallback know before you go items if no data available
        if knowBeforeGoItems.isEmpty {
            knowBeforeGoItems = [
                "Please arrive 15 minutes before the scheduled start time",
                "Comfortable walking shoes recommended",
                "Bring valid ID for verification",
                "Activity may be affected by weather conditions"
            ]
            print("🔍 [CHECKOUT] Added fallback know before you go items")
        }
        
        knowBeforeGo = [
            InfoDetailModel(title: "Know before you go", items: knowBeforeGoItems.filter { !$0.isEmpty })
        ]
        
        // Meeting point and operating days - these properties may not exist in ReviewTourInfo
        meetingPoint = ""  // Set empty since property doesn't exist in this model
        operatingDays = [] // Set empty since property doesn't exist in this model
        
        print("🔍 [CHECKOUT] ========== Final Summary ==========")
        print("   - Highlights: \(highlights.first?.items.count ?? 0) items")
        print("   - Inclusions: \(inclusions.first?.items.count ?? 0) items")
        print("   - Exclusions: \(exclusions.first?.items.count ?? 0) items")
        print("   - Cancellation Policy: \(cancellationPolicyData.first?.items.count ?? 0) items")
        print("   - Know Before Go: \(knowBeforeGo.first?.items.count ?? 0) items")
        print("   - Features: \(allFeatures.count) items")
        print("🔍 [CHECKOUT] ========================================")
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
        
        // Get review_uid from the review response
        guard let reviewUid = reviewResponse?.data?.reviewUid, !reviewUid.isEmpty else {
            errorMessage = "Review UID not available. Please try again."
            showToast(message: "Review UID not available. Please try again.")
            print("❌ [INIT BOOK] Review UID is missing from review response")
            isLoading = false
            return
        }
        
        print("🔍 [INIT BOOK] ========== Starting Init Book ==========")
        print("🔍 [INIT BOOK] Using review_uid: '\(reviewUid)'")
        print("🔍 [INIT BOOK] Guest details: \(guestDetails?.firstName ?? "nil") \(guestDetails?.lastName ?? "nil")")
        
        // Create sub-expressions to help compiler type-checking
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
            title: guestDetails?.title ?? "Mr",
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
        
        // Construct the main request body with sub-expressions
        let requestBody = InitBookRequest(
            booking_details: bookingDetails,
            contact_details: contactDetails,
            earning_details: earningDetails,
            gst_details: gstDetails,
            pickup_details: pickupDetails,
            language_details: languageDetails,
            booking_question: bookingQuestion
        )
        
        print("🔍 [INIT BOOK] Request constructed:")
        print("   - UID: '\(reviewUid)'")
        print("   - Contact: \(contactDetails.first_name) \(contactDetails.last_name)")
        print("   - Email: \(contactDetails.email)")
        print("   - Mobile: +\(contactDetails.code) \(contactDetails.mobile)")
        print("   - Total Amount: \(earningDetails.total_amount)")
        
        let headers: [String: String] = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
           Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
           Constants.APIHeaders.siteId: ssoSiteIdGlobal,
           Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
        print("🔍 [INIT BOOK] Headers set for request")
        print(requestBody)
        print(headers)
        print(url)
        
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<InitBookResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("🔍 [INIT BOOK] Response received:")
                    print("   - Status: \(response.status ?? false)")
                    print("   - Status Code: \(response.status_code ?? 0)")
                    
                    if let status = response.status, status, let data = response.data {
                        print("✅ [INIT BOOK] Success!")
                        print("   - Booking ID: '\(data.booking_id ?? "nil")'")
                        print("   - PG Token: '\(data.pg_token ?? "nil")'")
                        print("   - Success URL: '\(data.success_url ?? "nil")'")
                        print("   - PG Type: '\(data.pg_type ?? "nil")'")
                        print("   - Price Changed: '\(data.price_changed ?? "nil")'")
                        print("   - Message: '\(data.msg ?? "nil")'")
                        
                        // Store booking_id and payment URL
                        if let bookingId = data.booking_id {
                            self.orderNo = bookingId
                            
                            // Store the payment URL (success_url from API)
                            if let successUrl = data.success_url {
                                self.paymentUrl = successUrl
                                print("✅ [INIT BOOK] Payment URL stored: \(successUrl)")
                            }
                            
                            self.shouldNavigateToPayment = true
                            print("✅ [INIT BOOK] Navigation to payment triggered with booking ID: \(bookingId)")
                        } else {
                            self.errorMessage = "Booking ID not received"
                            self.showToast(message: "Booking ID not received")
                            print("❌ [INIT BOOK] No booking ID in response")
                        }
                    } else if let error = response.error {
                        self.errorMessage = error.details
                        self.showToast(message: error.details)
                        print("❌ [INIT BOOK] API Error: \(error.type) - \(error.details)")
                    } else {
                        self.errorMessage = "Unknown error occurred"
                        self.showToast(message: "Unknown error occurred")
                        print("❌ [INIT BOOK] Unknown error - no data or error in response")
                    }
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showToast(message: error.localizedDescription)
                    print("❌ [INIT BOOK] Network Error: \(error.localizedDescription)")
                }
                
                print("🔍 [INIT BOOK] ========== Init Book Complete ==========")
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
