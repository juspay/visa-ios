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
    let encryptPayLoad: String
    @State private var showMenu = false

    var body: some View {
        NavigationStorageView {
            GeometryReader { geo in
                ThemeTemplateView(header: {
                    EmptyView()
                }, content: {
                    ZStack {
                        VStack(spacing: 0) {
                            VStack(spacing: 14) {
                                VStack(spacing: 28) {
                                    
                                    // ✅ TopBar with search + hamburger
                                    TopBarView {
                                        withAnimation {
                                            isSearchSheetPresented = true
                                        }
                                    } onHamburgerTap: {
                                        withAnimation {
                                            showMenu.toggle()
                                        }
                                    }
                                    
                                    // Content Sections
                                    VStack(spacing: 10) {
                                        SectionHeaderView(
                                            title: Constants.HomeScreenConstants.exploreDestinationsHeaderText,
                                            showViewAll: true
                                        ) {
                                            navigateToAllDestinations = true
                                        }
                                        DestinationScrollView(destinations: viewModel.destinations)
                                    }

                                    VStack(spacing: 10) {
                                        SectionHeaderView(
                                            title: Constants.HomeScreenConstants.epicExperiencesHeader,
                                            showViewAll: false
                                        )
                                        ExperienceListView(experiences: viewModel.experiences)
                                    }
                                }
                            }
                            .padding(.top, 22)

                            LoadMoreButton {
                                viewModel.loadMoreExperiences()
                            }
                        }

                        // ✅ Side Menu Overlay
                        if showMenu {
                            HStack {
                                SideMenuView()
                                    .frame(width: 280)
                                    .transition(.move(edge: .leading))
                                Spacer()
                            }
                            .background(
                                Color.black.opacity(0.3)
                                    .onTapGesture {
                                        withAnimation { showMenu.toggle() }
                                    }
                            )
                        }
                    }
                    .onAppear {
                        isSearchSheetPresented = false
                        viewModelSearchDestinationViewModel.decryptJWE(jwe: encryptPayLoad) { result in
                            switch result {
                            case .success(let data):
                                do {
                                    let decoded = try JSONDecoder().decode(DecryptedResponse.self, from: data)
                                    DispatchQueue.main.async {
                                        viewModelSearchDestinationViewModel.decryptedResponse = decoded
                                        print("DecryptedResponse stored: \(decoded)")

                                        firstName = decoded.payload.firstName
                                        lastName = decoded.payload.lastName
                                        customerEmail = decoded.payload.customerEmail
                                        aliasId = decoded.payload.aliasId
                                        customerId = decoded.payload.customerId
                                        isDeeplink = decoded.payload.isDeeplink
                                        location = decoded.payload.location

                                        print(encryptedPayload)
                                    }
                                } catch {
                                    print("Failed to decode: \(error)")
                                }
                            case .failure(let error):
                                print("Failed to decrypt: \(error.localizedDescription)")
                            }
                        }
                    }
                })
                .navigationBarBackButtonHidden(true)
                .navigation(
                    isActive: $navigateToAllDestinations,
                    id: Constants.NavigationId.allDestinations
                ) {
                    AllDestinationsView(
                        viewModel: viewModelSearchDestinationViewModel,
                        destinations: viewModel.destinations
                    )
                }
                .overlay(content: {
                    let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                        .screen.bounds.height ?? 0
                    BottomSheetView(
                        isPresented: $isSearchSheetPresented,
                        sheetHeight: screenHeight * 0.9
                    ) {
                        SearchDestinationBottomSheetView()
                    }
                })
            }
        }
    }
}


