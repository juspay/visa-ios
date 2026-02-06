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
    var description: String?
    
    init(type: String, ageRange: String, price: Int, count: Int, maxLimit: Int, minLimit: Int = 0, bandId: String = "", sortOrder: Int = 0, isAdult: Bool = false, description : String? = nil) {
        self.type = type
        self.ageRange = ageRange
        self.price = price
        self.count = count
        self.maxLimit = maxLimit
        self.minLimit = minLimit
        self.bandId = bandId
        self.sortOrder = sortOrder
        self.isAdult = isAdult
        self.description = description
    }
    
    init(from ageBand: DetailAgeBand) {
        self.type = ageBand.description
        self.ageRange = "(Age \(ageBand.ageFrom) to \(ageBand.ageTo))"
        self.price = 0 
        self.count = ageBand.minTravelersPerBooking > 0 ? ageBand.minTravelersPerBooking : 0
        self.maxLimit = ageBand.maxTravelersPerBooking
        self.minLimit = ageBand.minTravelersPerBooking
        self.bandId = ageBand.bandID
        self.sortOrder = ageBand.sortOrder
        self.isAdult = ageBand.adult
        self.description = ageBand.description
    }

    init(from reviewAgeBand: ReviewAgeBand) {
        self.type = reviewAgeBand.description ?? ""
        
        if let ageFrom = reviewAgeBand.ageFrom,
           let ageTo = reviewAgeBand.ageTo {
            self.ageRange = "(Age \(Int(ageFrom)) to \(Int(ageTo)))"
        } else {
            self.ageRange = ""
        }

        self.price = 0

        let minTravelers = Int(reviewAgeBand.minTravelersPerBooking ?? 0)
        let maxTravelers = Int(reviewAgeBand.maxTravelersPerBooking ?? 0)

        self.count = minTravelers
        self.maxLimit = maxTravelers
        self.minLimit = minTravelers

        self.bandId = reviewAgeBand.bandId ?? ""
        self.sortOrder = Int(reviewAgeBand.sortOrder ?? 0)
        self.isAdult = reviewAgeBand.adult ?? false
    }
}
