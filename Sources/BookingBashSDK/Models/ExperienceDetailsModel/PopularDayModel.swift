//
//  DayModel.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation

struct PopularDayModel: Identifiable {
    let id = UUID()
    let title: String
    let isHighlighted: Bool
}
