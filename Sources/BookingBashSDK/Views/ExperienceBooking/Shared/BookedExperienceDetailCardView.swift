import SwiftUI

struct BookedExperienceDetailCardView: View {
    @ObservedObject var experienceViewModel: ExperienceAvailabilitySelectOptionsViewModel
    @ObservedObject var confirmationViewModel: ExperienceBookingConfirmationViewModel
    let viewDetailsButtonTapped: (() -> Void)?
    var isBookingConfirmationScreen: Bool = true
    @Binding var shouldExpandDetails: Bool
//    let participantsSummary: String
    let selectedTime: String?
    
    var bookingDate: String {
        confirmationViewModel.bookingBasicDetails.first(where: { $0.key == "Booking Date" })?.value ?? "-"
    }
    
    var travelDate: String {
        confirmationViewModel.travelDate ?? "-"
    }
    
    var bookingParticipants: String {
        confirmationViewModel.bookingBasicDetails.first(where: { $0.key == "Participants" })?.value ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ExperienceDetailsCardHeaderView(
                images: [
                    Constants.Icons.print,
                    Constants.Icons.download,
                    Constants.Icons.shareYellow
                ]
            )
            
            BookedExperienceDetailInfoTopLocationView(
                title: confirmationViewModel.title ?? "",
                location: confirmationViewModel.location ?? location,
                titleTextColor: Color(hex: Constants.HexColors.blackStrong),
                locationTextColor: Color(hex: Constants.HexColors.neutral)
            )
            
            BookedExperienceDateTimeView(
                color: Color(hex: Constants.HexColors.neutral),
                selectedDate: travelDate,
                selectedTime: selectedTime ?? "-"
//                selectedParticipants: participantsSummary
            )
            
            if isBookingConfirmationScreen {
                Text("Your supplier voucher is on it's way - check your inbox soon")
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
            }
            
            if !shouldExpandDetails {
                ActionButton(title: Constants.BookingStatusScreenConstants.viewDetails) {
                    viewDetailsButtonTapped?()
                }
                .padding(.top, 12)
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
