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
    @StateObject private var viewModel = SortViewModel()

    var body: some View {
        ScrollView {
            RadioOptionsListView(
                title: Constants.DetailScreenConstants.sort,
                options: viewModel.options,
                selectedOption: viewModel.selectedOption,
                onSelect: { viewModel.select($0) },
                titleKeyPath: \.title
            )
        }
        .introspect(.scrollView, on: .iOS(.v15...)) { scrollView in
            scrollView.bounces = false
        }
    }
}
