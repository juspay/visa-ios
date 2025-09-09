//
//  FilterScreenView.swift
//  VisaActivity
//
//  Created by Apple on 31/07/25.
//

import Foundation
import SUINavigation
import SwiftUI

struct FilterScreenView: View {
    @StateObject var viewModel = FilterViewModel()
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ThemeTemplateView(header: {
                TopFilterBannerView()
            }, content: {
                FilterSectionListView(viewModel: viewModel)
                    .padding(.bottom, SafeAreaHelper.bottomInset() + 30)
                    .padding()
            })
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: viewModel.fetchOptions)
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.18), Color.clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(height: 6)
                    .zIndex(1)
                
                Divider()
                
                HStack(spacing: 20) {
                    Spacer()
                    Button(action: {
                        viewModel.reset()
                    }) {
                        Text(Constants.ExperienceListConstants.resetAll)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                            .padding(.horizontal, 16)
                            .frame(height: 42)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(hex: Constants.HexColors.primary), lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        navigationStorage?.popTo(Constants.NavigationId.experienceListDetailView)
                    }) {
                        Text(Constants.ExperienceListConstants.showResults)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .frame(height: 42)
                            .background(Color(hex: Constants.HexColors.primary))
                            .cornerRadius(4)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 15)
                .padding(.top, 14)
                .background(Color.white)
            }
        }
    }
}
