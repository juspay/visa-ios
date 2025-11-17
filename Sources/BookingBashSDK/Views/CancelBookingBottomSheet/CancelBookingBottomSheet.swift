import SwiftUI

struct CancelBookingBottomSheet: View {
    @Binding var isPresented: Bool
    var onFinish: () -> Void
    
    var body: some View {
        BottomSheetView(isPresented: $isPresented, sheetHeight: 420) {
            VStack(spacing: 0) {
                ZStack {
                    if let image = ImageLoader.bundleImage(named: Constants.CancelBookingBottomSheetConstants.imageName) {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 16)
                
                // Title
                Text(Constants.CancelBookingBottomSheetConstants.title)
                    .font(.custom(Constants.Font.lexendBold, size: 28))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                
                // Subtitle and contact info
                VStack(alignment: .leading, spacing: 0) {
                    Text(Constants.CancelBookingBottomSheetConstants.subtitle)
                        .font(.custom(Constants.Font.openSansRegular, size: 14))
                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(4)
                        .padding(.bottom, 16)
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text(Constants.CancelBookingBottomSheetConstants.emailLabel)
                            .font(.custom(Constants.Font.lexendBold, size: 15))
                            .foregroundColor(Color(hex: Constants.HexColors.neutral))
                        Text(Constants.CancelBookingBottomSheetConstants.emailValue)
                            .font(.custom(Constants.Font.openSansRegular, size: 15))
                            .foregroundColor(Color(hex: Constants.HexColors.neutral))
                    }
                    .padding(.bottom, 2)
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text(Constants.CancelBookingBottomSheetConstants.telLabel)
                            .font(.custom(Constants.Font.lexendBold, size: 15))
                            .foregroundColor(Color(hex: Constants.HexColors.neutral))
                        Text(Constants.CancelBookingBottomSheetConstants.telValue)
                            .font(.custom(Constants.Font.openSansRegular, size: 15))
                            .foregroundColor(Color(hex: Constants.HexColors.neutral))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                Spacer()
                
                // Button
                Button(action: {
                    isPresented = false
                    onFinish()
                }) {
                    Text(Constants.CancelBookingBottomSheetConstants.backButton)
                        .font(.custom(Constants.Font.lexendMedium, size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(hex: Constants.HexColors.primary))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(Color.white)
            .cornerRadius(24, corners: [.topLeft, .topRight])
        }
    }
}
