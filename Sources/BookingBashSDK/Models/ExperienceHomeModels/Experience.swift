//
//  Experience.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation

struct Experience: Identifiable {
    let id = UUID()
    let imageName: String
    let country: String
    let title: String
    let originalPrice: Int
    let discount: Int
    let finalPrice: Int
}
