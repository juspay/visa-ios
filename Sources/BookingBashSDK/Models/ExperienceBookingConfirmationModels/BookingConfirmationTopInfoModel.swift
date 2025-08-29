//
//  BookingConfirmationTopInfoModel.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation

struct BookingConfirmationTopInfoModel: Identifiable {
    let id = UUID()
    let image: String
    let bookingStatus: String
    let bookingMessage: String
}
