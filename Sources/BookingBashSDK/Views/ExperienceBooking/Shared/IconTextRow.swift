//
//  IconTextRow.swift
//  VisaActivity
//
//  Created by Apple on 07/08/25.
//

import Foundation
import SwiftUI

struct IconTextRow: View {
    let imageName: String
    let text: String
    var color: Color
    var isBold: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            Image(imageName)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(color)

            Text(text)
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(color)
        }
    }
}
