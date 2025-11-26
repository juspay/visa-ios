import Foundation

final class ExperienceListViewModel: ObservableObject {
    @Published var experiences: [ExperienceListModel] = []
    @Published var searchDestination: SearchResponseModel?
    @Published var searchRequestModel: SearchRequestModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var showErrorView: Bool = false

    private let service: ExperienceListService

    init(service: ExperienceListService = DefaultExperienceListService()) {
        self.service = service
    }

    var filteredExperiences: [ExperienceListModel] {
        guard searchText.count >= 3 else { return experiences }
        return experiences.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.productCode.localizedCaseInsensitiveContains(searchText) ||
            $0.currency.localizedCaseInsensitiveContains(searchText)
        }
    }

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
        self.searchRequestModel = requestBody

        service.fetchSearchData(requestBody: requestBody) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .success(let response):
                    if response.status == false || response.statusCode != 200 {
                        self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                        self.showErrorView = true
                        self.experiences = []
                        return
                    }

                    if let responseData = response.data {
                        self.showErrorView = false
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
                        self.showErrorView = true
                        self.experiences = []
                    }
                case .failure(_):
                    self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                    self.showErrorView = true
                    self.experiences = []
                }
            }
        }
    }

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
            limit: 700,
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
