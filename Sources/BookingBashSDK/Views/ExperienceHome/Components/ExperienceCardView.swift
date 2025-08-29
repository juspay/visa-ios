//
//  ExperienceCardView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import SwiftUI

struct ExperienceCardView: View {
    let experience: Experience
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geometry in
                Image(experience.imageName)
                    .resizable()
                    .frame(width: geometry.size.width)
                    .frame(height: 250)
                    .clipped()
            }
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.6),
                    Color.black.opacity(0.3),
                    Color.clear
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 130)
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text(experience.country)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(Color.white)
                        .font(.footnote)
                    
                    Text(experience.title)
                        .font(.custom(Constants.Font.openSansBold, size: 14))
                        .foregroundStyle(Color.white)
                        .font(.headline)
                        .lineLimit(1)
                }
                
                VStack(alignment: .leading) {
                    HStack(spacing: 8) {
                        Text("\(Constants.HomeScreenConstants.aed) \(experience.originalPrice)")
                            .strikethrough()
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                        
                        Text(String(format: Constants.HomeScreenConstants.youSave, experience.discount))
                            .font(.custom(Constants.Font.openSansBold, size: 12))
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                    }
                    
                    HStack(spacing: 4) {
                        Text("\(Constants.HomeScreenConstants.aed) \(experience.finalPrice)")
                            .font(.custom(Constants.Font.openSansBold, size: 14))
                            .foregroundStyle(Color.white)
                            .font(.body)
                        
                        Text(Constants.HomeScreenConstants.perPersonText)
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                            .foregroundStyle(Color.white)
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .frame(height: 250)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
