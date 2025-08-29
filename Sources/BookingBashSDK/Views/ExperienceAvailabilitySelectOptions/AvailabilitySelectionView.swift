//
//  AvailabilitySelectionView.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation
import SwiftUI

struct AvailabilitySelectionView: View {
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel
    let onDateTap: () -> Void
    let onParticipantsTap: () -> Void
    
    var productCode: String?
    var currency: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(Constants.AvailabilityScreenConstants.availability)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(.white)

            Text(Constants.AvailabilityScreenConstants.select)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.surfaceWeakest))
                .padding(.bottom, -6)

            VStack(spacing: 0) {
                AvailabilitySelectionRowView(
                    iconName: Constants.Icons.calendar,
                    title: Constants.AvailabilityScreenConstants.date,
                    value: viewModel.selectedDate,
                    onTap: onDateTap
                )

                SeparatorLine(color: Color(hex: Constants.HexColors.neutral))
                    .padding(.horizontal)

                AvailabilitySelectionRowView(
                    iconName: Constants.Icons.user,
                    title: Constants.AvailabilityScreenConstants.participants,
                    value: viewModel.participants,
                    onTap: onParticipantsTap
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: Constants.HexColors.neutral), lineWidth: 1)
            )
        }
        .background(Color.clear)
        .onAppear {
            viewModel
                .fetchAvailabilities(
                    productCode: productCode ?? "",
                    currencyCode: currency ?? ""
                )
        }
    }
}
