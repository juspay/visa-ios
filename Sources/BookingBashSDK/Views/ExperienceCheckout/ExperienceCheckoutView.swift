//
//  ExperienceCheckoutView.swift
//  VisaActivity
//
//  Created by Apple on 08/08/25.
//

import SwiftUI
import SUINavigation

struct ExperienceCheckoutView: View {
    @StateObject private var experienceCheckoutViewModel = ExperienceCheckoutViewModel()
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    let package: Package
    var model: ExperienceDetailModel
    @State private var guestDetails = GuestDetails()
    @State var showAll: Bool = false
    @State var isConsentBoxChecked : Bool = false
    @State private var shouldShowFairSummaryCard: Bool = false
    @State private var shouldNavigateToConfirmation: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    
    var body: some View {
        ZStack {
            ThemeTemplateView(header: {
                VStack(alignment: .leading, spacing: 0) {
                    MainTopHeaderView(headerText: Constants.CheckoutPageConstants.checkoutHeaderText)
                        .padding(.bottom, 6)
                       
                    VStack(alignment: .leading, spacing: 16) {
                        ExperienceTopImageCarousalListView(experienceDetailCarousalModel: experienceCheckoutViewModel.carousalData)
                            .padding(.trailing, -15)
                        BookedExperienceDetailInfoTopLocationView(
                            title: model.title,
                            location: experienceCheckoutViewModel.location ?? ""
                        )
                        BookedExperienceDateTimeView(
                            color: .white,
                            shouldShowRefundable: false,
                            selectedDate: formattedSelectedDate(viewModel.selectedDateFromCalender),
//                            selectedTime: package.selectedTime ?? "--:--",
                            selectedParticipants: viewModel.participantsSummary // Show full summary like "2 Adults, 3 Children"
                        )
                    }
                }
            }, content: {
                VStack(spacing: 16) {
                    FeatureGridView(
                        features: experienceCheckoutViewModel.allFeatures,
                        showAll: $showAll
                    )
                    // guest detail -
                    GuestDetailsFormView(details:  $guestDetails)
                    //   FareSummaryCardView
                    FareSummaryCardView(
                        fairSummaryData: experienceCheckoutViewModel.fairSummaryData, totalPrice: totalPriceG,
                        totalLableText: Constants.CheckoutPageConstants.total
                    )
                    
                    CheckboxTermsView(
                        isAgreed: $isConsentBoxChecked,
                        termsAndConditionTapped: {
                            print(Constants.CheckoutPageConstants.termsAndConditionsTapped)
                        },
                        privacyPolicytapped: {
                            print(Constants.CheckoutPageConstants.privacyPolicyTapped)
                        }
                    )
                    
                    //  Error message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 4)
                    }
                    
                }
                .padding()
            })
            .navigationBarBackButtonHidden(true)
            .onAppear {
                // Set the selected travel date from the availability view model
                experienceCheckoutViewModel.selectedTravelDate = viewModel.selectedDateFromCalender
            }
            .safeAreaInset(edge: .bottom) {
                ExperienceBottomPaymentBarView(
                    buttonText: Constants.CheckoutPageConstants.saveContinue,
                    payNowButtonTapped: {
                        // Validate mobile number first
                        if let mobileError = validateMobile(guestDetails.mobileNumber, forCode: guestDetails.mobileCountryCode) {
                            toastMessage = mobileError
                            showToast = true
                            return
                        }
                        
                        if !isConsentBoxChecked {
                            toastMessage = "Please agree to the Terms & Conditions and Privacy Policy before continuing."
                            showToast = true
                            return
                        }
                        
                        // if All good, proceed
                        experienceCheckoutViewModel.initBook()
                    },
                    
                    infoButtontapped: {
                        shouldShowFairSummaryCard = true
                    },
                    price: totalPriceG
                )
            }
            
            .overlay(content: {
                BottomSheetView(isPresented: $shouldShowFairSummaryCard) {
                    FareSummaryCardView(fairSummaryData: experienceCheckoutViewModel.fairSummaryData, totalPrice: totalPriceG, totalLableText: Constants.CheckoutPageConstants.total
                    )
                    .padding()
                }
            })
            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ToastView(message: toastMessage)
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            showToast = false
                        }
                    }
                }
            }
        }
        .navigation(isActive: $experienceCheckoutViewModel.shouldNavigateToPayment,
                    id: Constants.NavigationId.paymentWebView) {
            PaymentView( // <-- wrapper around PaymentWebView
                orderId: experienceCheckoutViewModel.orderNo ?? "",
                shouldNavigateToConfirmation: $shouldNavigateToConfirmation
            )
            .navigationBarBackButtonHidden(true) // hide default nav bar back
        }
        
        .navigation(isActive: $shouldNavigateToConfirmation, id: "confirmationPage") {
            ExperienceBookingConfirmationView(
                orderNo: experienceCheckoutViewModel.orderNo ?? "")
        }

        .onAppear {
            experienceCheckoutViewModel.fetchData()
        }
    }
    
    func validateMobile(_ mobile: String, forCode code: String) -> String? {
        let trimmed = mobile.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if mobile number is empty
        if trimmed.isEmpty {
            return "Please enter a mobile number."
        }
        
        // Check if country code is empty or not selected
        if code.isEmpty {
            return "Please select a country code."
        }
        
        // Check if mobile contains only numbers
        if !trimmed.allSatisfy({ $0.isNumber }) {
            return "Mobile number should contain only digits."
        }
        
        // Find the maxCharLimit for the selected code
        let codes: [MobileCode] = [
            MobileCode(name: "UAE", maxCharLimit: 9, countryCode: 1, dialCode: "+971", image: "https://d33mtyizv24ggq.cloudfront.net/assets/ae.svg"),
            MobileCode(name: "China", maxCharLimit: 11, countryCode: 2, dialCode: "+86", image: "https://d33mtyizv24ggq.cloudfront.net/assets/cn.svg"),
            MobileCode(name: "Singapore", maxCharLimit: 8, countryCode: 3, dialCode: "+65", image: "https://d33mtyizv24ggq.cloudfront.net/assets/sg.svg"),
            MobileCode(name: "India", maxCharLimit: 10, countryCode: 4, dialCode: "+91", image: "https://d33mtyizv24ggq.cloudfront.net/assets/in.svg"),
            MobileCode(name: "Iceland", maxCharLimit: 7, countryCode: 5, dialCode: "+354", image: "https://d33mtyizv24ggq.cloudfront.net/assets/is.svg")
        ]
        
        if let selected = codes.first(where: { $0.dialCode == code }) {
            // Check if mobile number matches the exact required length for the country
            if trimmed.count != selected.maxCharLimit {
                return "\(selected.name) mobile number should be exactly \(selected.maxCharLimit) digits."
            }
        } else {
            return "Invalid country code selected."
        }
        
        return nil
    }
    
    private func formattedSelectedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy" // Sat, 22 Jun 2025
        return formatter.string(from: date)
    }
}
