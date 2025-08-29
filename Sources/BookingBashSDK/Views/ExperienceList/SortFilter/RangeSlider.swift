//
//  RangeSlider.swift
//  VisaActivity
//
//  Created by Apple on 31/07/25.
//

import Foundation
import SwiftUI

struct RangeSlider: View {
    @Binding var minValue: Double
    @Binding var maxValue: Double

    var minLimit: Double
    var maxLimit: Double

    @State private var isMinSliderAbove = false
    @State private var isMaxSliderAbove = false

    var body: some View {
        GeometryReader { geometry in
            let totalRange = maxLimit - minLimit
            let sliderWidth = geometry.size.width
            let knobRadius: CGFloat = 12

            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 3)
                Rectangle()
                    .fill(Color(hex: Constants.HexColors.neutral))
                    .frame(
                        width: CGFloat((maxValue - minValue) / totalRange) * sliderWidth,
                        height: 3
                    )
                    .offset(x: CGFloat((minValue - minLimit) / totalRange) * sliderWidth)

                Circle()
                    .fill(Color(hex: Constants.HexColors.primary))
                    .frame(width: 24, height: 24)
                    .offset(x: CGFloat((minValue - minLimit) / totalRange) * sliderWidth - knobRadius)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let percent = min(max(0, (value.location.x - knobRadius) / sliderWidth), 1)
                                let newMin = minLimit + percent * totalRange
                                minValue = min(newMin, maxValue - 1)
                            }
                            .onEnded { _ in
                                isMinSliderAbove = true
                                isMaxSliderAbove = false
                            }
                    )
                    .zIndex(isMinSliderAbove ? 1 : 0)
                Circle()
                    .fill(Color(hex: Constants.HexColors.primary))
                    .frame(width: 24, height: 24)
                    .offset(x: CGFloat((maxValue - minLimit) / totalRange) * sliderWidth - knobRadius)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let percent = min(max(0, (value.location.x - knobRadius) / sliderWidth), 1)
                                let newMax = minLimit + percent * totalRange
                                maxValue = max(newMax, minValue + 1)
                            }
                            .onEnded { _ in
                                isMinSliderAbove = false
                                isMaxSliderAbove = true
                            }
                    )
                    .zIndex(isMaxSliderAbove ? 1 : 0)
            }
        }
        .frame(height: 24)
    }
}
