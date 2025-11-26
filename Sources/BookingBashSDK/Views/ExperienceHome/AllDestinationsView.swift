import SwiftUI
import SUINavigation

struct AllDestinationsView: View {
    @ObservedObject var viewModel: SearchDestinationViewModel
    let destinations: [Destination]
    @State private var searchText = ""
    @State private var navigateToExperienceList = false
    @State private var experienceListSearchRequestModel: SearchRequestModel?
    @StateObject private var experienceListViewModel = ExperienceListViewModel()
    
    // Filtered destinations based on searchText
    
    var filteredDestinations: [Destination] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Show all destinations until user types at least 3 characters
        guard trimmed.count >= 3 else {
            return destinations
        }
        
        // Filter results only when 3 or more letters are typed
        return destinations.filter {
            $0.city.localizedCaseInsensitiveContains(trimmed) ||
            $0.name.localizedCaseInsensitiveContains(trimmed) ||
            $0.region.localizedCaseInsensitiveContains(trimmed)
        }
    }

    
    var body: some View {
        GeometryReader { geo in
            ThemeTemplateView(
                header: {
                    ExploreDestinationsHeaderView()
                        .padding(.bottom, 12)
                },
                content: {
                    VStack {
                        Spacer()
                        // Add search bar to search destinations
                        ExperienceSearchBarView(
                            viewModel: experienceListViewModel,
                            searchPlaceholderText: "Search attractions / city",
                            searchText: $searchText
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                        Spacer()
                        if filteredDestinations.isEmpty {
                            NoResultsView()
                                .padding(.top, 100)
                        } else {
                            DestinationGridView(destinations: filteredDestinations, geo: geo) { destination in
                                // Calculate check-in and check-out dates dynamically
                                let calendar = Calendar.current
                                let currentDate = Date()
                                let checkInDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                                let checkOutDate = calendar.date(byAdding: .day, value: 2, to: checkInDate) ?? checkInDate
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                let checkInDateString = dateFormatter.string(from: checkInDate)
                                let checkOutDateString = dateFormatter.string(from: checkOutDate)
                                
                                let requestModel = SearchRequestModel(
                                    destinationId: destination.destinationId,
                                    destinationType: Int(destination.destinationType),
                                    location: destination.city,
                                    checkInDate: checkInDateString,
                                    checkOutDate: checkOutDateString,
                                    currency: "AED",
                                    clientId: "CLIENT_ABC123",
                                    enquiryId: "ENQ_456XYZ",
                                    productCode: [],
                                    filters: SearchFilters(
                                        limit: 700,
                                        offset: 0,
                                        priceRange: [],
                                        rating: [],
                                        duration: [],
                                        reviewCount: [],
                                        sort_by: SortBy(name: "price", type: "ASC"),
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
                                experienceListSearchRequestModel = requestModel
                                navigateToExperienceList = true
                            }
                        }
                    }
                })
            .navigationBarBackButtonHidden(true)
            .navigation(
                isActive: $navigateToExperienceList,
                id: Constants.NavigationId.experienceListDetailView
            ) {
                if let requestModel = experienceListSearchRequestModel {
                    ExperienceListDetailView(
                        destinationId: requestModel.destinationId,
                        destinationType: Int(requestModel.destinationType) ,
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
}
