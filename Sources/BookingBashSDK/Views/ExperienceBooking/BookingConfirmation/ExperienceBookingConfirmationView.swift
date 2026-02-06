import SwiftUI
import SUINavigation

struct ExperienceBookingConfirmationView: View {
    @StateObject private var viewModel: ExperienceBookingConfirmationViewModel
    @State private var shouldExpandDetails = false
    @State private var navigateToHome = false
    @State private var showCancelReasonSheet: Bool = false
    @State private var showCancelConfirmationSheet: Bool = false
    @State private var cancellationFailedSheet: Bool = false
    @State private var navigateToCancellationView: Bool = false

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
        ZStack {
            ZStack(alignment: .bottom) {
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
                        hideBackButton: false,
                        header: { headerSection },
                        content: { contentSection }
                    )
                    .navigationBarBackButtonHidden(true)
                    .safeAreaInset(edge: .bottom) { backToHomeButton }
                    .modifier(NavigationDestinationModifier(navigateToHome: $navigateToHome))
                }
            }
            .onAppear { fetchBookingStatus() }
            .overlay { cancellationReasonOverlay }
            .overlay { cancellationConfirmationOverlay }
            .overlay { cancelBookingFailedOverlay }
            .background(navigationToCancellation)
            
            toastOverlay
        }
    }
}

private extension ExperienceBookingConfirmationView {
    var toastOverlay: some View {
        Group {
            if viewModel.showToast {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ToastView(message: viewModel.toastMessage)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.easeInOut, value: viewModel.showToast)
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

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
        case .refunded:
            ExperienceBookingConfirmationTopView(bookingInfo: viewModel.bookingRefundedInfo)
                .padding(.bottom, 22)
        }
    }
    
    var contentSection: some View {
        VStack(spacing: 16) {
            BookingBasicDetailsCardView(
                basicBookingDetailsModel: viewModel.bookingBasicDetails.filter { $0.key.lowercased() != "participants" }
            )
            BookedExperienceDetailCardView(
                confirmationViewModel: viewModel,
                viewDetailsButtonTapped: { shouldExpandDetails = true },
                cancelBookingButtonTapped: {
                    fetchCancellationReasons()
                    showCancelReasonSheet = true
                },
                isBookingConfirmationScreen: viewModel.bookingStatus == .confirmed,
                shouldExpandDetails: $shouldExpandDetails,
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
            isActive: $navigateToCancellationView
        ) { EmptyView() }
    }

    func showTopBanner() -> Bool {
        switch viewModel.bookingStatus {
        case .cancelled, .refunded:
            return false
            
        default:
            return true
        }
    }
    
    func showRefundableView() -> Bool {
        switch viewModel.bookingStatus {
        case .cancelled, .refunded:
            return true
            
        default:
            return false
        }
    }
}

private extension ExperienceBookingConfirmationView {
    var expandedDetailsSection: some View {
        VStack(spacing: 16) {
            if !viewModel.contactDetails.isEmpty {
                ContactDetailsCardView(
                    contactDetailsModel: viewModel.contactDetails,
                    title: Constants.BookingStatusScreenConstants.supplierContactTitle,
                    whatsappNumberRequired: false)
            }
            FareSummaryCardView(
                fairSummaryData: viewModel.fairSummaryData,
                totalPrice: "\(viewModel.currency) \(viewModel.totalAmount.commaSeparated())",
                shouldShowTopBanner: showTopBanner(),
                savingsText: viewModel.savingsTextforFareBreakup // Pass savings text for banner
            )
            if showRefundableView() {
                RefundDetailsCardView(viewModel: viewModel)
            }
            ConfirmationInfoReusableCardView(section: viewModel.cancellationPolicy, showBullets: false)
            ConfirmationInfoReusableCardView(section: viewModel.leadTraveller, showBullets: false)
            ConfirmationInfoReusableCardView(section: viewModel.inclusions, showBullets: true)
//            ConfirmationInfoReusableCardView(section: viewModel.OtherDetails, showBullets: false)
            ContactDetailsCardView(
                contactDetailsModel: viewModel.personContactDetails,
                title: Constants.BookingStatusScreenConstants.contactDetails
            )
            if let additionalInformation  = viewModel.bookingDetailsResponse?.data?.bookingDetails?.productInfo?.additionalInfo, !additionalInformation.isEmpty {
                ConfirmationInfoReusableCardView(section: viewModel.additionalInformation, showBullets: true)
            }
            
            if viewModel.bookingStatus == .confirmed, let travelDate =  viewModel.travelDate, travelDate.isTravelDateTodayOrFuture() {
                ActionButton(title: Constants.BookingStatusScreenConstants.cancelBooking) {
                    fetchCancellationReasons()
                    showCancelReasonSheet = true
                }
            }
        }
    }
}

private extension ExperienceBookingConfirmationView {
    @ViewBuilder
    var cancellationReasonOverlay: some View {
        if showCancelReasonSheet {
            CancelBookingReasonsBottomSheetView(viewModel: viewModel, isPresented: $showCancelReasonSheet, onNextClicked: { reason in
                if reason != nil  {
                    showCancelReasonSheet = false
                    showCancelConfirmationSheet = true
                    viewModel.preCancelBooking(orderNo: viewModel.orderNumberForCancel)
                } else {
                    viewModel.showToastMessage("Please select a cancellation reason to continue.")
                }
            })
        }
    }

