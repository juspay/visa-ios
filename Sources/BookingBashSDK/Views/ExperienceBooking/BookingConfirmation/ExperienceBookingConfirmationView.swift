import SwiftUI
import SUINavigation
struct ExperienceBookingConfirmationView: View {
    @StateObject private var viewModel: ExperienceBookingConfirmationViewModel
    @State private var shouldExpandDetails = false
    @State private var navigateToHome = false
    @Environment(\.presentationMode) private var presentationMode
    
    let orderNo: String
    let isFromBookingJourney: Bool
    let participantsSummary: String
    let selectedTime: String?
    
    init(orderNo: String = "", isFromBookingJourney: Bool = true, booking: Booking? = nil, participantsSummary: String = "", selectedTime: String? = nil) {
        self.orderNo = orderNo
        self.isFromBookingJourney = isFromBookingJourney
        self.participantsSummary = participantsSummary
        self.selectedTime = selectedTime
        _viewModel = StateObject(wrappedValue: ExperienceBookingConfirmationViewModel(booking: booking, selectedTime: selectedTime))
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            if viewModel.isLoading {
                // Show loader while fetching booking status
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                    Text("Loading booking details...")
                        .padding(.top, 16)
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                ThemeTemplateView(
                    hideBackButton: isFromBookingJourney,
                    header: { headerSection },
                    content: { contentSection }
                )
                .navigationBarBackButtonHidden(true)
                .safeAreaInset(edge: .bottom) { backToHomeButton }
                .modifier(NavigationDestinationModifier(navigateToHome: $navigateToHome))
            }
        }
        .onAppear { fetchBookingStatus() }
        .overlay { cancellationOverlay }
        .background(navigationToCancellation)
    }
}

private extension ExperienceBookingConfirmationView {
    
    @ViewBuilder
    var headerSection: some View {
        switch viewModel.bookingStatus {
        case .confirmed:
            ExperienceBookingConfirmationTopView(bookingInfo: viewModel.bookingTopInfo)
                .padding(.bottom, 22)
        case .bookingPending:
            ExperienceBookingConfirmationTopView(bookingInfo: viewModel.bookingPendingInfo)
                .padding(.bottom, 22)
        case .paymentfailed:
            ExperienceBookingConfirmationTopView(bookingInfo: viewModel.paymentFailedInfo)
                .padding(.bottom, 22)
        case .bookingFailed:
            ExperienceBookingConfirmationTopView(bookingInfo: viewModel.bookingFailedInfo)
                .padding(.bottom, 22)
        case .cancelled:
            ExperienceBookingConfirmationTopView(bookingInfo: viewModel.bookingCancelledInfo)
                .padding(.bottom, 22)
        }
    }
    
    var contentSection: some View {
        VStack(spacing: 16) {
            BookingBasicDetailsCardView(
                basicBookingDetailsModel: viewModel.bookingBasicDetails.filter { $0.key.lowercased() != "participants" }
            )
            BookedExperienceDetailCardView(
                experienceViewModel: ExperienceAvailabilitySelectOptionsViewModel(),
                confirmationViewModel: viewModel,
                viewDetailsButtonTapped: { shouldExpandDetails = true },
                isBookingConfirmationScreen: viewModel.bookingStatus == .confirmed,
                shouldExpandDetails: $shouldExpandDetails,
//                participantsSummary: participantsSummary,
                selectedTime: selectedTime
            )
            if shouldExpandDetails { expandedDetailsSection }
        }
        .padding()
    }
    
    var backToHomeButton: some View {
        BackToHomeButtonView { navigateToHome = true }
    }
    
    var navigationToCancellation: some View {
        NavigationLink(
            destination: BookingCancellationView(experienceBookingConfirmationViewModel: viewModel, participantsSummary: participantsSummary, selectedTime: selectedTime ?? ""),
            isActive: $viewModel.navigateToCancellationView
        ) { EmptyView() }
    }
}

private extension ExperienceBookingConfirmationView {
    var expandedDetailsSection: some View {
        VStack(spacing: 16) {
            ContactDetailsCardView(
                contactDetailsModel: viewModel.contactDetails,
                title: Constants.BookingStatusScreenConstants.supplierContactTitle
            )
            FareSummaryCardView(
                fairSummaryData: viewModel.fairSummaryData,
                totalPrice: "\(viewModel.currency) \( viewModel.totalAmount)",
                savingsText: viewModel.savingsTextforFareBreakup // Pass savings text for banner
            )
            ConfirmationInfoReusableCardView(section: viewModel.cancellationPolicy, showBullets: false)
            ConfirmationInfoReusableCardView(section: viewModel.leadTraveller, showBullets: false)
            ConfirmationInfoReusableCardView(section: viewModel.inclusions, showBullets: true)
//            ConfirmationInfoReusableCardView(section: viewModel.OtherDetails, showBullets: false)
            ContactDetailsCardView(
                contactDetailsModel: viewModel.personContactDetails,
                title: Constants.BookingStatusScreenConstants.contactDetails
            )
            ConfirmationInfoReusableCardView(section: viewModel.additionalInformation, showBullets: true)
            
            if viewModel.bookingStatus == .confirmed || viewModel.bookingStatus == .bookingPending {
                ActionButton(title: Constants.BookingStatusScreenConstants.cancelBooking) {
                    viewModel.proceedToCancelBooking()
                }
            }
        }
    }
}

private extension ExperienceBookingConfirmationView {
    
    @ViewBuilder
    var cancellationOverlay: some View {
        if viewModel.shouldShowCancellationOverlay {
            CancelBookingBottomSheet(
                isPresented: Binding(
                    get: { viewModel.shouldShowCancellationOverlay },
                    set: { newValue in
                        if !newValue {
                            viewModel.resetCancellationState()
                        }
                    }
                ),
                onFinish: {
                    viewModel.resetCancellationState()
                }
            )
        }
    }
}

private extension ExperienceBookingConfirmationView {
    func fetchBookingStatus() {
        viewModel.fetchBookingStatus(
            orderNo: orderNo,
            siteId: Constants.SharedConstants.siteId,
            isFromBookingJourney: isFromBookingJourney
        )
    }
}
