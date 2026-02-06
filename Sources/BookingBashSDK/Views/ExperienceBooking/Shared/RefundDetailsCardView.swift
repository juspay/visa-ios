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
    
    // Use preCancelBookingResponse if available (immediately after cancellation),
    // otherwise use bookingDetailsResponse (from My Transaction)
    private var preCancelData: CancelBookingDetails? {
        viewModel.preCancelbookingResponse?.data
    }
    
    private var cancelFee: CancelFee? {
        viewModel.bookingDetailsResponse?.data?.bookingDetails?.travellerInfo?.cancelFee
    }
    
    private var refundAmount: Double {
        preCancelData?.refundAmount ?? cancelFee?.refundAmount ?? 0.0
    }
    
    private var deductionAmount: Double {
        preCancelData?.cancellationFee ?? cancelFee?.activityCancellationFee ?? 0.0
    }
    
    private var totalRefundAmount: Double {
        preCancelData?.totalAmount ?? cancelFee?.totalAmount ?? 0.0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Constants.BookingStatusScreenConstants.refundDetails)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            
            HStack {
                Text(Constants.BookingStatusScreenConstants.refundAmount)
                Spacer()
                Text("\(viewModel.currency) \(refundAmount.commaSeparated())")
            }
            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            
            HStack {
                Text(Constants.BookingStatusScreenConstants.deduction)
                Spacer()
                Text("\(viewModel.currency) \(deductionAmount.commaSeparated())")
            }
            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            
            SeparatorLine()
            
            HStack {
                Text(Constants.BookingStatusScreenConstants.totalRefundProcessed)
                Spacer()
                Text("\(viewModel.currency) \(totalRefundAmount.commaSeparated())")
            }
            .font(.custom(Constants.Font.openSansBold, size: 12))
            .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            if let pgRefundAmount = cancelFee?.pgRefundAmount, let pgCurrency = cancelFee?.pgCurrency {
                refundNote(refundAmount: pgRefundAmount.commaSeparated(),
                           refundCurrency: pgCurrency)
            }
            
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
    }

    private func refundNote(refundAmount: String, refundCurrency: String) -> some View {
        VStack(alignment: .leading) {
            Text(Constants.BookingStatusScreenConstants.refundNote)
                .font(.custom(Constants.Font.openSansBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            HStack(alignment: .top, spacing: 8) {
                Text(String(format: Constants.BookingStatusScreenConstants.refundAmountText, refundCurrency, refundAmount))
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(Color(hex: Constants.HexColors.bgPremierWeak))
        .cornerRadius(8)
    }
}
