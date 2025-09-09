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
    
    // Add optional orderNo parameter for transaction list flow
    let orderNo: String?
    
    // Default initializer for booking flow (maintains existing behavior)
    init(experienceBookingConfirmationViewModel: ExperienceBookingConfirmationViewModel) {
        self.experienceBookingConfirmationViewModel = experienceBookingConfirmationViewModel
        self.orderNo = nil
    }
    
    // New initializer for transaction list flow
    init(experienceBookingConfirmationViewModel: ExperienceBookingConfirmationViewModel, orderNo: String) {
        self.experienceBookingConfirmationViewModel = experienceBookingConfirmationViewModel
        self.orderNo = orderNo
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ThemeTemplateView(header: {
                ExperienceBookingConfirmationTopView(bookingInfo: experienceBookingConfirmationViewModel.bookingTopInfo)
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
                            cancellationSheetState = .reason
                        },
                        shouldExpandDetails: $shouldExpandDetails
                    )
                    
                    if shouldExpandDetails {
                        ContactDetailsCardView(contactDetailsModel: experienceBookingConfirmationViewModel.contactDetails, title: Constants.BookingStatusScreenConstants.supplierContactTitle)
                        FareSummaryCardView(fairSummaryData: experienceBookingConfirmationViewModel.fairSummaryData, totalPrice: totalPriceG)
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
            .navigationBarBackButtonHidden(true)
            .safeAreaInset(edge: .bottom) {
                BackToHomeButtonView() {
                    navigationStorage?.popToRoot()
                }
            }
        }
        .onAppear{
            // Use the passed orderNo if available, otherwise use hardcoded value (for booking flow)
            let orderToUse = orderNo ?? "ACT24596"
            experienceBookingConfirmationViewModel.fetchBookingStatus(orderNo: orderToUse, siteId: "68b585760e65320801973737")
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
