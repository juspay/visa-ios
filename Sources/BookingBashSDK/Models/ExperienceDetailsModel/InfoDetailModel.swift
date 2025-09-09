//
//  InfoDetailModel.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation

struct InfoDetailModel: Identifiable {
    let id = UUID()
    let title: String
    var shortDesciption: String = ""
    let items: [String]
}
