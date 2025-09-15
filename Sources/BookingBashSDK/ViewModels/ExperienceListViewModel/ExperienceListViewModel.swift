//
//  ExperienceListViewModel.swift
//  VisaActivity
//
//  Created by Apple on 30/07/25.
//

import Foundation

class ExperienceListViewModel: ObservableObject {
    @Published var experiences: [ExperienceListModel] = []
    @Published var searchDestination: SearchResponseModel?
    @Published var searchRequestModel: SearchRequestModel?
    @Published var isLoading = false
    
    @Published var errorMessage: String?
    
    func fetchSearchData(
        destinationId: String,
        destinationType: String,
        location: String,
        checkInDate: String,
        checkOutDate: String,
        currency: String,
        productCodes: [String] = []
    ) {
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/search") else
        { return }
        
        isLoading = true
        errorMessage = nil
        
        let filters = SearchFilters(
            limit: 50,
            offset: 0,
            priceRange: [],
            rating: [],
            duration: [],
            reviewCount: [],
            sortBy: SortBy(name: "price", type: "ASC"),
            categories: [],
            language: ["en", "ar"],
            itineraryType: [],
            ticketType: [],
            confirmationType: [],
            featureFlags: [
                "free_cancellation",
                "special_offer",
                "private_tour",
                "skip_the_line",
                "likely_to_sell_out"
            ],
            productCode: productCodes
        )
        
        let requestBody = SearchRequestModel(
            destinationId: destinationId,
            destinationType: destinationType,
            location: location,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            currency: currency,
            clientId: "CLIENT_ABC123",
            enquiryId: "ENQ_456XYZ",
            productCode: productCodes,
            filters: filters
        )
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": TokenProvider.getAuthHeader() ?? "",
            "token": encryptedPayload
        ]
        
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<SearchResponseModel, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    if let responseData = response.data {
                        self.searchDestination = response
                        self.setUIData(responseData: responseData)
                        print("response from list view - \(response)")
                        print(" Decoded Response:", responseData)
                    } else {
                        self.errorMessage = "No data in response"
                    }
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ Error:", error.localizedDescription)
                }
            }
        }
    }
    
    private func setUIData(responseData: SearchDataModel?) {
        guard let responseData = responseData else { return }
        
        let newExperiences = responseData.result.map {
            ExperienceListModel(
                title: $0.title,
                rating: Double($0.rating),
                reviewCount: $0.reviewCount,
                price: Int($0.price.baseRate.rounded()),
                imageName: $0.thumbnail,
                productCode: $0.productCode,
                currency: $0.price.currency
            )
        }
        
        experiences = newExperiences
    }
}
