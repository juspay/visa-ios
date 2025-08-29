//
//  Calender.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation

struct CalendarMonth: Identifiable {
    let id = UUID()
    let name: String
    let year: Int
    let days: [CalendarDay]
}

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
    let isInCurrentMonth: Bool
    let isSelectable: Bool
}
