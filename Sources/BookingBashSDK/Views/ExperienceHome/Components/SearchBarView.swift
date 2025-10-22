

import Foundation
import SwiftUI

struct SearchBarView: View {
    @ObservedObject var viewModel: SearchDestinationViewModel
    let searchPlaceholderText: String
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 8) {
            if let searchImage = ImageLoader.bundleImage(named: Constants.Icons.searchIcon) {
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
            
            if !searchText.isEmpty {
                Image(systemName: Constants.Icons.xmark)
                    .imageScale(.small)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    .onTapGesture {
                        searchText = ""
                        viewModel.destinations = [] // Clear search results
                    }
            }
        }
        .onChange(of: searchText) { newValue in
            let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmed.count >= 3 {
                viewModel.autoSuggestFetchData(searchCity: trimmed) { _ in }
            } else {
                viewModel.destinations = [] // Clear results if less than 3 characters
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 12)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .overlay(
            Capsule()
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
}

