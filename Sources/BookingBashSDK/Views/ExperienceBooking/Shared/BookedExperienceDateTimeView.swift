import Foundation
import SwiftUI

struct BookedExperienceDateTimeView: View {
    let color: Color
    var shouldShowRefundable: Bool? = nil
    let location: String?
    let selectedDate: String
    let selectedTime: String
    let selectedParticipants: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let location = location {
                IconTextRow(
                    imageName: Constants.Icons.map,
                    text: location,
                    color: color
                )
            }
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
                Spacer()
            }
            if !selectedTime.isEmpty && selectedTime != "00:00" {
                IconTextRow(
                    imageName: Constants.Icons.clock,
                    text: selectedTime,
                    color: color
                )
            }
            
            // MARK: - Refundable / Non-Refundable Section
            if let shouldShowRefundable {
                let iconName = shouldShowRefundable ? Constants.Icons.greenTick : Constants.Icons.redCross
                let titleText = shouldShowRefundable ? Constants.BookingStatusScreenConstants.refundable
                : Constants.BookingStatusScreenConstants.nonRefundable
                let textColor: Color = shouldShowRefundable ? .green : .red
                
                HStack(spacing: 6) {
                    if let icon = ImageLoader.bundleImage(named: iconName) {
                        icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    Text(titleText)
                        .foregroundColor(textColor)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                }
            }
        }
    }
}
