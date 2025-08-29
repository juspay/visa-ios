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
    @ObservedObject var viewModel = SearchDestinationViewModel()
    @State private var navigateToExperienceListDetailView = false
    
    var body: some View {
        VStack(spacing: 18) {
            SearchBarView(
                viewModel: viewModel,
                searchPlaceholderText: Constants.HomeScreenConstants.searchDestination,
                searchText: $viewModel.searchText
            )
            
//            SectionView(
//                title: Constants.searchScreenConstants.searchResults,
//                showClear: false,
//                destinations: viewModel.destinations,
//                onClear: nil,
//                onTap: { destination in
//                    viewModel.selectDestination(destination)
//                    navigateToExperienceListDetailView = true
//                }
//            )

            if viewModel.searchText.count >= 3 && viewModel.destinations.isEmpty {
                NoResultsView()
                    .padding(.top, 100)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                    //    if viewModel.searchText.count >= 3 {
                            SectionView(
                                title: Constants.searchScreenConstants.searchResults,
                                showClear: false,
                                destinations: viewModel.destinations,
                                onClear: nil,
                                onTap: { destination in
                                    viewModel.selectDestination(destination)
                                    navigateToExperienceListDetailView = true
                                }
                            )
 //                       }
//                        else {
//                            if !viewModel.recentSearches.isEmpty {
//                                SectionView(
//                                    title: Constants.searchScreenConstants.recentSearches,
//                                    showClear: true,
//                                    destinations: viewModel.recentSearches,
//                                    onClear: viewModel.clearRecentSearches,
//                                    onTap: { destination in
//                                        viewModel.selectDestination(destination)
//                                        navigateToExperienceListDetailView = true
//                                    }
//                                )
//                            }
//                            SectionView(
//                                title: Constants.searchScreenConstants.selectDestination,
//                                showClear: false,
//                                destinations: viewModel.allDestinations,
//                                onClear: nil,
//                                onTap: { destination in
//                                    viewModel.selectDestination(destination)
//                                    navigateToExperienceListDetailView = true
//                                }
//                            )
//                        }
                    }
                    .padding(.bottom, 30)
                }
                .introspect(.scrollView, on: .iOS(.v15...)) { scrollView in
                    scrollView.bounces = false
                }
                .padding(.bottom, 20)
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
            ExperienceListDetailView()
        }
    }
}
