//
//  ViewModel.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var destinations: [Destination] = []
    @Published var experiences: [Experience] = []
    @Published var homeResponseData: HomeResponseModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    private var allExperiences: [Experience] = []
    private let loadCount = 5

    init() {
        fetchHomeData()
    }

    // MARK: - API Call for Home Data
    func fetchHomeData() {
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/home") else {
            print("Invalid URL for home data")
            errorMessage = "Invalid API URL"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        // Add required headers
        let headers = [
            "Content-Type": "application/json",
            "Authorization": TokenProvider.getAuthHeader() ?? ""
        ]
        
        print("Fetching home data from: \(url)")
        NetworkManager.shared.get(url: url, headers: headers) { (result: Result<HomeResponseModel, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    print("Home data fetched successfully: \(response)")
                    self.homeResponseData = response
                    self.processHomeResponse(response)
                case .failure(let error):
                    print("Failed to fetch home data: \(error)")
                    self.errorMessage = error.localizedDescription
                    // Fallback to mock data if API fails
                    self.loadMockData()
                }
            }
        }
    }
    
    // MARK: - Dedicated Home API Call (Similar to autoSuggest pattern)
    func homeAPICall() {
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/home") else {
            print("Invalid URL for home data")
            errorMessage = "Invalid home API request"
            return
        }
        
        // Add required headers
        let headers = [
            "Content-Type": "application/json",
            "Authorization": TokenProvider.getAuthHeader() ?? ""
        ]
        
        print(url)
        NetworkManager.shared.get(url: url, headers: headers) { (result: Result<HomeResponseModel, Error>) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    print("Home data fetched: \(response)")
                    self.homeResponseData = response
                    self.processHomeResponse(response)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Process API Response
    private func processHomeResponse(_ response: HomeResponseModel) {
        // Convert API destinations to local Destination model with full navigation data
        self.destinations = response.destination.map { apiDestination in
            Destination(
                name: apiDestination.title,
                imageURL: apiDestination.image,
                destinationId: apiDestination.destinationId,
                destinationType: apiDestination.destinationType,
                locationName: apiDestination.locationName,
                city: apiDestination.city,
                state: apiDestination.state,
                region: apiDestination.region
            )
        }
        
        // Convert API feature activities to local Experience model
        self.allExperiences = response.featureActivity.map { activity in
            Experience(
                imageURL: activity.thumbnail, // Changed from imageName to imageURL
                country: activity.destinationName,
                title: activity.title,
                originalPrice: Int(activity.price.strikeout?.totalAmount ?? activity.price.totalAmount),
                discount: activity.price.strikeout?.savingPercentage ?? 0,
                finalPrice: Int(activity.price.totalAmount), productCode: activity.productCode
            )
        }
        
        // Load initial experiences
        loadMoreExperiences()
    }

    func loadMoreExperiences() {
        let remaining = allExperiences.dropFirst(experiences.count)
        let nextChunk = remaining.prefix(loadCount)
        experiences.append(contentsOf: nextChunk)
    }

    private func loadMockData() {
        destinations = [
            Destination(name: "Singapore", imageName: "Birds"),
            Destination(name: "UAE", imageName: "Birds"),
            Destination(name: "Turkey", imageName: "Birds"),
            Destination(name: "China", imageName: "Birds"),
            Destination(name: "India", imageName: "Birds")
        ]

        allExperiences = [
            Experience(imageURL: "Sky", country: "Dubai", title: "Dubai Red Dunes ATV", originalPrice: 300, discount: 5, finalPrice: 295, productCode: ""),
            Experience(imageURL: "Sky", country: "Egypt", title: "Temple of Horus at Edfu", originalPrice: 300, discount: 5, finalPrice: 295, productCode: ""),
            Experience(imageURL: "Nature", country: "Bangkok", title: "Safari World Tickets", originalPrice: 300, discount: 5, finalPrice: 295, productCode: ""),
            Experience(imageURL: "Sky", country: "Turkey", title: "Land of Legends Night Show", originalPrice: 300, discount: 5, finalPrice: 295, productCode: ""),
            Experience(imageURL: "Sky", country: "Brazil", title: "Christ the Redeemer Tickets", originalPrice: 300, discount: 5, finalPrice: 295, productCode: ""),
            Experience(imageURL: "Nature", country: "Japan", title: "Mount Fuji Day Trip", originalPrice: 400, discount: 10, finalPrice: 360, productCode: "")
        ]

        loadMoreExperiences()
    }
}
