
struct BookingDetailsRequest: Codable {
    let bookingId: String
    
    enum CodingKeys: String, CodingKey {
        case bookingId = "booking_id"
    }
}
