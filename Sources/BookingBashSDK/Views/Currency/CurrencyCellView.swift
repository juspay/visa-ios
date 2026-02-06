//
//  CurrencyCellView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 28/11/25.
//

import SwiftUI

struct CurrencyCellView: View {
    var countryDetail: CurrencyDataModel
    var isSelected: Bool
    var onSelection: (CurrencyDataModel) -> Void

    var body: some View {
        HStack(spacing: 8) {
            if let radio = ImageLoader.bundleImage(
                named: isSelected
                ? Constants.Icons.radioButtonChecked
                : Constants.Icons.radioButtonUnchecked
            ) {
                radio
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(
                        isSelected
                        ? Color(hex: Constants.HexColors.primary)
                        : Color(hex: Constants.HexColors.neutral)
                    )
            }

            HStack(spacing: 0) {
                Text(countryDetail.code ?? "")
                    .font(.custom(Constants.Font.openSansBold, size: 14))
                Text("-")
                    .font(.custom(Constants.Font.openSansRegular, size: 14))
                Text(countryDetail.name ?? "")
                    .font(.custom(Constants.Font.openSansRegular, size: 14))
            }
            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))

            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onSelection(countryDetail)
        }
        .padding(.vertical, 12)
    }
}
