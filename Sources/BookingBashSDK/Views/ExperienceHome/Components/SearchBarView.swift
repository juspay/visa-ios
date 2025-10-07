//
//  SearchBarView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SwiftUI

struct SearchBarView: View {
    @ObservedObject var viewModel: SearchDestinationViewModel
    let searchPlaceholderText: String
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 8) {
            if let searchImage = bundleImage(named: Constants.Icons.searchIcon) {
                searchImage
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
            }
            
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(searchPlaceholderText)
                        .font(.custom(Constants.Font.openSansRegular, size: 14))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                }
                
                TextField("", text: $searchText)
                    .font(.custom(Constants.Font.openSansRegular, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            }
            
            Spacer()
            
            Image(systemName: Constants.Icons.xmark)
                .imageScale(.small)
                .frame(width: 18, height: 18)
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                .onTapGesture {
                    searchText = ""
                }
        }
        .onChange(of: searchText) { newValue in
            if searchText.count >= 3 {
                viewModel.autoSuggestFetchData(searchCity: searchText)
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
}
