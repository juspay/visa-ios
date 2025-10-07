//
//  FairTopBannerView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct FairTopBannerView: View {
    let iconName: String
    let text: String
    let gradientColors: [Color]

    var body: some View {
        HStack(spacing: 8) {
            Spacer()
            if let icon = bundleImage(named: iconName) {
                icon
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
            } else {
                Image(iconName)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
            }

            Text(text)
                .foregroundStyle(.white)
                .font(.custom(Constants.Font.openSansBold, size: 14))
            Spacer()
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}
