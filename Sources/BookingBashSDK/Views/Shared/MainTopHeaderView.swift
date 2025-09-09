//
//  MainTopHeaderView.swift
//  VisaActivity
//
//  Created by Apple on 08/08/25.
//

import SwiftUI

struct MainTopHeaderView: View {
    let headerText: String
    
    var body: some View {
        Text(headerText)
            .font(.custom(Constants.Font.openSansBold, size: 14))
            .foregroundStyle(Color.white)
            .padding(.bottom, 10)
    }
}
