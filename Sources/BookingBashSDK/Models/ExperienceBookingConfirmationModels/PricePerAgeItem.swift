//
//  PricePerAgeItem.swift
//  VisaActivity
//
//  Created by Apple on 16/10/25.
//

import Foundation

struct PricePerAgeItem: Identifiable {
    let id = UUID()
    let ageBand: String      // e.g., "adult", "child", "infant"
    let count: Int           // number of travelers
    let pricePerTraveller: Double
    let totalAmount: Double
}