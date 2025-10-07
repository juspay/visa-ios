//
//  AvailabilitySelectionRowView.swift
//  VisaActivity
//
//  Created by Apple on 07/08/25.
//

import Foundation
import SwiftUI

struct AvailabilitySelectionRowView: View {
    let iconName: String
    let title: String
    let value: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 4) {
                if let icon = bundleImage(named: iconName) {
                    icon
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                } else {
                    Image(iconName)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }

                Text(title)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.surfaceWeakest))

                Spacer()

                Text(value)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.surfaceWeakest))

                if let arrowImage = bundleImage(named: Constants.Icons.arrowRight) {
                    arrowImage
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
            }
            .padding(16)
        }
    }
}
