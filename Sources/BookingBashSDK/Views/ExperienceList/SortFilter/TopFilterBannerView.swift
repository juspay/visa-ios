//
//  TopFilterBannerView.swift
//  VisaActivity
//
//  Created by Apple on 31/07/25.
//

import SwiftUI

struct TopFilterBannerView: View {
    var body: some View {
        HStack(spacing: 4){
            Image(Constants.Icons.filters)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
            Text(Constants.ExperienceListConstants.filters)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(.white)
            Spacer()
        }
    }
}

#Preview {
    TopFilterBannerView()
}
