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
    let checkInDate: String
    var body: some View
    {
        VStack(alignment: .leading, spacing: 8){
            HStack{
                IconTextRow( imageName: Constants.Icons.calendar, text: checkInDate, color: color )
                Spacer()
                
                IconTextRow( imageName: Constants.Icons.user, text: "1 Adult", color: color )
            }
            IconTextRow( imageName: Constants.Icons.clock, text: "08:00", color: color )
            if(shouldShowRefundable)
            { HStack(spacing: 6)
                { Image(Constants.Icons.check)
                        .resizable()
                        .foregroundStyle(.green)
                        .frame(width: 20, height: 20)
                    
                    Text(Constants.BookingStatusScreenConstants.refundable)
                        .foregroundStyle(.green)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12)) } } } } }
//struct BookedExperienceDateTimeView: View {
//    let color: Color
//    var shouldShowRefundable: Bool = true
//
//    let selectedDate: String
//    let selectedTime: String
//    let selectedParticipants: String
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                IconTextRow(
//                    imageName: Constants.Icons.calendar,
//                    text: selectedDate,
//                    color: color
//                )
//
//                Spacer()
//
//                IconTextRow(
//                    imageName: Constants.Icons.user,
//                    text: selectedParticipants,
//                    color: color
//                )
//            }
//
//            IconTextRow(
//                imageName: Constants.Icons.clock,
//                text: selectedTime,
//                color: color
//            )
//
//            if shouldShowRefundable {
//                HStack(spacing: 6) {
//                    Image(Constants.Icons.check)
//                        .resizable()
//                        .foregroundStyle(.green)
//                        .frame(width: 20, height: 20)
//                    Text(Constants.BookingStatusScreenConstants.refundable)
//                        .foregroundStyle(.green)
//                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
//                }
//            }
//        }
//    }
//}
