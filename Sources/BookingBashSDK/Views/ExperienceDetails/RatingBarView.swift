//
//  RatingBarView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct RatingBarView: View {
    let rating: Int
    let progress: CGFloat
    let count: String

    var body: some View {
        HStack(spacing: 18) {
            HStack(spacing: 0) {
                ForEach(0..<5) { index in
                    Image(index < rating ? Constants.Icons.star : Constants.Icons.starEmpty)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.3))
                    Capsule().fill(Color(hex: Constants.HexColors.primary))
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 4)

            Text(count)
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                .frame(width: 34, alignment: .trailing)
        }
    }
}
