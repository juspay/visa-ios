//
//  ExperienceHomeView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SUINavigation
import SwiftUI

struct ExperienceHomeView: View {
    @ObservedObject var viewModelSearchDestinationViewModel = SearchDestinationViewModel()
    @State private var isSearchSheetPresented = false
    @State private var navigateToAllDestinations = false
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStorageView {
            GeometryReader { geo in
                ThemeTemplateView(header: {
                    EmptyView()
                }, content: {
                    VStack(spacing: 0) {
                        VStack(spacing: 14) {
                            VStack(spacing: 28) {
                                TopBarView {
                                    withAnimation {
                                        isSearchSheetPresented = true
                                    }
                                }
                                
                                VStack(spacing: 10) {
                                    SectionHeaderView(
                                        title: Constants.HomeScreenConstants.exploreDestinationsHeaderText,
                                        showViewAll: true) {
                                            navigateToAllDestinations = true
                                        }
                                    DestinationScrollView(destinations: viewModel.destinations)
                                }
                                
                                VStack(spacing: 10) {
                                    SectionHeaderView(title: Constants.HomeScreenConstants.epicExperiencesHeader, showViewAll: false)
                                    ExperienceListView(experiences: viewModel.experiences)
                                }
                            }
                        }
                        .padding(.top, 22)
                        
                        LoadMoreButton {
                            viewModel.loadMoreExperiences()
                        }
                    }
                    .onAppear(perform: {
                        isSearchSheetPresented = false
                    })
                })
                .navigation(isActive: $navigateToAllDestinations, id: Constants.NavigationId.allDestinations) {
                    AllDestinationsView(
                        viewModel: viewModelSearchDestinationViewModel,
                        destinations: viewModel.destinations
                    )
                }
                .overlay(content: {
                    let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                        .screen.bounds.height ?? 0
                    BottomSheetView(isPresented: $isSearchSheetPresented, sheetHeight: screenHeight * 0.9) {
                        SearchDestinationBottomSheetView()
                    }
                })
            }
        }
    }
}

