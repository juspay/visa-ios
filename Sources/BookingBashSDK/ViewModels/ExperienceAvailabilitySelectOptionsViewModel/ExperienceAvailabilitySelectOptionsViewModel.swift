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
    @Published var bandId: String = ""
    @Published var response: AvailabilityApiResponse?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasInitializedPackages: Bool = false
    var currentActivityCode: String?
    var currentCurrencyCode: String?
    @Published var ageBands: [DetailAgeBand] = []
    private let calendar = Calendar.current
    let icons = ["bolt.fill"]

    // ✅ NEW TEMP VARIABLES for bottom sheet
    @Published var tempCategories: [ParticipantCategory] = []
    @Published var tempParticipants: String = ""

    init() {
        generateMonths()
    }

    func loadDynamicAgeBands() {
        if !globalAgeBands.isEmpty && ageBands.isEmpty {
            updateCategoriesFromAgeBands(globalAgeBands)
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

    func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        calendar.isDate(d1, inSameDayAs: d2)
    }

    func selectDate() {
        refreshAvailabilityAfterParticipantChange()
    }

    func selectParticipants() {
        refreshAvailabilityAfterParticipantChange()
    }

    @Published var packages: [Package] = []
    var selectedPackage: Package? {
        return packages.first { $0.isExpanded }
    }

    func updateSelectedPackageData() {
        guard let selected = selectedPackage else {
            if let firstPackage = packages.first {
                availablityKey = firstPackage.availabilityKey ?? ""
                subActivityCode = firstPackage.subActivityCode ?? ""
            }
            return
        }
        availablityKey = selected.availabilityKey ?? ""
        subActivityCode = selected.subActivityCode ?? ""
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
        self.ageBands = ageBands
        let sortedAgeBands = ageBands.sorted { $0.sortOrder < $1.sortOrder }
        categories = sortedAgeBands.map { ageBand in
            var category = ParticipantCategory(from: ageBand)
            category.count = ageBand.minTravelersPerBooking
            return category
        }

        // ✅ Copy initial state into temp
        tempCategories = categories
        updateParticipantsSummary()
        tempParticipants = participants
    }

    private func updateParticipantsSummary() {
        participants = participantsSummary
    }

    // ✅ TEMP INCREMENT / DECREMENT (used in ParticipantSelectionView)
    func incrementTemp(for category: ParticipantCategory) {
        guard let index = tempCategories.firstIndex(where: { $0.id == category.id }) else { return }
        let totalSelected = tempCategories.reduce(0) { $0 + $1.count }
        if totalSelected < maxTravelersPerBooking {
            if tempCategories[index].count < tempCategories[index].maxLimit {
                tempCategories[index].count += 1
                tempParticipants = tempParticipantsSummary
            }
        }
    }

    func decrementTemp(for category: ParticipantCategory) {
        guard let index = tempCategories.firstIndex(where: { $0.id == category.id }) else { return }
        if tempCategories[index].count > 0 {
            tempCategories[index].count -= 1
            tempParticipants = tempParticipantsSummary
        }
    }

    // ✅ APPLY TEMP VALUES ONLY WHEN SELECT IS PRESSED
    func confirmParticipantSelection() {
        categories = tempCategories
        participants = participantsSummary
        refreshAvailabilityAfterParticipantChange()
    }

    var totalSelected: Int {
        categories.reduce(0) { $0 + $1.count }
    }

    var canSelect: Bool {
        totalSelected <= 15
    }

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
                }else if category.bandId.lowercased().contains("custom") {
                    label = "Custom"
                } else {
                    label = category.bandId
                }
                parts.append("\(category.count) \(label)")
            }
        }
        if parts.isEmpty {
            return "No participants"
        }
        return parts.joined(separator: ", ")
    }

    // ✅ TEMP SUMMARY (for showing live count in sheet)
    var tempParticipantsSummary: String {
        var parts: [String] = []
        for category in tempCategories {
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
        return parts.isEmpty ? "No participants" : parts.joined(separator: ", ")
    }

    func refreshAvailabilityAfterParticipantChange() {
        guard let activityCode = currentActivityCode else {
            return
        }
        if categories.isEmpty {
            if !ageBands.isEmpty {
                updateCategoriesFromAgeBands(ageBands)
            } else if !globalAgeBands.isEmpty {
                updateCategoriesFromAgeBands(globalAgeBands)
            }
        }
        let currencyCode = currentCurrencyCode ??
            response?.data?.result?.first?.rates.first?.price.currency ?? "AED"
        fetchAvailabilities(productCode: activityCode, currencyCode: currencyCode)
    }
}
extension ExperienceAvailabilitySelectOptionsViewModel {
    func fetchAvailabilities(productCode: String, currencyCode: String) {
        guard let url = URL(string: Constants.APIURLs.availabilityUrl ) else { return }
        if ageBands.isEmpty && !globalAgeBands.isEmpty {
                ageBands = globalAgeBands
            }
        if categories.isEmpty {
            if !ageBands.isEmpty {
                updateCategoriesFromAgeBands(ageBands)
            } else if !globalAgeBands.isEmpty {
                updateCategoriesFromAgeBands(globalAgeBands)
            }
        }
        currentActivityCode = productCode
        currentCurrencyCode = currencyCode
        isLoading = true
        formatter.dateFormat = "yyyy-MM-dd"
        var travelDetails: [TravelerDetail] = []
        for category in categories {
            if category.count > 0 {
                let ageBand = category.bandId.isEmpty ? category.type.uppercased() : category.bandId
                travelDetails.append(TravelerDetail(ageBand: ageBand, travelerCount: category.count))
            }
        }
        let requestBody = AvailabilityRequest(
            activityCode: productCode,
            currency: currencyCode,
            checkInDate: formatter.string(from: selectedDateFromCalender),
            travelerDetails: travelDetails
        )
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.tokenKey: ssoTokenGlobal,
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            Constants.APIHeaders.trackId: "eb325ead-60be-4651-b6a5-4182dcd9824f"
        ]
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
                        if data.status == false || data.statusCode != 200 {
                            self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                            self.showErrorView = true
                        } else {
                            self.setApiResponse(self.response?.data)
                            self.showErrorView = false
                        }
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                        self.showErrorView = true
                    }
                })
            }
        )
    }
    func setApiResponse(_ responseData: AvailabilityData?) {
        guard let data = responseData else { return }
        avalabulityUid = data.uid ?? ""
        let trackId = data.trackId ?? ""
        let uid = data.uid ?? ""
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
