//
//  CurrencySectionListView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 28/11/25.
//

import SwiftUI

struct CurrencySectionListView: View {
    var countryData: [CurrencyDataModel]?
    var headerText: String?
    @Binding var selectedCurrency: CurrencyDataModel?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
//            if let headerText, !headerText.isEmpty {
//                Text(headerText)
//                    .font(.headline)
//            }

            if let list = countryData, !list.isEmpty {
                ForEach(list, id: \.code) { item in
                    CurrencyCellView(
                        countryDetail: item,
                        isSelected: selectedCurrency?.code == item.code
                    ) { selected in
                        selectedCurrency = selected
                    }
                    if item.code != list.last?.code {
                        SeparatorLine()
                    }
                }
            } else {
                NoResultsView(text: Constants.ErrorMessages.noMatchingCurrency)
                    .padding(.top, 100)
                    
            }
        }
        .padding()
        .background((countryData?.isEmpty ?? true) ? Color.clear : Color(hex: Constants.HexColors.surfaceWeakest))
        .cornerRadius(16, corners: .allCorners)
    }
}

#Preview {
    CurrencySectionListView( selectedCurrency: .constant(nil))
}
