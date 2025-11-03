import Foundation
import SwiftUI

struct TopBarView: View {
    var onSearchTap: () -> Void
    var onHamburgerTap: () -> Void
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    .frame(width: 44, height: 44)
                if let hamburgerImage = ImageLoader.bundleImage(named: Constants.Icons.hamburger) {
                    hamburgerImage
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                }
            }
            .onTapGesture {
                onHamburgerTap()
            }
            
            HStack(spacing: 8) {
                if let searchImage = ImageLoader.bundleImage(named: Constants.Icons.searchIcon) {
                    searchImage
                        .frame(width: 15, height: 15)
                        .foregroundStyle(Color(hex: Constants.HexColors.primaryStrong))
                }
                
                Text(Constants.HomeScreenConstants.searchDestination)
                    .lineLimit(1)
                    .font(.custom(Constants.Font.openSansRegular, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                onSearchTap()
            }
        }
        .padding(.horizontal, 15)
    }
}
