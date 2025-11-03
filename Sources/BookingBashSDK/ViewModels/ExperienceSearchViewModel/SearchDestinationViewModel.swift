import Foundation
import SwiftUI

protocol SearchPersistenceService {
    func saveRecentSearches(_ searches: [SearchDestinationModel])
    func loadRecentSearches() -> [SearchDestinationModel]
    func clearRecentSearches()
}

final class UserDefaultsSearchPersistenceService: SearchPersistenceService {
    private let key = "recentSearches_v2"
    
    func saveRecentSearches(_ searches: [SearchDestinationModel]) {
        do {
            let data = try JSONEncoder().encode(searches)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save searches: \(error)")
        }
    }
    
    func loadRecentSearches() -> [SearchDestinationModel] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([SearchDestinationModel].self, from: data)) ?? []
    }
    
    func clearRecentSearches() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

final class SearchDestinationViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var recentSearches: [SearchDestinationModel] = []
    @Published var destinations: [SearchDestinationModel] = []
    @Published var errorMessage: String?
    
    private let autoSuggestBaseURL: String
    private let persistence: SearchPersistenceService
    
    init(
        autoSuggestBaseURL: String = Constants.APIURLs.autoSuggestBaseURL,
        persistence: SearchPersistenceService = UserDefaultsSearchPersistenceService()
    ) {
        self.autoSuggestBaseURL = autoSuggestBaseURL
        self.persistence = persistence
        self.recentSearches = persistence.loadRecentSearches()
    }
    
    var shouldShowNoResults: Bool {
        searchText.count >= 3 && !searchText.isEmpty && destinations.isEmpty
    }
    
    var shouldShowRecentSearches: Bool {
        !recentSearches.isEmpty && searchText.isEmpty
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
        persistence.clearRecentSearches()
    }
    
    private func updateRecentSearches(with newEntry: SearchDestinationModel) {
        var searches = recentSearches
        searches.removeAll { $0.name.caseInsensitiveCompare(newEntry.name) == .orderedSame }
        searches.insert(newEntry, at: 0)
        recentSearches = Array(searches.prefix(5))
        persistence.saveRecentSearches(recentSearches)
    }
    
    func addToRecentSearches(_ fullData: DestinationModel) {
        let name = fullData.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        
        let entry = SearchDestinationModel(
            name: name,
            destinationId: fullData.destinationId,
            destinationType: fullData.destinationType,
            isRecent: true
        )
        updateRecentSearches(with: entry)
    }
    
    func addToRecentSearchesByName(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        let entry = SearchDestinationModel(
            name: trimmed,
            destinationId: nil,
            destinationType: nil,
            isRecent: true
        )
        updateRecentSearches(with: entry)
    }
    
    // MARK: - Destination Handling
    func handleDestinationTap(
        _ destination: SearchDestinationModel,
        onSelect: @escaping (SearchRequestModel) -> Void
    ) {
        if let id = destination.destinationId, let type = destination.destinationType {
            // Create a proper entry to preserve destinationId and destinationType
            let entry = SearchDestinationModel(
                name: destination.name,
                destinationId: id,
                destinationType: type,
                isRecent: true
            )
            updateRecentSearches(with: entry)
            onSelect(buildRequestModel(from: destination.name, id: id, type: type))
        } else {
            autoSuggestFetchData(searchCity: destination.name) { [weak self] fullData in
                guard let self = self else { return }
                
                if let fullData = fullData {
                    self.addToRecentSearches(fullData)
                    onSelect(self.buildRequestModel(from: fullData.title, id: fullData.destinationId, type: fullData.destinationType))
                } else {
                    self.addToRecentSearchesByName(destination.name)
                    // Use destination type 2 (city) as default instead of 0
                    onSelect(self.buildRequestModel(from: destination.name, id: "", type: 2))
                }
            }
        }
    }
    
    // MARK: - Auto Suggest Fetch
    func autoSuggestFetchData(searchCity: String, completion: @escaping (DestinationModel?) -> Void) {
        guard let url = URL(string: "\(autoSuggestBaseURL)?keyword=\(searchCity.lowercased())") else {
            setError("Invalid URL for search city: \(searchCity)")
            completion(nil)
            return
        }
            
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            Constants.APIHeaders.tokenKey: ssoTokenGlobal
            
            
        ]
        
        NetworkManager.shared.get(url: url, headers: headers) { [weak self] (result: Result<AutoSuggestDestinationApiResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.mapDestinations(from: response.data)
                    let match = response.data.first { $0.title.caseInsensitiveCompare(searchCity) == .orderedSame }
                    completion(match)
                    print("auto suggest response - response - \(response)")
                case .failure(let error):
                    self?.setError(error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func mapDestinations(from data: [DestinationModel]?) {
        guard let data = data else {
            destinations = []
            return
        }
        destinations = data.map {
            SearchDestinationModel(
                name: $0.title,
                destinationId: $0.destinationId,
                destinationType: $0.destinationType,
                isRecent: false
            )
        }
    }
    
    private func buildRequestModel(from name: String, id: String, type: Int) -> SearchRequestModel {
        // Calculate dynamic dates
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Check-in date: current date + 1 days
        guard let checkInDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
            fatalError("Failed to calculate check-in date")
        }
        // Check-out date: check-in date + 2 days
        guard let checkOutDate = calendar.date(byAdding: .day, value: 1, to: checkInDate) else {
            fatalError("Failed to calculate check-out date")
        }
        
        // Format dates as "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let checkInDateString = dateFormatter.string(from: checkInDate)
        let checkOutDateString = dateFormatter.string(from: checkOutDate)
        
        return SearchRequestModel(
            destinationId: id,
            destinationType: type,
            location: name,
            checkInDate: checkInDateString,
            checkOutDate: checkOutDateString,
            currency: "AED",
            clientId: "CLIENT_ABC123",
            enquiryId: "ENQ_456XYZ",
            productCode: [],
            filters: SearchFilters(
                limit: 700,
                offset: 0,
                priceRange: [],
                rating: [],
                duration: [],
                reviewCount: [],
                sort_by: SortBy(name: "price", type: "ASC"),
                categories: [],
                language: ["en", "ar"],
                itineraryType: [],
                ticketType: [],
                confirmationType: [],
                featureFlags: ["free_cancellation","special_offer","private_tour","skip_the_line","likely_to_sell_out"],
                productCode: []
            )
        )
    }
    
    private func setError(_ message: String) {
        errorMessage = message
    }
}
