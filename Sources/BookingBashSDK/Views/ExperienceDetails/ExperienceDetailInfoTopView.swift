//
//  ExperienceDetailInfoTopView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct ExperienceDetailInfoTopView: View {
    let model: ExperienceDetailModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(model.category)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color.white)
                Spacer()
                HStack(spacing: 2) {
                    if let starImage = bundleImage(named: Constants.Icons.star) {
                        starImage
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    }
                    
                    Text(String(format: "%.1f", model.rating))
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    Text("(\(model.reviewCount))")
                        .foregroundStyle(Color.white)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                }
            }
            ExperienceDetailInfoTopLocationView(title: model.title, location: model.location)
        }
        .background(Color(hex: Constants.HexColors.secondary))
    }
        
}
