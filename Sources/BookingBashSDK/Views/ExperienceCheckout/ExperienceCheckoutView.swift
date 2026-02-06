import SwiftUI
import SUINavigation

enum CheckoutScrollID {
    static let firstName = "checkout.firstName"
    static let mobile = "checkout.mobile"
    static let arrivalCard = "checkout.arrival"
    static let departureCard = "checkout.departure"
}

struct ExperienceCheckoutView: View {
    @ObservedObject private var checkoutViewModel: ExperienceCheckoutViewModel
    @ObservedObject private var experienceDetailViewModel: ExperienceDetailViewModel
    @ObservedObject private var availabilityViewModel: ExperienceAvailabilitySelectOptionsViewModel
    
    var package: Package?
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
    @State private var showError: Bool = false
    @State private var scrollToID: ScrollAnchorID?
    @State private var guestDetailsExpanded = true
    @State private var selectedOption: PickupLocationType? = .decideLater
    @State private var selectedTourLanguage: String = ""
    @State private var navigateToBookingQuestions: Bool = false
    // MARK: - Time Picker State
   @State private var showTimePickerSheet = false
   @State private var activeTimeBinding: Binding<String> = .constant("")

    init(
        checkoutViewModel: ExperienceCheckoutViewModel,
        experienceDetailViewModel: ExperienceDetailViewModel,
        availabilityViewModel: ExperienceAvailabilitySelectOptionsViewModel,
        package: Package? = nil,
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
                scrollToID: $scrollToID,
                header: { headerSection },
                content: { contentSection }
            )
            .navigationBarBackButtonHidden(true)
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 0) {
                    CheckboxTermsView(
                        isAgreed: $isConsentBoxChecked,
                        termsAndConditionTapped: { checkoutViewModel.handleTermsTapped() },
                        privacyPolicytapped: { checkoutViewModel.handlePrivacyTapped() }
                    )
                    .padding(.horizontal)
                    paymentBarSection
                }
            }
            .overlay { bottomSheetOverlay }
            .searchCountryCodeSheet(isPresented: $showCountryCodeList, countries: MobileCodeData.allCodes) { countryCode in
                guestDetails.mobileCountryCode = countryCode?.dialCode ?? ""
                guestDetails.mobileNumber = ""
            }
            .navigation(isActive: $checkoutViewModel.shouldNavigateToPayment, id: Constants.NavigationId.paymentWebView) {
                PaymentView(
                    orderId: checkoutViewModel.orderNo ?? "",
                    paymentUrl: checkoutViewModel.paymentUrl ?? "",
                    participantsSummary: availabilityViewModel.participantsSummary,
                    selectedTime: selectedTime
                )
                .navigationBarBackButtonHidden(true)
            }
            .navigation(isActive: $navigateToBookingQuestions, id: Constants.NavigationId.bookingQuestions) {
                BookingQuestionView(viewModel: checkoutViewModel, onFormSubmit: { })
                    .navigationBarBackButtonHidden(true)
            }
            .environment(\.showTimePicker, TimePickerAction(show: { binding in
                            self.activeTimeBinding = binding
                            self.showTimePickerSheet = true
                        }))
            .dismissKeyboardOnTap()
            
            // NEW: Time Picker Custom Overlay
            if showTimePickerSheet {
                // Dimmed Background
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { showTimePickerSheet = false }
                    .zIndex(200) // Ensure it sits on top of everything
                
                // The Bottom Sheet
                TimePickerBottomsheet(
                    isPresented: $showTimePickerSheet,
                    selectedTime: activeTimeBinding
                )
                .zIndex(201)
                .transition(.move(edge: .bottom))
            }

            toastOverlay
            navigationLinks
            
//            // Show No Result Placeholder if API status is false or statusCode != 200
//            if checkoutViewModel.showNoResultImage && (checkoutViewModel.errorStatusCode != 200 || checkoutViewModel.errorMessage != nil) {
//                VStack(spacing: 12) {
//                    ErrorMessageView()
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.white.opacity(0.95))
//                .edgesIgnoringSafeArea(.all)
//            }
            
            if checkoutViewModel.isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .onAppearOnce {
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
        .onAppear {
            checkoutViewModel.isLoading = false
        }
    }
}

private extension ExperienceCheckoutView {
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            MainTopHeaderView(headerText: Constants.CheckoutPageConstants.checkoutHeaderText)
                .padding(.bottom, 6)
            
