//
//  InfoListView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI
import SUINavigation

struct InfoListView: View {
    @ObservedObject var viewModel: ExperienceDetailViewModel
    @State private var isRowSelected: Bool = false
    @State private var selectedValue: InfoType?
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                InfoRowView(title: item.title)
                    .onTapGesture {
                        isRowSelected = true
                        selectedValue = item.type
                    }
                
                if index != viewModel.items.count - 1 {
                    SeparatorLine()
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
            }
        }
        .navigation(isActive: $isRowSelected, id: Constants.NavigationId.infoScreen) {
            destinationView(for: selectedValue )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
        .background(Color.white)
    }
    
    @ViewBuilder
    private func destinationView(for type: InfoType?) -> some View {
        let experienceName = viewModel.experienceDetail?.title ?? ""
        switch type {
        case .highlights:
            InfoDetailListView(sections: viewModel.highlights, showBullets: true, experienceName: experienceName)
        case .included:
            InfoDetailListView(sections: viewModel.inclusions, showBullets: true, experienceName: experienceName)
        case .excluded:
            InfoDetailListView(sections: viewModel.exclusions, showBullets: true, experienceName: experienceName)
        case .cancellation:
            InfoDetailListView(sections: viewModel.cancellationPolicyData, showBullets: false, experienceName: experienceName)
        case .where_:
            Text("Where View")
        case .reviews:
            ReviewListView(viewModel: viewModel)
        case .photos:
            TravellerPhotosGridView(viewModel: viewModel)
        case .none:
            EmptyView()
        case .know_before_you_go:
            InfoDetailListView(sections: viewModel.knowBeforeYouGoData, showBullets: false, experienceName: experienceName)
        }
    }
}
