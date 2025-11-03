import Foundation

final class ExperienceDetailViewModel: ObservableObject {
    @Published var carousalData: [ExperienceDetailCarousalModel] = []
      @Published var isLoading: Bool = false
      
      @Published var experienceDetail: ExperienceDetailModel?
      @Published var isViewMoreExpanded = false
      @Published var allFeatures: [FeatureItem] = []
      
      @Published var sortRatingsOptions: [SortOption] = [
          .init(title: "Most Relevant"),
          .init(title: "Ratings - High to low"),
          .init(title: "Ratings - Low to high")
      ]
      @Published var selectedOption: SortOption?
      
      @Published var aboutExperience: AboutExperienceModel? = nil
      @Published var items: [InfoItem] = []
      
      @Published var inclusions: [InfoDetailModel] = []
      @Published var exclusions: [InfoDetailModel] = []
      @Published var highlights: [InfoDetailModel] = []
      @Published var cancellationPolicyData: [InfoDetailModel] = []
      
      @Published var reviews: [ReviewsModel] = []
      @Published var images: [TravellerPhotosModel] = []
      
      @Published var price: String = ""
      @Published var maxTravelersPerBooking: Int?
      @Published var priceValue: Double = 0.0
      @Published var location: String = ""
      @Published var ageBands: String = ""
      @Published var priceSuffix: String = "/Person"
      @Published var buttonText: String = "Check Availability"
      @Published var errorMessage: String?
      @Published var apiReviewResponseData: DetailResponseData?
      @Published var strikeoutPrice = 0.0
      @Published var savingsPercentage: Double = 0.0
      @Published var savingsAmount: Double = 0.0
      @Published var hasDiscount: Bool = false
      
     
      @Published var showErrorOverlay: Bool = false
      var errorStatusCode: Int? = nil
      
      // MARK: - Derived Property
      var shouldShowErrorOverlay: Bool {
          return showErrorOverlay
      }

      // MARK: - Non-Published Properties
      var cancellationPolicy: String = ""
      let icons = ["bolt.fill"]
      var ageBandsForAvailability: [DetailAgeBand] = []
    
    // MARK: - Public Methods
    func fetchReviewData(activityCode: String, currency: String) {
        isLoading = true
        // Fetch images first, then fetch review data
        fetchImageList(activityCode: activityCode) {
            self.fetchExperienceDetails(activityCode: activityCode, currency: currency)
        }
    }
    
    func fetchImageList(activityCode: String, completion: @escaping () -> Void = {}) {
        guard let url = URL(string: Constants.APIURLs.imageListURL) else {
            completion()
            return
        }
        
        let requestBody = ImageListRequest(activity_code: activityCode)
        
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
         
            
        ]
        
