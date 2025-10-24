import Foundation

protocol ExperienceListService {
    func fetchSearchData(
        requestBody: SearchRequestModel,
        completion: @escaping (Result<SearchResponseModel, Error>) -> Void
    )
}

// MARK: - Default Service
final class DefaultExperienceListService: ExperienceListService {
    private let session = NetworkManager.shared
    
    func fetchSearchData(
        requestBody: SearchRequestModel,
        completion: @escaping (Result<SearchResponseModel, Error>) -> Void
    ) {
        guard let url = URL(string: Constants.APIURLs.searchBaseURL) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
                 Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
       
       print("Headers for list view - \(headers)")
        
        // Convert to JSON to see exactly what's being sent
        if let jsonData = try? JSONEncoder().encode(requestBody),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("📤 [API REQUEST] JSON Payload:\n\(jsonString)")
        }
        
        session.post(url: url, body: requestBody, headers: headers, completion: completion)
    }
    
    enum ServiceError: LocalizedError {
        case invalidURL
        var errorDescription: String? { "Invalid URL" }
    }
}

// MARK: - ViewModel
final class ExperienceListViewModel: ObservableObject {
    @Published var experiences: [ExperienceListModel] = []
    @Published var searchDestination: SearchResponseModel?
    @Published var searchRequestModel: SearchRequestModel?
    @Published var navigateToFilterScreenView : Bool = true
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    private let service: ExperienceListService
    
    init(service: ExperienceListService = DefaultExperienceListService()) {
        self.service = service
    }
    
    // MARK: - Computed Filtered Experiences
    var filteredExperiences: [ExperienceListModel] {
        guard searchText.count >= 3 else { return experiences }
        return experiences.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.productCode.localizedCaseInsensitiveContains(searchText) ||
            $0.currency.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Public Methods
    func fetchSearchData(
        destinationId: String,
        destinationType: Int,
        location: String,
        checkInDate: String,
        checkOutDate: String,
        currency: String,
        productCodes: [String] = []
    ) {
        guard let _ = URL(string: Constants.APIURLs.searchBaseURL) else { return }
        
        isLoading = true
        errorMessage = nil
        
        let requestBody = SearchRequestBuilder.build(
            destinationId: destinationId,
            destinationType: destinationType,
            location: location,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            currency: currency,
            productCodes: productCodes
        )
        
        // Store the request model for sorting/filtering later
        self.searchRequestModel = requestBody
        
        service.fetchSearchData(requestBody: requestBody) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    if let responseData = response.data {
                        self.searchDestination = response
                        var mappedExperiences = self.mapResponseToUIModels(responseData)
                        if let sortBy = self.searchRequestModel?.filters.sort_by {
                            if sortBy.name.lowercased() == "price" && sortBy.type.uppercased() == "DESC" {
                                mappedExperiences.sort { $0.price > $1.price }
                            } else if sortBy.name.lowercased() == "price" && sortBy.type.uppercased() == "ASC" {
                                mappedExperiences.sort { $0.price < $1.price }
                            }
                        }
                        self.experiences = mappedExperiences
                    } else {
                        self.errorMessage = Constants.ErrorMessages.noDataInResponse
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Internal Helpers (accessible to SortViewModel)
    func mapResponseToUIModels(_ responseData: SearchDataModel) -> [ExperienceListModel] {
        responseData.result.map {
            ExperienceListModel(
                title: $0.title,
                rating: $0.rating,
                reviewCount: $0.reviewCount,
                price: $0.price.totalAmount,
                strikeoutPrice: $0.price.strikeout?.totalAmount,
                savingPercentage: $0.price.strikeout?.savingPercentage,
                imageName: $0.thumbnail,
                productCode: $0.activityCode,
                currency: $0.price.currency
            )
        }
    }
}
struct SearchRequestBuilder {
    static func build(
        destinationId: String,
        destinationType: Int,
        location: String,
        checkInDate: String,
        checkOutDate: String,
        currency: String,
        productCodes: [String]
    ) -> SearchRequestModel {
        let filters = SearchFilters(
            limit: 50,
            offset: 0,
            priceRange: [],
            rating: [],
            duration: [],
            reviewCount: [],
            sort_by: SortBy(name: "price", type: "ASC"),
            categories: [],
            language: [],
            itineraryType: [],
            ticketType: [],
            confirmationType: [],
            featureFlags: [],
            productCode: productCodes
        )
        
        return SearchRequestModel(
            destinationId: destinationId,
            destinationType: destinationType,
            location: location,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            currency: currency,
            clientId: "",
            enquiryId: "",
            productCode: productCodes,
            filters: filters
        )
    }
}

