import SwiftUI

struct SearchDestinationBottomSheetView: View {
    @ObservedObject var searchDestinationViewModel: SearchDestinationViewModel
    var onSelectDestination: (SearchRequestModel) -> Void
    @FocusState private var isSearchFieldFocused: Bool
    @Binding var isPresented: Bool
    @State private var isContentVisible: Bool = false

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                    isSearchFieldFocused = false
                }

            VStack(spacing: 18) {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }

                SearchBarView(
                    viewModel: searchDestinationViewModel,
                    searchPlaceholderText: Constants.HomeScreenConstants.searchDestination,
                    searchText: $searchDestinationViewModel.searchText,
                    isFocused: $isSearchFieldFocused
                )
                .transaction { $0.animation = nil }

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
            .opacity(isContentVisible ? 1 : 0)
            .animation(.easeOut(duration: 0.15), value: isContentVisible)
        }
        .onAppear {
            isContentVisible = true
            DispatchQueue.main.async {
                isSearchFieldFocused = true
            }
        }
    }
}

