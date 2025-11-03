
import Foundation
import SwiftUI

struct FareSummaryCardView: View {
    let fairSummaryData: [FareItem]
    var totalPrice: String
    var shouldShowTopBanner: Bool = true
    var totalLableText: String = "Total Amount Paid"
    var savingsText: String? // Optional savings text

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Top gradient banner with icon and savings text (only show if shouldShowTopBanner is true)
            if shouldShowTopBanner {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "#1A3A52"),
                            Color(hex: "#2E5B3F"),
                            Color(hex: "#4CAF50")
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(height: 60)

                    HStack(alignment: .center, spacing: 8) {
                        if let savingIcon = ImageLoader.bundleImage(named: Constants.Icons.savingGray) {
                            savingIcon
                                .resizable()
                                .frame(width: 25, height: 25)
                                .colorMultiply(.white)
                        }

                        if let savingsText = savingsText {
                            Text(savingsText)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .cornerRadius(12, corners: [.topLeft, .topRight])
            }

            // Content section
            VStack(alignment: .leading, spacing: 0) {
                // Fare summary header
                Text("Fare summary")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "#2C3E50"))
                    .padding(.top, 14)
                    .padding(.bottom, 14)

                // Show loading or empty state if no data
                if fairSummaryData.isEmpty {
                    HStack(alignment: .center, spacing: 8) {
                        Text("Loading fare details...")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#7F8C8D"))
                        Spacer()
                    }
                    .padding(.bottom, 12)
                } else {
                    // Fare items
                    ForEach(fairSummaryData.indices, id: \.self) { index in
                        let fareItem = fairSummaryData[index]
                        HStack(alignment: .center, spacing: 8) {
                            Text(fareItem.title)
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#5A5A5A"))
                            Spacer()
                            Text(fareItem.value)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(fareItem.isDiscount ? .green : .gray)
                        }
                        .padding(.bottom, 12)
                    }
                }

                // Divider before total
                Divider()
                    .background(Color(hex: "#E0E0E0"))
                    .padding(.bottom, 14)

                // Total Amount Paid
                HStack(alignment: .center, spacing: 8) {
                    Text(totalLableText)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(hex: "#2C3E50"))
                    Spacer()
                    Text(" \(totalPrice)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "#2C3E50"))
                }
                .padding(.bottom, 10)

                // Prices inclusive of taxes
                Text("Prices inclusive of taxes")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#95A5A6"))
                    .padding(.bottom, 14)
            }
            .padding(.horizontal, 14)
            .background(Color.white)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// Helper extension already uses RoundedCorner which is defined in ExperienceHome/Components/RoundedCorner.swift
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
