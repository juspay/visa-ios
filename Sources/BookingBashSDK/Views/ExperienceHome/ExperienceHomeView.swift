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
//    @State private var showMenu = false
    @State private var showSkipSheet = false
    @State private var showPrivacyPolicySheet = false
    @State private var hasShownPrivacyPolicyThisSession = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var showSSOError = false
    @State private var ssoErrorMessage = ""
    @State private var selectedCountry = ""
    @State private var navigationToListFromSearch = false

    let encryptPayLoadMainapp: String
    @Binding var isActive: Bool
    let environment: String
    var onFinish: () -> Void
    
    public init(
        encryptPayLoadMainapp: String,
        isActive: Binding<Bool>,
        onFinish: @escaping () -> Void,
        environment: String // "sandbox" or "production"
    ) {
        self.encryptPayLoadMainapp = encryptPayLoadMainapp
        self._isActive = isActive
        self.onFinish = onFinish
        self.environment = environment
        
        ConfigurationManager.shared.configure(for: environment)
    }

    var body: some View {
        GeometryReader { geo in
            ThemeTemplateView(
                header: { EmptyView() },
                content: {
                    ZStack {
                        if homeViewModel.isLoading {
                            VStack {
                                LoaderView(text: Constants.ExperienceHomeViewConstants.loadingExperience)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white)
                            .ignoresSafeArea()
                            
                        } else {
                            contentStack
                            if homeViewModel.showMenu { sideMenu }
                        }
                        
                        // SSO error UI overlay
                        if showSSOError {
                            Color.white.opacity(0.95)
                                .edgesIgnoringSafeArea(.all)
                            Spacer()
                            VStack(spacing: 20) {
                                ErrorMessageView(errorMessage: .authFail)
                                    .padding(.top, 60)
                                Button(action: {
                                    handleAppExit()
                                }) {
                                    Text(Constants.PrivacyPolicyConstants.exitButton)
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
                navigationToListFromSearch = false
            }
            .onAppearOnce {
                let hasAgreed = UserDefaults.standard.bool(forKey: Constants.ExperienceHomeViewConstants.hasAgreedToPrivacy)
                
                if hasAgreed {
                    // User has already agreed earlier → load immediately
                    homeViewModel.performInitialLoad(
                        encryptedToken: encryptPayLoadMainapp,
                        onError: { errorMsg in
                            ssoErrorMessage = errorMsg
                            showSSOError = true
                        }
                    )
                } else {
                    // Show privacy policy after slight delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showPrivacyPolicySheet = true
                    }
                }
                
                // Store these globally once (for navigation)
                encryptedPayloadMain = encryptPayLoadMainapp
                globalOnFinishCallback = onFinish
                environmentType = environment
            }
            .onReceive(
                NotificationCenter.default.publisher(for: .currencyDidChange)
            ) { notification in
                if let currency = notification.userInfo?["currency"] as? String {
                    print("Currency changed to:", currency)
                    homeViewModel.fetchHomeData()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationLinks(
                experienceListSearchRequestModel,
                navigateToAllDestinations: $navigateToAllDestinations,
                navigateToExperienceList: $navigateToExperienceList,
                searchDestinationViewModel: searchDestinationViewModel,
                destinations: homeViewModel.destinations,
                selectedCountry: selectedDestination?.name ?? "",
                navigationToListFromSearch: navigationToListFromSearch
            )
            .searchSheet(
                isPresented: $isSearchSheetPresented,
                destinations: homeViewModel.destinations,
                searchDestinationViewModel: searchDestinationViewModel
            ) { requestModel in
                isSearchSheetPresented = false
                experienceListSearchRequestModel = requestModel
                DispatchQueue.main.async {
                    navigateToExperienceList = true
                    navigationToListFromSearch = true
                }
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
                    UserDefaults.standard.set(true, forKey: Constants.ExperienceHomeViewConstants.hasAgreedToPrivacy)
                    homeViewModel.performInitialLoad(
                        encryptedToken: encryptPayLoadMainapp,
                        onError: { errorMsg in
                            ssoErrorMessage = errorMsg
                            showSSOError = true
                        }
                    )
                },
                onDisAgree: {
                    onFinish()
                }
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func handleAppExit() {
        showSSOError = false
        onFinish()
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
            withAnimation { homeViewModel.showMenu.toggle() }
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
                experienceListSearchRequestModel = searchDestinationViewModel.buildRequestModel(
                    from: destination.name,
                    id: destination.destinationId,
                    type: destination.destinationType
                )
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
            ExperienceListView(experiences: $homeViewModel.experiences)
        }
    }
    
    var sideMenu: some View {
        HStack {
            SideMenuView(viewModel: homeViewModel)
                .frame(width: 340)
                .transition(.move(edge: .leading))
            Spacer()
        }
        .background(
            Color.black.opacity(0.3)
                .onTapGesture { withAnimation { homeViewModel.showMenu.toggle() } }
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
        destinations: [Destination],
        selectedCountry: String,
        navigationToListFromSearch: Bool
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
                            checkInDate: requestModel.checkInDate,
                            checkOutDate: requestModel.checkOutDate,
                            currency: requestModel.currency,
                            productCodes: requestModel.productCode,
                            countryName: selectedCountry,
                            navigationToListFromSearch: navigationToListFromSearch
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
                            checkInDate: requestModel.checkInDate,
                            checkOutDate: requestModel.checkOutDate,
                            currency: requestModel.currency,
                            productCodes: requestModel.productCode,
                            countryName: selectedCountry ,
                            navigationToListFromSearch: navigationToListFromSearch
                        )
                    }
                }
        }
    }
}