    @ViewBuilder
    var cancellationConfirmationOverlay: some View {
        if showCancelConfirmationSheet {
            CancelBookingConfirmationBottomSheet(isPresented: $showCancelConfirmationSheet, viewModel: viewModel) { success in
                if success {
                    navigateToCancellationView = true
                } else {
                    cancellationFailedSheet = true
                }
            }
        }
    }

    @ViewBuilder
    var cancelBookingFailedOverlay: some View {
        if cancellationFailedSheet {
            CancelBookingFailedBottomSheet(isPresented: $cancellationFailedSheet) {
                navigateToHome = true
            }
        }
    }
}

private extension ExperienceBookingConfirmationView {
    func fetchBookingStatus() {
        viewModel.fetchBookingStatus(
            orderNo: orderNo,
            siteId: ssoSiteIdGlobal,
            isFromBookingJourney: isFromBookingJourney
        )
    }

    private func fetchCancellationReasons() {
        let orderNo = viewModel.bookingBasicDetails
            .first(where: { $0.key == Constants.BookingStatusScreenConstants.bookingIdKey })?.value ?? ""
        
        viewModel.fetchCancellationReasons(orderNo: orderNo)
    }
}

struct CancelBookingConfirmationBottomSheet: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: ExperienceBookingConfirmationViewModel
    var onCancelled: ((Bool) -> Void)? = nil

    @State var buttonClicked: Bool = false

    var body: some View {
        BottomSheetView(isPresented: $isPresented) {
            VStack(alignment: .leading, spacing: 20) {
                Text(Constants.BookingStatusScreenConstants.cancelBookingTitle)
                    .font(.custom(Constants.Font.openSansBold, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                SeparatorLine()
                
                HStack {
                    Text(Constants.BookingStatusScreenConstants.totalAmount)
                    Spacer()
                    Text("\(viewModel.preCancelbookingResponse?.data?.currency ?? "AED") \(viewModel.preCancelbookingResponse?.data?.totalAmount?.commaSeparated() ?? "0.00")")
                }
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                
                HStack {
                    Text(Constants.BookingStatusScreenConstants.deduction)
                    Spacer()
                    Text("\(viewModel.preCancelbookingResponse?.data?.currency ?? "AED") \(viewModel.preCancelbookingResponse?.data?.cancellationFee?.commaSeparated() ?? "0.00")")
                }
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                
                SeparatorLine()
                
                HStack {
                    Text(Constants.BookingStatusScreenConstants.totalAmountToBeRefunded)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                    Spacer()
                    Text("\(viewModel.preCancelbookingResponse?.data?.currency ?? "AED") \(viewModel.preCancelbookingResponse?.data?.refundAmount?.commaSeparated() ?? "0.00")")
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(Color.black)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(Constants.BookingStatusScreenConstants.refundAmount)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    Text(Constants.BookingStatusScreenConstants.refundText)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                }
                .padding(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: Constants.HexColors.bgPremierWeak))
            
                Button(action: {
                    buttonClicked = true
                    cancelBooking()
                }) {
                    Group {
                        if buttonClicked {
                            ProgressView()
                                .foregroundStyle(.white)
                        } else {
                            Text(Constants.BookingStatusScreenConstants.cancelNow)
                                .font(.custom(Constants.Font.openSansBold, size: 12))
                                .foregroundStyle(.white)
                        }
                    }
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(Color(hex: Constants.HexColors.primary))
                        .cornerRadius(4)
                }
            }
            .padding(.top, 24)
            .padding([.horizontal, .bottom], 16)
        }
    }

    private func cancelBooking() {
        guard let selectedReason = viewModel.selectedReason else { return }

        viewModel.cancelBooking(reasonCode: selectedReason.code) { success in
            onCancelled?(success)
            isPresented = false
        }
    }
}
