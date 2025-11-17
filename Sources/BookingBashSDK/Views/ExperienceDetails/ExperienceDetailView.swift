import SwiftUI
import SUINavigation

struct ExperienceDetailView: View {
    @StateObject private var experienceDetailViewModel = ExperienceDetailViewModel()
    @StateObject private var experienceAvailabilityViewModel = ExperienceAvailabilitySelectOptionsViewModel()
    @State var shouldPresentCalenderView: Bool = false
    @State private var showAll: Bool = false
    @State private var showParticipantsSheet: Bool = false

    let productCode: String
    let currency: String?

    init(productCode: String? = nil, currency: String? = nil) {
        self.productCode = productCode ?? ""
        self.currency = currency
    }

    var body: some View {
        ZStack(alignment: .center) {
            ThemeTemplateView(
                header: { headerContent },
                content: { mainContent }
            )
            .navigationBarBackButtonHidden(true)
            .padding(.bottom, -8)
            .safeAreaInset(edge: .bottom) {
                if !experienceDetailViewModel.isLoading &&
                    experienceDetailViewModel.errorStatusCode != 500 &&
                    experienceDetailViewModel.errorMessage == nil {
                    ExperienceDetailBottomBarView(viewModel: experienceDetailViewModel) {
                        shouldPresentCalenderView = true
                    }
                }
            }
        }
        .overlay { calendarBottomSheet }
        .onAppear {
            experienceDetailViewModel.fetchReviewData(
                activityCode: productCode,
                currency: currency ?? ""
            )
        }
    }
}


private extension ExperienceDetailView {
    var headerContent: some View {
        
        VStack(spacing: 12) {
            ExperienceDetailsTopHeaderView()

            if experienceDetailViewModel.isLoading {
                headerLoadingPlaceholder
            } else if experienceDetailViewModel.errorMessage != nil {
                EmptyView()
            } else {
                ExperienceTopImageCarousalListView(
                    experienceDetailCarousalModel: experienceDetailViewModel.carousalData
                )
                .padding(.trailing, -15)

                if let model = experienceDetailViewModel.experienceDetail {
                        ExperienceDetailInfoTopView(model: model)
                }
            }
        }
        .padding(.bottom, 14)
    }
    
    var mainContent: some View {
        VStack(spacing: 16) {
            if experienceDetailViewModel.isLoading {
                LoaderView(text: Constants.ExperienceListDetailViewConstants.loading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if experienceDetailViewModel.showErrorOverlay || (experienceDetailViewModel.errorStatusCode != nil && experienceDetailViewModel.errorStatusCode != 200) {
                Spacer()
                VStack(spacing: 20) {
                    ErrorMessageView()
                }
                .frame(maxWidth: .infinity)
                Spacer()
            } else if experienceDetailViewModel.errorMessage != nil {
                EmptyView()
            } else {
                // Only show FeatureGridView if there are features
                if !experienceDetailViewModel.allFeatures.isEmpty {
                    FeatureGridView(
                        features: experienceDetailViewModel.allFeatures,
                        showAll: $showAll
                    )
                   
                } else {
                    Color.clear
                        .frame(height: 0)
                }
                
                if let aboutExperience = experienceDetailViewModel.aboutExperience {
                    AboutExperienceCardView(
                        aboutExperienceModel: aboutExperience,
                        isExpanded: $experienceDetailViewModel.isViewMoreExpanded
                    )
                }
                
                FreeCancellationView(cancellationPolicy: experienceDetailViewModel.cancellationPolicy)
                // PopularDaysCardView(days: experienceDetailViewModel.popularDays)
                InfoListView(viewModel: experienceDetailViewModel)
                
//                SimilarExperiencesView(
//                    experienceDetailCarousalModel: experienceDetailViewModel.carousalData
//                )
//                .padding(.trailing, -16)
            }
        }
        .padding()
    }
    
    var headerLoadingPlaceholder: some View {
        VStack(spacing: 16) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .cornerRadius(12)
                .redacted(reason: .placeholder)
            
            VStack(spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 24)
                    .cornerRadius(4)
                    .redacted(reason: .placeholder)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 16)
                    .cornerRadius(4)
                    .redacted(reason: .placeholder)
            }
        }
        .padding(.trailing, -15)
    }
    
    var calendarBottomSheet: some View {
        let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .screen.bounds.height ?? 0
        return BottomSheetView(
            isPresented: $shouldPresentCalenderView,
            sheetHeight: screenHeight * 0.85
        ) {
            ZStack(alignment: .topTrailing) {
                if let model = experienceDetailViewModel.experienceDetail {

                    CustomCalendarView(
                        viewModel: experienceAvailabilityViewModel, showParticipantsSheet: $showParticipantsSheet,
                        shouldPresentCalenderView: $shouldPresentCalenderView,
                        isFromDetailView: true,
                        model: model,
                        experienceDetailViewModel: experienceDetailViewModel,
                        productCode: productCode,
                        currency: currency
                    )

                } else {
                    LoaderView(text: Constants.ExperienceListDetailViewConstants.loading)
                }
                // Cross button at top right
                if !showParticipantsSheet {
                    Button(action: {
                        shouldPresentCalenderView = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .offset(y: -15)
                    .zIndex(1)
                    .padding(.trailing, 16)
                }
            }
        }
    }
}
