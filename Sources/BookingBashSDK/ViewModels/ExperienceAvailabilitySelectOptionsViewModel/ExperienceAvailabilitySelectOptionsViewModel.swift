//
//  ExperienceAvailabilitySelectOptionsViewModel.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation

class ExperienceAvailabilitySelectOptionsViewModel: ObservableObject {
    @Published var selectedDate: String = ""
    @Published var participants: String = "1 Adult"
    
    @Published var months: [CalendarMonth] = []
    @Published var selectedDateFromCalender: Date = Date()
    let formatter = DateFormatter()
    
    @Published var response: AvailabilityApiResponse?
    @Published var errorMessage: String?
    
    private let calendar = Calendar.current
    
    let icons = [
        "bolt.fill"
    ]
    
    init() {
        generateMonths()
    }
    
    func dateSelectedFromCalender(date: Date) {
        selectedDateFromCalender = date
        selectedDate = formatDate(date)
        checkInDateG = selectedDate
    }
    
    func generateMonths() {
        let startDate = calendar.startOfDay(for: Date())
        months = (0..<13).compactMap { offset in
            guard let monthDate = calendar.date(byAdding: .month, value: offset, to: startDate) else { return nil }
            let name = DateFormatter().monthSymbols[calendar.component(.month, from: monthDate) - 1]
            let year = calendar.component(.year, from: monthDate)
            let days = generateDays(for: monthDate)
            return CalendarMonth(name: name, year: year, days: days)
        }
    }
    
    func generateDays(for date: Date) -> [CalendarDay] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
        var days: [CalendarDay] = []
        
        let firstWeekday = calendar.component(.weekday, from: monthInterval.start) - 1
        for _ in 0..<firstWeekday {
            days.append(CalendarDay(date: Date(), isInCurrentMonth: false, isSelectable: false))
        }
        
        var currentDate = monthInterval.start
        while currentDate < monthInterval.end {
            let isFuture = currentDate >= calendar.startOfDay(for: Date())
            days.append(CalendarDay(date: currentDate, isInCurrentMonth: true, isSelectable: isFuture))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
    
    func monthIndex(from name: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        if let date = formatter.date(from: name) {
            return Calendar.current.component(.month, from: date)
        }
        return 0
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    func selectToday() {
        selectedDateFromCalender = calendar.startOfDay(for: Date())
        selectedDate = formatDate(selectedDateFromCalender)
    }
    
    func selectTomorrow() {
        selectedDateFromCalender = calendar.date(byAdding: .day, value: 1, to: Date())!
        selectedDate = formatDate(selectedDateFromCalender)
    }
    
    func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        calendar.isDate(d1, inSameDayAs: d2)
    }
    
    func selectDate() {
        print("Select date tapped")
    }
    
    func selectParticipants() {
        print("Select participants tapped")
    }
    
    @Published var packages: [Package] = []

    func toggleExpansion(for package: Package) {
        packages = packages.map { item in
            if item.id == package.id {
                var newItem = item
                newItem.isExpanded.toggle()
                return newItem
            } else {
                var newItem = item
                newItem.isExpanded = false
                return newItem
            }
        }
    }
    
    func toggleInfo(for package: Package) {
        packages = packages.map { item in
            if item.id == package.id {
                var newItem = item
                newItem.isInfoExpanded.toggle()
                return newItem
            } else {
                return item
            }
        }
    }
    
    func selectTime(_ time: String, for package: Package) {
        packages = packages.map { item in
            if item.id == package.id {
                var newItem = item
                newItem.selectedTime = time
                return newItem
            } else {
                return item
            }
        }
    }
    
    @Published var categories = [
        ParticipantCategory(type: "Adult", ageRange: "(age 13 to 100)", price: 295, count: 1, maxLimit: 10),
        ParticipantCategory(type: "Children", ageRange: "(age 5 to 12)", price: 0, count: 0, maxLimit: 5),
        ParticipantCategory(type: "Infant", ageRange: "(age 0 to 2)", price: 0, count: 0, maxLimit: 3)
    ]
    
    func increment(for category: ParticipantCategory) {
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
        if categories[index].count < categories[index].maxLimit {
            categories[index].count += 1
            participants = "\(categories[index].count) \(categories[index].type)"
        }
    }
    
    func decrement(for category: ParticipantCategory) {
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
        if categories[index].count > 0 {
            categories[index].count -= 1
            participants = "\(categories[index].count) \(categories[index].type)"
        }
    }
    
    var totalSelected: Int {
        categories.reduce(0) { $0 + $1.count }
    }
    
    var canSelect: Bool {
        totalSelected <= 15 
    }
}

extension ExperienceAvailabilitySelectOptionsViewModel {
    
    func fetchAvailabilities(productCode: String, currencyCode: String) {
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/availability") else { return }
        formatter.dateFormat = "yyyy-MM-dd"
        
        let travelDetails: [TravelerDetail] = [TravelerDetail(age_band: "ADULT", traveler_count: 1)]
        let requestBody = AvailabilityRequest(
            product_id: productCode,
            currency: currencyCode,
            check_in_date: formatter.string(from: selectedDateFromCalender),
            traveler_details: travelDetails
        )
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Basic Qy1FWTNSM0c6OWRjOWMwOWRiMzdkYWRmYmQyNDAxYTljNjBmODY1MGY1YjZlMDFjYg==",
            "token": encryptedPayload
        ]
        NetworkManager.shared.post(url: url, body: requestBody, headers : headers) { (result: Result<AvailabilityApiResponse, Error>) in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let data):
                    self.response = data
                    setApiResponse(response?.data)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error:", error)
                }
            }
        }
    }
    
    func setApiResponse(_ responseData: AvailabilityData?) {
        guard let data = responseData else { return }
        
        packages = data.availabilities.flatMap { availability in
            availability.rates.map { rate in
                // Collect times from ALL rates in this availability
                let times = availability.rates.compactMap { $0.time }
                
                // Info items from labels
                let infoItems: [InfoItems] = rate.labels.map { label in
                    InfoItems(title: label, icon: "bolt.fill") // static icon, dynamic title
                }
                
                // Pricing description
                let pricingDescriptions: [String] = rate.price.pricePerAgeBand.map { ageBand in
                    "\(ageBand.travelerCount) \(ageBand.ageBand) x AED \(ageBand.totalBandPrice)"
                }
                
                // Total amount for this rate
                let totalAmount = rate.price.pricePerAgeBand
                    .map { $0.totalBandPrice }
                    .reduce(0, +)
                
                return Package(
                    title: rate.description.isEmpty ? "Two Park Pass - Dubai Parks and Resorts" : rate.description,
                    times: times,
                    infoItems: infoItems,
                    pricingDescription: pricingDescriptions,
                    totalAmount: "\(totalAmount)"
                )
            }
        }
    }
}
