//
//  DestinationCardView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import SwiftUI

struct DestinationCardView: View {
    
    let destination: Destination
    var itemWidth: CGFloat = 140
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: destination.imageURL ?? "")) { phase in
                switch phase {
                case .empty:
                    // Placeholder while loading
                    ProgressView()
                        .frame(width: itemWidth, height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: itemWidth, height: 200)
                        .clipped()
                case .failure:
                    // Fallback image if network fails
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: itemWidth, height: 200)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .center
                )
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(8),
                alignment: .bottom
            )
            
            Text(destination.name)
                .font(.custom(Constants.Font.openSansBold, size: 16))
                .foregroundStyle(Color.white)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}
