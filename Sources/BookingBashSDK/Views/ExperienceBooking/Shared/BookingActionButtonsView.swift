//
//  BookingActionButtonsView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct ActionButton: View {
    let title: String
    let buttontapped: (() -> Void)?

    var body: some View {
        Button(action: {
            buttontapped?()
        }) {
            Text(title)
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.primary))
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(hex: Constants.HexColors.primary), lineWidth: 1)
                )
        }
    }
}

