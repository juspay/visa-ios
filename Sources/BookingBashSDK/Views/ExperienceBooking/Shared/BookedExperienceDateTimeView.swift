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
    let selectedDate: String
    let selectedParticipants: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                IconTextRow(
                    imageName: Constants.Icons.calendargray,
                    text: selectedDate,
                    color: color
                )
                Spacer()
                IconTextRow(
                    imageName: Constants.Icons.user,
                    text: selectedParticipants,
                    color: color
                )
            }
            if shouldShowRefundable {
                HStack(spacing: 6) {
                    
                    if let checkIcon = ImageLoader.bundleImage(named: Constants.Icons.check) {
                        checkIcon
                            .resizable()
                            .foregroundStyle(.green)
                            .frame(width: 20, height: 20)
                    }
                    Text(Constants.BookingStatusScreenConstants.refundable)
                        .foregroundStyle(.green)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                }
            }
        }
    }
}
