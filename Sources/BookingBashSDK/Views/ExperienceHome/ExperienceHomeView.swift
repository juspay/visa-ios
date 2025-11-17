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
                        if homeViewModel.isLoading {
                            
                            VStack {
                                LoaderView(text: Constants.ExperienceHomeViewConstants.loadingExperience)
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
                                ErrorMessageView()
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
}
