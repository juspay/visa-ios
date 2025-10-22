
import Foundation

struct ParticipantCategory: Identifiable {
    let id = UUID()
    let type: String
    let ageRange: String
    let price: Int
    var count: Int
    let maxLimit: Int
    let minLimit: Int
    let bandId: String
    let sortOrder: Int
    let isAdult: Bool
    
    // Initialize with static data (for backward compatibility)
    init(type: String, ageRange: String, price: Int, count: Int, maxLimit: Int, minLimit: Int = 0, bandId: String = "", sortOrder: Int = 0, isAdult: Bool = false) {
        self.type = type
        self.ageRange = ageRange
        self.price = price
        self.count = count
        self.maxLimit = maxLimit
        self.minLimit = minLimit
        self.bandId = bandId
        self.sortOrder = sortOrder
        self.isAdult = isAdult
    }
    
    // Initialize from DetailAgeBand (from details API response)
    init(from ageBand: DetailAgeBand) {
        self.type = ageBand.description
        self.ageRange = "(age \(ageBand.ageFrom) to \(ageBand.ageTo))"
        self.price = 0 // Price will be calculated from availability API
        self.count = ageBand.minTravelersPerBooking > 0 ? ageBand.minTravelersPerBooking : 0
        self.maxLimit = ageBand.maxTravelersPerBooking
        self.minLimit = ageBand.minTravelersPerBooking
        self.bandId = ageBand.bandID
        self.sortOrder = ageBand.sortOrder
        self.isAdult = ageBand.adult
    }
}
