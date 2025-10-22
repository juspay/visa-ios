//
//  LoaderView.swift
//  VisaActivity
//
//  Created by GitHub Copilot on 11/09/25.
//

import SwiftUI

struct LoaderView: View {
    let text: String
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: Constants.HexColors.primary)))
                .scaleEffect(1.5)
            
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(hex: Constants.HexColors.primary))
        }
        .padding(30)
    }
}
