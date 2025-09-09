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
    let onFilterTapped: () -> Void

    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Image(Constants.Icons.filters)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    
                Text(String(format: Constants.ExperienceListConstants.experienceFound, count))
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            }
            .onTapGesture {
                onFilterTapped()
            }
            Spacer()
            HStack(spacing: 0){
                Text(Constants.DetailScreenConstants.sort)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                Image(Constants.Icons.arrowDown)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
            }
            .onTapGesture {
                onSortTapped()
            }
        }
    }
}
