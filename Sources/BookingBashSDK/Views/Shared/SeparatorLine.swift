//
//  SeparatorLine.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import SwiftUI

struct SeparatorLine: View {
    var color: Color = Color(hex: Constants.HexColors.neutralWeak)
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 1)
    }
}

#Preview {
    SeparatorLine()
}
