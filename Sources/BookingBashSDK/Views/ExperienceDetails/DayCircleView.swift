//
//  DayCircleView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct DayCircleView: View {
    let day: String
    let isHighlighted: Bool

    var body: some View {
        Text(day)
            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .fill(isHighlighted ? Color(hex: Constants.HexColors.bgPremierWeak) : Color(hex: Constants.HexColors.surfaceWeakest))
            )
            .overlay(
                Circle()
                    .stroke(isHighlighted ? Color(hex:Constants.HexColors.primary) : Color.clear, lineWidth: 1)
            )
    }
}

