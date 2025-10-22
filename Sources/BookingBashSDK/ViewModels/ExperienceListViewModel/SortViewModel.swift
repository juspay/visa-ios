//
//  SortViewModel.swift
//  VisaActivity
//
//  Created by Apple on 31/07/25.
//

import Foundation
import SwiftUI
import Combine

class SortViewModel: ObservableObject {
    @Published var selectedOption: SortOption?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: ExperienceListService
    private var viewModel: ExperienceListViewModel
    
    let options: [SortOption] = [
        SortOption(title: "Price - Low to high"),
        SortOption(title: "Price - High to low")
    ]
    
    init(viewModel: ExperienceListViewModel,
         service: ExperienceListService = DefaultExperienceListService()) {
        self.viewModel = viewModel
        self.service = service
        self.selectedOption = options.first
    }
    
    func select(_ option: SortOption) {
        selectedOption = option
        fetchSortedExperiences()
    }
    
    private func fetchSortedExperiences() {
        guard let selectedOption = selectedOption,
              let requestModel = viewModel.searchRequestModel else { return }
        
        isLoading = true
        errorMessage = nil
        
        let updatedSortBy: SortBy = {
            switch selectedOption.title {
            case "Price - Low to high": return SortBy(name: "price", type: "ASC")
            case "Price - High to low": return SortBy(name: "price", type: "DESC")
            default: return SortBy(name: "price", type: "ASC") // fallback to ASC if needed
            }
        }()
        
        var updatedRequest = requestModel
        updatedRequest.filters.sort_by = updatedSortBy
        viewModel.searchRequestModel = updatedRequest
        
        service.fetchSearchData(requestBody: updatedRequest) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    if let data = response.data {
                        self.viewModel.searchDestination = response
                        self.viewModel.experiences = self.viewModel.mapResponseToUIModels(data)
                    } else {
                        self.errorMessage = "No data in response"
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
