//
//  InfoDetailView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct InfoDetailView: View {
    let section: InfoDetailModel
    let showBullets: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(section.title)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                .padding(.bottom, 4)
                .onAppear {
                    print("DEBUG UI: Displaying section '\(section.title)' with \(section.items.count) items")
                    for (index, item) in section.items.enumerated() {
                        print("DEBUG UI: Item \(index): '\(item)'")
                    }
                }
            if(!section.shortDesciption.isEmpty) {
                Text(section.shortDesciption)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    .foregroundStyle(.black)
            }

            ForEach(section.items, id: \.self) { item in
                VStack {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        if showBullets {
                            Text(Constants.BookingStatusScreenConstants.dot)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                                .padding(.leading, 6)
                        }
                        Text(item)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                }
                
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
