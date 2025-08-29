//
//  ExperienceListView.swift
//  VisaActivity
//
//  Created by Apple on 30/07/25.
//

import Foundation
import SUINavigation
import SwiftUI

struct ExperienceListDetailView: View {
    @StateObject private var viewModel = ExperienceListViewModel()
    @State private var showSortSheet = false
    @State private var navigateToFilterScreenView = false
    @State private var listItemTapped = false
    @State var searchText: String = ""
    @State private var selectedPrductCode = ""
    @State private var selectedCurency = "INR"
    
    var body: some View {
        ThemeTemplateView(header: {
            MainTopHeaderView(headerText: "Save big with a fun pass")
        }, content: {
            VStack(spacing: 30) {
                //                SearchBarView(searchPlaceholderText: Constants.ExperienceListConstants.searchExperiencesNear,
                //                              searchText: $searchText)
                //                HeaderTitleView()
                //                ExperienceCountSortView(count: viewModel.experiences.count) {
                //                    showSortSheet = true
                //                } onFilterTapped: {
                //                    navigateToFilterScreenView = true
                //                }
                
                LazyVStack(spacing: 20) {
                    ForEach(Array(viewModel.experiences.enumerated()), id: \.1.id) { index, experience in
                        ExperienceListCardView(experience: experience)
                            .onTapGesture {
                                selectedPrductCode = experience.productCode
                                selectedCurency = experience.currency
                                listItemTapped = true
                            }
                            .zIndex(Double(viewModel.experiences.count - index))
                    }
                }
            }
            .padding()
            
        })
        .navigation(isActive: $navigateToFilterScreenView, id: Constants.NavigationId.filterScreenView) {
            FilterScreenView()
        }
        .navigation(isActive: $listItemTapped, id: Constants.NavigationId.experienceDetailView) {
            ExperienceDetailView(
                productCode: selectedPrductCode,
                currency: selectedCurency
            )
        }
        .overlay(
            BottomSheetView(isPresented: $showSortSheet) {
                SortView()
            }
        )
        .onAppear {
            viewModel.fetchSearchData()
        }
    }
}
