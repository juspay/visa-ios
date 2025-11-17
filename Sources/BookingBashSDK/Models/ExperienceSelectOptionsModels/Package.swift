import Foundation

struct Package: Identifiable {
    let id = UUID()
    let title: String
    let times: [String]
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
}

struct InfoItems: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}
