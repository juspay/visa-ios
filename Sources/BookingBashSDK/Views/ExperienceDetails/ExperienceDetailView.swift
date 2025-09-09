//
//  ExperienceDetailView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import SwiftUI
import SUINavigation

struct ExperienceDetailView: View {
    @StateObject private var experienceDetailViewModel = ExperienceDetailViewModel()
    @State private var shouldPresentCalenderView: Bool = false
    @State var searchText: String = ""
    @State var showAll: Bool = false
    var productCode: String?
    var currency: String?
    
    init(
        productCode: String? = nil,
        currency: String? = nil
    ) {
        self.productCode = productCode
        self.currency = currency
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ThemeTemplateView(
                header: {
                    VStack(spacing: 12) {
                        ExperienceDetailsTopHeaderView()
                        ExperienceTopImageCarousalListView(experienceDetailCarousalModel: experienceDetailViewModel.carousalData)
                            .padding(.trailing, -15)
                        if let model = experienceDetailViewModel.experienceDetail {
                            ExperienceDetailInfoTopView(
                                model: model
                            )
                        }
                    }
                    .padding(.bottom, 14)
                    
                },
                content: {
                    VStack(spacing: 16) {
                        FeatureGridView(features: experienceDetailViewModel.allFeatures,
                                        showAll: $showAll)
                        if let aboutExperience = experienceDetailViewModel.aboutExperience {
                            AboutExperienceCardView(
                                aboutExperienceModel: aboutExperience,
                                isExpanded: $experienceDetailViewModel.isViewMoreExpanded
                            )
                        }
                        FreeCancellationView(cancellationPolicy: experienceDetailViewModel.cancellationPolicy)
                        PopularDaysCardView(days: experienceDetailViewModel.popularDays)
                        InfoListView(viewModel: experienceDetailViewModel)
                        SimilarExperiencesView(experienceDetailCarousalModel: experienceDetailViewModel.carousalData)
                            .padding(.trailing, -16)
                    }
                    .padding()
                    
                })
            .navigationBarBackButtonHidden(true)
            .padding(.bottom, -8)
            .safeAreaInset(edge: .bottom) {
                ExperienceDetailBottomBarView(viewModel: experienceDetailViewModel) {
                    shouldPresentCalenderView = true
                }
            }
        }

        .overlay(content: {
            let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .screen.bounds.height ?? 0
            BottomSheetView(isPresented: $shouldPresentCalenderView, sheetHeight: screenHeight * 0.85) {
                CustomCalendarView(productCode: productCode, currency: currency)
            }
            
        })
        
        .onAppear {
            experienceDetailViewModel
                .fetchReviewData(
                    productCode: productCode ?? "",
                    currency: currency ?? ""
                )
        }
    }
}

#Preview {
    ExperienceDetailView()
}
