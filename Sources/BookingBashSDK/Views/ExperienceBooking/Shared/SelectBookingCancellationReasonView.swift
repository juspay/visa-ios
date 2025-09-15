//
//  SelectBookingCancellationReasonView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct SelectBookingCancellationReasonView: View {
    @ObservedObject var viewModel: ExperienceBookingConfirmationViewModel
    @Binding var cancellationSheetState: CancellationSheetState
    @Binding var navigateToCancellationView: Bool
    let orderNo: String // Added orderNo parameter
    
    var body: some View {
        VStack(spacing: 0) {
            RadioOptionsListView(
                title: Constants.BookingStatusScreenConstants.selectCancellationReason,
                options: viewModel.reasons,
                selectedOption: viewModel.selectedReason,
                onSelect: { viewModel.selectedReason = $0 },
                titleKeyPath: \.title
            )

            Button(action: {
                print("\(Constants.BookingStatusScreenConstants.selectedReason) \(String(describing: viewModel.selectedReason?.title))")
                guard let reasonCode = viewModel.selectedReason?.code else { return }
                // Extract orderNo from bookingBasicDetails as in CancelBookingBottomSheetView
                let orderNoToUse = viewModel.bookingBasicDetails.first(where: { $0.key == "Booking ID" })?.value ?? orderNo
                
                
                viewModel.cancelBooking(orderNoo: orderNoToUse, siteId: "68b585760e65320801973737", reasonCode: reasonCode) { success in
                    if success {
                        navigateToCancellationView = true
                    }
                }
            }) {
                Text(Constants.SharedConstants.next)
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color(hex: Constants.HexColors.primary))
                    .cornerRadius(6)
            }
            .padding(.horizontal, 16)
            .padding(.top, 32)
            .disabled(viewModel.selectedReason == nil)
            .opacity(viewModel.selectedReason == nil ? 0.5 : 1.0)
        }
    }
}
