import SwiftUI
import SUINavigation

struct AvailabilitySelectionMainView: View {
    @ObservedObject var experienceAvailabilitySViewModel: ExperienceAvailabilitySelectOptionsViewModel
    let model: ExperienceDetailModel
    @ObservedObject var experienceDetailViewModel: ExperienceDetailViewModel
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    
    @State private var shouldPresentCalenderView = false
    var productCode: String?
    var currency: String?
    @Binding var showParticipantsSheet: Bool
    var fromDetailFlow: Bool = false
    @State private var showSheetOnAppear: Bool = false
    @State private var showPriceChangeSheet: Bool = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""

    var body: some View {
        ZStack {
            GeometryReader { geo in
                ThemeTemplateView(header: {
                    AvailabilitySelectionView(
                        viewModel: experienceAvailabilitySViewModel,
                        onDateTap: {
                            shouldPresentCalenderView = true
                        }, onParticipantsTap: {
                            showParticipantsSheet = true
                        },
                        productCode: productCode,
                        currency: currency
                    )
                    .padding(.bottom, 16)
                }, content: {
                    if let response = experienceAvailabilitySViewModel.response,
                       response.status == false && response.statusCode != 200, !experienceAvailabilitySViewModel.isLoading  {
                        VStack {
                            ErrorMessageView(errorMessage: .noMatchFound)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .padding(.top, 60)
                        .background(Color.white)
                    } else {
                        ExperiencePassesListView(
                            viewModel: experienceAvailabilitySViewModel,
                            experienceDetailViewModel: experienceDetailViewModel, showPriceChangeSheet: $showPriceChangeSheet,
                            model: model,
                            productCode: productCode ?? ""
                        )
                        .frame(maxWidth: .infinity)
                    }
                })
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    experienceAvailabilitySViewModel.fetchAvailabilities(
                        productCode: productCode ?? "",
                        currencyCode: currency ?? ""
                    )
                    //                if fromDetailFlow, experienceAvailabilitySViewModel.isAvailabilityResponseFetched, !experienceAvailabilitySViewModel.showErrorView {
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    //                        showParticipantsSheet = true
                    //                    }
                    //                }
                }
                .onChange(of: experienceAvailabilitySViewModel.isAvailabilityResponseFetched) { responseFetched in
                    if responseFetched, fromDetailFlow, !experienceAvailabilitySViewModel.showErrorView, !showSheetOnAppear, experienceAvailabilitySViewModel.response?.data?.uid != nil  {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showSheetOnAppear = true
                            showParticipantsSheet = true
                        }
                    }
                }
                .overlay { PriceChangeBottomSheetOverlay }
                .overlay(
                    BottomSheetView(isPresented: $showParticipantsSheet) {
                        ZStack(alignment: .topTrailing) {
                            ParticipantSelectionView(
                                viewModel: experienceAvailabilitySViewModel, detailViewModel: experienceDetailViewModel,
                                onSelect: {
                                    if !validatePax() {
                                        showToast = true
                                    } else {
                                        showParticipantsSheet = false
                                    }
                                }
                            )
                            
                            Button(action: {
                                showParticipantsSheet = false
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                                    .padding(10)
                                    .background(Color(.systemGray6))
                                    .clipShape(Circle())
                                    .shadow(radius: 1)
                            }
                            .padding(.top, 4)
                            .padding(.trailing, 16)
                        }
                    }
                )
                .navigation(isActive: $experienceAvailabilitySViewModel.navigateToCheckout, id: Constants.NavigationId.experienceCheckoutView) {
                    ExperienceCheckoutView(
                        checkoutViewModel: ExperienceCheckoutViewModel(productId: productCode ?? ""),
                        experienceDetailViewModel: experienceDetailViewModel,
                        availabilityViewModel: experienceAvailabilitySViewModel,
                        package: experienceAvailabilitySViewModel.selectedPackage,
                        model: model,
                        productCode: productCode ?? "",
                        currency: currency ?? "",
                        subActivityCode: subActivityCode,
                        uid: experienceAvailabilitySViewModel.response?.data?.uid ?? "",
                        availabilityKey: experienceAvailabilitySViewModel.findAvailabilityKey(for: experienceAvailabilitySViewModel.selectedPackage),
                        selectedTime: experienceAvailabilitySViewModel.selectedPackage?.selectedTime ?? ""
                    )
                }
                .overlay(
                    BottomSheetView(
                        isPresented: $shouldPresentCalenderView,
                        sheetHeight: geo.size.height * 0.85
                    ) {
                        ZStack(alignment: .topTrailing) {
                            CustomCalendarView(
                                viewModel: experienceAvailabilitySViewModel, showParticipantsSheet: $showParticipantsSheet,
                                shouldPresentCalenderView: $shouldPresentCalenderView,
                                isFromDetailView: false,
                                model: model,
                                experienceDetailViewModel: experienceDetailViewModel,
                                productCode: productCode,
                                currency: currency
                            )
                            Button {
                                shouldPresentCalenderView = false
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.gray)
                                    .padding(4)
                                    .background(Color(.systemGray6).opacity(0.9))
                                    .clipShape(Circle())
                                    .shadow(radius: 1)
                            }
                            .buttonStyle(.plain)
                            .padding(.trailing, 16)
                        }
                        .background(Color.clear)
                    }
                )
            }
            
            toastOverlay
        }
    }
    
    var toastOverlay: some View {
        Group {
            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ToastView(message: toastMessage)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .animation(.easeInOut, value: showToast)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        showToast = false
                                    }
                                }
                            }
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    var PriceChangeBottomSheetOverlay: some View {
        PriceChangeBottomSheet(isPresented: $showPriceChangeSheet, priceCheckData: experienceAvailabilitySViewModel.priceCheckResponse?.data) {
            showPriceChangeSheet = false
            experienceAvailabilitySViewModel.navigateToCheckout = true
        }
    }

    func validatePax() -> Bool {
        guard let min = experienceDetailViewModel.apiReviewResponseData?.info.bookingRequirements.minTravelersPerBooking,
            let max = experienceDetailViewModel.apiReviewResponseData?.info.bookingRequirements.maxTravelersPerBooking else {
            return true
        }

        let selected = experienceAvailabilitySViewModel.totalSelected

        guard selected >= min && selected <= max else {
            toastMessage = "Please select at least \(min) participants to continue."
            return false
        }
        return true
    }
}
