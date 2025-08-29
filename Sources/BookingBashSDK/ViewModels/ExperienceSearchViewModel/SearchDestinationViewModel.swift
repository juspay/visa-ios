//
//  SearchDestinationViewModel.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SwiftUI

class SearchDestinationViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var recentSearches: [SearchDestinationModel] = [
        SearchDestinationModel(name: "Dubai", isRecent: true),
        SearchDestinationModel(name: "Sharjah", isRecent: true)
    ]
//    /@Published var allDestinations: [SearchDestinationModel] = []
//        SearchDestinationModel(name: "Singapore", isRecent: false),
//        SearchDestinationModel(name: "Spain", isRecent: false),
//        SearchDestinationModel(name: "Germany", isRecent: false),
//        SearchDestinationModel(name: "France", isRecent: false),
//        SearchDestinationModel(name: "United Arab Emirates", isRecent: false)
//    ]
    
    @Published var destinations: [SearchDestinationModel] = []
    @Published var autoSuggestDestinations: AutoSuggestDestinationApiResponse?
    @Published var errorMessage: String?

//    var searchResults: [SearchDestinationModel] {
//        guard searchText.count <= 3 else {
//            return []
//        }
//        return allDestinations
//    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
    }

    func selectDestination(_ destination: SearchDestinationModel) {
        if !destinations.contains(destination) {
            withAnimation(.none) {
                recentSearches.insert(SearchDestinationModel(name: destination.name, isRecent: true), at: 0)
            }
        }
        print("Selected: \(destination.name)")
    }
    
    func autoSuggestFetchData(searchCity: String) {
        // Remove leading space and use safe URL creation
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/autosuggest?keyword=\(searchCity.lowercased())") else {
            print("Invalid URL for search city: \(searchCity)")
            errorMessage = "Invalid search request"
            return
        }
        
        // Add required headers
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Basic Qy1FWTNSM0c6OWRjOWMwOWRiMzdkYWRmYmQyNDAxYTljNjBmODY1MGY1YjZlMDFjYg=="
        ]
        
        print(url)
        NetworkManager.shared.get(url: url, headers: headers) { (result: Result<AutoSuggestDestinationApiResponse, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    print("destinations fetched: \(response)")
                    self.autoSuggestDestinations = response
                    self.setCountryData(responseData: response.data)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func setCountryData(responseData: [DestinationModel]?) {
        guard let data = responseData else { return }
        
        destinations = data.map { destination in
            SearchDestinationModel(name: destination.title, isRecent: false)
        }
        
        print("destinations count: \(destinations.count)")
    }
}