            VStack(alignment: .leading, spacing: 16) {
//                ExperienceTopImageCarousalListView(experienceDetailCarousalModel: checkoutViewModel.carousalData)
//                    .padding(.trailing, -15)
//
                BookedExperienceDetailInfoTopLocationView(
                    title: model.title,
                    location: checkoutViewModel.location ?? ""
                )
                
                BookedExperienceDateTimeView(
                    color: .white,
                    location: checkoutViewModel.location,
                    selectedDate: checkoutViewModel.formattedSelectedDate(availabilityViewModel.selectedDateFromCalender),
                    selectedTime: selectedTime,
                    selectedParticipants: availabilityViewModel.participantsSummary
                )
            }
        }
    }
    
    var contentSection: some View {
        VStack{
            if checkoutViewModel.showNoResultImage && (checkoutViewModel.errorStatusCode != 200 || checkoutViewModel.errorMessage != nil) {
                VStack(spacing: 12) {
                    ErrorMessageView()
                }
            } else {
                VStack(spacing: 16) {
                    if !experienceDetailViewModel.allFeatures.isEmpty {
                        FeatureGridView(features: experienceDetailViewModel.allFeatures, showAll: $showAll)
                    }
                    GuestDetailsFormView(details: $guestDetails, showCountryCodeList: $showCountryCodeList, showError: $showError, isExpanded: $guestDetailsExpanded)
                    
                    if let pickupPointQuestion = checkoutViewModel.pickupPointQuestion, (checkoutViewModel.arrivalPickupModes?.isEmpty == false || checkoutViewModel.departurePickupModes?.isEmpty == false) {
                        PickupLocationCardView(selectedOption: $selectedOption)
                        
                        
                        Group {
                            if selectedOption == .likeTobePickedUp {
                                VStack(spacing: 16) {
                                    // 1. Arrival Card
                                    if let arrivalPickupMode = checkoutViewModel.arrivalPickupModes {
                                        TransferModeCardView(
                                            title: "Arrival transfer mode",
                                            availableModes: arrivalPickupMode,
                                            selectedMode: $checkoutViewModel.selectedArrivalMode,
                                            fields: $checkoutViewModel.arrivalPickupFields,
                                            showError: $showError
                                        )
                                        .id(CheckoutScrollID.arrivalCard)
                                    }
                                    
                                    // 2. Departure Card
                                    if let departurePickupModes = checkoutViewModel.departurePickupModes {
                                        TransferModeCardView(
                                            title: "Departure transfer mode",
                                            availableModes: checkoutViewModel.pickupPointQuestion?.departurePickupMode,
                                            selectedMode: $checkoutViewModel.selectedDepartureMode,
                                            fields: $checkoutViewModel.departurePickupFields,
                                            showError: $showError
                                        )
                                        .id(CheckoutScrollID.departureCard)
                                    }
                                }
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .opacity
                                    )
                                )
                            }
                        }
                        .animation(.easeInOut(duration: 0.35), value: selectedOption)
                    }

                    if checkoutViewModel.questions != nil {
                        BookingQuestionsCard
                    }

                    FareSummaryCardView(fairSummaryData: checkoutViewModel.fairSummaryData,
                                        totalPrice: "\(currency ?? "AED") \(checkoutViewModel.formattedTotalAmount)",
                                        savingsText: checkoutViewModel.savingsTextforFareBreakup,
                                        fareSummaryOnChecoutView: true,
                                        pgPrice: checkoutViewModel.reviewResponse?.data?.price?.pgPrice,
                                            needCollapsableView: true,
                                        ismarkup: checkoutViewModel.reviewResponse?.data?.tourOption?.rates?.first?.ismarkup ?? false)
                    InfoListView(viewModel: experienceDetailViewModel)
                }
                .padding()
            }
        }
        .dismissKeyboardOnTap()
    }
    
    var BookingQuestionsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 1) {
                if checkoutViewModel.areAllFormsValid {
                    if let check = ImageLoader.bundleImage(named: Constants.Icons.greenCheckFill) {
                    check.resizable().frame(width: 20, height: 20)
                    }
                }
                Text("Booking Questions")
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                Text("*")
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundColor(Color(hex: Constants.HexColors.error))
                
                Spacer()
                
                if let arrowImage = ImageLoader.bundleImage(named: Constants.Icons.arrowRight) {
                    arrowImage
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(checkoutViewModel.areAllFormsValid ? Color(hex: Constants.HexColors.surfaceWeakest): Color.clear))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(checkoutViewModel.areAllFormsValid ? Color(hex: Constants.HexColors.greenShade) : Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1))
            .contentShape(Rectangle())
            .onTapGesture {
                navigateToBookingQuestions = true
            }

            if showError, !checkoutViewModel.areAllFormsValid {
                Text("Booking questions details are required for the selected guest")
                    .font(.custom(Constants.Font.openSansRegular, size: 10))
                    .foregroundColor(Color(hex: Constants.HexColors.error))
            }
        }
    }
    
    var paymentBarSection: some View {
        ExperienceBottomPaymentBarView(
            buttonText: Constants.CheckoutPageConstants.saveContinue,
            payNowButtonTapped: { saveAction() },
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
                    savingsText: checkoutViewModel.savingsTextforFareBreakup,
                    fareSummaryOnChecoutView: currency != checkoutViewModel.reviewResponse?.data?.price?.pgPrice?.currency,
                    pgPrice: checkoutViewModel.reviewResponse?.data?.price?.pgPrice,
                    needCollapsableView: true
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
//            NavigationLink(
//                destination: PaymentView(
//                    orderId: checkoutViewModel.orderNo ?? "",
//                    paymentUrl: checkoutViewModel.paymentUrl ?? "",
//                    participantsSummary: availabilityViewModel.participantsSummary,
//                    selectedTime: selectedTime // <-- Pass selectedTime
//                )
//                .navigationBarBackButtonHidden(true),
//                isActive: $checkoutViewModel.shouldNavigateToPayment
//            ) {
//                EmptyView()
//            }
//            .hidden()
            
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

    func saveAction() {
        // 1. Base Validations (Always Required)
        let isGuestFormValid = checkoutViewModel.validateFields(guestDetails: guestDetails)
        let isConsentValid = checkoutViewModel.validateConcentBoxChecked(isConsentBoxChecked: isConsentBoxChecked, guestDetails: guestDetails)

        // 2. Booking Questions Validation (Conditional)
        // Only validate if questions array is not nil and not empty
        let areQuestionsVisible = (checkoutViewModel.questions?.isEmpty == false)
        let isBookingQuestionsValid = areQuestionsVisible ? checkoutViewModel.areAllFormsValid : true

        // 3. Pickup Details Validation (Conditional)
        // Logic matches your UI: pickupPointQuestion must exist AND at least one mode list (arrival or departure) must be non-empty
        let isPickupVisible = (checkoutViewModel.pickupPointQuestion != nil) &&
                              ((checkoutViewModel.arrivalPickupModes?.isEmpty == false) || (checkoutViewModel.departurePickupModes?.isEmpty == false))
        
        // Only validate pickup details if the section is visible
        let isPickupValid = isPickupVisible ? checkoutViewModel.validatePickupDetails(selectedOption: selectedOption) : true

        // 4. Final Execution
        if isGuestFormValid && isConsentValid && isBookingQuestionsValid && isPickupValid {
            
            // All visible required fields are valid -> Proceed
            checkoutViewModel.initBook(guestDetails: guestDetails)
            showError = false
            
        } else {
            // Something is invalid -> Show Errors & Scroll
            showError = true
            guestDetailsExpanded = true
            
            // SCROLL LOGIC
            
            // Priority 1: Guest Details (Top of page)
            if guestDetails.title.isEmpty || guestDetails.firstName.isEmpty {
                scrollToID = CheckoutScrollID.firstName
            }
            else if guestDetails.mobileNumber.isEmpty || !checkoutViewModel.isValidMobileNumber(guestDetails: guestDetails) {
                scrollToID = CheckoutScrollID.mobile
            }
            
            // Priority 2: Pickup Details (Middle of page) - ONLY if Visible
            else if isPickupVisible {
                
                // Check Arrival specific errors
                if checkoutViewModel.arrivalPickupFields.contains(where: { $0.error != nil }) ||
                   (selectedOption == .likeTobePickedUp && checkoutViewModel.selectedArrivalMode == nil && checkoutViewModel.arrivalPickupModes?.isEmpty == false) {
                    scrollToID = CheckoutScrollID.arrivalCard
                }
                
                // Check Departure specific errors
                else if checkoutViewModel.departurePickupFields.contains(where: { $0.error != nil }) ||
                        (selectedOption == .likeTobePickedUp && checkoutViewModel.selectedDepartureMode == nil && checkoutViewModel.departurePickupModes?.isEmpty == false) {
                    scrollToID = CheckoutScrollID.departureCard
                }
            }
            
            // Priority 3: Booking Questions
            // No specific scroll ID is usually needed as it's near the bottom,
            // but the red border/text logic in your view will handle the visual feedback.
        }
    }
}
