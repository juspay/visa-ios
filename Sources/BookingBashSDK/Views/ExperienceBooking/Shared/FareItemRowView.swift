//
//  FareItemRowView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct FareItemRowView: View {
    let title: String
    let value: String
    let isDiscount: Bool

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            Spacer()
            Text(value)
                .foregroundStyle(isDiscount ? Color.green : Color(hex: Constants.HexColors.neutral))
        }
        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
    }
}

