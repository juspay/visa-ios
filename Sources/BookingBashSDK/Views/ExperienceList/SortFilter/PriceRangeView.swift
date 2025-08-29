//
//  PriceRangeView.swift
//  VisaActivity
//
//  Created by Apple on 31/07/25.
//

import SwiftUI

struct PriceRangeView: View {
    @Binding var minPrice: Double
    @Binding var maxPrice: Double
    
    var minLimit: Double
    var maxLimit: Double

    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 14) {
                Text(Constants.ExperienceListConstants.pricePerPerson)
                    .font(.custom(Constants.Font.openSansBold, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                HStack {
                    priceBox(title: Constants.ExperienceListConstants.min,
                             value: "\(Constants.ExperienceListConstants.aed) \(Int(minPrice))"
                    )
                    Spacer()
                    priceBox(title: Constants.ExperienceListConstants.min,
                             value: "\(Constants.ExperienceListConstants.aed) \(Int(maxPrice))"
                    )
                }
            }
            RangeSlider(minValue: $minPrice, maxValue: $maxPrice, minLimit: minLimit, maxLimit: maxLimit)
                .padding(.horizontal, 15)
        }
    }

    private func priceBox(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.custom(Constants.Font.openSansRegular, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))

            Text(value)
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
        }
        .frame(width: 90)
        .padding(.leading, -10)
        .padding(.vertical, 4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
    }
}

