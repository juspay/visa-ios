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
    case bottomSheet
}

struct ExperienceBookingConfirmationView: View {
    @StateObject private var experienceBookingConfirmationViewModel = ExperienceBookingConfirmationViewModel()
    @State private var cancellationSheetState: CancellationSheetState = .none
    @State private var shouldExpandDetails: Bool = false
    @State private var navigateToHome: Bool = false
    @State private var isFetchingReasons: Bool = false
    @State private var fetchReasonsError: String? = nil
    @State private var navigateToCancellationView: Bool = false
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    @Environment(\.presentationMode) private var presentationMode
    
    // Parameters to determine navigation source
    let orderNo: String
    let isFromBookingJourney: Bool
    
    // Initializers
    init(orderNo: String = "", isFromBookingJourney: Bool = true) {
        self.orderNo = orderNo
        self.isFromBookingJourney = isFromBookingJourney
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
                            isFetchingReasons = true
                            fetchReasonsError = nil
                            experienceBookingConfirmationViewModel.fetchCancellationReasons(orderNo: orderNo) {
                                isFetchingReasons = false
                                if let error = experienceBookingConfirmationViewModel.errorMessage, !error.isEmpty {
                                    fetchReasonsError = error
                                } else {
                                    cancellationSheetState = .reason
                                }
                            }
                        },
                        shouldExpandDetails: $shouldExpandDetails
                    )
                    
                    if shouldExpandDetails {
                        ContactDetailsCardView(contactDetailsModel: experienceBookingConfirmationViewModel.contactDetails, title: Constants.BookingStatusScreenConstants.supplierContactTitle)
                            
                        FareSummaryCardView(fairSummaryData: experienceBookingConfirmationViewModel.fairSummaryData, totalPrice: "\(experienceBookingConfirmationViewModel.currency) \(String(format: "%.0f", experienceBookingConfirmationViewModel.totalAmount))")
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.cancellationPolicy, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.leadTraveller, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.specialRequest, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.meetingPickup, showBullets: false)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.inclusions, showBullets: true)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.OtherDetails, showBullets: false)
                        ContactDetailsCardView(contactDetailsModel: experienceBookingConfirmationViewModel.personContactDetails, title: Constants.BookingStatusScreenConstants.contactDetails)
                        ConfirmationInfoReusableCardView(section: experienceBookingConfirmationViewModel.additionalInformation, showBullets: true)
                        
                        ActionButton(title: Constants.BookingStatusScreenConstants.cancelBooking) {
                            cancellationSheetState = .bottomSheet
                        }
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
        .onAppear{
            // Use the passed orderNo and isFromBookingJourney parameter
            experienceBookingConfirmationViewModel.fetchBookingStatus(
                orderNo: orderNo,
                siteId: "68b585760e65320801973737",
                isFromBookingJourney: isFromBookingJourney
            )
        }
        .overlay {
            if cancellationSheetState != .none || isFetchingReasons || fetchReasonsError != nil {
                BottomSheetView(isPresented: Binding(
                    get: { cancellationSheetState != .none || isFetchingReasons || fetchReasonsError != nil },
                    set: { newValue in
                        if (!newValue) {
                            cancellationSheetState = .none
                            isFetchingReasons = false
                            fetchReasonsError = nil
                        }
                    }
                )) {
                    if isFetchingReasons {
                        VStack(spacing: 16) {
                            ProgressView()
                            Text("Loading cancellation reasons...")
                        }.padding()
                    } else if let error = fetchReasonsError {
                        VStack(spacing: 16) {
                            Text("Failed to load reasons: \(error)")
                                .foregroundColor(.red)
                            Button("Retry") {
                                isFetchingReasons = true
                                fetchReasonsError = nil
                                experienceBookingConfirmationViewModel.fetchCancellationReasons(orderNo: orderNo) {
                                    isFetchingReasons = false
                                    if let error = experienceBookingConfirmationViewModel.errorMessage, !error.isEmpty {
                                        fetchReasonsError = error
                                    } else {
                                        cancellationSheetState = .reason
                                    }
                                }
                            }
                        }.padding()
                    } else {
                        switch cancellationSheetState {
                        case .reason:
                            SelectBookingCancellationReasonView(
                                viewModel: experienceBookingConfirmationViewModel,
                                cancellationSheetState: $cancellationSheetState,
                                navigateToCancellationView: $navigateToCancellationView,
                                orderNo: orderNo
                            )
                        case .bottomSheet:
                            CancelBookingBottomSheetView(
                                viewModel: experienceBookingConfirmationViewModel,
                                cancellationSheetState: $cancellationSheetState
                            ) {
                                navigateToCancellationView = true
                            }
                        case .none:
                            EmptyView()
                        }
                    }
                }
            }
        }
        // NavigationLink for navigation push to BookingCancellationView
        NavigationLink(
            destination: BookingCancellationView(experienceBookingConfirmationViewModel: experienceBookingConfirmationViewModel),
            isActive: $navigateToCancellationView
        ) {
            EmptyView()
        }
    }
}
