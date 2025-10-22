//
//  CustomNavigationBar.swift
//  VisaActivity
//
//  Created by Rohit Sankpal on 24/08/25.
//
import SwiftUI

struct CustomNavigationBar: View {
    var title: String = ""
    var onBack: (() -> Void)?
    
    var body: some View {
        HStack {
            // Back button
            Button(action: {
                onBack?()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Title (optional)
            if !title.isEmpty {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            // App logo on right side
            Image("AppLogo") 
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 32)
        }
        .padding(.horizontal, 16)
        .frame(height: 50)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