        print("Fetching image list for activity code: \(activityCode)")
        print("Image List URL: \(url)")
        
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<ImageListResponse, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if let imageData = response.data {
                        self.updateCarouselWithImages(imageData: imageData)
                        print("Successfully fetched \(imageData.count) images")
                    } else {
                        print("No image data in response")
                    }
                case .failure(let error):
                    print("Failed to fetch images: \(error.localizedDescription)")
                }
                
                completion()
            }
        }
    }
    
    private func fetchExperienceDetails(activityCode: String, currency: String) {
            guard let url = URL(string: Constants.APIURLs.detailsBaseURL) else {
                isLoading = false
                return
            }

            let requestBody = ExperienceRequest(activity_code: activityCode, currency: currency)

            let headers = [
                Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
                Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
                Constants.APIHeaders.siteId: ssoSiteIdGlobal,
                Constants.APIHeaders.tokenKey: ssoTokenGlobal
            ]

            print("url for details - \(url)")

            NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<DetailExperienceApiResponse, Error>) in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.isLoading = false

                    switch result {
                    case .success(let response):
                        // ✅ Check for API failure (500 or false status)
                        if response.status == false || response.statusCode != 200 {
                            self.errorStatusCode = response.statusCode
                            self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                            self.showErrorOverlay = true
                          
                            return
                        }

                        // ✅ Handle valid data
                        if let responseData = response.data {
                            self.setUiData(responseData: responseData)
                            self.showErrorOverlay = false
                            print("✅ DetailExperienceApiResponse received successfully")
                        } else {
                            print("⚠️ Empty detail response")
                            self.errorMessage = "No data found"
                            self.showErrorOverlay = true
                        }

                    case .failure(let error):
                        print("❌ Network error: \(error.localizedDescription)")
                        self.errorStatusCode = 500
                        self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                        self.showErrorOverlay = true
                    }
                }
            }
        }
    

    private func updateCarouselWithImages(imageData: ImageListData) {
        var carouselImages: [ExperienceDetailCarousalModel] = []
        
        // Process the image results
        for imageResult in imageData.result {
            // Find the best quality image (preferably 720x480 or 674x446 for carousel display)
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
        }
        
        print("Updated carousel with \(carouselImages.count) images")
    }
    
    func setUiData(responseData: DetailResponseData?) {
        guard let data = responseData else { return }
        maxTravelersPerBooking = data.info.bookingRequirements.maxTravelersPerBooking
        // Store the response data for later use
        apiReviewResponseData = data
        
        // Only set carousel from thumbnail if no images were fetched from image list API
        if carousalData.isEmpty {
            carousalData = [ExperienceDetailCarousalModel(imageUrl: data.info.thumbnail)]
        }
        
        // Price & Location - Format price with strikeout if available
        let formattedPrice = String(format: "%.2f", data.price.totalAmount)
                price = "\(data.price.currency) \(formattedPrice)"
                priceValue = data.price.totalAmount // Store the original Double value
                detaislUid = data.uid ?? ""
                print(detaislUid)
                // Strikeout price if available
               
        price = "\(data.price.currency) \(formattedPrice)"
        detaislUid = data.uid ?? ""
        print(detaislUid)
        
        // Store age bands for passing to availability view
        let ageBands = data.info.ageBands
        ageBandsForAvailability = ageBands
        
        // Store in global variable for cross-view communication
        globalAgeBands = ageBands
        print("🔍 [DETAILS] Found \(ageBands.count) age bands from details API:")
        print("🔍 [DETAILS] Found------ \(ageBandsForAvailability) age bands for details API:")
        for ageBand in ageBands {
            print("   - \(ageBand.bandID): age \(ageBand.ageFrom)-\(ageBand.ageTo), min: \(ageBand.minTravelersPerBooking), max: \(ageBand.maxTravelersPerBooking)")
        }
        
        // Strikeout price if available
        let strikeout = data.price.strikeout
        if strikeout.savingAmount > 0 {
            strikeoutPrice = strikeout.totalAmount

            hasDiscount = true
            savingsAmount = strikeout.savingAmount
            savingsPercentage = strikeout.savingPercentage
        } else {
            strikeoutPrice = 0.0
            savingsAmount = 0.0
            savingsPercentage = 0.0
            hasDiscount = false
        }
        
        // Build location string from available data
        var locationParts: [String] = []
        if !data.info.city.isEmpty {
            locationParts.append(data.info.city)
        }
        if !data.info.country.isEmpty {
            locationParts.append(data.info.country)
        }
        location = locationParts.joined(separator: " - ")
        
        // Experience Detail
        experienceDetail = ExperienceDetailModel(
            title: data.info.title,
            location: location,
            category: data.info.itinerary?.itineraryType ?? "",
            rating: data.info.ratings,
            reviewCount: data.info.reviewCount
        )
        
        // Features from duration and ticket info instead of additional info
        var features: [FeatureItem] = []
        
        // Add duration if available
        let durationDisplay = data.info.duration.display
        print("DEBUG: Duration display: '\(durationDisplay)'")
        if !durationDisplay.isEmpty {
            features.append(FeatureItem(iconName: "bolt.fill", title: durationDisplay))
            print("DEBUG: ✅ Added duration feature: '\(durationDisplay)'")
        } else {
            print("DEBUG: ❌ Duration is empty")
        }
        
        // Add ticket type description if available
        print("DEBUG: ticketInfo exists: \(data.info.ticketInfo != nil)")
        if let ticketInfo = data.info.ticketInfo {
            print("DEBUG: ticketTypeDescription: '\(ticketInfo.ticketTypeDescription)'")
            if !ticketInfo.ticketTypeDescription.isEmpty {
                features.append(FeatureItem(iconName: "bolt.fill", title: ticketInfo.ticketTypeDescription))
                print("DEBUG: ✅ Added ticket feature: '\(ticketInfo.ticketTypeDescription)'")
            } else {
                print("DEBUG: ❌ ticketTypeDescription is empty")
            }
        } else {
            print("DEBUG: ❌ ticketInfo is nil")
        }
        
        allFeatures = features
        
        
        // About - include duration in description
        let aboutDescription = "\(data.info.description)\n\nDuration: \(durationDisplay)"
        aboutExperience = AboutExperienceModel(
            title: "About this experience",
            description: aboutDescription
        )
        
        // Cancellation Policy
        cancellationPolicy = data.info.cancellationPolicy.description
        var cancellationItems = [data.info.cancellationPolicy.description]
        
        cancellationPolicyData = [
            InfoDetailModel(title: "Cancellation Policy", items: cancellationItems)
        ]
        
        // Inclusions / Exclusions - map from response model with improved logic
        print("DEBUG: Processing inclusions count: \(data.info.inclusions.count)")
        for (index, inclusion) in data.info.inclusions.enumerated() {
            print("DEBUG: Inclusion \(index): description='\(inclusion.description ?? "nil")', typeDescription='\(inclusion.typeDescription)', category='\(inclusion.category)', categoryDescription='\(inclusion.categoryDescription)', otherDescription='\(inclusion.otherDescription ?? "nil")'")
        }
        
        let inclusionItems = data.info.inclusions.compactMap { inclusion -> String? in
            // Priority order: description -> otherDescription -> categoryDescription -> typeDescription
            if let description = inclusion.description, !description.isEmpty, description != "Other" {
                return description
            } else if let otherDescription = inclusion.otherDescription, !otherDescription.isEmpty, otherDescription != "Other" {
                return otherDescription
            } else if !inclusion.categoryDescription.isEmpty, inclusion.categoryDescription != "Other" {
                return inclusion.categoryDescription
            } else if !inclusion.typeDescription.isEmpty, inclusion.typeDescription != "Other" {
                return inclusion.typeDescription
            } else {
                // If all fields are "Other" or empty, create a meaningful description from category
                switch inclusion.category.uppercased() {
                case "TRANSPORT", "TRANSPORTATION":
                    return "Transportation included"
                case "GUIDE":
                    return "Professional guide included"
                case "FOOD", "MEALS":
                    return "Meals included"
                case "ADMISSION", "ENTRY":
                    return "Admission tickets included"
                case "EQUIPMENT":
                    return "Equipment provided"
                default:
                    return inclusion.category.capitalized + " included"
                }
            }
        }
        
        inclusions = [InfoDetailModel(title: "What's Included", items: inclusionItems)]
        
        print("DEBUG: Processing exclusions count: \(data.info.exclusions.count)")
        for (index, exclusion) in data.info.exclusions.enumerated() {
            print("DEBUG: Exclusion \(index): description='\(exclusion.description ?? "nil")', typeDescription='\(exclusion.typeDescription)', category='\(exclusion.category)', categoryDescription='\(exclusion.categoryDescription)', otherDescription='\(exclusion.otherDescription ?? "nil")'")
        }
        
        let exclusionItems = data.info.exclusions.compactMap { exclusion -> String? in
            // Priority order: description -> otherDescription -> categoryDescription -> typeDescription
            if let description = exclusion.description, !description.isEmpty, description != "Other" {
                return description
            } else if let otherDescription = exclusion.otherDescription, !otherDescription.isEmpty, otherDescription != "Other" {
                return otherDescription
            } else if !exclusion.categoryDescription.isEmpty, exclusion.categoryDescription != "Other" {
                return exclusion.categoryDescription
            } else if !exclusion.typeDescription.isEmpty, exclusion.typeDescription != "Other" {
                return exclusion.typeDescription
            } else {
                // If all fields are "Other" or empty, create a meaningful description from category
                switch exclusion.category.uppercased() {
                case "TRANSPORT", "TRANSPORTATION":
                    return "Transportation not included"
                case "GUIDE":
                    return "Personal guide not included"
                case "FOOD", "MEALS", "MEAL":
                    return "Food and drinks not included"
                case "ADMISSION", "ENTRY", "TICKET":
                    return "Additional entrance fees not included"
                case "EQUIPMENT", "GEAR":
                    return "Personal equipment not provided"
                case "INSURANCE":
                    return "Travel insurance not included"
                case "GRATUITY", "TIP", "TIPS":
                    return "Gratuities not included"
                case "HOTEL", "ACCOMMODATION":
                    return "Hotel pickup/drop-off not included"
                case "SOUVENIR", "SHOPPING":
                    return "Souvenirs and personal purchases not included"
                case "OTHER":
                    return "Additional services not included"
                default:
                    return exclusion.category.capitalized + " not included"
                }
            }
        }
        
        exclusions = [InfoDetailModel(title: "What's Excluded", items: exclusionItems)]
        
        print("DEBUG: Final inclusions items count: \(inclusions.first?.items.count ?? 0)")
        print("DEBUG: Final exclusions items count: \(exclusions.first?.items.count ?? 0)")
        print("DEBUG: Inclusion items: \(inclusions.first?.items ?? [])")
        print("DEBUG: Exclusion items: \(exclusions.first?.items ?? [])")
        
        // Highlights - using additionalInfo as requested
        highlights = [
            InfoDetailModel(title: "Highlights",
                          items: data.info.additionalInfo.map { $0.description })
        ]
        
        // Update the items array to only show sections with data
        updateItemsBasedOnAvailableData()
    }
    
    // MARK: - Helper Methods
    
    /// Updates the items array to only include sections that have data from the API
    private func updateItemsBasedOnAvailableData() {
        var availableItems: [InfoItem] = []
        
        // Check Highlights - show if additionalInfo has content
        if let firstHighlight = highlights.first, !firstHighlight.items.isEmpty {
            availableItems.append(InfoItem(title: "Highlights", type: .highlights))
        }
        
        // Check What's Included - show if inclusions has content
        if let firstInclusion = inclusions.first, !firstInclusion.items.isEmpty {
            availableItems.append(InfoItem(title: "What's Included", type: .included))
        }
        
        // Check What's Excluded - show if exclusions has content
        if let firstExclusion = exclusions.first, !firstExclusion.items.isEmpty {
            availableItems.append(InfoItem(title: "What's Excluded", type: .excluded))
        }
        
        // Check Cancellation Policy - show if cancellationPolicyData has content
        if let firstCancellation = cancellationPolicyData.first, !firstCancellation.items.isEmpty {
            availableItems.append(InfoItem(title: "Cancellation Policy", type: .cancellation))
        }
        
        // Always show Reviews (using static data for now)
//        if !reviews.isEmpty {
//            availableItems.append(InfoItem(title: "Reviews", type: .reviews))
//        }
//
//        // Always show Traveler Photos (using static data for now)
//        if !images.isEmpty {
//            availableItems.append(InfoItem(title: "Traveler Photos", type: .photos))
//        }
        
        // Update the published items array
        items = availableItems
        
        print("DEBUG: Updated items array with \(availableItems.count) sections")
        for item in availableItems {
            print("DEBUG: Available section: \(item.title)")
        }
    }
    
    // Helper method to get appropriate icon for feature type
    private func getIconForFeature(type: String) -> String {
        switch type {
        case "WHEELCHAIR_ACCESSIBLE", "SURFACES_WHEELCHAIR_ACCESSIBLE", "TRANSPORTATION_WHEELCHAIR_ACCESSIBLE":
            return "figure.roll"
        case "STROLLER_ACCESSIBLE":
            return "figure.and.child.holdinghands"
        case "PETS_WELCOME":
            return "pawprint.fill"
        case "PUBLIC_TRANSPORTATION_NEARBY":
            return "bus.fill"
        case "INFANTS_MUST_SIT_ON_LAPS", "INFANT_SEATS_AVAILABLE":
            return "figure.and.child.holdinghands"
        case "PHYSICAL_EASY":
            return "bolt.fill" // Changed from clock to thunder icon
        default:
            return "checkmark.circle.fill"
        }
    }
}

