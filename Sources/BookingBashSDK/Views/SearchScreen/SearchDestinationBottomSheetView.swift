//
//  SearchDestinationBottomSheetView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SwiftUI
import SUINavigation
@_spi(Advanced) import SwiftUIIntrospect

struct SearchDestinationBottomSheetView: View {
    @ObservedObject var experienceViewModel = ExperienceListViewModel()
    @ObservedObject var viewModel = SearchDestinationViewModel()
    @State private var navigateToExperienceListDetailView = false

    var body: some View {
        VStack(spacing: 18) {
            SearchBarView(
                viewModel: viewModel,
                searchPlaceholderText: Constants.HomeScreenConstants.searchDestination,
                searchText: $viewModel.searchText
            )

            if viewModel.searchText.count >= 3 && viewModel.destinations.isEmpty {
                NoResultsView()
                    .padding(.top, 100)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        SectionView(
                            title: Constants.searchScreenConstants.searchResults,
                            showClear: false,
                            destinations: viewModel.destinations,
                            onClear: nil,
                            onTap: { destination in
                                // Suppose you can get full API object from autoSuggestDestinations
                                if let fullData = viewModel.autoSuggestDestinations?.data.first(where: { $0.title == destination.name }) {
                                    viewModel.selectDestination(destination, fullData: fullData)
                                    
                                    // Prepare ExperienceListViewModel request
                                    experienceViewModel.searchRequestModel = SearchRequestModel(
                                        destinationId: fullData.destinationId,
                                        destinationType: fullData.destinationType,
                                        location: fullData.title,
                                        checkInDate: "2025-10-24", // Can later replace with dynamic date
                                        checkOutDate: "2025-10-25",
                                        currency: "INR",
                                        clientId: "CLIENT_ABC123",
                                        enquiryId: "ENQ_456XYZ",
                                        productCode: [],
                                        filters: SearchFilters(
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
                                            productCode: []
                                        )
                                    )
                                    
                                    navigateToExperienceListDetailView = true
                                }
                            }
                        )
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
        .padding(.horizontal, 15)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigation(isActive: $navigateToExperienceListDetailView,
                    id: Constants.NavigationId.experienceListDetailView) {
            if let requestModel = experienceViewModel.searchRequestModel {
                ExperienceListDetailView(
                    destinationId: requestModel.destinationId,
                    destinationType: requestModel.destinationType,
                    location: requestModel.location,
                    checkInDate: requestModel.checkInDate,
                    checkOutDate: requestModel.checkOutDate,
                    currency: requestModel.currency,
                    productCodes: requestModel.productCode
                )
            }
        }
    }
}

