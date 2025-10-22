import Foundation

// MARK: - Simple model to hold booking price data from JSON
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
    // MARK: - Basic booking info
    @Published var title: String?
    @Published var location: String?
    @Published var bookingStatus: BookingStatus = .confirmed
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    var booking: Booking?
    
    // MARK: - Cancellation / Sheet state
    @Published var cancellationSheetState: CancellationSheetState = .none
    @Published var isFetchingReasons: Bool = false
    @Published var fetchReasonsError: String? = nil
    @Published var navigateToCancellationView: Bool = false
    
    var shouldShowCancellationOverlay: Bool {
        cancellationSheetState != .none || isFetchingReasons || fetchReasonsError != nil
    }
    
    // MARK: - Top info models
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
        bookingMessage: "Oops, your booking failed. It seems something went wrong during the booking process."
    )
    
    // MARK: - Supplier / contact
    @Published var supplierName: String? {
        didSet { updateContactDetails() }
    }
    @Published var supplierEmail: String = "support@supplier.com"
    @Published var supplierPhone: String = "+971 41234567"
    @Published var orderNumberForCancel: String = ""
    @Published var contactDetails: [ContactDetailsModel] = []
    
    // MARK: - Pricing / fare
    @Published var currency: String = "AED"
    @Published var totalAmount: Double = 0.0
    @Published var baseRate: Double = 0.0
    @Published var taxes: Double = 0.0
    @Published var strikeoutAmount: Double = 0.0
    @Published var savingPercentage: Double = 0
    @Published var fairSummaryData: [FareItem] = []
    @Published var savingsTextforFareBreakup: String = ""
    
    // Cancellation numeric values
    @Published var amountPaid: Int = 0
    @Published var cancellationFee: Int = 0
    var totalRefunded: Int { amountPaid - cancellationFee }
    
    // Booking / traveler details
    @Published var trackId: String?
    @Published var supplierTransactionId: String?
    @Published var bookingRef: String?
    @Published var bookingDate: String?
    @Published var travelDate: String?
    @Published var totalTravellers: Int = 0
    @Published var totalAdults: Int = 0
    @Published var totalChildren: Int = 0
    @Published var duration: String?
    @Published var activityCode: String?
    
    // Sections (confirmation cards)
    @Published var bookingBasicDetails: [BasicBookingDetailsModel] = []
    @Published var cancellationPolicy = ConfirmationReusableInfoModel(title: "Cancellation refund policy", points: ["-"])
    @Published var leadTraveller = ConfirmationReusableInfoModel(title: "Lead Traveler", points: ["-"])
    @Published var inclusions = ConfirmationReusableInfoModel(title: "What includes?", points: ["-"])
    @Published var OtherDetails = ConfirmationReusableInfoModel(title: "Other Details", points: ["-"])
    @Published var personContactDetails: [ContactDetailsModel] = []
    @Published var additionalInformation = ConfirmationReusableInfoModel(title: "Additional Information", points: ["-"])
    @Published var exclusions = ConfirmationReusableInfoModel(title: "What's Not Included?", points: ["-"])
    
    // MARK: - Cancellation reasons
    struct CancellationReasonsAPIResponse: Codable {
        let status: Bool
        let status_code: Int
        let data: [CancellationReason]
    }
    @Published var reasons: [CancellationReason] = []
    @Published var selectedReason: CancellationReason?
    
    // MARK: - Init
    init(booking: Booking? = nil) {
        self.booking = booking
        print("BookingConfirmationVM init booking:", booking?.bookingRef ?? "nil")
        
        // Call fetchBookingAsJSON if we have a booking reference
        if let bookingRef = booking?.bookingRef {
            fetchBookingAsJSON(orderNo: bookingRef, isFromBookingJourney: false) { [weak self] result in
                switch result {
                case .success(let json):
                    print("✅ Raw JSON received in init:", json)
                    // Extract and set price data for confirmation page using BookingPriceData model
                    if let data = json["data"] as? [String: Any],
                       let bookingDetails = data["booking_details"] as? [String: Any],
                       let price = bookingDetails["price"] as? [String: Any] {
                        
                        // Use the BookingPriceData model to cleanly extract all price info
                        let priceData = BookingPriceData(from: price)
                        
                        DispatchQueue.main.async {
                            // Update all price-related properties for confirmation page
                            self?.totalAmount = priceData.totalAmount
                            self?.currency = priceData.currency
                            self?.taxes = priceData.taxes
                            self?.baseRate = priceData.baseRate
                            self?.amountPaid = Int(round(priceData.totalAmount))
                            
                            // Update strikeout if available
                            if let strikeout = priceData.strikeout,
                               let strikeoutTotal = strikeout["total_amount"] as? Double {
                                self?.strikeoutAmount = strikeoutTotal
                                self?.savingPercentage = strikeout["saving_percentage"] as? Double ?? 0.0
                            }
                            
                            print("💰 [INIT] BookingPriceData applied successfully:")
                            print("   - Total Amount: \(priceData.totalAmount)")
                            print("   - Currency: \(priceData.currency)")
                            print("   - Taxes: \(priceData.taxes)")
                            print("   - Amount Paid: \(self?.amountPaid ?? 0)")
                        }
                    } else {
                        print("⚠️ [INIT] Could not extract price data from JSON")
                    }
                case .failure(let error):
                    print("❌ Error fetching JSON in init:", error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Internal helpers
    private func updateContactDetails() {
        let supplier = supplierName ?? "Unknown Supplier"
        contactDetails = [
            ContactDetailsModel(keyIcon: "UserGray", value: supplier),
            ContactDetailsModel(keyIcon: "Frame", value: supplierEmail),
            ContactDetailsModel(keyIcon: "Mobile", value: supplierPhone)
        ]
    }
    
    // MARK: - Fetch booking status
    func fetchBookingStatus(orderNo: String, siteId: String, isFromBookingJourney: Bool = true) {
        print("fetchBookingStatus called. VM booking:", booking?.bookingRef ?? "nil")
        orderNumberForCancel = orderNo
        print(isFromBookingJourney)
        
        guard !orderNo.isEmpty else {
            print(" Order number is empty — skipping API call.")
            return
        }
        
        // Set loading state to true
        self.isLoading = true
        
        // Choose URL based on isFromBookingJourney parameter
        let urlString = isFromBookingJourney ? Constants.APIURLs.bookStatusURL : Constants.APIURLs.bookingDetailsURL
        guard let url = URL(string: urlString) else {
            print(" Invalid URL for booking status")
            return
        }
        
        // Choose request body based on isFromBookingJourney parameter
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
                // Set loading to false when API call completes
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    guard response.status else {
                        self.errorMessage = " Invalid response: Status = false"
                        print("Booking response status false:", response)
                        return
                    }
                    
                    // PRODUCT INFO
                    if let product = response.data?.bookingDetails?.productInfo {
                        self.processProductInfo(product: product, bookingDetails: response.data?.bookingDetails)
                    } else {
                        print(" No product info found in response")
                    }
                    
                    // TRAVELLER INFO
                    if let traveller = response.data?.bookingDetails?.travellerInfo ?? response.data?.travellerInfo {
                        self.processTravellerInfo(traveller: traveller)
                    } else {
                        print("⚠️ No traveller info found in response")
                    }
                    
                    // BOOKING DETAILS
                    if let bookingDetails = response.data?.bookingDetails {
                        self.processBookingDetails(bookingDetails: bookingDetails)
                    }
                    
                    // FARE SUMMARY
                    self.updateFareSummary()
                    
                    // Note: amountPaid and totalAmount are set inside updateFareSummary()
                    // Don't set them here to avoid overwriting with old values
                    self.cancellationFee = 0
                    
                    print(" Booking data updated successfully")
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(" Booking status fetch failed:", error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Product processing
    private func processProductInfo(product: SuccessProductInfo, bookingDetails: SuccessBookingDetails?) {
        // Basic fields
        self.title = product.title ?? "-"
        self.location = "\(product.city ?? "-") - \(product.country ?? "-")"
        self.trackId = bookingDetails?.trackId ?? "-"
        self.activityCode = product.activityCode ?? "-"
        
        // Price info
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
        } else {
            print("⚠️ No pricing info found in response")
        }
        
        // Supplier info
        let supplierValue = product.providerSupplierName ?? "Unknown Supplier"
        self.supplierName = supplierValue
        // keep at least one contact detail as in original code (didSet on supplierName also updates contactDetails)
        self.contactDetails = [
            ContactDetailsModel(keyIcon: "UserGray", value: supplierValue),
        ]
        
        // INCLUSIONS
        if let inclusionsArray = product.inclusions {
            let points = inclusionsArray.map { $0.otherDescription ?? "-" }
            self.inclusions = ConfirmationReusableInfoModel(
                title: "What includes?",
                points: points.isEmpty ? ["Not available"] : points
            )
        } else {
            self.inclusions = ConfirmationReusableInfoModel(
                title: "What includes?",
                points: ["-"]
            )
        }
        
        // EXCLUSIONS
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
        
        // ADDITIONAL INFORMATION (display type values)
        self.additionalInformation = ConfirmationReusableInfoModel(
            title: "Additional Information",
            points: product.additionalInfo?.isEmpty == false
            ? product.additionalInfo!.compactMap { $0.type ?? "-" }
            : ["-"]
        )
        
        // Cancellation Policy
        let cancellationPolicyText = product.cancellationPolicy?.description ??
        "Tickets are non-cancellable, non-refundable and non-transferable."
        self.cancellationPolicy = ConfirmationReusableInfoModel(
            title: "Cancellation refund policy",
            points: [cancellationPolicyText]
        )
        
        // Other details: language
        let languageName = product.languageDetails?.name ?? "English"
        self.OtherDetails = ConfirmationReusableInfoModel(
            title: "Other Details",
            points: [
                "Tour language: \(languageName)"
            ]
        )
    }
    
    // MARK: - Traveller processing
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
            ContactDetailsModel(keyIcon: "UserGray", value: leadName),
            ContactDetailsModel(keyIcon: "Mobile", value: travellerNumber ?? "Not available")
        ]
    }
    
    // MARK: - Booking details processing
    private func processBookingDetails(bookingDetails: SuccessBookingDetails) {
        let bookingDate = self.formatBookingDate(from: bookingDetails.createdAt ?? "")
        let bookingref = bookingDetails.bookingRef ?? "-"
        let bookingId = bookingDetails.orderNo ?? "-"
        let voucherId = "ABCDLHRS31117"
        
        self.bookingBasicDetails = [
            BasicBookingDetailsModel(key: "Booking ID", value: bookingId),
            BasicBookingDetailsModel(key: "Voucher ID", value: bookingref),
            BasicBookingDetailsModel(key: "Booking Date", value: bookingDate)
        ]
        
        // Update booking status based on API response
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
                print("⚠️ Unknown booking status: \(status)")
                // Default to confirmed if status is unknown
                self.bookingStatus = .confirmed
            }
            print("✅ Booking status set to: \(self.bookingStatus)")
        }
    }
    
    // MARK: - Fare summary update
    private func updateFareSummary() {
        fetchBookingAsJSON(orderNo: orderNumberForCancel, isFromBookingJourney: false) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let json):
                print("🔍 [CONFIRMATION] ========== Processing Fare Summary ==========")
                
                // Extract price data from JSON
                guard let data = json["data"] as? [String: Any],
                      let bookingDetails = data["booking_details"] as? [String: Any],
                      let price = bookingDetails["price"] as? [String: Any] else {
                    print("❌ [CONFIRMATION] Could not extract price data from JSON")
                    return
                }
                
                print("✅ [CONFIRMATION] Price data found")
                
                // Clear existing fare summary
                DispatchQueue.main.async {
                    self.fairSummaryData.removeAll()
                    
                    // Extract price components using BookingPriceData model
                    let priceData = BookingPriceData(from: price)
                    
                    // Update all price properties for transaction flow
                    self.totalAmount = priceData.totalAmount
                    self.currency = priceData.currency
                    self.taxes = priceData.taxes
                    self.baseRate = priceData.baseRate
                    self.amountPaid = Int(round(priceData.totalAmount))
                    
                    // Update strikeout if available
                    if let strikeout = priceData.strikeout,
                       let strikeoutTotal = strikeout["total_amount"] as? Double {
                        self.strikeoutAmount = strikeoutTotal
                        self.savingPercentage = strikeout["saving_percentage"] as? Double ?? 0.0
                    }
                    
                    print("💰 [CONFIRMATION] BookingPriceData applied from transaction flow:")
                    print("   - Total Amount: \(priceData.totalAmount)")
                    print("   - Currency: \(priceData.currency)")
                    print("   - Amount Paid: \(self.amountPaid)")
                    
                    // Process pricePerAge array
                    if !priceData.pricePerAge.isEmpty {
                        print("🔍 [CONFIRMATION] Found pricePerAge array with \(priceData.pricePerAge.count) items")
                        
                        for item in priceData.pricePerAge {
                            if let bandId = item["band_id"] as? String,
                               let count = item["count"] as? Int,
                               let bandTotal = item["band_total"] as? Double,
                               let perPriceTraveller = item["per_price_traveller"] as? Double {
                                
                                let descriptionText = count > 1
                                    ? "\(bandId.capitalized)s"
                                    : bandId.capitalized
                                
                                let leftText = "\(count) \(descriptionText) x \(priceData.currency) \(String(format: "%.1f", perPriceTraveller))"
                                let rightText = "\(priceData.currency) \(String(format: "%.2f", bandTotal))"
                                
                                self.fairSummaryData.append(
                                    FareItem(title: leftText, value: rightText, isDiscount: false)
                                )
                                
                                print("✅ [CONFIRMATION] Added Fare Item → \(leftText) = \(rightText)")
                            } else {
                                print("⚠️ [CONFIRMATION] Skipped one price item because of missing data: \(item)")
                            }
                        }
                    } else {
                        print("⚠️ [CONFIRMATION] No pricePerAge data found, using fallback")
                        // Fallback to base rate if pricePerAge is not available
                        if priceData.baseRate > 0 {
                            let leftText = "Base Rate"
                            let rightText = "\(priceData.currency) \(String(format: "%.2f", priceData.baseRate))"
                            self.fairSummaryData.append(
                                FareItem(title: leftText, value: rightText, isDiscount: false)
                            )
                            print("✅ [CONFIRMATION] Added base rate fare item: \(leftText) = \(rightText)")
                        }
                    }
                    
                    // Add taxes if available and greater than 0
                    if priceData.taxes > 0 {
                        self.fairSummaryData.append(FareItem(
                            title: "Taxes and fees",
                            value: "\(priceData.currency) \(String(format: "%.2f", priceData.taxes))",
                            isDiscount: false
                        ))
                        print("🔍 [CONFIRMATION] ✅ Added taxes fare item: \(priceData.currency) \(String(format: "%.2f", priceData.taxes))")
                    }
                    
                    // Process discount if strikeout exists
                    if let strikeout = priceData.strikeout,
                       let originalAmount = strikeout["total_amount"] as? Double,
                       originalAmount > priceData.totalAmount {
                        
                        let discountAmount = originalAmount - priceData.totalAmount
                        self.fairSummaryData.append(FareItem(
                            title: "Discount",
                            value: "- \(priceData.currency) \(String(format: "%.2f", discountAmount))",
                            isDiscount: true
                        ))
                        
                        // Set the savings text
                        self.savingsTextforFareBreakup = "You are saving \(priceData.currency) \(String(format: "%.2f", discountAmount))"
                        print("🔍 [CONFIRMATION] ✅ Added discount fare item: - \(priceData.currency) \(String(format: "%.2f", discountAmount))")
                        print("🔍 [CONFIRMATION] ✅ Savings text: \(self.savingsTextforFareBreakup)")
                    } else {
                        // No discount
                        self.fairSummaryData.append(FareItem(
                            title: "Discount",
                            value: "- \(priceData.currency) 0.00",
                            isDiscount: true
                        ))
                        
                        // Set empty savings text
                        self.savingsTextforFareBreakup = "You are saving \(priceData.currency) 0.00"
                        print("🔍 [CONFIRMATION] ⚪ No strikeout price, added default discount item")
                    }
                    
                    print("🔍 [CONFIRMATION] Final fairSummaryData count: \(self.fairSummaryData.count)")
                    for (index, item) in self.fairSummaryData.enumerated() {
                        print("🔍 [CONFIRMATION] Fare item [\(index)]: \(item.title) = \(item.value)")
                    }
                    print("🔍 [CONFIRMATION] ========================================")
                }
                
            case .failure(let error):
                print("❌ [CONFIRMATION] Error fetching fare summary JSON:", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Date formatting helpers
    func formatBookingDate(from timestamp: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: timestamp) {
            return formatDate(date: date)
        }
        // try fallback
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
    
    // MARK: - Fetch Cancellation Reasons
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
            Constants.APIHeaders.tokenKey: encryptedPayloadMain
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
    
    // MARK: - Cancel booking API
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
            Constants.APIHeaders.tokenKey: encryptedPayloadMain,
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
    
    // MARK: - Helper methods used by the View
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
    
    // MARK: - Generic JSON Fetcher
    /// Fetches booking data as raw JSON without any model mapping
    /// - Parameters:
    ///   - orderNo: The order number or booking ID
    ///   - isFromBookingJourney: If true, uses book status URL, otherwise uses booking details URL
    ///   - completion: Returns the raw JSON dictionary or an error
    func fetchBookingAsJSON(orderNo: String, isFromBookingJourney: Bool = true, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Choose URL based on isFromBookingJourney parameter
        let urlString = isFromBookingJourney ? Constants.APIURLs.bookStatusURL : Constants.APIURLs.bookingDetailsURL
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Prepare request body
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
        
        // Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Make the request
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
                // Parse as raw JSON dictionary
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    // Print booking_details.price
                    if let data = json["data"] as? [String: Any],
                       let bookingDetails = data["booking_details"] as? [String: Any],
                       let price = bookingDetails["price"] as? [String: Any] {
                        print("📊 booking_details.price:")
                        print(price)
                        
                        // Pretty print the price object
                        if let priceData = try? JSONSerialization.data(withJSONObject: price, options: .prettyPrinted),
                           let priceString = String(data: priceData, encoding: .utf8) {
                            print("💰 Formatted price:\n\(priceString)")
                        }
                    } else {
                        print("⚠️ Could not find booking_details.price in JSON response")
                    }
                    
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
