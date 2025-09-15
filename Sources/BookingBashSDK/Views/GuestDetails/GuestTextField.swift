//
//  GuestTextField.swift
//  VisaActivity
//
//  Created by apple on 05/09/25.
//

import SwiftUI

struct GuestTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .padding(10)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.4))
            )
    }
}
