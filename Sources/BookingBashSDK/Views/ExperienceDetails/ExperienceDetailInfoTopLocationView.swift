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
            
            HStack(spacing: 2) {
                Image(Constants.Icons.map)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color.white)
                Text(location)
                    .foregroundStyle(Color.white)
                    .font(.custom(Constants.Font.openSansRegular, size: 12))
            }
        }
    }
}
