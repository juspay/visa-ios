//
//  AvailabilitySelectionMainView.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import SwiftUI
import SUINavigation


struct AvailabilitySelectionMainView: View {
    @ObservedObject var experienceAvailabilitySViewModel: ExperienceAvailabilitySelectOptionsViewModel
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    @State private var showDateSheet = false
    @State private var showParticipantsScreen = false
    var productCode: String?
    var currency: String?
    
    var body: some View {
        GeometryReader { geo in
            ThemeTemplateView(header: {
                AvailabilitySelectionView(
                    viewModel: experienceAvailabilitySViewModel,
                    onDateTap: {
                        showDateSheet = true
                        navigationStorage?.popTo(Constants.NavigationId.experienceDetailView)
                    }, onParticipantsTap: {
                        showParticipantsScreen = true
                    },
                    productCode: productCode,
                    currency: currency
                )
                    .padding(.bottom, 16)
            }, content: {
                ExperiencePassesListView(viewModel: experienceAvailabilitySViewModel)
                    .frame(maxWidth: .infinity)
                    
            })
            .navigationBarBackButtonHidden(true)
            .overlay(
                BottomSheetView(isPresented: $showParticipantsScreen) {
                    ParticipantSelectionView(viewModel: experienceAvailabilitySViewModel)
                }
            )
        }
    }
}

