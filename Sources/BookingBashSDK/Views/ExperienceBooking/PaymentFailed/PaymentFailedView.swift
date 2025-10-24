//
//  PaymentFailedView.swift
//  VisaActivity
//
//  Created by Apple on 07/08/25.
//

import Foundation
import SwiftUI
import SUINavigation

struct PaymentFailedView: View {
    @ObservedObject var experienceBookingConfirmationViewModel: ExperienceBookingConfirmationViewModel
    @State private var shouldExpandDetails: Bool = false
    @State private var showCancelBottomSheet: Bool = false
    let participantsSummary: String
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ThemeTemplateView(header: {
                ExperienceBookingConfirmationTopView(bookingInfo: experienceBookingConfirmationViewModel.paymentFailedInfo)
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
                            showCancelBottomSheet = true
                        },
                        isBookingConfirmationScreen: false,
                        shouldExpandDetails: $shouldExpandDetails, participantsSummary: participantsSummary
                    )
                    
                    if shouldExpandDetails {
                        FareSummaryCardView(fairSummaryData: experienceBookingConfirmationViewModel.fairSummaryData, totalPrice: "\(experienceBookingConfirmationViewModel.currency) \(String(format: "%.0f", experienceBookingConfirmationViewModel.totalAmount))", shouldShowTopBanner: false)
                        RefundDetailsCardView(viewModel: experienceBookingConfirmationViewModel)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.cancellationPolicy, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.leadTraveller, showBullets: false)
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
                    navigationStorage?.popToRoot()
                }
            }
        }
        .overlay {
            if showCancelBottomSheet {
                CancelBookingBottomSheet(
                    isPresented: $showCancelBottomSheet,
                    onFinish: {
                        showCancelBottomSheet = false
                    }
                )
            }
        }
    }
}
