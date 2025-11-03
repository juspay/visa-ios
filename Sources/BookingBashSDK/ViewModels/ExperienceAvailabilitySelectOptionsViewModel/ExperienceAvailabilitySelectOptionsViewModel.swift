import Foundation

class ExperienceAvailabilitySelectOptionsViewModel: ObservableObject {
    @Published var selectedDate: String = ""
    @Published var participants: String = ""
    @Published var showErrorView: Bool = false
    @Published var experienceTitle: String = ""
    @Published var months: [CalendarMonth] = []
    @Published var selectedDateFromCalender: Date = Date()
    let formatter = DateFormatter()
    @Published var maxTravelersPerBooking: Int = 0
    @Published var bandId : String = ""
    @Published var response: AvailabilityApiResponse?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasInitializedPackages: Bool = false
    
    // Added properties to store original API parameters
    var currentActivityCode: String?
    var currentCurrencyCode: String?
    
    // Add property to store age bands from details API
    @Published var ageBands: [DetailAgeBand] = []
    
    private let calendar = Calendar.current
    
    let icons = [
        "bolt.fill"
    ]
    
    init() {
        generateMonths()
        
        print("🔍 [INIT] Initialized availability view with default categories (1 Adult)")
    }
    
    // Method to load dynamic age bands when user opens participant selection
    func loadDynamicAgeBands() {
        if !globalAgeBands.isEmpty && ageBands.isEmpty {
            // Only load if we haven't loaded age bands yet
            print("🔍 [PARTICIPANTS] Loading dynamic age bands for participant selection")
            updateCategoriesFromAgeBands(globalAgeBands)
        } else {
            print("🔍 [PARTICIPANTS] Age bands already loaded or not available")
        }
    }
    
    func dateSelectedFromCalender(date: Date) {
        selectedDateFromCalender = date
        selectedDate = formatDate(date)
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
    
    //    func selectToday() {
    //        selectedDateFromCalender = calendar.startOfDay(for: Date())
    //        selectedDate = formatDate(selectedDateFromCalender)
    //    }
    //
    //    func selectTomorrow() {
    //        selectedDateFromCalender = calendar.date(byAdding: .day, value: 1, to: Date())!
    //        selectedDate = formatDate(selectedDateFromCalender)
    //    }
    
    func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        calendar.isDate(d1, inSameDayAs: d2)
    }
    
    func selectDate() {
        print("Select date tapped")
        // Refresh availability when date is selected/confirmed
        refreshAvailabilityAfterParticipantChange()
    }
    
    func selectParticipants() {
        print("Select participants tapped")
        // Refresh availability when participants selection is confirmed
        refreshAvailabilityAfterParticipantChange()
    }
    
    @Published var packages: [Package] = []
    
    var selectedPackage: Package? {
        return packages.first { $0.isExpanded }
    }
    
    // Function to update global variables with selected package data
    func updateSelectedPackageData() {
        guard let selected = selectedPackage else {
            // If no package is selected, use the first one as fallback
            if let firstPackage = packages.first {
                availablityKey = firstPackage.availabilityKey ?? ""
                subActivityCode = firstPackage.subActivityCode ?? ""
            }
            return
        }
        
        // Store values from the actually selected package
        availablityKey = selected.availabilityKey ?? ""
        subActivityCode = selected.subActivityCode ?? ""
        
        print("🔍 [SELECTION] Updated global variables from selected package:")
        print("   - Package: '\(selected.title)'")
        print("   - availabilityKey: '\(availablityKey)'")
        print("   - subActivityCode: '\(subActivityCode)'")
    }
    
