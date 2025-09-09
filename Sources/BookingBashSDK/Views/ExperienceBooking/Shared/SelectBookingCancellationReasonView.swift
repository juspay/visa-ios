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
                cancellationSheetState = .confirm
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

