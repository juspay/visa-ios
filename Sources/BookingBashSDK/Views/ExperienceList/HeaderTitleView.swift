//
//  HeaderTitleView.swift
//  VisaActivity
//
//  Created by Apple on 30/07/25.
//

import Foundation
import SwiftUI

struct HeaderTitleView: View {
    var body: some View {
        HStack {
            Text(Constants.ExperienceListConstants.exploreExperiencesNear)
                .font(.custom(Constants.Font.openSansBold, size: 18))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            Spacer()
        }
    }
}
