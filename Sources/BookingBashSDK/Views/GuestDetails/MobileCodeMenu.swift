//
//  MobileCode.swift
//  VisaActivity
//
//  Created by Sakshi on 05/09/25.
//
import SwiftUI

struct MobileCodeMenu: View {
    @Binding var selectedCode: String

    // List of country codes (add more as needed)
    private let codes = [
        ("🇦🇪", "+971"),
        ("🇮🇳", "+91"),
        ("🇺🇸", "+1"),
        ("🇬🇧", "+44") ]
    
    var body: some View {
        Menu {
            ForEach(codes, id: \.1) { code in
                Button {
                    selectedCode = code.1
                } label: {
                    HStack {
                        Text(code.0) // flag
                        Text(code.1) // code
                    }
                }
            }
        } label: {
            HStack {
                if let flag = codes.first(where: { $0.1 == selectedCode })?.0 {
                    Text(flag)
                }
                Text(selectedCode)
            }
            .padding(10)
            .frame(minWidth: 80)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.4))
            )
        }
    }
}
