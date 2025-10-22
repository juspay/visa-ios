
import Foundation
import SwiftUI

struct ParticipantSelectionView: View {
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    var onSelect: (() -> Void)? = nil // Add a closure for selection
    
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
                        
                        if category.price > 0 {
                            Text("\(Constants.AvailabilityScreenConstants.aed) \(category.price)")
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                viewModel.decrement(for: category)
                            }) {
                                if let minusImage = ImageLoader.bundleImage(named: Constants.Icons.minus) {
                                    minusImage
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                                }
                            }
//                            .disabled(category.isAdult && category.count == 1)
                            .disabled(category.count <= category.minLimit)

                            Text("\(category.count)")
                                .font(.custom(Constants.Font.openSansBold, size: 14))
                                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                            
                            Button(action: {
                                viewModel.increment(for: category)
                            }) {
                                if let plusImage = ImageLoader.bundleImage(named: Constants.Icons.plus) {
                                    plusImage
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 24, height: 24)
                                        .tint(Color(hex: Constants.HexColors.primary))
                                        .opacity(
                                            (category.count >= category.maxLimit)
                                            ? 0.4 : 1.0
                                        )
                                }
                            }
                            .disabled(
                                (category.count >= category.maxLimit)
                            )
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            
            Button(action: {
                print("\(Constants.AvailabilityScreenConstants.selectedParticipants) \(viewModel.categories)")
                viewModel.selectParticipants()
                onSelect?() // Call the closure when select is tapped
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
        .onAppear {
            // Load dynamic age bands when participant selection sheet appears
            viewModel.loadDynamicAgeBands()
        }
    }
}
