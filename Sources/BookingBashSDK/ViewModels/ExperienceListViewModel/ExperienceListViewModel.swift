//
//  ExperienceListViewModel.swift
//  VisaActivity
//
//  Created by Apple on 30/07/25.
//

import Foundation

class ExperienceListViewModel: ObservableObject {
    @Published var experiences: [ExperienceListModel] = []
//    [
//        ExperienceListModel(title: "Dubai Parks And Resorts", rating: 4.8, reviewCount: 269, price: 1200, imageName: "Sky"),
//        ExperienceListModel(title: "Luxury Dubai Canal Cruise + La Perle Silver Pass Combo", rating: 4.8, reviewCount: 269, price: 1200, imageName: "Sky"),
//        ExperienceListModel(title: "Dubai Parks And Resorts", rating: 4.8, reviewCount: 269, price: 1200, imageName: "Sky"),
//        ExperienceListModel(title: "Luxury Dubai Canal Cruise + La Perle Silver Pass Combo", rating: 4.8, reviewCount: 269, price: 1200, imageName: "Sky"),
//        ExperienceListModel(title: "Dubai Parks And Resorts", rating: 4.8, reviewCount: 269, price: 1200, imageName: "Sky"),
//        ExperienceListModel(title: "Luxury Dubai Canal Cruise + La Perle Silver Pass Combo", rating: 4.8, reviewCount: 269, price: 1200, imageName: "Sky")
//    ]
    @Published var searchDestination: SearchResponseModel?
    @Published var errorMessage: String?
    
    func fetchSearchData() {
        guard let url = URL(string: "https://common-servicessit.vetravel.io/api/activities/2.0/search") else { return }
        
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
            productCode: ["PRD123", "PRD456"]
        )
        
        let requestBody = SearchRequestModel(
            destinationId: "12633",
            destinationType: "CITY",
            location: "Dubai",
            checkInDate: "2025-10-24",
            checkOutDate: "2025-10-25",
            currency: "INR",
            clientId: "CLIENT_ABC123",
            enquiryId: "ENQ_456XYZ",
            productCode: ["PRD123", "PRD456"],
            filters: filters
        )
        
        NetworkManager.shared.post(url: url, body: requestBody) { (result: Result<SearchResponseModel, Error>) in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let response):
                    if let responseData = response.data {
                        searchDestination?.data = responseData
                        setUIData(responseData: responseData)
                        print(responseData)
                        print("\n\n")
                    } else {
                        print("error in fetching data")
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func setUIData(responseData: SearchDataModel?) {
        guard let responseData = responseData else {
            return
        }
        let newExperiences = responseData.result.map {
            ExperienceListModel(
                title: $0.title,
                rating: Double($0.rating),
                reviewCount: $0.reviewCount,
                price: Int($0.price.baseRate),
                imageName: "Sky",
                productCode: $0.productCode,
                currency: $0.price.currency
            )
        }
        
        experiences.append(contentsOf: newExperiences)
    }
}
