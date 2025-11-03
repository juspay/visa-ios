import SwiftUI
import Combine

struct ExperienceHomeView: View {
    @StateObject private var searchDestinationViewModel = SearchDestinationViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var isSearchSheetPresented = false
    @State private var navigateToAllDestinations = false
    @State private var navigateToExperienceList = false
    @State private var navigateToLaunchPage = false
    @State private var selectedDestination: Destination?
    @State private var experienceListSearchRequestModel: SearchRequestModel?
    @State private var showMenu = false
    @State private var showSkipSheet = false
    @State private var isDecryptionLoading = false
    @State private var showPrivacyPolicySheet = false
    @State private var hasShownPrivacyPolicyThisSession = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showSSOError = false
    @State private var ssoErrorMessage = ""
    
    let encryptPayLoadMainapp: String
    @Binding var isActive: Bool
    var onFinish: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ThemeTemplateView(
                header: { EmptyView() },
                content: {
                    ZStack {
                        if homeViewModel.isLoading || isDecryptionLoading {
                            
                            VStack {
                                LoaderView(text: "Loading Experiences")
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white)
                            .ignoresSafeArea()
                            
                        } else {
                            contentStack
                            if showMenu { sideMenu }
                        }
                        
                        // SSO error UI overlay
                        if showSSOError {
                            Color.white.opacity(0.95)
                                .edgesIgnoringSafeArea(.all)
                            Spacer()
                            VStack(spacing: 20) {
                                if let noResultImage = ImageLoader.bundleImage(named: Constants.Icons.searchNoResult) {
                                    noResultImage
                                        .resizable()
                                        .frame(width: 124, height: 124)
                                }
                                Text(ssoErrorMessage)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                Button(action: {
                                    handleAppExit()
                                }) {
                                    Text("Exit")
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(maxWidth: 100)
                                        .padding()
                                        .background(Color(hex: Constants.HexColors.primary))
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal, 24)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white)
                        }
                    }
                } ,
                onBack: { showSkipSheet = true }
            )
            
            .onAppear {
                let hasAgreed = UserDefaults.standard.bool(forKey: "hasAgreedToPrivacy")
                
                if hasAgreed {
                    // User has already agreed earlier → load immediately
                    performInitialLoad()
                } else {
                    // Show privacy policy after slight delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showPrivacyPolicySheet = true
                    }
                }
                
                // Store these globally once (for navigation)
                encryptedPayloadMain = encryptPayLoadMainapp
                globalOnFinishCallback = onFinish
            }
            
            .navigationBarBackButtonHidden(true)
            .navigationLinks(
                experienceListSearchRequestModel,
                navigateToAllDestinations: $navigateToAllDestinations,
                navigateToExperienceList: $navigateToExperienceList,
                searchDestinationViewModel: searchDestinationViewModel,
                destinations: homeViewModel.destinations
            )
            .searchSheet(
                isPresented: $isSearchSheetPresented,
                searchDestinationViewModel: searchDestinationViewModel
            ) { requestModel in
                isSearchSheetPresented = false
                experienceListSearchRequestModel = requestModel
                DispatchQueue.main.async { navigateToExperienceList = true }
            }
            .skipConfirmationSheet(
                isPresented: $showSkipSheet,
                isActive: $showSkipSheet
            ) {
                navigateToLaunchPage = true
                onFinish()
            }
            .privacyPolicySheet(
                isPresented: $showPrivacyPolicySheet,
                onAgree: {
                    UserDefaults.standard.set(true, forKey: "hasAgreedToPrivacy")
                    performInitialLoad()
                },
                onDisAgree: {
                    onFinish()
                }
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    private func performInitialLoad() {
        homeViewModel.performSSOLogin(encryptedToken: encryptPayLoadMainapp)
        
        homeViewModel.$ssoLoginResponse
            .compactMap { $0 }
            .sink { response in
                if response.status == true {
                    homeViewModel.loadHome(encryptPayload: encryptPayLoadMainapp)
                } else {
                    ssoErrorMessage = Constants.ErrorMessages.somethingWentWrong
                    showSSOError = true
                }
            }
            .store(in: &cancellables)
        
        homeViewModel.$errorMessage
            .dropFirst() // ignore initial empty value
            .sink { error in
                guard !error.isEmpty else { return }
                ssoErrorMessage = Constants.ErrorMessages.somethingWentWrong
                showSSOError = true
            }
            .store(in: &cancellables)
    }
    
    
    private func handleAppExit() {
        showSSOError = false
        onFinish()
    }
    
    private func showPrivacyPolicyIfNeeded() {
        let hasAgreed = UserDefaults.standard.bool(forKey: "hasAgreedToPrivacy")
        guard !hasAgreed else { return } // If already agreed, do nothing
        
        // Only show once on first launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showPrivacyPolicySheet = true
        }
    }
}

