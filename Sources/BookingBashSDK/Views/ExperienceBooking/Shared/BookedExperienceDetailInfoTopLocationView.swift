//
//  BookedExperienceDetailInfoTopLocationView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct BookedExperienceDetailInfoTopLocationView: View {
    let title: String
    let location: String
    var titleTextColor: Color = .white
    var locationTextColor: Color = .white
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(titleTextColor)
                .lineLimit(nil) // Allows unlimited lines
                .fixedSize(horizontal: false, vertical: true)
            
            
            // Location hidden as per requirement
            // HStack(spacing: 2) {
            //
            //     if let mapIcon = ImageLoader.bundleImage(named: Constants.Icons.map) {
            //         mapIcon
            //             .resizable()
            //             .renderingMode(.template)
            //             .frame(width: 18, height: 18)
            //             .foregroundStyle(locationTextColor)
            //     }
            //     Text(location)
            //         .foregroundStyle(locationTextColor)
            //         .font(.custom(Constants.Font.openSansSemiBold, size: 12))
            // }
        }
    }
}
