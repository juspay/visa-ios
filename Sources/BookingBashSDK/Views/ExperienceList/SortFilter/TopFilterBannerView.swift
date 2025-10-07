//
//  TopFilterBannerView.swift
//  VisaActivity
//
//  Created by Apple on 31/07/25.
//

import SwiftUI

struct TopFilterBannerView: View {
    var body: some View {
        HStack(spacing: 16) {
            if let filtersImage = bundleImage(named: Constants.Icons.filters) {
                filtersImage
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.white)
            }
            
            Text("Filters")
                .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    TopFilterBannerView()
}
