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
        ZStack {
            // Main content structure with app bar always visible
            ZStack(alignment: .bottom) {
                ThemeTemplateView(
                    header: {
                        VStack(spacing: 12) {
                            ExperienceDetailsTopHeaderView()
                            
                            // Show loading or content based on loading state
                            if experienceDetailViewModel.isLoading {
                                // Loading state for header content
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
                            } else {
                                // Actual content when loaded
                                ExperienceTopImageCarousalListView(experienceDetailCarousalModel: experienceDetailViewModel.carousalData)
                                    .padding(.trailing, -15)
                                if let model = experienceDetailViewModel.experienceDetail {
                                    ExperienceDetailInfoTopView(
                                        model: model
                                    )
                                }
                            }
                        }
                        .padding(.bottom, 14)
                        
                    },
                    content: {
                        if experienceDetailViewModel.isLoading {
                            // Loading content
                            VStack(spacing: 16) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    .scaleEffect(1.5)
                                
                                Text("Loading...")
                                    .foregroundColor(.primary)
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                        } else {
                            // Actual content when loaded
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
                        }
                        
                    })
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

        .overlay(content: {
            let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .screen.bounds.height ?? 0
            BottomSheetView(isPresented: $shouldPresentCalenderView, sheetHeight: screenHeight * 0.85) {
                if let model = experienceDetailViewModel.experienceDetail {
                    CustomCalendarView(model: model, productCode: productCode, currency: currency)
                } else {
                    // Optionally, show a placeholder or loading view
                    Text("Loading...")
                }
            }
            
        })
        
        .onAppear {
            productIdG = productCode ?? ""
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
