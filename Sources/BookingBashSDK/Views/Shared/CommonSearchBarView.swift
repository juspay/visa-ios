//
//  CommonSearchBarView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 22/11/25.
//

import SwiftUI

struct CommonSearchBarView: View {
    @Binding var searchedText: String
    var placeholder: String = "Search Country..."
    var onTap: (() -> Void)? = nil

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {

            // Search icon
            (ImageLoader.bundleImage(named: Constants.Icons.searchIcon)
             ?? Image(systemName: "magnifyingglass"))
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundStyle(Color(hex: Constants.HexColors.primaryStrong))

            // TextField
            TextField("", text: $searchedText)
                .focused($isFocused)
                .font(.custom(Constants.Font.openSansRegular, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                .overlay(
                    Group {
                        if searchedText.isEmpty {
                            Text(placeholder)
                                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong).opacity(0.6))
                                .font(.custom(Constants.Font.openSansRegular, size: 14))
                                .allowsHitTesting(false)
                        }
                    },
                    alignment: .leading
                )

            // Clear button (xmark)
            if !searchedText.isEmpty {
                Button {
                    searchedText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.gray.opacity(0.6))
                }
                .padding(.trailing, 4)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
            onTap?()
        }
    }
}

#Preview {
    CommonSearchBarView(searchedText: .constant(""))
}
