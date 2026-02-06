import SwiftUI

struct NoResultsView: View {
    var text: String = Constants.ErrorMessages.noResultsFound
    var body: some View {
        VStack(spacing: 24) {
            if let noResultImage = ImageLoader.bundleImage(named: Constants.Icons.searchNoResult) {
                noResultImage
                    .resizable()
                    .frame(width: 124, height: 124)
            }
            
            VStack(spacing: 16) {
                Text(text)
                    .font(.custom(Constants.Font.openSansBold, size: 18))
                    .foregroundStyle(Color(hex: Constants.HexColors.secondary))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
    }
}
