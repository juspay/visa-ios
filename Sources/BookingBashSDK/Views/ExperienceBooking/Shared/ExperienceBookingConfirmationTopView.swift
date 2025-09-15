//
//  ExperienceBookingConfirmationTopView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import SwiftUI

struct ExperienceBookingConfirmationTopView: View {
    
    let bookingInfo: BookingConfirmationTopInfoModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                if let icon = bundleImage(named: bookingInfo.image) {
                    icon
                        .resizable()
                        .frame(width: 40, height: 40)
                } else {
                    Image(bookingInfo.image)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                
                Text(bookingInfo.bookingStatus)
                    .font(.custom(Constants.Font.openSansBold, size: 16))
                    .foregroundStyle(Color(hex: Constants.HexColors.surfaceWeakest))
                    .multilineTextAlignment(.center)
                Text(bookingInfo.bookingMessage)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.surfaceWeakest))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        
    }
}
