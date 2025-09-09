//
//  CancellationReasonModel.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation

struct CancellationReason: Identifiable, Equatable {
    let id = UUID()
    let title: String
}
