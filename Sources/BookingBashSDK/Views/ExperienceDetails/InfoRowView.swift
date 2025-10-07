//
//  InfoRowView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct InfoRowView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))

            Spacer()

            if let arrowImage = bundleImage(named: Constants.Icons.arrowRight) {
                arrowImage
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            }
        }
        .padding()
        .background(Color.white)
    }
}
