
import Foundation

struct BookingConfirmationTopInfoModel: Identifiable {
    let id = UUID()
    let image: String
    let bookingStatus: String
    let bookingMessage: String
}
