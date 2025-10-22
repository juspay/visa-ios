

import SwiftUI

struct SearchDestinationBottomSheetView: View {
    @ObservedObject var searchDestinationViewModel: SearchDestinationViewModel
    var onSelectDestination: (SearchRequestModel) -> Void
    
    var body: some View {
        VStack(spacing: 18) {
            SearchBarView(
                viewModel: searchDestinationViewModel,
                searchPlaceholderText: Constants.HomeScreenConstants.searchDestination,
                searchText: $searchDestinationViewModel.searchText
            )
            
            if searchDestinationViewModel.shouldShowNoResults {
                NoResultsView()
                    .padding(.top, 100)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        if searchDestinationViewModel.shouldShowRecentSearches {
                            SectionView(
                                title: Constants.searchScreenConstants.recentSearches,
                                showClear: true,
                                destinations: searchDestinationViewModel.recentSearches,
                                onClear: searchDestinationViewModel.clearRecentSearches,
                                onTap: { searchDestinationViewModel.handleDestinationTap($0, onSelect: onSelectDestination) }
                            )
                        }
                        
                        if !searchDestinationViewModel.destinations.isEmpty {
                            SectionView(
                                title: Constants.searchScreenConstants.searchResults,
                                showClear: false,
                                destinations: searchDestinationViewModel.destinations,
                                onClear: nil,
                                onTap: { searchDestinationViewModel.handleDestinationTap($0, onSelect: onSelectDestination) }
                            )
                        }
                    }
                }
            }
        }
        .padding()
    }
}

