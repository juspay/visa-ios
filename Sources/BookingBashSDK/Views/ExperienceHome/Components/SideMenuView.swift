//
//  SideMenuView.swift
//  VisaActivity
//
//  Created by praveen on 04/09/25.
//

import SwiftUI

struct SideMenuView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Profile Section
                HStack(spacing: 12) {
                    Circle()
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "person")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                        )
                    
                    Text("Hi \(firstName)!")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
                // Menu Items
                VStack(spacing: 16) {
                    //  Navigate to MyTransactionView
                    NavigationLink(destination: MyTransactionView()) {
                        MenuRow(icon: "ticket", title: "My Transactions")
                    }
                    
                    MenuRow(icon: "bag", title: "My BB-Pro Savings")
                    MenuRow(icon: "heart", title: "My Favorites")
//                    MenuRow(icon: "person", title: "My Profile")
                    NavigationLink(destination: ProfileView()) {
                        MenuRow(icon: "person", title: "My Profile")
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }
}


struct MenuRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .frame(width: 24, alignment: .center)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(12)
    }
}
