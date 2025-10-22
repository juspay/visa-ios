//
//  SortView.swift
//  VisaActivity
//
//  Created by Apple on 31/07/25.
//

import Foundation
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct SortView: View {
    @ObservedObject var viewModel: SortViewModel
    var onOptionSelected: (() -> Void)? = nil

    var body: some View {
        ScrollView {
            RadioOptionsListView(
                title: Constants.DetailScreenConstants.sort,
                options: viewModel.options,
                selectedOption: viewModel.selectedOption,
                onSelect: { option in
                    viewModel.select(option)
                    onOptionSelected?()
                },
                titleKeyPath: \.title
            )
        }
        .introspect(.scrollView, on: .iOS(.v15...)) { scrollView in
            scrollView.bounces = false
        }
    }
}

