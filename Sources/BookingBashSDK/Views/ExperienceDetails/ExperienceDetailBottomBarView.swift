//
//  ExperienceDetailBottomBarView.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation
import SwiftUI

struct ExperienceDetailBottomBarView: View {
    @ObservedObject var viewModel: ExperienceDetailViewModel
    var onCheckAvailabilityButtonTapped: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Constants.DetailScreenConstants.startingFrom)
                        .font(.custom(Constants.Font.openSansRegular, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    HStack(spacing: 2) {
                        Text(viewModel.price)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                        Text(Constants.DetailScreenConstants.perPerson)
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    
                    onCheckAvailabilityButtonTapped?()
                }) {
                    Text(viewModel.buttonText)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .frame(height: 42)
                        .background(Color(hex: Constants.HexColors.primary))
                        .cornerRadius(4)
                }
            }
            .padding(15)
        }
        .background(Color.white)
    }
}
