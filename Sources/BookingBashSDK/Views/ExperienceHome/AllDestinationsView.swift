import SwiftUI
import SUINavigation

struct AllDestinationsView: View {
    @ObservedObject var viewModel: SearchDestinationViewModel
    let destinations: [Destination]
    @State private var searchText = ""
    @State private var navigateToExperienceList = false
    @State private var experienceListSearchRequestModel: SearchRequestModel?

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
                    DestinationGridView(destinations: destinations, geo: geo) { destination in
                        // Prepare SearchRequestModel similar to ExperienceHomeView
                        let requestModel = SearchRequestModel(
                            destinationId: destination.destinationId,
                            destinationType: destination.destinationType,
                            location: destination.city,
                            checkInDate: "2025-10-24",
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
                        experienceListSearchRequestModel = requestModel
                        navigateToExperienceList = true
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
}
