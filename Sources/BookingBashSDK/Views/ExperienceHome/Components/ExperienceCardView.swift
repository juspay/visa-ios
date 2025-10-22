//
//  ExperienceCardView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import SwiftUI

struct ExperienceCardView: View {
    let experience: Experience
    var cardHeight: CGFloat = 230
    var cardWidth: CGFloat = 400
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geometry in
                AsyncImage(url: URL(string: experience.imageURL)) { image in
                    image
                        .resizable()
                        .frame(width: geometry.size.width)
                        .frame(height: 250)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: geometry.size.width)
                        .frame(height: 250)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        )
                }
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

                    Text(experience.title)
                        .font(.custom(Constants.Font.openSansBold, size: 14))
                        .foregroundStyle(Color.white)
                        .font(.headline)
                        .lineLimit(1)
                }
                
                VStack(alignment: .leading) {
                    Text("Starting from \(experience.finalPrice) /Person")
                        .font(.custom(Constants.Font.openSansBold, size: 14))
                        .foregroundStyle(Color.white)
                        .font(.body)
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
