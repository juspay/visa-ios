//
//  FilterSectionListView.swift
//  VisaActivity
//
//  Created by Apple on 31/07/25.
//

import Foundation
import SwiftUI

struct FilterSectionListView: View {
    @ObservedObject var viewModel: FilterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PriceRangeView(
                minPrice: $viewModel.minPrice,
                maxPrice: $viewModel.maxPrice,
                minLimit: viewModel.minLimit,
                maxLimit: viewModel.maxLimit
            )
            
            SeparatorLine()
            
            ForEach(Array(viewModel.filterGroups.enumerated()), id: \.element.id) { index, group in
                VStack(spacing: 26) {
                    FilterSectionView(
                        viewModel: viewModel,
                        title: group.title,
                        options: group.options
                    )
                    
                    if index < viewModel.filterGroups.count - 1 {
                        SeparatorLine()
                    }
                }
            }
        }
    }
}
