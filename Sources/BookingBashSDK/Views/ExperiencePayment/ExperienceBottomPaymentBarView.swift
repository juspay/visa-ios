//
//  BottomPaymentBarView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct ExperienceBottomPaymentBarView: View {
    let buttonText: String
    let payNowButtonTapped: (() -> Void)
    let infoButtontapped: () -> Void
    let price : String
    
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
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Constants.ExperiencePaymentConstants.total)
                        .font(.custom(Constants.Font.openSansRegular, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    
                    HStack(spacing: 4) {
                        Text("\(Constants.ExperiencePaymentConstants.aed) \(price)")
                            .font(.custom(Constants.Font.openSansBold, size: 16))
                            .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                        
                        Image(Constants.Icons.info)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                            .onTapGesture {
                                infoButtontapped()
                            }
                    }
                }
                Spacer()
                Button(action: {
                    payNowButtonTapped()
                }) {
                    Text(buttonText)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(.white)
                        .frame(width: 140 ,height: 42)
                        .background(Color(hex: Constants.HexColors.primary))
                        .cornerRadius(4)
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
       
    }
}


