//
//  FilterSectionView.swift
//  VisaActivity
//
//  Created by Apple on 31/07/25.
//

import Foundation
import SwiftUI

struct FilterSectionView: View {
    @ObservedObject var viewModel: FilterViewModel
    
    let title: String
    let options: [FilterOption]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            ForEach(options) { option in
                Button(action: {
                    viewModel.toggleOption(option.id)
                }) {
                    HStack {
                        if let checkboxImage = bundleImage(named: viewModel.isSelected(option.id)
                              ? Constants.Icons.checkBoxFilled
                              : Constants.Icons.checkBox) {
                            checkboxImage
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(viewModel.isSelected(
                                    option.id) ? Color(hex: Constants.HexColors.primary) : Color(hex: Constants.HexColors.neutral))
                        }
                        
                        Text(option.label)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                        
                        Spacer()
                    }
                }
            }
        }
    }
}