// MARK: - Static Data Setup
extension ExperienceDetailViewModel {
    
    private func configureStaticData() {
        items = [
            InfoItem(title: "Highlights", type: .highlights),
            InfoItem(title: "What's Included", type: .included),
            InfoItem(title: "What's Excluded", type: .excluded),
            InfoItem(title: "Cancellation Policy", type: .cancellation),
            InfoItem(title: "Reviews", type: .reviews),
            InfoItem(title: "Traveler Photos", type: .photos)
        ]
        
        // Initialize empty arrays - these will be populated with dynamic API data
        highlights = [
            InfoDetailModel(title: "Highlights", items: [])
        ]
        
        inclusions = [
            InfoDetailModel(title: "What's Included", items: [])
        ]
        
        exclusions = [
            InfoDetailModel(title: "What's Excluded", items: [])
        ]
        
        cancellationPolicyData = [
            InfoDetailModel(title: "Cancellation Policy", items: [])
        ]
        
        reviews = [
            ReviewsModel(
                rating: 5,
                title: "5/5",
                body: "It was a memorable experience, my kids enjoyed it so much...",
                images: ["Nature", "Nature", "Nature", "Nature"],
                userName: "Sophia",
                date: "19 Jun 2025"
            ),
            ReviewsModel(
                rating: 5,
                title: "5/5",
                body: "It was a memorable experience, my kids enjoyed it so much...",
                images: ["Nature", "Nature", "Nature", "Nature"],
                userName: "Sophia",
                date: "19 Jun 2025"
            ),
            ReviewsModel(
                rating: 5,
                title: "5/5",
                body: "It was a memorable experience, my kids enjoyed it so much...",
                images: ["Nature", "Nature", "Nature", "Nature", "Nature", "Nature", "Nature"],
                userName: "Sophia",
                date: "19 Jun 2025"
            )
        ]
        
        images = [
            TravellerPhotosModel(imageName: "Nature", overlayText: nil),
            TravellerPhotosModel(imageName: "Nature", overlayText: nil),
            TravellerPhotosModel(imageName: "Nature", overlayText: nil),
            TravellerPhotosModel(imageName: "Nature", overlayText: nil),
            TravellerPhotosModel(imageName: "Nature", overlayText: nil),
            TravellerPhotosModel(imageName: "Nature", overlayText: "+387")
        ]
    }
}

