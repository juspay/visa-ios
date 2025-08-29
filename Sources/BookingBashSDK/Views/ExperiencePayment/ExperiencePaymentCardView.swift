//
//  ExperiencePaymentCardView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import SwiftUI

struct ExperiencePaymentCardView: View {
    @StateObject private var viewModel = ExperiencePaymentViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Spacer()
                Image(Constants.Icons.logoVisa)
                    .resizable()
                    .frame(width: 65, height: 20)
                    .foregroundStyle(Color(hex: Constants.HexColors.primaryStrong))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(Constants.ExperiencePaymentConstants.cardNumber)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                Text(viewModel.card.cardNumber)
                    .font(.custom(Constants.Font.openSansBold, size: 22))
                    .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(Constants.ExperiencePaymentConstants.cardHolderName)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    Text(viewModel.card.cardHolderName)
                        .font(.custom(Constants.Font.openSansBold, size: 16))
                        .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(Constants.ExperiencePaymentConstants.expiryDate)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    Text(viewModel.card.expiryDate)
                        .font(.custom(Constants.Font.openSansBold, size: 16))
                        .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 2) {
                    Text(Constants.ExperiencePaymentConstants.cvv)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    Text(Constants.ExperiencePaymentConstants.mandatory)
                        .foregroundStyle(Color(hex: Constants.HexColors.error))
                }
                
                TextField("", text: $viewModel.cvv)
                    .placeholder(when: viewModel.cvv.isEmpty) {
                        Text(Constants.ExperiencePaymentConstants.enterCVV)
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .frame(height: 40)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
                    )
                    .keyboardType(.numberPad)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding()
        .background(Color(hex: Constants.HexColors.surfaceWeakest))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
