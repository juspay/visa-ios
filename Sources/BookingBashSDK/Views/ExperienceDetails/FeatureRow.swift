//
//  FeatureRow.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct FeatureRow: View {
    let item: FeatureItem

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: item.iconName)
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            Text(item.title ?? "")
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
        }
    }
}
