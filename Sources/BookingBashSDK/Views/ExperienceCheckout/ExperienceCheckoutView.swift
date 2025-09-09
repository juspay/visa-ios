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
    @State private var guestDetails = GuestDetails()
    @State var showAll: Bool = false
    @State var isConsentBoxChecked : Bool = false
    @State private var shouldShowFairSummaryCard: Bool = false
    @State private var shouldNavigateToConfirmation: Bool = false
    @State private var errorMessage: String? = nil
    
    
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
                            title: packageTitleG,
                            location: addressG
                            
                        )
                        BookedExperienceDateTimeView(
                            color: .white,
                            shouldShowRefundable: false, checkInDate: checkInDateG
                            
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
                    //                    FareSummaryCardView
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
            .safeAreaInset(edge: .bottom) {
                ExperienceBottomPaymentBarView(
                    buttonText: Constants.CheckoutPageConstants.saveContinue,

                    payNowButtonTapped: {
                        // validate mobile first
                        if let mobileError = validateMobile(guestDetails.mobile) {
                            errorMessage = mobileError
                            return
                        }
                        
                        // check consent box
                        if isConsentBoxChecked {
                            errorMessage = nil
                            experienceCheckoutViewModel.initBook() // <-- this eventually toggles shouldNavigateToPayment
                        } else {
                            errorMessage = "Please agree to the Terms & Conditions and Privacy Policy before continuing."
                        }
                    }
,
                    infoButtontapped: {
                        shouldShowFairSummaryCard = true
                    },
                    price: totalPriceG
                )
            }
            
            .overlay(content: {
                BottomSheetView(isPresented: $shouldShowFairSummaryCard) {
                    FareSummaryCardView(fairSummaryData: experienceCheckoutViewModel.fairSummaryData, totalPrice: totalPriceG,
                                        totalLableText: Constants.CheckoutPageConstants.total
                    )
                    .padding()
                }
            })
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
                            experienceBookingConfirmationViewModel: ExperienceBookingConfirmationViewModel(),
                            orderNo: experienceCheckoutViewModel.orderNo ?? "ACT24596"
                        )
                    }
        
                    .onAppear {
                        experienceCheckoutViewModel.fetchData()
                    }
    }
    
    func validateMobile(_ mobile: String) -> String? {
        let trimmed = mobile.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return "Mobile number cannot be empty"
        } else if trimmed.count != 7 {
            return "Enter valid Mobile Number"
        }
        return nil
    }
    
}
