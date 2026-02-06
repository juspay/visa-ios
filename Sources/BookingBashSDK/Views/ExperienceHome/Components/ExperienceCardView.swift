

import SwiftUI

struct ExperienceCardView: View {
    @Binding var experience: Experience
    var cardHeight: CGFloat = 230

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geometry in
                AsyncImage(url: URL(string: experience.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: geometry.size.width, height: cardHeight)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(.circular)
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: cardHeight)
                            .clipped()

                    case .failure:
                        if let arrow = ImageLoader.bundleImage(named: Constants.Icons.epicxEperiencesPlaceholder) {
                         arrow
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: cardHeight)
                            .clipped()
                     }

                    default:
                        if let arrow = ImageLoader.bundleImage(named: Constants.Icons.epicxEperiencesPlaceholder) {
                         arrow
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: cardHeight)
                            .clipped()
                     }
                    }
                }
            }

            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.6),
                    Color.black.opacity(0.3),
                    Color.clear
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 130)
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 16) {
                Text(experience.title)
                    .font(.custom(Constants.Font.openSansBold, size: 14))
                    .foregroundColor(.white)
                    .lineLimit(2)
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 2) {
                        Text("\(experience.currency) \(experience.originalPrice.commaSeparated())")
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                            .foregroundColor(.white)
                            .strikethrough()
                        
                        Text("You save \(Int(experience.discount.rounded()))%")
                            .font(.custom(Constants.Font.openSansBold, size: 12))
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 2) {
                        Text("\(experience.currency) \(experience.finalPrice.commaSeparated())")
                            .font(.custom(Constants.Font.openSansBold, size: 12))
                            .foregroundColor(.white)
                        Text("/\(experience.pricingModel.capitalized)")
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                            .foregroundColor(.white)
                    }

                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .frame(height: cardHeight)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .contentShape(Rectangle())
    }
}
