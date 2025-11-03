
import Foundation
import SwiftUI

struct ExperienceDetailBottomBarView: View {
    @ObservedObject var viewModel: ExperienceDetailViewModel
    var onCheckAvailabilityButtonTapped: (() -> Void)?
    
    private func formatPrice(_ priceValue: Double, currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ","
        let formattedPrice = formatter.string(from: NSNumber(value: priceValue)) ?? String(format: "%.2f", priceValue)
        return "\(currency) \(formattedPrice)"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if viewModel.hasDiscount && viewModel.strikeoutPrice > 0.0 {
                        HStack(spacing: 8) {
                            Text(formatPrice(viewModel.strikeoutPrice, currency: viewModel.price.components(separatedBy: " ").first ?? ""))
                                .font(.custom(Constants.Font.openSansRegular, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                                .overlay(
                                    Rectangle()
                                        .fill(Color(hex: Constants.HexColors.neutral))
                                        .frame(height: 0.8)
                                )
                            
                            Text("You save \(Int(viewModel.savingsPercentage))%")
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.greenShade))
                        }
                    }
                    
                    Text(Constants.DetailScreenConstants.startingFrom)
                        .font(.custom(Constants.Font.openSansRegular, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    
                    HStack(spacing: 2) {
                        Text("AED")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                        Text(String(format: "%.2f", viewModel.priceValue))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                        Text(Constants.DetailScreenConstants.perPerson)
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    
                    onCheckAvailabilityButtonTapped?()
                }) {
                    Text(viewModel.buttonText)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .frame(height: 42)
                        .background(Color(hex: Constants.HexColors.primary))
                        .cornerRadius(4)
                }
            }
            .padding(15)
        }
        .background(Color.white)
    }
}
