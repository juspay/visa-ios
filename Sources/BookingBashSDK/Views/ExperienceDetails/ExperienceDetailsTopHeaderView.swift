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
                
            }, label: {
                Image(Constants.Icons.wishlist)
                    .resizable()
                    .foregroundStyle(Color.white)
                    .frame(width: 24, height: 24)
            })
            
            Button(action: {
                
            }, label: {
                Image(Constants.Icons.Share)
                    .resizable()
                    .foregroundStyle(Color.white)
                    .frame(width: 24, height: 24)
            })
        }
    }
}

#Preview {
    ExperienceDetailsTopHeaderView()
}
