//
//  LoaderView.swift
//  VisaActivity
//
//  Created by GitHub Copilot on 11/09/25.
//

import SwiftUI

struct LoaderView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: Constants.HexColors.primary)))
                    .scaleEffect(1.5)
                
                Text("Loading...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: Constants.HexColors.primary))
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}