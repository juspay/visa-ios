
import Foundation
import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let showViewAll: Bool
    var viewAllAction: (() -> Void)? = nil
//    var onCurrencyClick: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 20) {
            Text(title)
                .font(.custom(Constants.Font.openSansBold, size: 18))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            Spacer()
            
            if showViewAll {
//                Button(action: {
//                    onCurrencyClick?()
//                }) {
//                    HStack(spacing: 4) {
//                        Text(currencyGlobal)
//                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
//                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
//                        Image(systemName: Constants.ExperienceListDetailViewConstants.chevronDown)
//                        
//                            .font(.caption)
//                            .foregroundColor(Color(hex: Constants.HexColors.primary))
//                    }
//                }

                Text(Constants.HomeScreenConstants.viewAll)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    .onTapGesture {
                        viewAllAction?()
                    }
            }
        }
        .padding(.horizontal, 15)
    }
}
