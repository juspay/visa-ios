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
                            // Calculate check-in and check-out dates dynamically
                            let calendar = Calendar.current
                            let currentDate = Date()
                            let checkInDate = calendar.date(byAdding: .day, value: 20, to: currentDate) ?? currentDate
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
                                    limit: 50,
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
