//
//  ExperienceCountSortView.swift
//  VisaActivity
//
//  Created by Apple on 30/07/25.
//

import Foundation
import SwiftUI

struct ExperienceCountSortView: View {
    let count: Int
    let onSortTapped: () -> Void

    var body: some View {
        HStack {
            Text(String(format: Constants.ExperienceListConstants.experienceFound, count))
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            
            Spacer()
            HStack(spacing: 0){
                Text(Constants.DetailScreenConstants.sort)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                if let arrowImage = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                    arrowImage
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                }
            }
            .onTapGesture {
                onSortTapped()
            }
        }
    }
}
