//
//  ProfileInfoCardView.swift
//  VisaActivity
//
//  Created by Apple on 04/09/25.
//

import SwiftUI

struct ProfileInfoCardView: View {
    let profile: ProfileModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                Text(profile.name)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            }
            
            HStack(spacing: 8) {
                Image(systemName: "envelope")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                Text(profile.email)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            }
            
//            HStack(spacing: 8) {
//                Image(systemName: "phone")
//                    .resizable()
//                    .frame(width: 20, height: 20)
//                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
//                Text(profile.phone)
//                    .font(.custom(Constants.Font.openSansSemiBold, size: 14))
//                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
//            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: Constants.HexColors.surfaceWeakest))
        )
    }
}
