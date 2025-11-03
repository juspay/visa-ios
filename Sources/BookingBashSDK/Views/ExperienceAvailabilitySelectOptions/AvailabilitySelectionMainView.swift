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
    
    // new flag (defaults to false)
    var fromDetailFlow: Bool = false
    
    var body: some View {
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
                   response.status == false && response.statusCode != 200 {
                    VStack {
                        Spacer()
                        VStack(spacing: 20) {
                            if let noResultImage = ImageLoader.bundleImage(named: Constants.Icons.searchNoResult) {
                                noResultImage
                                    .resizable()
                                    .frame(width: 124, height: 124)
                            }
                            Text(Constants.ErrorMessages.somethingWentWrong)
                                .font(.headline)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                }
                else {
                    ExperiencePassesListView(
                        viewModel: experienceAvailabilitySViewModel,
                        experienceDetailViewModel: experienceDetailViewModel,
                        model: model,
                        productCode: productCode ?? ""
                    )
                    .frame(maxWidth: .infinity)
                }
            })
            .navigationBarBackButtonHidden(true)
            .onAppear {
                if fromDetailFlow {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showParticipantsSheet = true
                    }
                }
            }
            
            .overlay(
                BottomSheetView(isPresented: $showParticipantsSheet) {
                    ZStack(alignment: .topTrailing) {
                        ParticipantSelectionView(
                            viewModel: experienceAvailabilitySViewModel, detailViewModel: experienceDetailViewModel,
                            onSelect: {
                                showParticipantsSheet = false
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
            
            // Calendar Bottom Sheet (when opening calendar from AvailabilitySelectionView)
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
                        
                        Button(action: {
                            shouldPresentCalenderView = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                                .padding(10)
                                .background(Color(.systemGray6).opacity(0.9))
                                .clipShape(Circle())
                                .shadow(radius: 1)
                        }
                        .padding(.top, 12)
                        .padding(.trailing, 16)
                    }
                    .background(Color.clear)
                }
            )
        }
    }
}
