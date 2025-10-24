import SwiftUI
import SUINavigation

struct ExperienceCheckoutView: View {
    @ObservedObject private var checkoutViewModel: ExperienceCheckoutViewModel
    @ObservedObject private var experienceDetailViewModel: ExperienceDetailViewModel
    @ObservedObject private var availabilityViewModel: ExperienceAvailabilitySelectOptionsViewModel
    
    let package: Package
    let model: ExperienceDetailModel
    let productCode: String
    let currency: String?
    let subActivityCode : String
    let uid : String
    let availabilityKey : String
    
    @State private var guestDetails = GuestDetails()
    @State private var showAll = false
    @State private var showFairSummary = false
    @State private var isConsentBoxChecked = false
    @State private var navigateToConfirmation = false
    
    init(
        checkoutViewModel: ExperienceCheckoutViewModel,
        experienceDetailViewModel: ExperienceDetailViewModel,
        availabilityViewModel: ExperienceAvailabilitySelectOptionsViewModel,
        package: Package,
        model: ExperienceDetailModel,
        productCode: String,
        currency: String,
        subActivityCode: String,
        uid: String,
        availabilityKey: String
    ) {
        self._checkoutViewModel = ObservedObject(wrappedValue: checkoutViewModel)
        self._experienceDetailViewModel = ObservedObject(wrappedValue: experienceDetailViewModel)
        self._availabilityViewModel = ObservedObject(wrappedValue: availabilityViewModel)
        self.package = package
        self.model = model
        self.productCode = productCode
        self.currency = currency
        self.subActivityCode = subActivityCode
        self.uid = uid
        self.availabilityKey = availabilityKey
    }
    
    var body: some View {
        ZStack {
            ThemeTemplateView(
                header: { headerSection },
                content: { contentSection }
            )
            .navigationBarBackButtonHidden(true)
            .safeAreaInset(edge: .bottom) { paymentBarSection }
            .overlay { bottomSheetOverlay }
            
            toastOverlay
            navigationLinks
            
            if checkoutViewModel.isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
                    onAppear()
                    
                    if experienceDetailViewModel.items.isEmpty {
                        print(" Refetching data for checkout screen...")
                        experienceDetailViewModel.fetchReviewData(
                            activityCode: productCode,
                            currency: currency ?? "AED"
                        )
                    }
                }
    }
}

private extension ExperienceCheckoutView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            MainTopHeaderView(headerText: Constants.CheckoutPageConstants.checkoutHeaderText)
                .padding(.bottom, 6)
            
            VStack(alignment: .leading, spacing: 16) {
                ExperienceTopImageCarousalListView(experienceDetailCarousalModel: checkoutViewModel.carousalData)
                    .padding(.trailing, -15)
                
                BookedExperienceDetailInfoTopLocationView(
                    title: model.title,
                    location: checkoutViewModel.location ?? ""
                )
                
                BookedExperienceDateTimeView(
                    color: .white,
                    shouldShowRefundable: false,
                    selectedDate: checkoutViewModel.formattedSelectedDate(availabilityViewModel.selectedDateFromCalender),
                    selectedParticipants: availabilityViewModel.participantsSummary
                )
            }
        }
    }
    
    var contentSection: some View {
        VStack(spacing: 16) {
            FeatureGridView(features: experienceDetailViewModel.allFeatures, showAll: $showAll)
            GuestDetailsFormView(details: $guestDetails)
            
            FareSummaryCardView(
                fairSummaryData: checkoutViewModel.fairSummaryData,
                totalPrice: checkoutViewModel.formattedTotalAmount,
                totalLableText: Constants.CheckoutPageConstants.total,
                savingsText: checkoutViewModel.savingsTextforFareBreakup
            )
            
            InfoListView(viewModel: experienceDetailViewModel)
            
            CheckboxTermsView(
                isAgreed: $isConsentBoxChecked,
                termsAndConditionTapped: { checkoutViewModel.handleTermsTapped() },
                privacyPolicytapped: { checkoutViewModel.handlePrivacyTapped() }
            )
            
            if let errorMessage = checkoutViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 4)
            }
        }
        .padding()
    }
    
    var paymentBarSection: some View {
        ExperienceBottomPaymentBarView(
            buttonText: Constants.CheckoutPageConstants.saveContinue,
            payNowButtonTapped: { checkoutViewModel.handlePayNowTapped(guestDetails: guestDetails, isConsentBoxChecked: isConsentBoxChecked) },
            infoButtontapped: { showFairSummary = true },
            price: checkoutViewModel.formattedTotalAmount,
            isLoading: checkoutViewModel.isLoading
        )
    }
    
    var bottomSheetOverlay: some View {
        BottomSheetView(isPresented: $showFairSummary) {
            FareSummaryCardView(
                fairSummaryData: checkoutViewModel.fairSummaryData,
                totalPrice: checkoutViewModel.formattedTotalAmount,
                totalLableText: Constants.CheckoutPageConstants.total
            )
            .padding()
        }
    }
    
    var toastOverlay: some View {
        Group {
            if checkoutViewModel.showToast {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ToastView(message: checkoutViewModel.toastMessage)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.easeInOut, value: checkoutViewModel.showToast)
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    var navigationLinks: some View {
        Group {
            NavigationLink(isActive: $checkoutViewModel.shouldNavigateToPayment) {
                PaymentView(
                    orderId: checkoutViewModel.orderNo ?? "",
                    paymentUrl: checkoutViewModel.paymentUrl ?? "",
                    participantsSummary: availabilityViewModel.participantsSummary
                )
                .navigationBarBackButtonHidden(true)
            } label: { EmptyView() }
            
            NavigationLink(isActive: $checkoutViewModel.shouldNavigateToTerms) {
                TermsAndConditionsWebView(
                    url: termsAndConditionsUrlGlobal,
                    title: "Terms & Conditions"
                )
            } label: { EmptyView() }
            
            NavigationLink(isActive: $checkoutViewModel.shouldNavigateToPrivacy) {
                TermsAndConditionsWebView(
                    url: privacyPolicyUrlGlobal,
                    title: "Privacy Policy"
                )
            } label: { EmptyView() }
        }
    }
}

private extension ExperienceCheckoutView {
    func onAppear() {
        // Set the selected package in the checkout view model to access subActivityCode
        checkoutViewModel.setSelectedPackage(package)
        
        // Set the availability response to access track_id
        checkoutViewModel.setAvailabilityResponse(availabilityViewModel.response)
        
        // Set the dynamic uid and availabilityKey from the passed parameters
        checkoutViewModel.setUid(uid)
        checkoutViewModel.setAvailabilityKey(availabilityKey)
        
        checkoutViewModel.selectedTravelDate = availabilityViewModel.selectedDateFromCalender
        checkoutViewModel.fetchData()
//        experienceDetailViewModel.fetchReviewData(
//            activityCode: productCode,
//            currency: currency ?? ""
//        )
    }
}
