//
//  ConfirmationInfoReusableCardView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct ConfirmationInfoReusableCardView: View {
    let section: ConfirmationReusableInfoModel
    let showBullets: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(section.title)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))

            ForEach(section.points, id: \.self) { item in
                VStack {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        if showBullets {
                            Text(Constants.BookingStatusScreenConstants.dot)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                                .padding(.leading, 6)
                        }
                        Text(item)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                }
                
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
    }
}
