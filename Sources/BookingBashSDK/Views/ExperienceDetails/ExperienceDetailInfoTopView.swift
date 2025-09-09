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
                HStack(spacing: 4) {
                    Image(Constants.Icons.star)
                        .frame(width: 14, height: 14)
                        .foregroundStyle(Color.white)
                    Text(String(format: "%.1f", model.rating))
                        .foregroundStyle(Color.white)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
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
