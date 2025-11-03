//
//  Untitled.swift
//  VisaActivity
//
//
import SwiftUI

struct ExperienceSelectedDestination: View {
    // MARK: - ViewModels
    @StateObject private var searchDestinationViewModel = SearchDestinationViewModel()
    @StateObject private var experienceViewModel = ExperienceListViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    
    // MARK: - State
    @State private var isSearchSheetPresented = false
    @State private var navigateToAllDestinations = false
    @State private var navigateToExperienceList = false
    @State private var selectedDestination: Destination?
    @State private var experienceListSearchRequestModel: SearchRequestModel?
    @State private var searchText: String = ""
    @FocusState private var isSearchFieldFocused: Bool

    
    // Currency
    @State private var isCurrencySheetPresented = false
    @State private var selectedCurrency: String = "AED"
    
    private let currencies = ["AED", "₹ INR", "$ USD", "£ GBP", "€ EUR"]
    
    var body: some View {
        ThemeTemplateView(
            needsScroll: true,
            headerHasPadding: false,
            contentHasRoundedCorners: false,
            
            // MARK: - Header (Top bar + Hero image + Search bar)
            header: {
                VStack(spacing: 0) {
                    
                    // Country & Currency row ABOVE image
                    HStack {
                        // Left (Country)
                        HStack(spacing: 6) {
                            Text("🇦🇪")
                            Text("UAE")
                                .foregroundColor(.white)
                                .bold()
                            Image(systemName: "chevron.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Right (Currency Button → Bottom Sheet)
                        Button(action: {
                            isCurrencySheetPresented = true
                        }) {
                            HStack {
                                Text(selectedCurrency)
                                    .bold()
                                
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                            }
                            .foregroundColor(.white)
                            
                        }
                        .halfSheet(showSheet: $isCurrencySheetPresented) {
                            CurrencySelectionSheet(
                                selectedCurrency: $selectedCurrency,
                                isPresented: $isCurrencySheetPresented,
                                currencies: currencies
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                    
                    //  Image with floating search bar
                    GeometryReader { proxy in
                        ZStack(alignment: .bottom) {
                            if let destinationImg = ImageLoader.bundleImage(named: "DestinationImg") {
                                destinationImg
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: proxy.size.width, height: 300)
                                    .mask(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .frame(width: proxy.size.width, height: 300)
                                            .padding(.bottom, -16) // keeps bottom corners square
                                    )
                            }
                            
                            SearchBarView(
                                viewModel: searchDestinationViewModel,
                                searchPlaceholderText: "Search attractions / city",
                                searchText: $searchText, isFocused: $isSearchFieldFocused
                            )
                            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 16)
                            .offset(y: -20)
                            .onTapGesture {
                                withAnimation { isSearchSheetPresented = true }
                            }
                        }
                    }
                    .frame(height: 300)
                }
            },
            
            // MARK: - Content (below white background)
            content: {
                VStack(spacing: 28) {
                    
                    // Explore Cities
                    VStack(spacing: 10) {
                        Spacer()
                        SectionHeaderView(
                            title: Constants.HomeScreenConstants.exploreCitiesHeaderText,
                            showViewAll: true
                        )
                        
                        DestinationScrollView(destinations: homeViewModel.destinations) { destination in
                            selectedDestination = destination
                            experienceListSearchRequestModel = makeSearchRequest(for: destination)
                            navigateToExperienceList = true
                        }
                    }
                    
                    // Epic Experiences
                    VStack(spacing: 10) {
                        SectionHeaderView(
                            title: Constants.HomeScreenConstants.epicExperiences,
                            showViewAll: false
                        )
                        ExperienceListView(experiences: homeViewModel.experiences)
                    }
                }
                .onAppear {
//                    searchDestinationViewModel.decryptPayload("dummy")
                    homeViewModel.loadHome(encryptPayload: "encryptPayLoad")

                }
            }
        )
    }
}

// MARK: - Currency Selection Bottom Sheet
struct CurrencySelectionSheet: View {
    @Binding var selectedCurrency: String
    @Binding var isPresented: Bool
    let currencies: [String]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Left-aligned title
                Text("Select Currency")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                Divider() // optional thin line
                Spacer()
                
                // Currency options
                ForEach(currencies, id: \.self) { currency in
                    Button(action: {
                        selectedCurrency = currency
                        isPresented = false
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                // Outer circle
                                Image(systemName: "circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
                                
                                // Inner circle (only if selected)
                                if selectedCurrency == currency {
                                    Circle()
                                        .fill(Color(hex: Constants.HexColors.primary))
                                        .frame(width: 10, height: 10) // smaller inner circle
                                }
                            }
                            
                            Text(currency)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer(minLength: 0)
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Helpers
private extension ExperienceSelectedDestination {
    func makeSearchRequest(for destination: Destination) -> SearchRequestModel {
        SearchRequestModel(
            destinationId: destination.destinationId,
            destinationType: destination.destinationType,
            location: destination.city,
            checkInDate: Constants.ExperienceHomeConstants.defaultCheckInDate,
            checkOutDate: Constants.ExperienceHomeConstants.defaultCheckOutDate,
            currency: Constants.ExperienceHomeConstants.defaultCurrency,
            clientId: Constants.ExperienceHomeConstants.defaultClientId,
            enquiryId: Constants.ExperienceHomeConstants.defaultEnquiryId,
            productCode: [],
            filters: SearchFilters(
                limit: 700,
                offset: Constants.ExperienceHomeConstants.defaultOffset,
                priceRange: [],
                rating: [],
                duration: [],
                reviewCount: [],
                sort_by: SortBy(
                    name: Constants.ExperienceHomeConstants.defaultSortName,
                    type: Constants.ExperienceHomeConstants.defaultSortType
                ),
                categories: [],
                language: Constants.ExperienceHomeConstants.supportedLanguages,
                itineraryType: [],
                ticketType: [],
                confirmationType: [],
                featureFlags: Constants.ExperienceHomeConstants.featureFlags,
                productCode: []
            )
        )
    }
}

extension View {
    func halfSheet<SheetView: View>(
        showSheet: Binding<Bool>,
        @ViewBuilder sheetView: @escaping () -> SheetView
    ) -> some View {
        self.background(
            HalfSheetHelper(sheetView: sheetView(), showSheet: showSheet)
        )
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    var sheetView: SheetView
    @Binding var showSheet: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if showSheet {
            let sheetController = UIHostingController(rootView: sheetView)
            sheetController.modalPresentationStyle = .pageSheet
            
            if let sheet = sheetController.presentationController as? UISheetPresentationController {
                //  custom height for the screen
                if #available(iOS 16.0, *) {
                    sheet.detents = [.custom { context in
                        return context.maximumDetentValue * 0.45
                    }]
                } else {
                    // fallback for iOS 15: use .medium() which is smaller than .large()
                    sheet.detents = [.medium()]
                }
                sheet.prefersGrabberVisible = true
            }
            
            uiViewController.present(sheetController, animated: true) {
                showSheet = false
            }
        }
    }
}
