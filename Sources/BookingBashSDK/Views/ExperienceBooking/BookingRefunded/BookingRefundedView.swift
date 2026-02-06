//
//  BookingRefundedView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 23/01/26.
//

import SwiftUI
import SUINavigation

struct BookingRefundedView: View {
    @ObservedObject var experienceBookingConfirmationViewModel: ExperienceBookingConfirmationViewModel
    let participantsSummary: String
    let selectedTime: String
    @State private var shouldExpandDetails: Bool = false
    @State private var showCancelBottomSheet: Bool = false
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    @State private var navigateToHome: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ThemeTemplateView(hideBackButton: true, header: {
                ExperienceBookingConfirmationTopView(bookingInfo: experienceBookingConfirmationViewModel.bookingRefundedInfo)
                    .padding(.bottom, 22)
            }, content: {
                VStack(spacing: 16) {
                    BookingBasicDetailsCardView(basicBookingDetailsModel: experienceBookingConfirmationViewModel.bookingBasicDetails)
                    
                    BookedExperienceDetailCardView(
                        confirmationViewModel: experienceBookingConfirmationViewModel,
                        viewDetailsButtonTapped: {
                            shouldExpandDetails = true
                        },
                        isBookingConfirmationScreen: false,
                        shouldExpandDetails: $shouldExpandDetails, selectedTime: selectedTime
                    )
                    
                    if shouldExpandDetails {
                        FareSummaryCardView(fairSummaryData: experienceBookingConfirmationViewModel.fairSummaryData, totalPrice: "\(experienceBookingConfirmationViewModel.currency) \(experienceBookingConfirmationViewModel.totalAmount.commaSeparated())", shouldShowTopBanner: false)
                        RefundDetailsCardView(viewModel: experienceBookingConfirmationViewModel)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.cancellationPolicy, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.leadTraveller, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.inclusions, showBullets: true)
                        
                        ContactDetailsCardView(contactDetailsModel: experienceBookingConfirmationViewModel.personContactDetails, title: Constants.BookingStatusScreenConstants.contactDetails)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.additionalInformation, showBullets: true)
                    }
                }
                .padding()
            })
            .navigationBarBackButtonHidden(true)
            .safeAreaInset(edge: .bottom) {
                BackToHomeButtonView() {
                    navigateToHome = true
                }
            }
            .modifier(NavigationDestinationModifier(navigateToHome: $navigateToHome))

        }
    }
}
