//
//  Experience.swift
//  VisaActivity
//
//  Created by Apple on 30/07/25.
//

import Foundation

struct ExperienceListModel: Identifiable {
    let id = UUID()
    let title: String
    let rating: Double
    let reviewCount: Int
    let price: Double // Changed from Int to Double to preserve exact values
    let strikeoutPrice: Double? // Changed from Int to Double
    let savingPercentage: Double? // Percentage saved
    let imageName: String
    let productCode: String
    let currency: String
}
