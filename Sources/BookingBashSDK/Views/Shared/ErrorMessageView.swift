import SwiftUI

enum ErrorMessageType {
    case noMatchFound
    case somethingWentWrong
    case noResultFound
    case authFail

    var title: String {
        switch self {
        case .noMatchFound: return Constants.ErrorMessages.noMatchFound
        case .somethingWentWrong: return Constants.ErrorMessages.somethingWentWrong
        case .noResultFound: return Constants.ErrorMessages.noResultsFound
        case .authFail: return Constants.ErrorMessages.authFail
        }
    }

    var description: String? {
        switch self {
        case .noMatchFound: return Constants.ErrorMessages.noMatchFoundDescription
        case .somethingWentWrong: return nil
        case .noResultFound: return Constants.ErrorMessages.noResultsFoundDescription
        case .authFail: return nil
        }
    }
}

struct ErrorMessageView: View {
    var errorMessage: ErrorMessageType = .somethingWentWrong

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if let noResultImage = ImageLoader.bundleImage(named: Constants.Icons.searchNoResult) {
                noResultImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 124, height: 124)
                    .padding(.top, 40)
                    .padding(.bottom, 8)
            }

            Text(errorMessage.title)
                .font(.custom(Constants.Font.openSansBold, size: 18))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let description = errorMessage.description {
                Text(description)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.001)) 
        .ignoresSafeArea()
    }
}
