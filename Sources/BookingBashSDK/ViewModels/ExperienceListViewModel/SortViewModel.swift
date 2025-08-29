//
//  SortViewModel.swift
//  VisaActivity
//
//  Created by Apple on 31/07/25.
//

import Foundation
import SwiftUI

class SortViewModel: ObservableObject {
    @Published var selectedOption: SortOption?

    let options: [SortOption] = [
        SortOption(title: "Recommended"),
        SortOption(title: "Price - Low to high"),
        SortOption(title: "Price - High to low"),
        SortOption(title: "Ratings - High to low")
    ]

    init() {
        selectedOption = options.first
    }

    func select(_ option: SortOption) {
        selectedOption = option
    }

    func isSelected(_ option: SortOption) -> Bool {
        selectedOption == option
    }
}
