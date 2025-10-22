//
//  ExperienceDetailInfoTopLocationView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import SwiftUI

struct ExperienceDetailInfoTopLocationView: View {
    let title: String
    let location: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom(Constants.Font.openSansBold, size: 18))
                .foregroundStyle(.white)
            
            HStack(spacing: 8) {
                if let mapImage = ImageLoader.bundleImage(named: Constants.Icons.map) {
                    mapImage
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.white)
                }
                
                Text(location)
                    .font(.custom(Constants.Font.openSansRegular, size: 12))
                    .foregroundStyle(.white)
            }
        }
    }
}
