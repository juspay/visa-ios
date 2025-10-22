import Foundation

class TransactionsViewModel: ObservableObject {
    @Published var selectedTab: TransactionTab = .Upcoming {
        didSet {
            // Clear previous data and errors when tab changes
            bookings = []
            errorMessage = nil
            currentPage = 1
            hasMoreData = true
            // Fetch new data when tab changes
            fetchBookings()
        }
    }
    @Published var bookings: [Booking] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let url = URL(string: Constants.APIURLs.bookingListURL)!
    private var currentPage = 1
    private let limit = 10
    private var hasMoreData = true
    
    init() {
        // Fetch bookings on initial load
        fetchBookings()
    }
    
    // Map tab to API filter type
    private var filterType: String {
        switch selectedTab {
        case .Upcoming:
            return "upcoming"
        case .Completed:
            return "completed"
        case .Cancelled:
            return "cancelled"
        }
    }
    
    func fetchBookings(isLoadingMore: Bool = false) {
        guard !isLoading else { return }
        
        isLoading = true
        
        // Build URL with query parameters for pagination
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(currentPage)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        guard let urlWithParams = urlComponents?.url else {
            self.isLoading = false
            return
        }
        
        let requestBody = BookingListRequest(
            email: customerEmail,
            site_id: ssoSiteIdGlobal,
            type: filterType
        )
       
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
                
        NetworkManager.shared.post(url: urlWithParams, body: requestBody, headers: headers) { (result: Result<BookingResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    let newBookings = response.data.bookings
                    
                    if isLoadingMore {
                        // Append new bookings for pagination
                        self.bookings.append(contentsOf: newBookings)
                    } else {
                        // Replace bookings for initial load or tab change
                        self.bookings = newBookings
                    }
                    
                    // Check if there's more data to load
                    self.hasMoreData = newBookings.count == self.limit
                    
                    newBookings.forEach { print($0) }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadMoreBookings() {
        guard hasMoreData && !isLoading else { return }
        currentPage += 1
        fetchBookings(isLoadingMore: true)
    }
}
