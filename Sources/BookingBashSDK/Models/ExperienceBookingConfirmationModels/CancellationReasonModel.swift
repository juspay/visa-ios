//
//  CancellationReasonModel.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation

struct CancellationReason: Identifiable, Equatable, Codable {
    let id = UUID()
    let title: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case title = "cancellation_text"
        case code = "cancellation_code"
    }
}
