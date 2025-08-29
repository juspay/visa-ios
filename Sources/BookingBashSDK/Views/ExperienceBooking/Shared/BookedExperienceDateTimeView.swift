//
//  BookedExperienceDateTimeView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct BookedExperienceDateTimeView: View {
    let color: Color
    var shouldShowRefundable: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                IconTextRow(
                    imageName: Constants.Icons.calendar,
                    text: "Sat, 22 Jun 2025",
                    color: color
                )
                
                Spacer()
                
                IconTextRow(
                    imageName: Constants.Icons.user,
                    text: "2 Adults, 1 Child",
                    color: color
                )
            }
            
            IconTextRow(
                imageName:  Constants.Icons.clock,
                text: "08:00",
                color: color
            )
            
            if(shouldShowRefundable) {
                HStack(spacing: 6) {
                    Image(Constants.Icons.check)
                        .resizable()
                        .foregroundStyle(.green)
                        .frame(width: 20, height: 20)
                    Text(Constants.BookingStatusScreenConstants.refundable)
                        .foregroundStyle(.green)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                }
            }
        }
    }
}
