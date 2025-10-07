//
//  FareSummaryCardView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct FareSummaryCardView: View {
    let fairSummaryData: [FareItem]
    var totalPrice : String
    var shouldShowTopBanner: Bool = true
    var totalLableText: String = Constants.BookingStatusScreenConstants.totalAmountPaid
    
    // Calculate discount amount from fairSummaryData for top banner
    private var discountAmount: String {
        if let discountItem = fairSummaryData.first(where: { $0.isDiscount }) {
            return discountItem.value.replacingOccurrences(of: "- ", with: "")
        }
        return "AED 0"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if(shouldShowTopBanner && !discountAmount.isEmpty && discountAmount != "AED 0") {
                FairTopBannerView(
                    iconName: Constants.Icons.saving,
                    text: String(format: Constants.BookingStatusScreenConstants.savingFormat, discountAmount),
                    gradientColors: [
                        Color(hex: Constants.HexColors.blueShade),
                        Color(hex: Constants.HexColors.blueShade),
                        Color(hex: Constants.HexColors.greenShade)
                    ]
                )
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(Constants.BookingStatusScreenConstants.fareSummary)
                    .font(.custom(Constants.Font.openSansBold, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                
                // Dynamically display fare items from fairSummaryData
                ForEach(fairSummaryData.indices, id: \.self) { index in
                    let fareItem = fairSummaryData[index]
                    FareItemRowView(
                        title: fareItem.title,
                        value: fareItem.value,
                        isDiscount: fareItem.isDiscount
                    )
                }
                
                SeparatorLine()
                
                HStack {
                    Text(totalLableText)
                    Spacer()
                    Text(totalPrice.isEmpty ? "AED 0" : totalPrice)
                }
                .font(.custom(Constants.Font.openSansBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                
                Text(Constants.BookingStatusScreenConstants.pricesWithTaxes)
                    .font(.custom(Constants.Font.openSansRegular, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            }
            .padding()
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
    }
}
