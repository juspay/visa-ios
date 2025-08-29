//
//  ReviewCardView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct ReviewCardView: View {
    let review: ReviewsModel
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                HStack(spacing: 0) {
                    ForEach(0..<5) { index in
                        Image(index < review.rating ? Constants.Icons.star : Constants.Icons.starEmpty)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    }
                }
                
                Text(review.title)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            }
            
            Text(review.body)
                .lineLimit(isExpanded ? nil : 3)
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            
            Button(action: {
                isExpanded.toggle()
            }) {
                Text(isExpanded ? Constants.SharedConstants.readLess : Constants.SharedConstants.readMore)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
            }
            .padding(.top, -2)
            .buttonStyle(.plain)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(review.images, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 75, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(.trailing, -16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(review.userName)
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                
                
                Text(review.date)
                    .font(.custom(Constants.Font.openSansRegular, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}


