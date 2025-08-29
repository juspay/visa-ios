//
//  PopularDaysCardView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct PopularDaysCardView: View {
    let title: String = Constants.DetailScreenConstants.MostPopularDays
    let days: [PopularDayModel]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))

            HStack() {
                ForEach(days) { day in
                    DayCircleView(day: day.title, isHighlighted: day.isHighlighted)
                        .frame(maxWidth: .infinity)
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
}
