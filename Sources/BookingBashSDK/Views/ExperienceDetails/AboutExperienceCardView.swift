//
//  AboutExperienceCardView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct AboutExperienceCardView: View {
    let aboutExperienceModel: AboutExperienceModel
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(aboutExperienceModel.title)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))

            Text(aboutExperienceModel.description)
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                .lineLimit(isExpanded ? nil : 3)

            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text(isExpanded ? Constants.SharedConstants.readLess : Constants.SharedConstants.readMore)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
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