// MARK: - Private subviews & helpers
private extension ExperienceHomeView {
    var contentStack: some View {
        VStack(spacing: 0) {
            VStack(spacing: 14) {
                VStack(spacing: 28) {
                    topBar
                    destinationsSection
                    epicExperiencesSection
                }
            }
            .padding(.top, 22)
        }
    }
    
    var topBar: some View {
        TopBarView {
            withAnimation { isSearchSheetPresented = true }
        } onHamburgerTap: {
            withAnimation { showMenu.toggle() }
        }
    }
    
    var destinationsSection: some View {
        VStack(spacing: 10) {
            SectionHeaderView(
                title: Constants.HomeScreenConstants.exploreDestinationsHeaderText,
                showViewAll: true
            ) {
                navigateToAllDestinations = true
            }
            
            DestinationScrollView(destinations: homeViewModel.destinations) { destination in
                selectedDestination = destination
                experienceListSearchRequestModel = makeSearchRequest(for: destination)
                navigateToExperienceList = true
            }
        }
    }
    
    var epicExperiencesSection: some View {
        VStack(spacing: 10) {
            SectionHeaderView(
                title: Constants.HomeScreenConstants.epicExperiencesHeader,
                showViewAll: false
            )
            ExperienceListView(experiences: homeViewModel.experiences)
        }
    }
    
    var sideMenu: some View {
        HStack {
            SideMenuView()
                .frame(width: 340)
                .transition(.move(edge: .leading))
            Spacer()
        }
        .background(
            Color.black.opacity(0.3)
                .onTapGesture { withAnimation { showMenu.toggle() } }
        )
    }
    
