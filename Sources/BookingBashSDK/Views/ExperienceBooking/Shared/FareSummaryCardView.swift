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
    var shouldShowTopBanner: Bool = true
    var totalLableText: String = Constants.BookingStatusScreenConstants.totalAmountPaid
    
    var body: some View {
        VStack(spacing: 0) {
            if(shouldShowTopBanner) {
                FairTopBannerView(
                    iconName: Constants.Icons.saving,
                    text: String(format: Constants.BookingStatusScreenConstants.savingFormat, 5),
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
                
                ForEach(fairSummaryData) { data in
                    FareItemRowView(title: data.title, value: data.value, isDiscount: data.isDiscount)
                }
                
                SeparatorLine()
                
                HStack {
                    Text(totalLableText)
                    Spacer()
                    Text("\(Constants.BookingStatusScreenConstants.aed) 885")
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
