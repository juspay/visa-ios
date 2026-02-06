import Foundation

final class ExperienceListViewModel: ObservableObject {

    // MARK: - Published State
    @Published var experiences: [ExperienceListModel] = []
    @Published var searchDestination: SearchResponseModel?
    @Published var searchRequestModel: SearchRequestModel?

    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var showErrorView: Bool = false
    @Published var searchText: String = ""

    // MARK: - Pagination
    @Published private(set) var hasMore: Bool = true
    private(set) var offset: Int = 0
    let pageLimit: Int = 50

    private let service: ExperienceListService

    // MARK: - Init
    init(service: ExperienceListService = DefaultExperienceListService()) {
        self.service = service
    }

    // MARK: - Search Filtering
    var filteredExperiences: [ExperienceListModel] {
        guard searchText.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3 else {
            return experiences
        }

        return experiences.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.productCode.localizedCaseInsensitiveContains(searchText) ||
            $0.currency.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Initial Fetch
    func resetAndFetch(
        destinationId: String,
        destinationType: Int,
        checkInDate: String,
        checkOutDate: String,
        currency: String,
        productCodes: [String] = []
    ) {
        offset = 0
        hasMore = true
        experiences.removeAll()
        showErrorView = false
        errorMessage = nil

        let request = SearchRequestBuilder.build(
            destinationId: destinationId,
            destinationType: destinationType,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            currency: currency,
            productCodes: productCodes,
            limit: pageLimit,
            offset: offset
        )

        searchRequestModel = request
        fetchPage(requestBody: request, isInitial: true)
    }

    // MARK: - Pagination Trigger
    func loadMoreIfNeeded(currentItem: ExperienceListModel?) {
        // ❌ Disable pagination during search
        guard searchText.count < 3 else { return }

        guard let currentItem = currentItem else { return }
        guard hasMore, !isLoadingMore, !isLoading else { return }

        if currentItem.productCode == experiences.last?.productCode {
            loadNextPage()
        }
    }

    // MARK: - Load Next Page
    private func loadNextPage() {
        guard hasMore, !isLoadingMore else { return }
        guard var request = searchRequestModel else { return }

        isLoadingMore = true
        offset += pageLimit

        request.filters = SearchFilters(
            limit: pageLimit,
            offset: offset,
            priceRange: request.filters.priceRange,
            rating: request.filters.rating,
            duration: request.filters.duration,
            reviewCount: request.filters.reviewCount,
            sort_by: request.filters.sort_by,
            categories: request.filters.categories,
            language: request.filters.language,
            itineraryType: request.filters.itineraryType,
            ticketType: request.filters.ticketType,
            confirmationType: request.filters.confirmationType,
            featureFlags: request.filters.featureFlags,
            productCode: request.filters.productCode
        )

        searchRequestModel = request
        fetchPage(requestBody: request, isInitial: false)
    }

    // MARK: - API Call
    private func fetchPage(requestBody: SearchRequestModel, isInitial: Bool) {

        if isInitial {
            isLoading = true
        }

        errorMessage = nil

        service.fetchSearchData(requestBody: requestBody) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }

                self.isLoading = false
                self.isLoadingMore = false

                switch result {

                case .success(let response):
                    guard response.status == true,
                          response.statusCode == 200,
                          let data = response.data else {
                        self.showErrorView = true
                        self.hasMore = false
                        return
                    }

                    let newPage = self.mapResponseToUIModels(data)

                    // 🔴 Stop pagination if API returns empty page
                    if newPage.isEmpty {
                        self.hasMore = false
                        return
                    }

                    if isInitial {
                        self.experiences = newPage
                    } else {
                        self.experiences.append(contentsOf: newPage)
                    }

                case .failure:
                    self.showErrorView = true
                    self.hasMore = false
                }
            }
        }
    }

    // MARK: - Mapping
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

    func updateSortOrder(sortBy: SortBy) {
            guard var request = searchRequestModel else { return }
            
            // 1. Reset Pagination Logic
            self.offset = 0
            self.hasMore = true
            self.experiences.removeAll()
            self.errorMessage = nil
            self.showErrorView = false
            
            // 2. Update the Request Model
            request.filters.offset = 0 // IMPORTANT: Reset offset in the API payload
            request.filters.sort_by = sortBy
            
            self.searchRequestModel = request
            
            // 3. Trigger the fresh fetch
            // Set loading to true immediately to ensure View shows Loader, not NoResults
            self.isLoading = true
            fetchPage(requestBody: request, isInitial: true)
        }
}

struct SearchRequestBuilder {
    static func build(
        destinationId: String,
        destinationType: Int,
        checkInDate: String,
        checkOutDate: String,
        currency: String,
        productCodes: [String],
        limit: Int,
        offset: Int
    ) -> SearchRequestModel {
        let filters = SearchFilters(
            limit: limit,
            offset: offset,
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
