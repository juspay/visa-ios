//
//  ContactDetailsView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct ContactDetailsCardView: View {
    let contactDetailsModel: [ContactDetailsModel]
    let title: String
    var body: some View {
        VStack(alignment:.leading, spacing: 8) {
            Text(title)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            VStack(alignment: .leading, spacing: 6) {
                ForEach(contactDetailsModel) { item in
                    HStack(spacing: 4) {
                        if let icon = ImageLoader.bundleImage(named: item.keyIcon) {
                            icon
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        } else {
                            Image(item.keyIcon)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        }
                        Text(item.value)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
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
