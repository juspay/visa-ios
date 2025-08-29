//
//  FareItem.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation

struct FareItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let isDiscount: Bool
}

