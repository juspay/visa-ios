//
//  SortOptionsListView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct RadioOptionsListView<Option: Identifiable & Equatable>: View {
    let title: String
    let options: [Option]
    let selectedOption: Option?
    let onSelect: (Option) -> Void
    let titleKeyPath: KeyPath<Option, String>

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SortHeaderView(title: title)

            ForEach(options) { option in
                RadioButtonView(
                    title: option[keyPath: titleKeyPath],
                    isSelected: selectedOption == option,
                    onTap: {
                        onSelect(option)
                    }
                )
            }
        }
        .padding(.horizontal, 15)
    }
}

