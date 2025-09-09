//
//  ParticipantSelectionView.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation
import SwiftUI

struct ParticipantSelectionView: View {
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 0) {
                Text(Constants.AvailabilityScreenConstants.participants)
                    .font(.custom(Constants.Font.openSansBold, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                
                Text(String(format: Constants.AvailabilityScreenConstants.maxTravelersFormat, 15))
                    .font(.custom(Constants.Font.openSansRegular, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            }
            
            ForEach(viewModel.categories) { category in
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            Text(category.type)
                                .font(.custom(Constants.Font.openSansBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                            
                            Text(category.ageRange)
                                .font(.custom(Constants.Font.openSansRegular, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        }
                        
                        Spacer()
                        
                        Text("\(Constants.AvailabilityScreenConstants.aed) \(category.price)")
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                viewModel.decrement(for: category)
                            }) {
                                Image(Constants.Icons.minus)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
                            }
                            
                            Text("\(category.count)")
                                .font(.custom(Constants.Font.openSansBold, size: 14))
                                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                            
                            Button(action: {
                                viewModel.increment(for: category)
                            }) {
                                Image(Constants.Icons.plus)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            
            Button(action: {
                print("\(Constants.AvailabilityScreenConstants.selectedParticipants) \(viewModel.categories)")
            }) {
                Text(Constants.AvailabilityScreenConstants.select)
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color(hex: Constants.HexColors.primary))
                    .cornerRadius(8)
            }
            .padding(.top, 38)
            .padding(.bottom)
        }
        .padding(.horizontal)
    }
}
