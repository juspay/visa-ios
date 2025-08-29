//
//  CalendarDayView.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation
import SwiftUI

struct CalendarDayView: View {
    let day: CalendarDay
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Group {
            if day.isInCurrentMonth {
                Button(action: {
                    if day.isSelectable {
                        onSelect()
                    }
                }) {
                    Text("\(Calendar.current.component(.day, from: day.date))")
                        .font(
                            day.isSelectable
                            ? (isSelected ? .custom(Constants.Font.openSansBold, size: 14) : .custom(Constants.Font.openSansRegular, size: 14))
                            : .custom(Constants.Font.openSansSemiBold, size: 14)
                        )
                        .foregroundStyle(
                            day.isSelectable
                            ? (isSelected ? .white : Color(hex: Constants.HexColors.blackStrong))
                            : Color(hex: Constants.HexColors.neutralWeak)
                        )
                        .frame(width: 34, height: 34)
                        .background(
                            isSelected ? Color(hex: Constants.HexColors.secondary) : Color.clear
                        )
                        .clipShape(Circle())
                }
                .disabled(!day.isSelectable)
            } else {
                Text("")
                    .frame(width: 34, height: 34)
            }
        }
    }
}
