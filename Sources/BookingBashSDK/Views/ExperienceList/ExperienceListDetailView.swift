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
    @State private var selectedProductCode = ""
    @State private var selectedCurrency = ""
    
    //  Dynamic params
    let destinationId: String
    let destinationType: String
    let location: String
    let checkInDate: String
    let checkOutDate: String
    let currency: String
    let productCodes: [String]
    
    var body: some View {
        ThemeTemplateView(header: {
            MainTopHeaderView(headerText: "")
        }, content: {
            ZStack {
                if viewModel.isLoading {
                    // Centered loading indicator
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView("Loading experiences...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .scaleEffect(1.2)
                            Spacer()
                        }
                        Spacer()
                    }
                } else {
                    VStack(spacing: 30) {
                        if let errorMessage = viewModel.errorMessage {
                            // Error handling
                            VStack {
                                Spacer()
                                Text(" \(errorMessage)")
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Spacer()
                            }
                        } else if viewModel.experiences.isEmpty {
                            // Empty state
                            VStack {
                                Spacer()
                                Text("No experiences found")
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Spacer()
                            }
                        } else {
                            LazyVStack(spacing: 20) {
                                ForEach(Array(viewModel.experiences.enumerated()), id: \.1.id) { index, experience in
                                    ExperienceListCardView(experience: experience)
                                        .onTapGesture {
                                            selectedProductCode = experience.productCode
                                            selectedCurrency = experience.currency
                                            listItemTapped = true
                                            productIdG = experience.productCode
                                           
                                        }
                                        .zIndex(Double(viewModel.experiences.count - index))
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        })
        .navigationBarBackButtonHidden(true)
        .navigation(isActive: $navigateToFilterScreenView, id: Constants.NavigationId.filterScreenView) {
            FilterScreenView()
        }
        .navigation(isActive: $listItemTapped, id: Constants.NavigationId.experienceDetailView) {
            ExperienceDetailView(
                productCode: selectedProductCode,
                currency: selectedCurrency
            )
        }
        .overlay(
            BottomSheetView(isPresented: $showSortSheet) {
                SortView()
            }
        )
        .onAppear {
            //  Fetch dynamically based on passed params
            viewModel.fetchSearchData(
                destinationId: destinationId,
                destinationType: destinationType,
                location: location,
                checkInDate: checkInDate,
                checkOutDate: checkOutDate,
                currency: currency,
                productCodes: productCodes
            )
        }
    }
}
