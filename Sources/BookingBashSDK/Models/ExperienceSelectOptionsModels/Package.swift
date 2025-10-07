//
//  Package.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation

struct Package: Identifiable {
    let id = UUID()
    let title: String
    let times: [String]
    let infoItems: [InfoItems]
    var pricingDescription: [String]
    var totalAmount: String
    var selectedTime: String?
    var isExpanded: Bool = false
    var isInfoExpanded: Bool = false
    var supplierName: String? 
    
}

struct InfoItems: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}
