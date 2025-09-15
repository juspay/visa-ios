//
//  ExperienceTopHeaderView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import SwiftUI

struct ExperienceDetailsTopHeaderView: View {
    var body: some View {
        HStack(spacing: 8) {
            Spacer()
            Button(action: {
                
            }) {
                if let wishlistImage = bundleImage(named: Constants.Icons.wishlist) {
                    wishlistImage
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
            }
            
            Button(action: {
                
            }) {
                if let shareImage = bundleImage(named: Constants.Icons.Share) {
                    shareImage
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    ExperienceDetailsTopHeaderView()
}
