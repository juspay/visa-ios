import SwiftUI
import SUINavigation

struct ExperienceDetailView: View {
    @StateObject private var experienceDetailViewModel = ExperienceDetailViewModel()
    @State private var shouldPresentCalenderView: Bool = false
    @State private var showAll: Bool = false
    
    let productCode: String
    let currency: String?
    
    init(productCode: String? = nil, currency: String? = nil) {
        self.productCode = productCode ?? ""
        self.currency = currency
        
    }
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                ThemeTemplateView(
                    header: { headerContent },
                    content: { mainContent }
                )
                .navigationBarBackButtonHidden(true)
                .padding(.bottom, -8)
                .safeAreaInset(edge: .bottom) {
                    if !experienceDetailViewModel.isLoading {
                        ExperienceDetailBottomBarView(viewModel: experienceDetailViewModel) {
                            shouldPresentCalenderView = true
                        }
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
            } else {
                ExperienceTopImageCarousalListView(
                    experienceDetailCarousalModel: experienceDetailViewModel.carousalData
                )
                .padding(.trailing, -15)

                if let model = experienceDetailViewModel.experienceDetail {
//                    if model.rating != 0.0 {
                        ExperienceDetailInfoTopView(model: model)
//                    }
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
            } else {
                // Only show FeatureGridView if there are features
                if !experienceDetailViewModel.allFeatures.isEmpty {
                    FeatureGridView(
                        features: experienceDetailViewModel.allFeatures,
                        showAll: $showAll
                    )
                    .onAppear {
                        print("DEBUG VIEW: FeatureGridView is VISIBLE with \(experienceDetailViewModel.allFeatures.count) features")
                    }
                } else {
                    Color.clear
                        .frame(height: 0)
                        .onAppear {
                            print("DEBUG VIEW: FeatureGridView is HIDDEN - allFeatures is empty")
                        }
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
            if let model = experienceDetailViewModel.experienceDetail {
                CustomCalendarView(
                    model: model, experienceDetailViewModel: experienceDetailViewModel,
                    productCode: productCode,
                    currency: currency
                )
            } else {
                LoaderView(text: Constants.ExperienceListDetailViewConstants.loading)
            }
        }
    }
}
