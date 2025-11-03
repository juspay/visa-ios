import Foundation
import SwiftUI

struct ExperienceListCardView: View {
    let experience: ExperienceListModel

    // Helper function to format price
    private func formatPrice(_ price: Double) -> String {
        return String(format: "%.2f", price)
    }

    // Dynamic height logic
    private var cardHeight: CGFloat {
        if let strikeoutPrice = experience.strikeoutPrice,
           let savingPercentage = experience.savingPercentage,
           strikeoutPrice > experience.price {
            return 140
        } else {
            return 120
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let height = cardHeight

            HStack(alignment: .top, spacing: 0) {
                // Image Section
                let imageUrl = URL(string: experience.imageName)
                if let imageUrl = imageUrl, !experience.imageName.isEmpty {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 100, height: height)
                                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                                .overlay(
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                )
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: height)
                                .clipped()
                                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                        case .failure:
                            if let placeholder = ImageLoader.bundleImage(named: Constants.TransactionRowConstants.placeHolderImage) {
                                placeholder
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: height)
                                    .clipped()
                                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 100, height: height)
                                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                            }
                        @unknown default:
                            if let placeholder = ImageLoader.bundleImage(named: Constants.TransactionRowConstants.placeHolderImage) {
                                placeholder
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: height)
                                    .clipped()
                                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 100, height: height)
                                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                            }
                        }
                    }
                } else {
                    if let placeholder = ImageLoader.bundleImage(named: Constants.TransactionRowConstants.placeHolderImage) {
                        placeholder
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: height)
                            .clipped()
                            .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: height)
                            .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                    }
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

                    // Pricing Section
                    VStack(alignment: .leading, spacing: 4) {
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

                        HStack(alignment: .bottom, spacing: 4) {
                            Text("\(experience.currency) \(formatPrice(experience.price))")
                                .font(.custom(Constants.Font.openSansBold, size: 16))
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))

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
            .frame(height: height)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
        }
        .frame(height: cardHeight)
    }
}
