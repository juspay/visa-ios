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
    let selectedTime: String
    
    @State private var guestDetails = GuestDetails()
    @State private var extraGuests: [String: [GuestDetails]] = [:]
    @State private var showAll = false
    @State private var showFairSummary = false
    @State private var isConsentBoxChecked = false
    @State private var navigateToConfirmation = false
    @State private var showCountryCodeList: Bool = false

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
        availabilityKey: String,
        selectedTime: String
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
        self.selectedTime = selectedTime
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
            .searchCountryCodeSheet(isPresented: $showCountryCodeList, countries: MobileCodeData.allCodes) { countryCode in
                guestDetails.mobileCountryCode = countryCode?.dialCode ?? ""
                guestDetails.mobileNumber = ""
            }
            toastOverlay
            navigationLinks
            
            // Show No Result Placeholder if API status is false or statusCode != 200
            if checkoutViewModel.showNoResultImage && (checkoutViewModel.errorStatusCode != 200 || checkoutViewModel.errorMessage != nil) {
                VStack(spacing: 12) {
                    ErrorMessageView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.95))
                .edgesIgnoringSafeArea(.all)
            }
            
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
                // Refetching data for checkout screen...
                experienceDetailViewModel.fetchReviewData(
                    activityCode: productCode,
                    currency: currency ?? "AED"
                )
            }
            // Initialize extraGuests per band
            var guestsDict: [String: [GuestDetails]] = [:]
            for category in availabilityViewModel.categories {
                let bandId = category.type
                let count = category.count
                guestsDict[bandId] = Array(repeating: GuestDetails(), count: max(0, count))
            }
            extraGuests = guestsDict
        }
        .onChange(of: checkoutViewModel.shouldNavigateToPayment) { shouldNavigate in
            if shouldNavigate {
                // Navigation state changed, Order ID and Payment URL available
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
                    loaction: checkoutViewModel.location ?? "",
                    selectedDate: checkoutViewModel.formattedSelectedDate(availabilityViewModel.selectedDateFromCalender),
                    selectedTime: selectedTime,
                    selectedParticipants: availabilityViewModel.participantsSummary
                )
            }
        }
    }
    
    var contentSection: some View {
        VStack(spacing: 16) {
            FeatureGridView(features: experienceDetailViewModel.allFeatures, showAll: $showAll)
            GuestDetailsFormView(details: $guestDetails, showCountryCodeList: $showCountryCodeList)
            
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
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        showFairSummary = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(10)
                            .background(Color(.systemGray6).opacity(0.9))
                            .clipShape(Circle())
                            .shadow(radius: 1)
                    }
                    .padding(.top, 12)
                    .padding(.trailing, 16)
                }
                
                FareSummaryCardView(
                    fairSummaryData: checkoutViewModel.fairSummaryData,
                    totalPrice: checkoutViewModel.formattedTotalAmount,
                    totalLableText: Constants.CheckoutPageConstants.total,
                    savingsText: checkoutViewModel.savingsTextforFareBreakup
                )
                .padding()
            }
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
        ZStack {
            // Payment Navigation
            NavigationLink(
                destination: PaymentView(
                    orderId: checkoutViewModel.orderNo ?? "",
                    paymentUrl: checkoutViewModel.paymentUrl ?? "",
                    participantsSummary: availabilityViewModel.participantsSummary,
                    selectedTime: selectedTime // <-- Pass selectedTime
                )
                .navigationBarBackButtonHidden(true),
                isActive: $checkoutViewModel.shouldNavigateToPayment
            ) {
                EmptyView()
            }
            .hidden()
            
            // Terms Navigation
            NavigationLink(
                destination: TermsAndConditionsWebView(
                    url: termsAndConditionsUrlGlobal,
                    title: "Terms & Conditions"
                ),
                isActive: $checkoutViewModel.shouldNavigateToTerms
            ) {
                EmptyView()
            }
            .hidden()
            
            // Privacy Navigation
            NavigationLink(
                destination: TermsAndConditionsWebView(
                    url: privacyPolicyUrlGlobal,
                    title: "Privacy Policy"
                ),
                isActive: $checkoutViewModel.shouldNavigateToPrivacy
            ) {
                EmptyView()
            }
            .hidden()
        }
    }
}

private extension ExperienceCheckoutView {
    func onAppear() {
        checkoutViewModel.setSelectedPackage(package)
        checkoutViewModel.setAvailabilityResponse(availabilityViewModel.response)
        checkoutViewModel.setUid(uid)
        checkoutViewModel.setAvailabilityKey(availabilityKey)
        checkoutViewModel.selectedTravelDate = availabilityViewModel.selectedDateFromCalender
        checkoutViewModel.fetchData()
    }
}
