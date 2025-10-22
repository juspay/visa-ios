import SwiftUI

struct CancelBookingBottomSheet: View {
    @Binding var isPresented: Bool
    var onFinish: () -> Void
    
    var body: some View {
        BottomSheetView(isPresented: $isPresented, sheetHeight: 420) {
            VStack(spacing: 0) {
                // Custom image with gold border/background
                ZStack {
                    
                    if let image = ImageLoader.bundleImage(named: "cancelBottomSheet") {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 16)
                
                // Title
                Text("Need to Cancel or Amend Your Booking?")
                    .font(.custom("Lexend-Bold", size: 28))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                
                // Subtitle and contact info
                VStack(alignment: .leading, spacing: 0) {
                    Text("For any cancellation or amendment requests, please reach out to us at the email or contact number provided below. Our team will be happy to assist you.")
                        .font(.custom("open_sans_regular", size: 14))
                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(4)
                        .padding(.bottom, 16)
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("Email:")
                            .font(.custom("Lexend-Bold", size: 15))
                            .foregroundColor(Color(hex: Constants.HexColors.neutral))
                        Text("reservations@bookingbash.com")
                            .font(.custom("open_sans_regular", size: 15))
                            .foregroundColor(Color(hex: Constants.HexColors.neutral))
                    }
                    .padding(.bottom, 2)
                    
                    HStack(alignment: .top, spacing: 4) {
                        Text("Tel:")
                            .font(.custom("Lexend-Bold", size: 15))
                            .foregroundColor(Color(hex: Constants.HexColors.neutral))
                        Text("+97148348696")
                            .font(.custom("open_sans_regular", size: 15))
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
                    Text("Back")
                        .font(.custom("Lexend-Medium", size: 18))
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
