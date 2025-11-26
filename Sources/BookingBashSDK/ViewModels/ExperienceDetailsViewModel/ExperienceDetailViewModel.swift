import Foundation
//display only those image whose isCover is false , check the response data in ImageListResponse for clarity.
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
    var shouldShowErrorOverlay: Bool {
        return showErrorOverlay
    }
    var cancellationPolicy: String = ""
    let icons = ["bolt.fill"]
    var ageBandsForAvailability: [DetailAgeBand] = []
    func fetchReviewData(activityCode: String, currency: String) {
        isLoading = true
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
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<ImageListResponse, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    if let imageData = response.data {
                        self.updateCarouselWithImages(imageData: imageData)
                    }
                case .failure(_):
                    break
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
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<DetailExperienceApiResponse, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    if response.status == false || response.statusCode != 200 {
                        self.errorStatusCode = response.statusCode
                        self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                        self.showErrorOverlay = true
                        return
                    }
                    if let responseData = response.data {
                        self.setUiData(responseData: responseData)
                        self.showErrorOverlay = false
                    } else {
                        self.errorMessage = "No data found"
                        self.showErrorOverlay = true
                    }
                case .failure(_):
                    self.errorStatusCode = 500
                    self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                    self.showErrorOverlay = true
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
    }
    
    func setUiData(responseData: DetailResponseData?) {
        guard let data = responseData else { return }
        maxTravelersPerBooking = data.info.bookingRequirements.maxTravelersPerBooking
        apiReviewResponseData = data

        let formattedPrice = String(format: "%.2f", data.price.totalAmount)
        price = "\(data.price.currency) \(formattedPrice)"
        priceValue = data.price.totalAmount
        detaislUid = data.uid ?? ""
        price = "\(data.price.currency) \(formattedPrice)"
        detaislUid = data.uid ?? ""
        let ageBands = data.info.ageBands
        ageBandsForAvailability = ageBands
        globalAgeBands = ageBands
        let strikeout = data.price.strikeout
        if strikeout.savingAmount > 0 {
            strikeoutPrice = strikeout.totalAmount
            hasDiscount = true
            savingsAmount = strikeout.savingAmount
            savingsPercentage = strikeout.savingPercentage.rounded()
        } else {
            strikeoutPrice = 0.0
            savingsAmount = 0.0
            savingsPercentage = 0.0
            hasDiscount = false
        }
        var locationParts: [String] = []
        if !data.info.city.isEmpty {
            locationParts.append(data.info.city)
        }
        if !data.info.country.isEmpty {
            locationParts.append(data.info.country)
        }
        location = locationParts.joined(separator: " - ")
        experienceDetail = ExperienceDetailModel(
            title: data.info.title,
            location: location,
            category: data.info.itinerary?.itineraryType ?? "",
            rating: data.info.ratings,
            reviewCount: data.info.reviewCount
        )
        var features: [FeatureItem] = []
        let durationDisplay = data.info.duration.display
        if !durationDisplay.isEmpty {
            features.append(FeatureItem(iconName: "bolt", title: durationDisplay))
        }
        if let ticketInfo = data.info.ticketInfo {
            if !ticketInfo.ticketTypeDescription.isEmpty {
                features.append(FeatureItem(iconName: "bolt", title: ticketInfo.ticketTypeDescription))
            }
        }
        allFeatures = features
        if !data.info.description.isEmpty {
            let aboutDescription = "\(data.info.description)\n\nDuration: \(durationDisplay)"
            aboutExperience = AboutExperienceModel(
                title: "About this experience",
                description: aboutDescription
            )
        }
        cancellationPolicy = data.info.cancellationPolicy.description
        var cancellationItems = [data.info.cancellationPolicy.description]
        cancellationPolicyData = [
            InfoDetailModel(title: "Cancellation Policy", items: cancellationItems)
        ]
        let inclusionItems = data.info.inclusions.compactMap { inclusion -> String? in
            if let description = inclusion.description, !description.isEmpty, description != "Other" {
                return description
            } else if let otherDescription = inclusion.otherDescription, !otherDescription.isEmpty, otherDescription != "Other" {
                return otherDescription
            } else if !inclusion.categoryDescription.isEmpty, inclusion.categoryDescription != "Other" {
                return inclusion.categoryDescription
            } else if !inclusion.typeDescription.isEmpty, inclusion.typeDescription != "Other" {
                return inclusion.typeDescription
            } else {
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
        let exclusionItems = data.info.exclusions.compactMap { exclusion -> String? in
            if let description = exclusion.description, !description.isEmpty, description != "Other" {
                return description
            } else if let otherDescription = exclusion.otherDescription, !otherDescription.isEmpty, otherDescription != "Other" {
                return otherDescription
            } else if !exclusion.categoryDescription.isEmpty, exclusion.categoryDescription != "Other" {
                return exclusion.categoryDescription
            } else if !exclusion.typeDescription.isEmpty, exclusion.typeDescription != "Other" {
                return exclusion.typeDescription
            } else {
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
        highlights = [
            InfoDetailModel(title: "Highlights",
                          items: data.info.additionalInfo.map { $0.description })
        ]
        updateItemsBasedOnAvailableData()
    }
    private func updateItemsBasedOnAvailableData() {
        var availableItems: [InfoItem] = []
        if let firstHighlight = highlights.first, !firstHighlight.items.isEmpty {
            availableItems.append(InfoItem(title: "Highlights", type: .highlights))
        }
        if let firstInclusion = inclusions.first, !firstInclusion.items.isEmpty {
            availableItems.append(InfoItem(title: "What's Included", type: .included))
        }
        if let firstExclusion = exclusions.first, !firstExclusion.items.isEmpty {
            availableItems.append(InfoItem(title: "What's Excluded", type: .excluded))
        }
        if let firstCancellation = cancellationPolicyData.first, !firstCancellation.items.isEmpty {
            availableItems.append(InfoItem(title: "Cancellation Policy", type: .cancellation))
        }
        items = availableItems
    }
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
            return "bolt.fill"
        default:
            return "checkmark.circle.fill"
        }
    }
}
