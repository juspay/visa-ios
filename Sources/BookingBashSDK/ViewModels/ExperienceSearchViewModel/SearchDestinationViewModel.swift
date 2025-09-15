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
    @Published var selectedDestinationModel: DestinationModel?
    @Published var recentSearches: [SearchDestinationModel] = [
        SearchDestinationModel(name: "Dubai", isRecent: true),
        SearchDestinationModel(name: "Sharjah", isRecent: true)
    ]
    
    @Published var destinations: [SearchDestinationModel] = []
    @Published var autoSuggestDestinations: AutoSuggestDestinationApiResponse?
    @Published var errorMessage: String?
    @Published var decryptedResponse: DecryptedResponse?


    func clearRecentSearches() {
        recentSearches.removeAll()
    }

    func selectDestination(_ destination: SearchDestinationModel, fullData: DestinationModel) {
           self.selectedDestinationModel = fullData
           print("Selected: \(destination.name) -> destinationId: \(fullData.destinationId)")
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
            "Authorization": TokenProvider.getAuthHeader() ?? ""
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
    private let decryptURL = URL(string: "https://auth.bookingbash.com/decrypt")
        
        func decryptJWE(jwe: String, completion: @escaping (Result<Data, Error>) -> Void) {
            guard let url = decryptURL else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = ["jwe": jwe]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                completion(.failure(error))
                return
            }
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -2, userInfo: nil)))
                    return
                }
                completion(.success(data))
            }
            task.resume()
        }
    
    
    private func setCountryData(responseData: [DestinationModel]?) {
        guard let data = responseData else { return }
        
        destinations = data.map { destination in
            SearchDestinationModel(name: destination.title, isRecent: false)
        }
        
        print("destinations count: \(destinations.count)")
    }
}
