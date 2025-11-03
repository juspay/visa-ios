import Foundation
import SwiftUI

struct ParticipantSelectionView: View {
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    @ObservedObject var detailViewModel: ExperienceDetailViewModel
    var onSelect: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            if let response = viewModel.response,
               response.status == false && response.statusCode != 200 {
                VStack(spacing: 20) {
                    if let noResultImage = ImageLoader.bundleImage(named: Constants.Icons.searchNoResult) {
                        noResultImage
                            .resizable()
                            .frame(width: 124, height: 124)
                    }
                    
                    Text(Constants.ErrorMessages.somethingWentWrong)
                        .font(.headline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            } else {
                // ✅ Normal Participant Selection Content
                VStack(alignment: .leading, spacing: 14) {
                    if let error = viewModel.errorMessage, !error.isEmpty {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.headline)
                            .padding(.bottom, 8)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(Constants.AvailabilityScreenConstants.participants)
                            .font(.custom(Constants.Font.openSansBold, size: 14))
                            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                        
                        Text(String(format: Constants.AvailabilityScreenConstants.maxTravelersFormat,
                                    detailViewModel.maxTravelersPerBooking ?? 0))
                        .font(.custom(Constants.Font.openSansRegular, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    }
                    
                    ForEach(viewModel.categories) { category in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 16) {
                                VStack(alignment: .leading) {
                                    Text(category.bandId)
                                        .font(.custom(Constants.Font.openSansBold, size: 12))
                                        .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                                    
//                                    if let index = viewModel.categories.firstIndex(where: { $0.id == category.id }),
//                                       index < detailViewModel.ageBandIDs.count {
//                                        Text(detailViewModel.ageBandIDs[index])
//                                            .font(.custom(Constants.Font.openSansBold, size: 12))
//                                            .foregroundStyle(Color(hex: Constants.HexColors.secondary))
//                                    } else {
//                                        Text("N/A")
//                                            .font(.custom(Constants.Font.openSansBold, size: 12))
//                                            .foregroundStyle(Color(hex: Constants.HexColors.secondary))
//                                    }

                                    
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
                                                .tint(Color(hex: Constants.HexColors.primary))
                                                .opacity(category.count <= category.minLimit ? 0.5 : 1.0)
                                            
                                            Text("\(category.count)")
                                                .font(.custom(Constants.Font.openSansBold, size: 14))
                                                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                                        }
                                    }
                                    .disabled(category.count <= category.minLimit)
                                    
                                    Button(action: {
                                        viewModel.increment(for: category)
                                    }) {
                                        if let plusImage = ImageLoader.bundleImage(named: Constants.Icons.plus) {
                                            plusImage
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 24, height: 24)
                                                .tint(Color(hex: Constants.HexColors.primary))
                                                .opacity((category.count >= category.maxLimit) ? 0.5 : 1.0)
                                        }
                                    }
                                    .disabled(category.count >= category.maxLimit)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    Button(action: {
                        viewModel.selectParticipants()
                        onSelect?()
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
        .onAppear {
            viewModel.maxTravelersPerBooking = detailViewModel.maxTravelersPerBooking ?? 0
            viewModel.loadDynamicAgeBands()
            
        }
    }
}