    func setFirstPackageExpanded() {
        packages = packages.enumerated().map { index, item in
            var newItem = item
            newItem.isExpanded = (index == 0)
            return newItem
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
    
    @Published var categories: [ParticipantCategory] = []
    
    func updateCategoriesFromAgeBands(_ ageBands: [DetailAgeBand]) {
        print("🔍 [AGE_BANDS] Updating categories from age bands:")
        for ageBand in ageBands {
            print("   - \(ageBand.bandID): age \(ageBand.ageFrom)-\(ageBand.ageTo), min: \(ageBand.minTravelersPerBooking), max: \(ageBand.maxTravelersPerBooking)")
        }
        
        self.ageBands = ageBands
      
        var currentCounts: [String: Int] = [:]
        
        let sortedAgeBands = ageBands.sorted { $0.sortOrder < $1.sortOrder }
        
        categories = sortedAgeBands.map { ageBand in
            var category = ParticipantCategory(from: ageBand)
            category.count = ageBand.minTravelersPerBooking
            print("[DEBUG] Created category: \(category.type) (bandId: \(category.bandId)), count: \(category.count), maxLimit: \(category.maxLimit)")
            return category
        }
        
        // Update participants summary for UI display
        updateParticipantsSummary()
        print("🔍 [AGE_BANDS] Categories updated dynamically from API min counts")
    }
    
    
    
    // Add method to update participants summary
    private func updateParticipantsSummary() {
        participants = participantsSummary
    }
    

    func increment(for category: ParticipantCategory) {
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
        
        // Calculate total selected participants before incrementing
        let totalSelected = categories.reduce(0) { $0 + $1.count }
        
        // Ensure total doesn't exceed maxTravelersPerBooking
        if totalSelected < maxTravelersPerBooking {
            if categories[index].count < categories[index].maxLimit {
                categories[index].count += 1
                print("[DEBUG] Incremented \(categories[index].type) (bandId: \(categories[index].bandId)), new count: \(categories[index].count)")
                updateParticipantsSummary()
            }
        } else {
            print("⚠️ Cannot exceed max travelers per booking: \(maxTravelersPerBooking)")
        }
    }
 
    func decrement(for category: ParticipantCategory) {
        guard let index = categories.firstIndex(where: { $0.id == category.id }) else { return }
        if categories[index].count > 0 {
            categories[index].count -= 1
            print("[DEBUG] Decremented \(categories[index].type) (bandId: \(categories[index].bandId)), new count: \(categories[index].count)")
            participants = "\(categories[index].count) \(categories[index].type)"
        }
    }
    
    var totalSelected: Int {
        categories.reduce(0) { $0 + $1.count }
    }
    
    var canSelect: Bool {
        totalSelected <= 15
    }
    
    // Computed property to summarize selected participants
    var participantsSummary: String {
        var parts: [String] = []
        for category in categories {
            if category.count > 0 {
                let label: String
                if category.bandId.lowercased().contains("adult") {
                    label = category.count > 1 ? "Adults" : "Adult"
                } else if category.bandId.lowercased().contains("child") || category.bandId.lowercased().contains("children") {
                    label = category.count > 1 ? "Children" : "Child"
                } else if category.bandId.lowercased().contains("infant") {
                    label = category.count > 1 ? "Infants" : "Infant"
                } else {
                    label = category.bandId
                }
                parts.append("\(category.count) \(label)")
            }
        }
        if parts.isEmpty {
            // Try to get bandId from selectedPackage's first rate's pricePerAge
            if let package = selectedPackage,
               let response = self.response,
               let result = response.data?.result?.first(where: { $0.subActivityName == package.title }),
               let rate = result.rates.first,
               let bandId = rate.price.pricePerAge.first?.bandId {
                return bandId
            }
            return "No participants"
        }
        return parts.joined(separator: ", ")
    }
    
    
    // Auto-refresh availability when participants change
//    func refreshAvailabilityAfterParticipantChange() {
//        // Only refresh if we have the required data from a previous API call
//        guard let activityCode = currentActivityCode else {
//            print("🔍 [REFRESH] No activity code available, skipping auto-refresh")
//            return
//        }
//        
//        // Use stored currency code or fallback to stored response currency or "AED"
//        let currencyCode = currentCurrencyCode ?? response?.data?.result?.first?.rates.first?.price.currency ?? "AED"
//        
//        print("🔍 [REFRESH] Auto-refreshing availability due to participant/date change")
//        print("   - Activity Code: \(activityCode)")
//        print("   - Currency: \(currencyCode)")
//        print("   - Participants: \(participantsSummary)")
//        print("   - Selected Date: \(formatter.string(from: selectedDateFromCalender))")
//        
//        // Call the API with updated participant data
//        fetchAvailabilities(productCode: activityCode, currencyCode: currencyCode)
//    }
    func refreshAvailabilityAfterParticipantChange() {
        guard let activityCode = currentActivityCode else {
            print("🔍 [REFRESH] No activity code available, skipping auto-refresh")
            return
        }

        // Ensure categories exist
        if categories.isEmpty {
            if !ageBands.isEmpty {
                print("🔁 [FIX] Rebuilding categories from local ageBands")
                updateCategoriesFromAgeBands(ageBands)
            } else if !globalAgeBands.isEmpty {
                print("🔁 [FIX] Rebuilding categories from globalAgeBands")
                updateCategoriesFromAgeBands(globalAgeBands)
            } else {
                print("⚠️ No age bands available to rebuild categories")
            }
        }

        let currencyCode = currentCurrencyCode ??
            response?.data?.result?.first?.rates.first?.price.currency ?? "AED"

        print("🔍 [REFRESH] Auto-refreshing availability")
        fetchAvailabilities(productCode: activityCode, currencyCode: currencyCode)
    }

}

extension ExperienceAvailabilitySelectOptionsViewModel {
    
    func fetchAvailabilities(productCode: String, currencyCode: String) {
        guard let url = URL(string: Constants.APIURLs.availabilityUrl ) else { return }
        
        if ageBands.isEmpty && !globalAgeBands.isEmpty {
                print("🔁 [SYNC] Local ageBands was empty — syncing from globalAgeBands")
                ageBands = globalAgeBands
            }
            
        // ✅ Ensure categories are loaded before creating travelerDetails
        if categories.isEmpty {
            if !ageBands.isEmpty {
                print("🔁 [AUTO-FIX] Categories empty — rebuilding from local ageBands")
                updateCategoriesFromAgeBands(ageBands)
            } else if !globalAgeBands.isEmpty {
                print("🔁 [AUTO-FIX] Categories empty — rebuilding from globalAgeBands")
                updateCategoriesFromAgeBands(globalAgeBands)
            } else {
                print("⚠️ [AUTO-FIX] No age bands found (global or local). TravelerDetails will be empty.")
            }
        }

        // Debug: Print categories before building travelerDetails
        print("[DEBUG] Categories before building travelerDetails:")
        for cat in categories {
            print("  - \(cat.type) (bandId: \(cat.bandId)), count: \(cat.count), maxLimit: \(cat.maxLimit)")
        }
        
        // Store both activityCode and currencyCode for later use
        currentActivityCode = productCode
        currentCurrencyCode = currencyCode
        
        // Set loading to true when starting the API call
        isLoading = true
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        // Create traveler details based on selected participants using dynamic band IDs
        var travelDetails: [TravelerDetail] = []
        for category in categories {
            print("[DEBUG] Building travelerDetail for \(category.type) (bandId: \(category.bandId)), count: \(category.count)")
            if category.count > 0 {
                let ageBand = category.bandId.isEmpty ? category.type.uppercased() : category.bandId
                travelDetails.append(TravelerDetail(ageBand: ageBand, travelerCount: category.count))
            }
        }
        print("[DEBUG] Final travelerDetails array: \(travelDetails)")
        
        let requestBody = AvailabilityRequest(
            activityCode: productCode,
            currency: currencyCode,
            checkInDate: formatter.string(from: selectedDateFromCalender),
            travelerDetails: travelDetails
        )
        print("requestBody for availability \(requestBody)")
        
        print("🔍 [API REQUEST] Sending traveler details:")
        for detail in travelDetails {
            print("   - \(detail.ageBand): \(detail.travelerCount) passengers")
        }
        
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.tokenKey: ssoTokenGlobal,
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            "track_id": "eb325ead-60be-4651-b6a5-4182dcd9824f"
        ]
        
        // Pass the closure as the last argument
        NetworkManager.shared.post(
            url: url,
            body: requestBody,
            headers: headers,
            completion: { (result: Result<AvailabilityApiResponse, Error>) in
                DispatchQueue.main.async(execute: {
                    self.isLoading = false
                    switch result {
                    case .success(let data):
                        self.response = data
                        // Check for error status and code
                        if data.status == false || data.statusCode != 200 {
                            self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                            self.showErrorView = true

                        } else {
                            self.setApiResponse(self.response?.data)
                            self.showErrorView = false
                            print("🔍 [API RESPONSE] Availability data received successfully\(data)")
                        }
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                        self.showErrorView = true
                        print("Error:", error)
                    }
                })
            }
        )
    }
    
    func setApiResponse(_ responseData: AvailabilityData?) {
        guard let data = responseData else { return }
        
        avalabulityUid = data.uid ?? ""
        print(avalabulityUid)
        print("praveen avalabulityUid")
        
        let trackId = data.trackId ?? ""
        let uid = data.uid ?? ""
        print("🔍 TrackId:", trackId, "UID:", uid)
        
        guard let resultArray = data.result, !resultArray.isEmpty else {
            packages = []
            return
        }
        
        packages = resultArray.enumerated().map { index, item in
            let times = item.rates.map { $0.time }
            let firstRate = item.rates.first
            let pricingDescriptions = firstRate?.price.pricePerAge.map { "\($0.count) \($0.bandId) x AED \($0.bandTotal)" } ?? []
            let totalAmount = firstRate?.price.pricePerAge.map { $0.bandTotal }.reduce(0, +) ?? 0
            let subActivityCode = firstRate?.subActivityCode
            
            return Package(
                title: item.subActivityName,
                times: times,
                infoItems: [],
                pricingDescription: pricingDescriptions,
                totalAmount: "\(totalAmount)",
                selectedTime: nil,
                isExpanded: index == 0,
                isInfoExpanded: false,
                supplierName: nil,
                subActivityCode: subActivityCode,
                activityCode: currentActivityCode,
                availabilityKey: item.availabilityKey
            )
        }
        
        updateSelectedPackageData()
    }
    
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
        
        updateSelectedPackageData()
    }
}
