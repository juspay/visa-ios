import Foundation
import SwiftUI

struct ExperienceListCardView: View {
    let experience: ExperienceListModel
    
    // Helper function to format price as double with two decimal places
    private func formatPrice(_ price: Double) -> String {
        return String(format: "%.2f", price)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HStack(alignment: .top, spacing: 0) {
                // Image Section
                AsyncImage(url: URL(string: experience.imageName)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 160)
                        .clipped()
                        .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 130, height: 160)
                        .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        )
                }
                
                // Content Section
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            // Rating Section
                            if experience.rating > 0.0 {
                                HStack(spacing: 4) {
                                    if let starImage = ImageLoader.bundleImage(named: Constants.Icons.star) {
                                        starImage
                                            .resizable()
                                            .frame(width: 14, height: 14)
                                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                                    }
                                    
                                    Text(String(format: "%.1f", experience.rating))
                                        .font(.custom(Constants.Font.openSansSemiBold, size: 13))
                                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                                }
                            }
                            
                            // Title
                            Text(experience.title)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 15))
                                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Pricing Section at bottom
                    VStack(alignment: .leading, spacing: 4) {
                        // Strikeout price and savings (only show if discount available)
                        if let strikeoutPrice = experience.strikeoutPrice,
                           let savingPercentage = experience.savingPercentage,
                           strikeoutPrice > experience.price {
                            HStack(spacing: 8) {
                                Text("\(experience.currency) \(formatPrice(strikeoutPrice))")
                                    .font(.custom(Constants.Font.openSansRegular, size: 12))
                                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                                    .overlay(
                                        Rectangle()
                                            .fill(Color(hex: Constants.HexColors.neutral))
                                            .frame(height: 0.8)
                                    )
                                
                                Text("You save \(Int(savingPercentage))%")
                                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                    .foregroundStyle(Color(hex: Constants.HexColors.greenShade))
                                
                                Spacer()
                            }
                        }
                        
                        // Final price
                        HStack(alignment: .bottom, spacing: 4) {
                            Text("\(experience.currency) \(formatPrice(experience.price))")
                                .font(.custom(Constants.Font.openSansBold, size: 16))
                                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                            
                            Text(Constants.ExperienceListConstants.perPerson)
                                .font(.custom(Constants.Font.openSansRegular, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
            }
            .frame(height: 160)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
        }
    }
}
