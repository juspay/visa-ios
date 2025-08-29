//
//  SectionHeaderView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let showViewAll: Bool
    var viewAllAction: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(.custom(Constants.Font.openSansBold, size: 18))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            Spacer()
            if showViewAll {
                Text(Constants.HomeScreenConstants.viewAll)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    .onTapGesture {
                        viewAllAction?()
                    }
            }
        }
        .padding(.horizontal, 15)
    }
}
