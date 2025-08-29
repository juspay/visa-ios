//
//  RefundDetailsCardView.swift
//  VisaActivity
//
//  Created by Apple on 07/08/25.
//

import Foundation
import SwiftUI

struct RefundDetailsCardView: View {
    @ObservedObject var viewModel: ExperienceBookingConfirmationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Constants.BookingStatusScreenConstants.refundDetails)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            
            HStack {
                Text(Constants.BookingStatusScreenConstants.refundProcessed)
                Spacer()
                Text("\(Constants.BookingStatusScreenConstants.aed) \(viewModel.amountPaid)")
            }
            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            
            HStack {
                Text(Constants.BookingStatusScreenConstants.deduction)
                Spacer()
                Text("\(Constants.BookingStatusScreenConstants.aed) \(viewModel.cancellationFee)")
            }
            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            
            SeparatorLine()
            
            HStack {
                Text(Constants.BookingStatusScreenConstants.totalRefundProcessed)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Text("\(Constants.BookingStatusScreenConstants.aed) \(viewModel.totalRefunded)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.black)
            }
            
            HStack(alignment: .top, spacing: 8) {
                Text(Constants.BookingStatusScreenConstants.refundText)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(Color(hex: Constants.HexColors.bgPremierWeak))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
    }
}

