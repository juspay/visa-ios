import Foundation

struct BookingPriceData {
    var totalAmount: Double
    var currency: String
    var taxes: Double
    var baseRate: Double
    var pricePerAge: [[String: Any]]
    var strikeout: [String: Any]?
    
    init(from priceDict: [String: Any]) {
        self.totalAmount = priceDict["total_amount"] as? Double ?? 0.0
        self.currency = priceDict["currency"] as? String ?? "AED"
        self.taxes = priceDict["taxes"] as? Double ?? 0.0
        self.baseRate = priceDict["base_rate"] as? Double ?? 0.0
        self.pricePerAge = priceDict["price_per_age"] as? [[String: Any]] ?? []
        self.strikeout = priceDict["strikeout"] as? [String: Any]
    }
}

class ExperienceBookingConfirmationViewModel: ObservableObject {
    @Published var title: String?
    @Published var location: String?
    @Published var bookingStatus: BookingStatus = .confirmed
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    var booking: Booking?
    @Published var selectedTime: String?
    @Published var cancellationSheetState: CancellationSheetState = .none
    @Published var isFetchingReasons: Bool = false
    @Published var fetchReasonsError: String? = nil
    @Published var navigateToCancellationView: Bool = false
    var shouldShowCancellationOverlay: Bool {
        cancellationSheetState != .none || isFetchingReasons || fetchReasonsError != nil
    }
    @Published var bookingTopInfo = BookingConfirmationTopInfoModel(
        image: "CheckFill",
        bookingStatus: "Booking Confirmed!",
        bookingMessage: "Congratulations! Your booking has been confirmed. You will receive your voucher shortly via email."
    )
    @Published var bookingCancelledInfo = BookingConfirmationTopInfoModel(
        image: "CheckFill",
        bookingStatus: "Cancellation Confirmed",
        bookingMessage: "Your booking is cancelled, you will receive your refund in your payment source in 2-5 working days."
    )
    @Published var bookingPendingInfo = BookingConfirmationTopInfoModel(
        image: "Pending",
        bookingStatus: "Booking Pending",
        bookingMessage: "Your experience booking is currently pending for approval. Once confirmed, you will receive further details via email. Thank you for your patience."
    )
    @Published var paymentFailedInfo = BookingConfirmationTopInfoModel(
        image: "Failed",
        bookingStatus: "Payment Failed",
        bookingMessage: "Oops! Your payment didn't go through. It looks like there was an issue during the payment process."
    )
    @Published var bookingFailedInfo = BookingConfirmationTopInfoModel(
        image: "Failed",
        bookingStatus: "Booking Failed",
        bookingMessage: "We couldn’t complete your booking. Any debited amount will be refunded within 24 hours."
    )
    @Published var supplierName: String? {
        didSet { updateContactDetails() }
    }
    @Published var supplierEmail: String = "support@supplier.com"
    @Published var supplierPhone: String = "+971 41234567"
    @Published var orderNumberForCancel: String = ""
    @Published var contactDetails: [ContactDetailsModel] = []
    @Published var currency: String = "AED"
    @Published var totalAmount: Double = 0.0
    @Published var baseRate: Double = 0.0
    @Published var taxes: Double = 0.0
    @Published var strikeoutAmount: Double = 0.0
    @Published var savingPercentage: Double = 0
    @Published var fairSummaryData: [FareItem] = []
    @Published var savingsTextforFareBreakup: String = ""
    @Published var amountPaid: Int = 0
    @Published var cancellationFee: Int = 0
    var totalRefunded: Int { amountPaid - cancellationFee }
    @Published var trackId: String?
    @Published var supplierTransactionId: String?
    @Published var bookingRef: String?
    @Published var bookingDate: String?
    @Published var travelDate: String?
    @Published var travelTime: String?
    @Published var totalTravellers: Int = 0
    @Published var totalAdults: Int = 0
    @Published var totalChildren: Int = 0
    @Published var duration: String?
    @Published var activityCode: String?
    @Published var bookingBasicDetails: [BasicBookingDetailsModel] = []
    @Published var cancellationPolicy = ConfirmationReusableInfoModel(title: "Cancellation refund policy", points: ["-"])
    @Published var leadTraveller = ConfirmationReusableInfoModel(title: "Lead Traveler", points: ["-"])
    @Published var inclusions = ConfirmationReusableInfoModel(title: "What's included?", points: ["-"])
    @Published var personContactDetails: [ContactDetailsModel] = []
    @Published var additionalInformation = ConfirmationReusableInfoModel(title: "Additional Information", points: ["Not Available"])
    @Published var exclusions = ConfirmationReusableInfoModel(title: "What's not included?", points: ["-"])
    var participantsSummary: String {
        var summary = ""
        if totalAdults > 0 {
            summary += "\(totalAdults) Adult" + (totalAdults > 1 ? "s" : "")
        }
        if totalChildren > 0 {
            if !summary.isEmpty { summary += ", " }
            summary += "\(totalChildren) Child" + (totalChildren > 1 ? "ren" : "")
        }
        if summary.isEmpty {
            summary = "No participants"
        }
        return summary
    }
    struct CancellationReasonsAPIResponse: Codable {
        let status: Bool
        let status_code: Int
        let data: [CancellationReason]
    }
    @Published var reasons: [CancellationReason] = []
    @Published var selectedReason: CancellationReason?
    init(booking: Booking? = nil, selectedTime: String? = nil) {
        self.booking = booking
        self.selectedTime = selectedTime
        if let bookingRef = booking?.bookingRef {
            fetchBookingAsJSON(orderNo: bookingRef, isFromBookingJourney: false) { [weak self] result in
                switch result {
                case .success(let json):
                    if let data = json["data"] as? [String: Any],
                       let bookingDetails = data["booking_details"] as? [String: Any],
                       let price = bookingDetails["price"] as? [String: Any] {
                        let priceData = BookingPriceData(from: price)
                        DispatchQueue.main.async {
                            self?.totalAmount = priceData.totalAmount
                            self?.currency = priceData.currency
                            self?.taxes = priceData.taxes
                            self?.baseRate = priceData.baseRate
                            self?.amountPaid = Int(round(priceData.totalAmount))
                            if let strikeout = priceData.strikeout,
                               let strikeoutTotal = strikeout["total_amount"] as? Double {
                                self?.strikeoutAmount = strikeoutTotal
                                self?.savingPercentage = strikeout["saving_percentage"] as? Double ?? 0.0
                            }
                        }
                    }
                case .failure:
                    break
                }
            }
        }
    }
    private func updateContactDetails() {
        let supplier = supplierName ?? "Unknown Supplier"
        contactDetails = [
            ContactDetailsModel(keyIcon: "UserGray", value: supplier),
            ContactDetailsModel(keyIcon: "Frame", value: supplierEmail),
            ContactDetailsModel(keyIcon: "mobile", value: supplierPhone)
        ]
    }
    func fetchBookingStatus(orderNo: String, siteId: String, isFromBookingJourney: Bool = true) {
        orderNumberForCancel = orderNo
        guard !orderNo.isEmpty else {
            return
        }
        self.isLoading = true
        let urlString = isFromBookingJourney ? Constants.APIURLs.bookStatusURL : Constants.APIURLs.bookingDetailsURL
        guard let url = URL(string: urlString) else {
            return
        }
        let requestBody: Codable
        if isFromBookingJourney {
            requestBody = ConfirmationRequest(orderNo: orderNo)
        } else {
            requestBody = BookingDetailsRequest(bookingId: orderNo)
        }
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
           Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
           Constants.APIHeaders.siteId: ssoSiteIdGlobal,
           Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<SuccessPageResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    guard response.status else {
                        self.errorMessage = " Invalid response: Status = false"
                        return
                    }
                    if let product = response.data?.bookingDetails?.productInfo {
                        self.processProductInfo(product: product, bookingDetails: response.data?.bookingDetails)
                    } 
                    if let traveller = response.data?.bookingDetails?.travellerInfo ?? response.data?.travellerInfo {
                        self.processTravellerInfo(traveller: traveller)
                    }
                    if let bookingDetails = response.data?.bookingDetails {
                        self.processBookingDetails(bookingDetails: bookingDetails)
                    }
                    self.updateFareSummary()
                    self.cancellationFee = 0
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    private func processProductInfo(product: SuccessProductInfo, bookingDetails: SuccessBookingDetails?) {
        self.title = product.title ?? "-"
        self.location = "\(product.city ?? "-") - \(product.country ?? "-")"
        self.trackId = bookingDetails?.trackId ?? "-"
        self.activityCode = product.activityCode ?? "-"
        if let price = product.price {
            self.currency = price.currency ?? ""
            self.baseRate = price.baseRate ?? 0
            self.taxes = price.taxes ?? 0
            self.totalAmount = price.totalAmount ?? 0
            if let strikeout = price.strikeout {
                self.strikeoutAmount = strikeout.totalAmount ?? 0
                self.savingPercentage = strikeout.savingPercentage ?? 0
            } else {
                self.strikeoutAmount = 0
                self.savingPercentage = 0
            }
        }
        let supplierValue = product.supplier?.name ?? "Unknown Supplier"
        let supplierEmail = product.supplier?.email ?? ""
        let supplierPhone = product.supplier?.phone ?? ""
        self.supplierName = supplierValue
        self.contactDetails = [
            ContactDetailsModel(keyIcon: "UserGray", value: supplierValue),
            ContactDetailsModel(keyIcon: "Frame", value: supplierEmail),
            ContactDetailsModel(keyIcon: "mobile", value: supplierPhone),
        ]
        if let inclusionsArray = product.inclusions {
            let points = inclusionsArray.map { $0.otherDescription ?? "-" }
            self.inclusions = ConfirmationReusableInfoModel(
                title: "What's included?",
                points: points.isEmpty ? ["Not available"] : points
            )
        } else {
            self.inclusions = ConfirmationReusableInfoModel(
                title: "What's included?",
                points: ["-"]
            )
        }
        if let exclusionsArray = product.exclusions {
            let points = exclusionsArray.map { $0.otherDescription ?? "-" }
            self.exclusions = ConfirmationReusableInfoModel(
                title: "What's Not Included?",
                points: points.isEmpty ? ["Not available"] : points
            )
        } else {
            self.exclusions = ConfirmationReusableInfoModel(
                title: "What's Not Included?",
                points: ["-"]
            )
        }
        self.additionalInformation = ConfirmationReusableInfoModel(
            title: "Additional Information",
            points: product.additionalInfo?.compactMap { $0.description } ?? []
        )
        let cancellationPolicyText = product.cancellationPolicy?.description ??
        "Tickets are non-cancellable, non-refundable and non-transferable."
        self.cancellationPolicy = ConfirmationReusableInfoModel(
            title: "Cancellation refund policy",
            points: [cancellationPolicyText]
        )
        let languageName = product.languageDetails?.name ?? "English"
    }
    private func processTravellerInfo(traveller: SuccessTravellerInfo) {
        self.travelDate = self.formatTravelDate(from: traveller.travelDate ?? "")
        self.totalTravellers = traveller.totalTraveller ?? 0
        self.totalAdults = traveller.totalAdult ?? 0
        self.totalChildren = traveller.totalChild ?? 0
        let leadName = [traveller.title, traveller.firstName, traveller.lastName]
            .compactMap { $0 }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
        self.leadTraveller = ConfirmationReusableInfoModel(
            title: "Lead Traveler",
            points: [leadName.isEmpty ? "-" : leadName]
        )
        let travellerNumber = traveller.mobile
        self.personContactDetails = [
            ContactDetailsModel(keyIcon: "Frame", value: "reservations@bookingbash.com"),
            ContactDetailsModel(keyIcon: "mobile", value: "+97148348696")
        ]
    }
    private func processBookingDetails(bookingDetails: SuccessBookingDetails) {
        let bookingDate = self.formatBookingDate(from: bookingDetails.createdAt ?? "")
        let bookingRef = bookingDetails.bookingRef ?? ""
        let bookingId = bookingDetails.orderNo ?? "-"
        var details: [BasicBookingDetailsModel] = [
            BasicBookingDetailsModel(key: "Booking ID", value: bookingId),
            BasicBookingDetailsModel(key: "Booking Date", value: bookingDate)
        ]
        if !bookingRef.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        details.insert(BasicBookingDetailsModel(key: "Voucher ID", value: bookingRef), at: 1)
        }
        self.bookingBasicDetails = details
        if let status = bookingDetails.bookingStatus?.uppercased() {
            switch status {
            case "CONFIRMED":
                self.bookingStatus = .confirmed
            case "PENDING":
                self.bookingStatus = .bookingPending
            case "FAILED":
                self.bookingStatus = .bookingFailed
            case "CANCELLED":
                self.bookingStatus = .cancelled
            case "PAYMENT_FAILED":
                self.bookingStatus = .paymentfailed
            default:
                self.bookingStatus = .confirmed
            }
        }
    }
    private func updateFareSummary() {
        fetchBookingAsJSON(orderNo: orderNumberForCancel, isFromBookingJourney: false) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let json):
                guard let data = json["data"] as? [String: Any],
                      let bookingDetails = data["booking_details"] as? [String: Any],
                      let price = bookingDetails["price"] as? [String: Any] else {
                    return
                }
                DispatchQueue.main.async {
                    self.fairSummaryData.removeAll()
                    let priceData = BookingPriceData(from: price)
                    self.totalAmount = priceData.totalAmount
                    self.currency = priceData.currency
                    self.taxes = priceData.taxes
                    self.baseRate = priceData.baseRate
                    self.amountPaid = Int(round(priceData.totalAmount))
                    if let strikeout = priceData.strikeout,
                       let strikeoutTotal = strikeout["total_amount"] as? Double {
                        self.strikeoutAmount = strikeoutTotal
                        self.savingPercentage = strikeout["saving_percentage"] as? Double ?? 0.0
                    }
                    if !priceData.pricePerAge.isEmpty {
                        for item in priceData.pricePerAge {
                            if let bandId = item["band_id"] as? String,
                               let count = item["count"] as? Int,
                               let bandTotal = item["band_total"] as? Double,
                               let perPriceTraveller = item["per_price_traveller"] as? Double {
                                let descriptionText = count > 1
                                    ? "\(bandId.capitalized)s"
                                    : bandId.capitalized
                                let leftText = "\(count) \(descriptionText) x \(priceData.currency) \( perPriceTraveller)"
                                let rightText = "\(priceData.currency) \(String(format: "%.2f", bandTotal))"
                                self.fairSummaryData.append(
                                    FareItem(title: leftText, value: rightText, isDiscount: false)
                                )
                            }
                        }
                    } else {
                        if priceData.baseRate > 0 {
                            let leftText = "Base Rate"
                            let rightText = "\(priceData.currency) \(String(format: "%.2f", priceData.baseRate))"
                            self.fairSummaryData.append(
                                FareItem(title: leftText, value: rightText, isDiscount: false)
                            )
                        }
                    }
                    if priceData.taxes > 0 {
                        self.fairSummaryData.append(FareItem(
                            title: "Taxes and fees",
                            value: "\(priceData.currency) \(String(format: "%.2f", priceData.taxes))",
                            isDiscount: false
                        ))
                    }
                    if let strikeout = priceData.strikeout,
                       let originalAmount = strikeout["total_amount"] as? Double,
                       originalAmount > priceData.totalAmount {
                        let discountAmount = originalAmount - priceData.totalAmount
                        self.fairSummaryData.append(FareItem(
                            title: "Discount",
                            value: "- \(priceData.currency) \(String(format: "%.2f", discountAmount))",
                            isDiscount: true
                        ))
                        self.savingsTextforFareBreakup = "You are saving \(priceData.currency) \(String(format: "%.2f", discountAmount))"
                    } else {
                        self.fairSummaryData.append(FareItem(
                            title: "Discount",
                            value: "- \(priceData.currency) 0.00",
                            isDiscount: true
                        ))
                        self.savingsTextforFareBreakup = "You are saving \(priceData.currency) 0.00"
                    }
                }
            case .failure:
                break
            }
        }
    }
    func formatBookingDate(from timestamp: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: timestamp) {
            return formatDate(date: date)
        }
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let fallbackDate = isoFormatter.date(from: timestamp) {
            return formatDate(date: fallbackDate)
        }
        return "-"
    }
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy"
        return formatter.string(from: date)
    }
    func formatTravelDate(from dateString: String) -> String {
        let possibleFormats = [
            "yyyy-MM-dd",
            "dd/MM/yyyy",
            "MM/dd/yyyy",
            "yyyy-MM-dd HH:mm:ss",
            "dd-MM-yyyy",
            "yyyy/MM/dd"
        ]
        for format in possibleFormats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = format
            formatter.timeZone = TimeZone.current
            if let date = formatter.date(from: dateString) {
                let displayFormatter = DateFormatter()
                displayFormatter.locale = Locale(identifier: "en_US_POSIX")
                displayFormatter.dateFormat = "EEE, dd MMM yyyy"
                return displayFormatter.string(from: date)
            }
        }
        return dateString.isEmpty ? "-" : dateString
    }
    func fetchCancellationReasons(orderNo: String, completion: (() -> Void)? = nil) {
        guard let url = URL(string: Constants.APIURLs.cancelReasonURL) else {
            self.errorMessage = "Invalid URL for cancellation reasons"
            completion?()
            return
        }
        let requestBody = ["order_no": orderNo]
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<CancellationReasonsAPIResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status {
                        self.reasons = response.data
                    } else {
                        self.errorMessage = "Failed to fetch cancellation reasons."
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                completion?()
            }
        }
    }
    func retryFetchingReasons(orderNo: String) {
        fetchCancellationReasons(orderNo: orderNo, completion: nil)
    }
    struct CancelBookingAPIResponse: Codable {
        let status: Bool
        let status_code: Int
        let data: CancelBookingData?
    }
    struct CancelBookingData: Codable {
        let booking_id: String?
        let status: String?
        let track_id: String?
        let order_no: String?
        let booking_status: String?
        let updated_at: String?
    }
    func cancelBooking(orderNoo: String, siteId: String, reasonCode: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constants.APIURLs.cancelBookingURL) else {
            self.errorMessage = "Invalid URL for cancel booking"
            completion(false)
            return
        }
        let requestBody = [
            "order_no": orderNumberForCancel,
            "reason_code": reasonCode
        ]
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.tokenKey: ssoTokenGlobal,
            Constants.APIHeaders.siteId: siteId
        ]
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<CancelBookingAPIResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status, let data = response.data, data.booking_status == "CANCELLED" {
                        self.bookingStatus = .cancelled
                        self.bookingCancelledInfo = BookingConfirmationTopInfoModel(
                            image: "CheckFill",
                            bookingStatus: "Cancellation Confirmed",
                            bookingMessage: "Your booking is cancelled, you will receive your refund in your payment source in 2-5 working days."
                        )
                        completion(true)
                    } else {
                        self.errorMessage = "Failed to cancel booking."
                        completion(false)
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    func proceedToCancelBooking() {
        cancellationSheetState = .bottomSheet
    }
    func confirmCancellation() {
        navigateToCancellationView = true
    }
    func resetCancellationState() {
        cancellationSheetState = .none
        isFetchingReasons = false
        fetchReasonsError = nil
    }
    func fetchBookingAsJSON(orderNo: String, isFromBookingJourney: Bool = true, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let urlString = isFromBookingJourney ? Constants.APIURLs.bookStatusURL : Constants.APIURLs.bookingDetailsURL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        let requestBody: [String: String]
        if isFromBookingJourney {
            requestBody = ["order_no": orderNo]
        } else {
            requestBody = ["booking_id": orderNo]
        }
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(error))
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                }
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    DispatchQueue.main.async {
                        completion(.success(json))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Invalid JSON format", code: -1, userInfo: nil)))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
