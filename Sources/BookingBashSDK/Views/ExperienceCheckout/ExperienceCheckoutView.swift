//
//  ExperienceCheckoutView.swift
//  VisaActivity
//
//  Created by Apple on 08/08/25.
//

import SwiftUI
import SUINavigation

struct ExperienceCheckoutView: View {
    @State private var experienceCheckoutViewModel = ExperienceCheckoutViewModel()
    @State var showAll: Bool = false
    @State var isConsentBoxChecked : Bool = false
    @State private var shouldShowFairSummaryCard: Bool = false
    @State private var shouldNavigateToPaymentScreen: Bool = false
    
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
                            title: "Two Park Pass - Dubai Parks and Resorts",
                            location: "Sheikh Zayed Road - Dubai - United Arab Emirates"
                        )
                        BookedExperienceDateTimeView(
                            color: Color.white,
                            shouldShowRefundable: false
                        )
                    }
                }
            }, content: {
                VStack(spacing: 16) {
                    FeatureGridView(
                        features: experienceCheckoutViewModel.allFeatures,
                        showAll: $showAll
                    )
                    FareSummaryCardView(
                        fairSummaryData: experienceCheckoutViewModel.fairSummaryData,
                        totalLableText: Constants.CheckoutPageConstants.total
                    )
                    CheckboxTermsView(
                        isAgreed: $isConsentBoxChecked,
                        termsAndConditionTapped: {
                            print(Constants.CheckoutPageConstants.termsAndConditionsTapped)
                        },
                        privacyPlicytapped: {
                            print(Constants.CheckoutPageConstants.privacyPolicyTapped)
                        }
                    )
                }
                .padding()
            })
            .safeAreaInset(edge: .bottom) {
                ExperienceBottomPaymentBarView(buttonText: Constants.CheckoutPageConstants.saveContinue) {
                    shouldNavigateToPaymentScreen = true
                } infoButtontapped: {
                    shouldShowFairSummaryCard = true
                }
            }
            .overlay(content: {
                BottomSheetView(isPresented: $shouldShowFairSummaryCard) {
                    FareSummaryCardView(fairSummaryData: experienceCheckoutViewModel.fairSummaryData,
                                        totalLableText: Constants.CheckoutPageConstants.total
                    )
                    .padding()
                }
            })
        }
        .navigation(isActive: $shouldNavigateToPaymentScreen, id: Constants.NavigationId.experiencePaymentView) {
            ExperiencePaymentView()
        }
        .onAppear {
            experienceCheckoutViewModel.fetchData()
        }
    }
}

#Preview {
    ExperienceCheckoutView()
}
