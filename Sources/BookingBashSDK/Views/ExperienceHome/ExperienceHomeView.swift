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
    @ObservedObject var experienceViewModel = ExperienceListViewModel()
    @State private var isSearchSheetPresented = false
    @State private var navigateToAllDestinations = false
    @State private var navigateToExperienceList = false
    @State private var selectedDestination: Destination?
    @StateObject private var viewModel = HomeViewModel()
    let encryptPayLoad: String
    @State private var showMenu = false
    @Binding var isActive: Bool
    var onFinish: () -> Void
    @State private var showSkipSheet = false
    @State private var isDecryptionLoading = false
    @State private var experienceListSearchRequestModel: SearchRequestModel? // Added for navigation
    @State private var showExperienceDetail = false
    @State private var selectedExperienceProductCode = ""
    @State private var selectedExperienceCurrency = ""
    @State private var showEpicExperienceListDetail = false
    
    var body: some View {
        GeometryReader { geo in
            ThemeTemplateView(
                header: {
                    EmptyView()
                },
                content: {
                    ZStack {
                        VStack(spacing: 0) {
                            VStack(spacing: 14) {
                                VStack(spacing: 28) {
                                    
                                    //  TopBar with search + hamburger
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
                                        { destination in
                                            selectedDestination = destination
                                            // Prepare SearchRequestModel similar to SearchDestinationBottomSheetView
                                            let requestModel = SearchRequestModel(
                                                destinationId: destination.destinationId, // Adjust property names as per your model
                                                destinationType: destination.destinationType, // Adjust as needed
                                                location: destination.city, // Adjust as needed
                                                checkInDate: "2025-10-24",
                                                checkOutDate: "2025-10-25",
                                                currency: "INR",
                                                clientId: "CLIENT_ABC123",
                                                enquiryId: "ENQ_456XYZ",
                                                productCode: [],
                                                filters: SearchFilters(
                                                    limit: 50,
                                                    offset: 0,
                                                    priceRange: [],
                                                    rating: [],
                                                    duration: [],
                                                    reviewCount: [],
                                                    sortBy: SortBy(name: "price", type: "ASC"),
                                                    categories: [],
                                                    language: ["en", "ar"],
                                                    itineraryType: [],
                                                    ticketType: [],
                                                    confirmationType: [],
                                                    featureFlags: [
                                                        "free_cancellation",
                                                        "special_offer",
                                                        "private_tour",
                                                        "skip_the_line",
                                                        "likely_to_sell_out"
                                                    ],
                                                    productCode: []
                                                )
                                            )
                                            experienceListSearchRequestModel = requestModel
                                            navigateToExperienceList = true
                                        }
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
                            
                        //                            LoadMoreButton {
                        //                                viewModel.loadMoreExperiences()
                        //                            }
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
                        
                        // ✅ Loader Overlay
                        if viewModel.isLoading || isDecryptionLoading {
                            LoaderView()
                        }
                    }
                    .onAppear {
                        viewModel.fetchHomeData()
                        
                        isSearchSheetPresented = false
                        isDecryptionLoading = true
                        viewModelSearchDestinationViewModel.decryptJWE(jwe: encryptPayLoad) { result in
                            DispatchQueue.main.async {
                                isDecryptionLoading = false
                            }
                            switch result {
                            case .success(let data):
                                do {
                                    let decoded = try JSONDecoder().decode(DecryptedResponse.self, from: data)
                                    DispatchQueue.main.async {
                                        viewModelSearchDestinationViewModel.decryptedResponse = decoded
                                        print("DecryptedResponse stored: \(decoded)")
                                        
                                        firstName = decoded.payload.firstName
                                        lastName = decoded.payload.lastName
                                        mobileNumber = decoded.payload.mobileNumber
                                        mobileCountryCode = decoded.payload.mobileCountryCode
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
                },
                onBack: { showSkipSheet = true }
            )
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

            
            //navigate to experienceDetailView on tapping an experience from explore destination
            .navigation(
                isActive: $navigateToExperienceList,
                id: Constants.NavigationId.experienceListDetailView
            ) {
                if let requestModel = experienceListSearchRequestModel {
                    ExperienceListDetailView(
                        destinationId: requestModel.destinationId,
                        destinationType: requestModel.destinationType,
                        location: requestModel.location,
                        checkInDate: requestModel.checkInDate,
                        checkOutDate: requestModel.checkOutDate,
                        currency: requestModel.currency,
                        productCodes: requestModel.productCode
                    )
                }
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
            .overlay(
                Group {
                    if showSkipSheet {
                        let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.height ?? 0
                        BottomSheetView(isPresented: $showSkipSheet, sheetHeight: screenHeight * 0.34) {
                            VStack(spacing: 20) {
                                Image("Activity")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                                Text("Do you want to skip the booking?")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 4)
                                HStack(spacing: 12) {
                                    Button(action: {
                                        // can modify this action as per requirement -
                                        showSkipSheet = false
                                        isActive = false
                                        onFinish()
                                    }) {
                                        Text("Yes, Skip")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color(hex:  Constants.HexColors.primary))
                                            .frame(width: 120, height: 48)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color(hex: "#B89B5E"), lineWidth: 2)
                                            )
                                    }
                                    Button(action: {
                                        showSkipSheet = false
                                    }) {
                                        Text("Stay")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 120, height: 48)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color(hex: "#B89B5E"))
                                            )
                                    }
                                }
                                .frame(maxWidth: 260)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 25)
                            .background(Color.white)
                            .cornerRadius(20)
                        }
                    }
                }, alignment: .bottom
            )
        }
        .navigationBarBackButtonHidden(true)
    }
}
