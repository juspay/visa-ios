//
//  CheckoutInfoListView.swift
//  VisaActivity
//
//  Created by AI Assistant
//

import Foundation
import SwiftUI
import SUINavigation

struct CheckoutInfoListView: View {
    @ObservedObject var viewModel: ExperienceCheckoutViewModel
    @State private var isRowSelected: Bool = false
    @State private var selectedInfoType: CheckoutInfoType?
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(infoItems.enumerated()), id: \.element.title) { index, item in
                InfoRowView(title: item.title)
                    .onTapGesture {
                        isRowSelected = true
                        selectedInfoType = item.type
                    }
                
                if index != infoItems.count - 1 {
                    SeparatorLine()
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                }
            }
        }
        .navigation(isActive: $isRowSelected, id: "checkout_info_screen") {
            destinationView(for: selectedInfoType)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
        .background(Color.white)
    }
    
    private var infoItems: [CheckoutInfoItem] {
        var items: [CheckoutInfoItem] = []
        
        // Add highlights if available
        if let highlightsData = viewModel.highlights.first, !highlightsData.items.isEmpty {
            items.append(CheckoutInfoItem(title: "Highlights", type: .highlights))
        }
        
        // Add inclusions if available
        if let inclusionsData = viewModel.inclusions.first, !inclusionsData.items.isEmpty {
            items.append(CheckoutInfoItem(title: "What's Included", type: .included))
        }
        
        // Add exclusions if available
        if let exclusionsData = viewModel.exclusions.first, !exclusionsData.items.isEmpty {
            items.append(CheckoutInfoItem(title: "What's Not Included", type: .excluded))
        }
        
        // Add cancellation policy if available
        if let cancellationData = viewModel.cancellationPolicyData.first, !cancellationData.items.isEmpty {
            items.append(CheckoutInfoItem(title: "Cancellation Policy", type: .cancellation))
        }
        
        // Add know before you go if available
        if let knowBeforeGoData = viewModel.knowBeforeGo.first, !knowBeforeGoData.items.isEmpty {
            items.append(CheckoutInfoItem(title: "Know Before You Go", type: .knowBeforeGo))
        }
        
        // Add duration if available
        if !viewModel.duration.isEmpty {
            items.append(CheckoutInfoItem(title: "Duration", type: .duration))
        }
        
        // Add meeting point if available
        if !viewModel.meetingPoint.isEmpty {
            items.append(CheckoutInfoItem(title: "Meeting Point", type: .meetingPoint))
        }
        
        return items
    }
    
    private func destinationView(for type: CheckoutInfoType?) -> AnyView {
        let experienceName = viewModel.experienceTitle
        
        switch type {
        case .highlights:
            return AnyView(CheckoutInfoDetailView(
                title: "Highlights",
                items: viewModel.highlights.first?.items ?? [],
                showBullets: true,
                experienceName: experienceName
            ))
        case .included:
            return AnyView(CheckoutInfoDetailView(
                title: "What's Included",
                items: viewModel.inclusions.first?.items ?? [],
                showBullets: true,
                experienceName: experienceName
            ))
        case .excluded:
            return AnyView(CheckoutInfoDetailView(
                title: "What's Not Included",
                items: viewModel.exclusions.first?.items ?? [],
                showBullets: true,
                experienceName: experienceName
            ))
        case .cancellation:
            return AnyView(CheckoutInfoDetailView(
                title: "Cancellation Policy",
                items: viewModel.cancellationPolicyData.first?.items ?? [],
                showBullets: false,
                experienceName: experienceName
            ))
        case .knowBeforeGo:
            return AnyView(CheckoutInfoDetailView(
                title: "Know Before You Go",
                items: viewModel.knowBeforeGo.first?.items ?? [],
                showBullets: true,
                experienceName: experienceName
            ))
        case .duration:
            return AnyView(CheckoutInfoDetailView(
                title: "Duration",
                items: [viewModel.duration].filter { !$0.isEmpty },
                showBullets: false,
                experienceName: experienceName
            ))
        case .meetingPoint:
            return AnyView(CheckoutInfoDetailView(
                title: "Meeting Point",
                items: [viewModel.meetingPoint].filter { !$0.isEmpty },
                showBullets: false,
                experienceName: experienceName
            ))
        case .none:
            return AnyView(EmptyView())
        }
    }
}

// MARK: - Supporting Types
enum CheckoutInfoType {
    case highlights
    case included
    case excluded
    case cancellation
    case duration
    case meetingPoint
    case knowBeforeGo
}

struct CheckoutInfoItem {
    let title: String
    let type: CheckoutInfoType
}
