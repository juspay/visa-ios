//
//  BackToHomeButtonView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import SwiftUI

struct BackToHomeButtonView: View {
    let onCheckAvailabilityButtonTapped: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.18), Color.clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(height: 6)
                .zIndex(1)
            Divider()
            Button(action: {
                onCheckAvailabilityButtonTapped?()
            }) {
                Text(Constants.BookingStatusScreenConstants.backToHome)
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color(hex: Constants.HexColors.primary))
                    .cornerRadius(4)
            }
            .padding()
        }
        .background(Color.white)
    }
}
