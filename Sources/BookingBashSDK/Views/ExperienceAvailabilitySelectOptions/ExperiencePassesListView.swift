//
//  ExperiencePassesListView.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation
import SwiftUI

struct ExperiencePassesListView: View {
    @ObservedObject var viewModel: ExperienceAvailabilitySelectOptionsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(
                "\(viewModel.packages.count) \(Constants.AvailabilityScreenConstants.optionsAvailable)"
            )
            .font(.custom(Constants.Font.openSansBold, size: 14))
            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            
            if viewModel.packages.count == 0 { // to show empty package view
                Text("No packages available")
                    .font(.custom(Constants.Font.openSansRegular, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            } else {
                ForEach(viewModel.packages) { package in
                    ExperiencePassesCardView(package: package, viewModel: viewModel)
                }
            }
        }
        .padding()
    }
}
