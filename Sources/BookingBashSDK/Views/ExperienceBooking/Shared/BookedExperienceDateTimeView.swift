import Foundation
import SwiftUI

struct BookedExperienceDateTimeView: View {
    let color: Color
    var shouldShowRefundable: Bool = true
    let loaction: String
    let selectedDate: String
    let selectedTime: String
    let selectedParticipants: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            IconTextRow(
                imageName: Constants.Icons.map,
                text: loaction,
                color: color
            )
            HStack {
                IconTextRow(
                    imageName: Constants.Icons.calendargray,
                    text: selectedDate,
                    color: color
                )
                Spacer()
                
                if let participants = selectedParticipants, !participants.isEmpty {
                    IconTextRow(
                        imageName: Constants.Icons.user,
                        text: participants,
                        color: color
                    )
                }
            }
            if !selectedTime.isEmpty && selectedTime != "00:00" {
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
                            .aspectRatio(contentMode: .fit)
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
