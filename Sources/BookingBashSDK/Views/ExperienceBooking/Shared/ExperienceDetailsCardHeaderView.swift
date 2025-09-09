//
//  ExperienceDetailsCardHeaderView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import SwiftUI

struct ExperienceDetailsCardHeaderView: View {
    let images: [String]
    var body: some View {
        HStack {
            Text(Constants.BookingStatusScreenConstants.experienceDetails)
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            Spacer()
            HStack(spacing: 10) {
                ForEach(images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                }
            }
        }
    }
}


