//
//  SearchDestinationModel.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation

struct SearchDestinationModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let isRecent: Bool
}
