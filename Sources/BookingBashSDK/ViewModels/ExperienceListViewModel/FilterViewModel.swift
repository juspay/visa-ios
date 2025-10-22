import Foundation
import SwiftUI

class FilterViewModel: ObservableObject {
    @Published var filterGroups: [FilterGroup] = []
    @Published var selectedOptionIDs: Set<String> = []
    
    @Published var minPrice: Double = 0.0
    @Published var maxPrice: Double = 0.0
        
    @Published var minLimit: Double = 0.0
    @Published var maxLimit: Double = 0.0

    func setPriceRange(from priceRange: PriceRange?) {
           guard let priceRange = priceRange else { return }
           
           self.minPrice = priceRange.min
           self.maxPrice = priceRange.max
           
           self.minLimit = priceRange.min
           self.maxLimit = priceRange.max
       }
    
    func fetchOptions() {
        self.filterGroups = [
            FilterGroup(
                id: "time_of_day",
                title: "Time of Day",
                options: [
                    FilterOption(id: "morning", label: "Morning (Before 12pm)", value: "morning"),
                    FilterOption(id: "afternoon", label: "Afternoon (After 12pm)", value: "afternoon"),
                    FilterOption(id: "evening", label: "Evening & Night (After 5pm)", value: "evening")
                ]
            ),
            FilterGroup(
                id: "duration",
                title: "Duration",
                options: [
                    FilterOption(id: "1h", label: "Up to 1 hour", value: "1h"),
                    FilterOption(id: "4h", label: "1 to 4 hours", value: "4h"),
                    FilterOption(id: "1d", label: "4 hours to 1 day", value: "1d")
                ]
            )
        ]
    }

    func toggleOption(_ id: String) {
        if selectedOptionIDs.contains(id) {
            selectedOptionIDs.remove(id)
        } else {
            selectedOptionIDs.insert(id)
        }
    }

    func isSelected(_ id: String) -> Bool {
        selectedOptionIDs.contains(id)
    }

    func reset() {
        selectedOptionIDs.removeAll()
        minPrice = 100.0
        maxPrice = 1000.0
    }
}

