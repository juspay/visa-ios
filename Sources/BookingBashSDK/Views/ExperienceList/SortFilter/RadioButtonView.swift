//
//  RadioButtonView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct RadioButtonView: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(isSelected
                      ? Constants.Icons.radioButtonChecked
                      : Constants.Icons.radioButtonUnchecked)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(
                        isSelected ? Color(hex: Constants.HexColors.primary) : Color(hex: Constants.HexColors.neutral)
                    )
                
                Text(title)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}
