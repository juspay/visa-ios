//
//  InfoItem.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation

struct InfoItem: Identifiable {
    let id = UUID()
    let title: String
    let type: InfoType
}

enum InfoType {
    case highlights, included, excluded, cancellation, know, where_, reviews, photos
}
