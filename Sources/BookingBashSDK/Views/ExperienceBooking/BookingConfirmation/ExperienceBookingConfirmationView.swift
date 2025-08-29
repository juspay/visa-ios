//
//  ExperienceBookingConfirmationView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import SwiftUI
import SUINavigation

enum CancellationSheetState {
    case none
    case reason
    case confirm
}

struct ExperienceBookingConfirmationView: View {
    @ObservedObject var experienceBookingConfirmationViewModel: ExperienceBookingConfirmationViewModel
    @State private var cancellationSheetState: CancellationSheetState = .none
    @State private var shouldExpandDetails: Bool = false
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ThemeTemplateView(header: {
                ExperienceBookingConfirmationTopView(bookingInfo: experienceBookingConfirmationViewModel.bookingTopInfo)
                    .padding(.bottom, 22)
            }, content: {
                VStack(spacing: 16) {
                    BookingBasicDetailsCardView(basicBookingDetailsModel: experienceBookingConfirmationViewModel.bookingBasicDetails)
                    
                    BookedExperienceDetailCardView(
                        viewDetailsButtonTapped: {
                            shouldExpandDetails = true
                        },
                        cancelBookingButtonTapped: {
                            cancellationSheetState = .reason
                        },
                        shouldExpandDetails: $shouldExpandDetails
                    )
                    
                    if shouldExpandDetails {
                        ContactDetailsCardView(contactDetailsModel: experienceBookingConfirmationViewModel.contactDetails, title: Constants.BookingStatusScreenConstants.supplierContactTitle)
                        FareSummaryCardView(fairSummaryData: experienceBookingConfirmationViewModel.fairSummaryData)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.cancellationPolicy, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.leadTraveller, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.specialRequest, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.meetingPickup, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.inclusions, showBullets: true)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.OtherDetails, showBullets: false)
                        ContactDetailsCardView(contactDetailsModel: experienceBookingConfirmationViewModel.personContactDetails, title: Constants.BookingStatusScreenConstants.contactDetails)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.additionalInformation, showBullets: true)
                        
                        ActionButton(title: Constants.BookingStatusScreenConstants.cancelBooking) {
                            cancellationSheetState = .reason
                        }
                    }
                }
                .padding()
            })
            .safeAreaInset(edge: .bottom) {
                BackToHomeButtonView() {
                    navigationStorage?.popToRoot()
                }
            }
        }
        .overlay {
            if cancellationSheetState != .none {
                BottomSheetView(isPresented: Binding(
                    get: { cancellationSheetState != .none },
                    set: { newValue in
                        if !newValue { cancellationSheetState = .none }
                    }
                )) {
                    switch cancellationSheetState {
                    case .reason:
                        SelectBookingCancellationReasonView(
                            viewModel: experienceBookingConfirmationViewModel,
                            cancellationSheetState: $cancellationSheetState
                        )
                    case .confirm:
                        CancelBookingBottomSheetView(viewModel: experienceBookingConfirmationViewModel, cancellationSheetState: $cancellationSheetState)
                    case .none:
                        EmptyView()
                    }
                }
            }
        }
    }
}
