import SwiftUI

struct NoResultErrorView: View {
    var body: some View {
        VStack(spacing: 12) {
            if let noResultImage = ImageLoader.bundleImage(named: Constants.Icons.searchNoResult) {
                noResultImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 124, height: 124)
                    .padding(.top, 40)
            }
            
            Text(Constants.ErrorMessages.noResultsFound)
                .font(.custom(Constants.Font.openSansSemiBold, size: 18))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text(Constants.ErrorMessages.noResultsFoundDescription)
                .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.001))
        .ignoresSafeArea()
    }
}

struct ErrorMessageView: View {
    var body: some View {
        VStack(spacing: 12) {
            if let noResultImage = ImageLoader.bundleImage(named: Constants.Icons.searchNoResult) {
                noResultImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 124, height: 124)
                    .padding(.top, 40)
            }
            
            Text(Constants.ErrorMessages.somethingWentWrong)
                .font(.custom(Constants.Font.openSansBold, size: 16))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.001)) 
        .ignoresSafeArea()
    }
}

