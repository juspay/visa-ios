//
//  TravellerPhotosExpandedView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct TravellerPhotosExpandedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(Constants.Icons.shrek)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 470)
                .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(index < 4
                              ? Constants.Icons.star
                              : Constants.Icons.starEmpty)
                            .foregroundStyle(.yellow)
                            .font(.system(size: 14))
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sophia")
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))

                    Text("19 Jun 2025")
                        .font(.custom(Constants.Font.openSansRegular, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
        }
        .background(Color.white)
        .padding(.horizontal)
    }
}

