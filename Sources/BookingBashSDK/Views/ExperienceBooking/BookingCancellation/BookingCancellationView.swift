//
//  BookingCancellationView.swift
//  VisaActivity
//
//  Created by Apple on 07/08/25.
//

import SwiftUI
import SUINavigation

struct BookingCancellationView: View {
    @ObservedObject var experienceBookingConfirmationViewModel: ExperienceBookingConfirmationViewModel
    @State private var shouldExpandDetails: Bool = false
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    @State private var navigateToHome: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ThemeTemplateView(header: {
                ExperienceBookingConfirmationTopView(bookingInfo: experienceBookingConfirmationViewModel.bookingCancelledInfo)
                    .padding(.bottom, 22)
            }, content: {
                VStack(spacing: 16) {
                    BookingBasicDetailsCardView(basicBookingDetailsModel: experienceBookingConfirmationViewModel.bookingBasicDetails)
                    
                    BookedExperienceDetailCardView(
                        experienceViewModel: ExperienceAvailabilitySelectOptionsViewModel(),
                        confirmationViewModel: experienceBookingConfirmationViewModel,
                        viewDetailsButtonTapped: {
                            shouldExpandDetails = true
                        },
                        cancelBookingButtonTapped: {
                        },
                        isBookingConfirmationScreen: false,
                        shouldExpandDetails: $shouldExpandDetails
                    )
                    
                    if shouldExpandDetails {
                        ContactDetailsCardView(contactDetailsModel: experienceBookingConfirmationViewModel.contactDetails, title: Constants.BookingStatusScreenConstants.supplierContactTitle)
                        FareSummaryCardView(fairSummaryData: experienceBookingConfirmationViewModel.fairSummaryData, totalPrice: "\(experienceBookingConfirmationViewModel.currency) \(String(format: "%.0f", experienceBookingConfirmationViewModel.totalAmount))", shouldShowTopBanner: false)
                        RefundDetailsCardView(viewModel: experienceBookingConfirmationViewModel)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.cancellationPolicy, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.leadTraveller, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.specialRequest, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.meetingPickup, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.inclusions, showBullets: true)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.OtherDetails, showBullets: false)
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
