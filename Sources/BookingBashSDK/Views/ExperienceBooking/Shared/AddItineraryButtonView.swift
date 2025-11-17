

import SwiftUI

struct AddItineraryButtonView: View {
    var body: some View {
        Button(action: {
            
        }) {
            HStack(spacing: 8) {
                if let icon = ImageLoader.bundleImage(named: Constants.BookingStatusScreenConstants.calendar) {
                    icon
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                } else {
                    Image(Constants.BookingStatusScreenConstants.calendar)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                }
                Text(Constants.BookingStatusScreenConstants.addItineraryToCalendar)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
            }
            .foregroundStyle(Color(hex: Constants.HexColors.primary))
            .frame(maxWidth: .infinity, minHeight: 36)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(hex: Constants.HexColors.primary), lineWidth: 1)
            )
        }
    }
}

#Preview {
    AddItineraryButtonView()
}
