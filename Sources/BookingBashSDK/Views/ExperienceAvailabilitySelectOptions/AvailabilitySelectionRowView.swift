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
                Image(iconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)

                Text(title)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.surfaceWeakest))

                Spacer()

                Text(value)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.surfaceWeakest))

                Image(Constants.Icons.arrowRight)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
            }
            .padding(16)
        }
    }
}
