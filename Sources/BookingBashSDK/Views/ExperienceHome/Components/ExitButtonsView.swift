//
//  ExitButtonsView.swift
//  VisaActivity
//
//  Created by Apple on 08/08/25.
//

import SwiftUI

struct ExitButtonsView: View {
    var textColor: Color = Color(hex: Constants.HexColors.primary)
    let buttonText: String
    var backgroundColor: Color = Color(hex: Constants.HexColors.primary)
    let buttontapped: () -> Void
    
    var body: some View {
        Button(action: {
            buttontapped()
        }, label: {
            Text(buttonText)
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(textColor)
                .frame(width: 100, height: 42)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(hex: Constants.HexColors.primary), lineWidth: 1)
                )
        })
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(backgroundColor)
        )
    }
}