    func makeSearchRequest(for destination: Destination) -> SearchRequestModel {
        let calendar = Calendar.current
        let currentDate = Date()
        let checkInDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        let checkOutDate = calendar.date(byAdding: .day, value: 2, to: checkInDate) ?? checkInDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let checkInDateString = dateFormatter.string(from: checkInDate)
        let checkOutDateString = dateFormatter.string(from: checkOutDate)
        
        return SearchRequestModel(
            destinationId: destination.destinationId,
            destinationType: destination.destinationType,
            location: destination.city,
            checkInDate: checkInDateString,
            checkOutDate: checkOutDateString,
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

// MARK: - Navigation
private extension View {
    func navigationLinks(
        _ experienceListSearchRequestModel: SearchRequestModel? = nil,
        navigateToAllDestinations: Binding<Bool>,
        navigateToExperienceList: Binding<Bool>,
        searchDestinationViewModel: SearchDestinationViewModel,
        destinations: [Destination]
    ) -> some View {
        if #available(iOS 16.0, *) {
            return self
                .navigationDestination(isPresented: navigateToAllDestinations) {
                    AllDestinationsView(
                        viewModel: searchDestinationViewModel,
                        destinations: destinations
                    )
                }
                .navigationDestination(isPresented: navigateToExperienceList) {
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
        } else {
            return self
                .navigation(
                    isActive: navigateToAllDestinations,
                    id: Constants.NavigationId.allDestinations
                ) {
                    AllDestinationsView(
                        viewModel: searchDestinationViewModel,
                        destinations: destinations
                    )
                }
                .navigation(
                    isActive: navigateToExperienceList,
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
    
    func searchSheet(
        isPresented: Binding<Bool>,
        searchDestinationViewModel: SearchDestinationViewModel,
        onSelectDestination: @escaping (SearchRequestModel) -> Void
    ) -> some View {
        overlay {
            if isPresented.wrappedValue {
                let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                    .screen.bounds.height ?? 0
                BottomSheetView(isPresented: isPresented, sheetHeight: screenHeight * 0.9) {
                    SearchDestinationBottomSheetView(
                        searchDestinationViewModel: searchDestinationViewModel,
                        onSelectDestination: onSelectDestination, isPresented: isPresented
                    )
                }
            }
        }
        .onAppear {
            searchDestinationViewModel.searchText = ""
            searchDestinationViewModel.destinations.removeAll()
        }
    }
    
    func skipConfirmationSheet(
        isPresented: Binding<Bool>,
        isActive: Binding<Bool>,
        onFinish: @escaping () -> Void
    ) -> some View {
        overlay(alignment: .bottom) {
            if isPresented.wrappedValue {
                GeometryReader { geometry in
                    let screenHeight = geometry.size.height
                    BottomSheetView(isPresented: isPresented, sheetHeight: screenHeight * 0.34) {
                        VStack(spacing: 20) {
                            
                            if let activityImage = ImageLoader.bundleImage(named: Constants.Icons.activity) {
                                activityImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                            }
                            
                            Text(Constants.HomeScreenConstants.cancelBookingText)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                            
                            HStack(spacing: 12) {
                                Button {
                                    isPresented.wrappedValue = false
                                    isActive.wrappedValue = false
                                    onFinish()
                                } label: {
                                    Text(Constants.HomeScreenConstants.skip)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(hex: Constants.HexColors.primary))
                                        .frame(width: 120, height: 48)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(hex: Constants.ColorConstants.strokeColor), lineWidth: 2)
                                        )
                                }
                                
                                Button {
                                    isPresented.wrappedValue = false
                                } label: {
                                    Text(Constants.HomeScreenConstants.stay)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 120, height: 48)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(hex: Constants.ColorConstants.fillColor))
                                        )
                                }
                            }
                            .frame(maxWidth: 260)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 25)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
}

extension View {
    func privacyPolicySheet(
        isPresented: Binding<Bool>,
        onAgree: @escaping () -> Void,
        onDisAgree: @escaping () -> Void
    ) -> some View {
        overlay(alignment: .bottom) {
            if isPresented.wrappedValue {
                GeometryReader { geometry in
                    let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                        .screen.bounds.height ?? 0
                    
                    BottomSheetView(
                        isPresented: isPresented,
                        sheetHeight: screenHeight * 0.52,
                        content: {
                            VStack(spacing: 0) {
                                if let policyImage = ImageLoader.bundleImage(named: Constants.Icons.sheild) {
                                    policyImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 48, height: 48)
                                        .padding(.top, 16)
                                }
                                Text("Your privacy is our\nresponsibility")
                                    .font(.custom("Lexend-Medium", size: 18))
                                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.bottom, 20)
                                VStack(alignment: .center, spacing: 8) {
                                    Text("Use of Your Personal data")
                                        .font(.custom("Lexend-Medium", size: 14))
                                        .foregroundColor(.black)
                                    Text("We’ll use your personal data (e.g., name, email) to create an account for BookingBash and send you transactional emails related to your bookings.")
                                        .font(.custom("Lexend-Medium", size: 14))
                                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text("By clicking \"I Agree,\" you consent to this use of your data.")
                                        .font(.custom("Lexend-Medium", size: 14))
                                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                                .padding(.bottom, 12)
                                Divider()
                                HStack(spacing: 16) {
                                    Button {
                                        isPresented.wrappedValue = false
                                        // handle exit logic here
                                        onDisAgree()
                                    } label: {
                                        Text("Exit")
                                            .font(.custom("Lexend-Medium", size: 16))
                                            .foregroundColor(Color(hex: Constants.HexColors.primary))
                                            .frame(maxWidth: .infinity, minHeight: 48)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color(hex: Constants.ColorConstants.strokeColor), lineWidth: 2)
                                            )
                                    }
                                    Button {
                                        isPresented.wrappedValue = false
                                        onAgree()
                                    } label: {
                                        Text("I Agree")
                                            .font(.custom("Lexend-Medium", size: 16))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, minHeight: 48)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color(hex: Constants.ColorConstants.fillColor))
                                            )
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 12)
                            }
                            .padding(.vertical, 0)
                            .padding(.horizontal, 25)
                            .background(Color.white)
                            .cornerRadius(20)
                            //  This line disables drag-to-dismiss only here
                            .highPriorityGesture(DragGesture())
                        },
                        productCode: nil,
                        isDragToDismissEnabled: false
                    )
                }
            }
        }
    }
}
