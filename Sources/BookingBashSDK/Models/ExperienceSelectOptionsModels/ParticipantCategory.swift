//
//  ParticipantCategory.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation

struct ParticipantCategory: Identifiable {
    let id = UUID()
    let type: String
    let ageRange: String
    let price: Int
    var count: Int
    let maxLimit: Int
}
