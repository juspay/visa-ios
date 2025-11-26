//
//  FeatureGridView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct FeatureGridView: View {
    let features: [FeatureItem]
    @Binding var showAll: Bool

    private var leftColumn: [FeatureItem] {
        let mid = (features.count + 1) / 2
        return Array(features.prefix(mid))
    }

    private var rightColumn: [FeatureItem] {
        let mid = (features.count + 1) / 2
        return Array(features.suffix(from: mid))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Know before you go")
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            HStack(alignment: .top) {
                columnView(items: leftColumn)
                Spacer()
                columnView(items: rightColumn)
            }

            if features.count > 4 {
                Button(action: {
                    withAnimation {
                        showAll.toggle()
                    }
                }) {
                    Text(showAll ? Constants.SharedConstants.viewLess : Constants.SharedConstants.viewMore)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func columnView(items: [FeatureItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                if showAll || index < 2 {
                    FeatureRow(item: item)
                }
            }
        }
    }
}
