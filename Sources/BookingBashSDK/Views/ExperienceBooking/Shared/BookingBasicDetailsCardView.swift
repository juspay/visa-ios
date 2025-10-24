import SwiftUI

struct BookingBasicDetailsCardView: View {
    let basicBookingDetailsModel: [BasicBookingDetailsModel]
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(basicBookingDetailsModel) { item in
                GeometryReader { geometry in
                    if item.key.lowercased().contains("date") {
                        HStack(alignment: .center, spacing: 8) {
                            Text(item.key)
                                .font(.custom(Constants.Font.openSansBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                                .frame(width: geometry.size.width * 0.25, alignment: .leading)
                            Text(item.value)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                                .multilineTextAlignment(.leading)
                                .frame(width: geometry.size.width * 0.45, alignment: .leading)
//                            HStack(spacing: 4) {
//                                Image(systemName: "person")
//                                    .foregroundColor(Color(hex: Constants.HexColors.neutral))
//                                Text(participantsSummary)
//                                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
//                                    .foregroundColor(Color(hex: Constants.HexColors.neutral))
//                            }
                        }
                    } else {
                        HStack(alignment: .top, spacing: 8) {
                            Text(item.key)
                                .font(.custom(Constants.Font.openSansBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                                .frame(width: geometry.size.width * 0.25, alignment: .leading)
                            Text(item.value)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                                .multilineTextAlignment(.leading)
                                .frame(width: geometry.size.width * 0.75, alignment: .leading)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
    }
}
