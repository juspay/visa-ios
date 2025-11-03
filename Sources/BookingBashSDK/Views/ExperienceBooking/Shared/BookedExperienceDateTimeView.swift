import Foundation
import SwiftUI

struct BookedExperienceDateTimeView: View {
    let color: Color
    var shouldShowRefundable: Bool = true
    let selectedDate: String
    let selectedTime: String
//    let selectedParticipants: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                IconTextRow(
                    imageName: Constants.Icons.calendargray,
                    text: selectedDate,
                    color: color
                )
                Spacer()
//                IconTextRow(
//                    imageName: Constants.Icons.user,
//                    text: selectedParticipants,
//                    color: color
//                )
            }
            if !selectedTime.isEmpty {
                IconTextRow(
                    imageName: Constants.Icons.clock,
                    text: selectedTime,
                    color: color
                )
            }
            if shouldShowRefundable {
                HStack(spacing: 6) {
                    if let checkIcon = ImageLoader.bundleImage(named: Constants.Icons.greenTick) {
                        checkIcon
                           
                            .resizable()
                           
                            .frame(width: 20, height: 20)
                    }
                    Text(Constants.BookingStatusScreenConstants.refundable)
                        .foregroundStyle(.green)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                }
            }
        }
    }
}
