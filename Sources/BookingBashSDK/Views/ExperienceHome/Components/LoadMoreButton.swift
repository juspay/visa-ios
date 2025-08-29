//
//  LoadMoreButton.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SwiftUI

struct LoadMoreButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(Constants.HomeScreenConstants.loadMore)
                .font(.custom(Constants.Font.openSansBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.primary))
                .frame(height: 42)
                .frame(maxWidth: .infinity)
                .background(Color(hex: Constants.HexColors.bgPremierWeak))
                .cornerRadius(4)
        }
        .padding(.top, 8)
        .padding(.horizontal, 15)
    }
}
