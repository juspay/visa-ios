//
//  SavedTravelerCardView.swift
//  VisaActivity
//
//  Created by Apple on 04/09/25.
//

import SwiftUI

struct SavedTravelerCardView: View {
    let traveler: SavedTravelerModel
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        Text(traveler.name)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "envelope")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        Text(traveler.email)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "phone")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        Text(traveler.phone)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    }
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
                .background(Color.white)
        )
    }
}