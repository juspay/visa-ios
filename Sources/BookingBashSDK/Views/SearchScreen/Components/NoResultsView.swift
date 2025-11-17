import SwiftUI

struct NoResultsView: View {
    var body: some View {
        VStack(spacing: 24) {
            if let noResultImage = ImageLoader.bundleImage(named: Constants.Icons.searchNoResult) {
                noResultImage
                    .resizable()
                    .frame(width: 124, height: 124)
            }
            
            VStack(spacing: 8) {
                Text(Constants.searchScreenConstants.noResultFound)
                    .font(.custom(Constants.Font.openSansBold, size: 18))
                    .foregroundStyle(Color(hex: Constants.HexColors.secondary))

                Text(Constants.searchScreenConstants.noResultFoundSubTitle)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 36)
    }
}
