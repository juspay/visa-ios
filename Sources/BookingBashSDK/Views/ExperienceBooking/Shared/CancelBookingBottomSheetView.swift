//
//  CancelBookingBottomSheet.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct CancelBookingBottomSheetView: View {
    @ObservedObject var viewModel: ExperienceBookingConfirmationViewModel
    @Binding var cancellationSheetState: CancellationSheetState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Constants.BookingStatusScreenConstants.cancelBooking)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            SeparatorLine()
            
            HStack {
                Text(Constants.BookingStatusScreenConstants.amountPaid)
                Spacer()
                Text("\(Constants.BookingStatusScreenConstants.aed) \(viewModel.amountPaid)")
            }
            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            
            HStack {
                Text(Constants.BookingStatusScreenConstants.cancellationFee)
                Spacer()
                Text("\(Constants.BookingStatusScreenConstants.aed) \(viewModel.cancellationFee)")
            }
            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            
            SeparatorLine()
            
            HStack {
                Text(Constants.BookingStatusScreenConstants.totalRefunded)
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                Spacer()
                Text("\(Constants.BookingStatusScreenConstants.aed) \(viewModel.totalRefunded)")
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            }
            
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Constants.BookingStatusScreenConstants.refundAmount)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    Text(Constants.BookingStatusScreenConstants.refundText)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                }
                Spacer()
            }
            .padding(6)
            .background(Color(hex: Constants.HexColors.bgPremierWeak))
            .cornerRadius(8)
            
            Button(action: {
                viewModel.bookingStatus = .cancelled
                cancellationSheetState = .none
            }) {
                Text(Constants.BookingStatusScreenConstants.cancelNow)
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color(hex: Constants.HexColors.primary))
                    .cornerRadius(4)
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 16)
        .background(Color.white)
    }
}

