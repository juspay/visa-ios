//
//  ToastView.swift
//  VisaActivity
//
//  Created by Praveen on 05/09/25.
//
import SwiftUI

struct ToastView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.gray)
            .cornerRadius(12)
            .font(.system(size: 16, weight: .semibold))
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
