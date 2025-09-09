//
//  ExperienceCardView.swift
//  VisaActivity
//
//  Created by Apple on 30/07/25.
//

import Foundation
import SwiftUI

struct ExperienceListCardView: View {
    let experience: ExperienceListModel
    
    @State private var showBanner = false
    @State private var isFavorite = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HStack(alignment: .top, spacing: 12) {
                GeometryReader { geo in
                    Image(experience.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: geo.size.height)
                        .clipped()
                        .clipShape(RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft]))
                }
                .frame(width: 120)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 2) {
                            Image(Constants.Icons.star)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(Color(hex: Constants.HexColors.primary))
                            
                            Text(String(format: "%.1f", experience.rating))
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.primary))
                            
                            Text("(\(experience.reviewCount))")
                                .font(.custom(Constants.Font.openSansRegular, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.primary))
                        }
                        
                        Text(experience.title)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    HStack(spacing: 4) {
                        Text("\(Constants.ExperienceListConstants.aed) \(experience.price)")
                            .font(.custom(Constants.Font.openSansBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        
                        Text(Constants.ExperienceListConstants.perPerson)
                            .font(.custom(Constants.Font.openSansRegular, size: 10))
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        
                        Spacer()
                        
                        Button(action: {
                            isFavorite.toggle()
                            showBanner = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showBanner = false
                            }
                        }) {
                            Image(isFavorite
                                  ? Constants.Icons.wishlistFill
                                  : Constants.Icons.wishlist)
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(Color(hex: Constants.HexColors.primaryStrong))
                        }
                    }
                }
                .padding(.vertical, 12)
                .padding(.trailing, 6)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 2)
            )
            .background(Color.white)
            .cornerRadius(8)
            
            if showBanner && isFavorite {
                HStack(spacing: 6) {
                    Image(Constants.Icons.check)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.green)
                    
                    Text(Constants.ExperienceListConstants.addedInFavorites)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(.green)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 2)
                )
                .cornerRadius(4)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .offset(x: 0, y: 24)
                .transition(.opacity)
                .zIndex(1000)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showBanner)
    }
}
