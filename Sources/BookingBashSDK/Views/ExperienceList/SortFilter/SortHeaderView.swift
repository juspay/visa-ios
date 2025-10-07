//
//  SortHeaderView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct SortHeaderView: View {
    var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.custom(Constants.Font.openSansBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            
            SeparatorLine()
        }
    }
}
