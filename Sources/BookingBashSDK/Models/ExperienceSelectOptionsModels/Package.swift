import Foundation

struct Package: Identifiable {
    let id = UUID()
    let title: String
    let slotDetails: [SlotDetails]
//    let times: [String]
    let infoItems: [InfoItems]
    var pricingDescription: [String]
    var totalAmount: String
    var selectedTime: String?
    var isExpanded: Bool = false
    var isInfoExpanded: Bool = false
    var supplierName: String?
    var subActivityCode: String?
    var activityCode: String?
    var availabilityKey: String?
    var subActivityDescription: String
}

struct SlotDetails: Identifiable {
    let id = UUID()
    let availabilityStatus: Bool
    let time: String
    let availableTimeSlot: Int
}

struct InfoItems: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}
