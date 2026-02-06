import SwiftUI

struct ExperienceBookingConfirmationTopView: View {
    let bookingInfo: BookingConfirmationTopInfoModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                if let bookingBashLogo = ImageLoader.bundleImage(named: Constants.Icons.bookingBash) {
                    bookingBashLogo
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                } else {
                    Image(Constants.Icons.bookingBash)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                }

                if let icon = ImageLoader.bundleImage(named: bookingInfo.image) {
                    icon
                        .resizable()
                        .frame(width: 40, height: 40)
                } else {
                    Image(bookingInfo.image)
                        .resizable()
                        .frame(width: 40, height: 40)
                }

                Text(bookingInfo.bookingStatus)
                    .font(.custom(Constants.Font.openSansBold, size: 16))
                    .foregroundStyle(Color(hex: Constants.HexColors.surfaceWeakest))
                    .multilineTextAlignment(.center)
                Text(bookingInfo.bookingMessage)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.surfaceWeakest))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        
    }
}
