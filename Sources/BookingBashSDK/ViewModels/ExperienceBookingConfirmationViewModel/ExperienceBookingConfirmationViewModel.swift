import Foundation

class ExperienceBookingConfirmationViewModel: ObservableObject {
    @Published var title: String?
    @Published var location: String? = nil
    @Published var bookingStatus: BookingStatus = .confirmed
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    var booking: Booking?
    @Published var selectedTime: String?
    @Published var showToast: Bool = false
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
    @Published var bookingRefundedInfo = BookingConfirmationTopInfoModel(
        image: "CheckFill",
        bookingStatus: "Refund Successful",
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
    @Published var supplierName: String? {
        didSet { updateContactDetails() }
    }
    @Published var supplierEmail: String = ""
    @Published var supplierPhone: String = ""
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
    @Published var amountPaid: Double = 0.00
    @Published var trackId: String?
    @Published var supplierTransactionId: String?
    @Published var bookingRef: String?
    @Published var bookingDate: String?
    @Published var travelDate: String?
    @Published var travelTime: String?
    @Published var totalTravellers: Int = 0
//    @Published var totalAdults: Int = 0
//    @Published var totalChildren: Int = 0
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
        guard let pricePerAge = bookingDetailsResponse?.data?.bookingDetails?.price?.pricePerAge else {
            return "No participants"
        }

        // Map each band to readable text
        let parts: [String] = pricePerAge.compactMap { item in
            guard item.count > 0 else { return nil }

            let label: String

            switch item.bandId.uppercased() {
            case "ADULT":
                label = item.count == 1 ? "Adult" : "Adults"
            case "CHILD":
                label = item.count == 1 ? "Child" : "Children"
            case "INFANT":
                label = item.count == 1 ? "Infant" : "Infants"
            case "FAMILY":
                label = item.count == 1 ? "Family" : "Families"
            case "PERSON":
                label = item.count == 1 ? "Person" : "People"
            case "CUSTOM":
                label = "Custom"
            default:
                label = item.count == 1 ? item.bandId.capitalized : "\(item.bandId.capitalized)s"
            }

            return "\(item.count) \(label)"
        }

        return parts.isEmpty ? "No participants" : parts.joined(separator: ", ")
    }
    @Published var toastMessage: String = ""
    @Published var reasons: [CancellationReason] = []
    @Published var selectedReason: CancellationReason?
    @Published var preCancelbookingResponse: PreCancelBookingResponse? = nil
    @Published var bookingDetailsResponse: BookingDetailsResponse? = nil
  
    init(booking: Booking? = nil, selectedTime: String? = nil) {
        self.booking = booking
        self.selectedTime = selectedTime
    }

    private func updateContactDetails() {
        contactDetails.removeAll()

        let hasEmail = !supplierEmail.isEmpty
        let hasPhone = !supplierPhone.isEmpty

        // Show name only if email or phone exists
        if (hasEmail || hasPhone),
           let supplierName = supplierName,
           !supplierName.isEmpty {
            contactDetails.append(
                ContactDetailsModel(keyIcon: "UserGray", value: supplierName)
            )
        }
        if hasEmail {
            contactDetails.append(
                ContactDetailsModel(keyIcon: "Frame", value: supplierEmail)
            )
        }
        if hasPhone {
            contactDetails.append(
                ContactDetailsModel(keyIcon: "mobile", value: supplierPhone)
            )
        }
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
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<BookingDetailsResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    guard response.status else {
                        self.errorMessage = " Invalid response: Status = false"
                        return
                    }
                    self.bookingDetailsResponse = response
                    if let product = response.data?.bookingDetails?.productInfo {
                        self.processProductInfo(product: product, bookingDetails: response.data?.bookingDetails)
                    }
                    if let traveller = response.data?.bookingDetails?.travellerInfo ?? response.data?.travellerInfo {
                        self.processTravellerInfo(traveller: traveller)
                    }
                    if let bookingDetails = response.data?.bookingDetails {
                        self.processBookingDetails(bookingDetails: bookingDetails)
                        self.updateFareSummary(priceData: bookingDetails.price)
                    }

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    private func processProductInfo(product: SuccessProductInfo, bookingDetails: SuccessBookingDetails?) {
        self.title = product.title ?? "-"
        if let city = product.city, !city.isEmpty , let country = product.country, !country.isEmpty {
            self.location = "\(city) - \(country)"
        }
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
        self.supplierName = product.supplier?.name ?? ""
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
        self.travelDate = traveller.travelDate?.formattedTravelDate() ?? ""
        self.totalTravellers = traveller.totalTraveller ?? 0
//        self.totalAdults = traveller.totalAdult ?? 0
//        self.totalChildren = traveller.totalChild ?? 0
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
            case "CONFIRMED", "PENDING":
                self.bookingStatus = .confirmed
            case "FAILED":
                self.bookingStatus = .bookingFailed
            case "CANCELLED":
                self.bookingStatus = .cancelled
            case "PAYMENT_FAILED":
                self.bookingStatus = .paymentfailed
            case "REFUNDED":
                self.bookingStatus = .refunded
            default:
                self.bookingStatus = .bookingFailed
            }
        }
    }
    
    private func updateFareSummary(priceData: SuccessProductPrice?) {
        self.fairSummaryData.removeAll()
        let currency = priceData?.currency ?? "AED"
        self.totalAmount = priceData?.totalAmount ?? 0.0
        self.currency = currency
        self.taxes = priceData?.taxes ?? 0.0
        self.baseRate = priceData?.baseRate ?? 0.0
        self.amountPaid = priceData?.totalAmount ?? 0.0
        if let strikeout = priceData?.strikeout, let strikeoutTotal = strikeout.totalAmount {
            self.strikeoutAmount = strikeoutTotal
            self.savingPercentage = strikeout.savingPercentage ?? 0.0
        }
        if let pricePerAge = priceData?.pricePerAge, !pricePerAge.isEmpty {
            for item in pricePerAge {
                let descriptionText: String
                switch item.bandId.uppercased() {
                case "ADULT":
                    descriptionText = item.count == 1 ? "Adult" : "Adults"
                case "CHILD":
                    descriptionText = item.count == 1 ? "Child" : "Children"
                case "FAMILY":
                    descriptionText = item.count == 1 ? "Family" : "Families"
                case "PERSON":
                    descriptionText = item.count == 1 ? "Person" : "People"
                case "CUSTOM":
                    descriptionText = "Custom"
                default:
                    descriptionText = item.count == 1 ? item.bandId.capitalized : "\(item.bandId.capitalized)s"
                }
                
                let leftText = "\(item.count) \(descriptionText) x \(currency) \(item.perPriceTraveller.commaSeparated())"
                let rightText = "\(currency) \( item.bandTotal.commaSeparated())"
                self.fairSummaryData.append(
                    FareItem(title: leftText, value: rightText, isDiscount: false)
                )
            }
        } else {
            if (priceData?.baseRate ?? 0.0) > 0 {
                let leftText = "Base Rate"
                let rightText = "\(currency) \(priceData?.baseRate?.commaSeparated() ?? "0.0")"
                self.fairSummaryData.append(
                    FareItem(title: leftText, value: rightText, isDiscount: false)
                )
            }
        }
        if let taxes = priceData?.taxes, taxes > 0 {
            self.fairSummaryData.append(FareItem(
                title: "Taxes and fees",
                value: "\(currency) \(taxes.commaSeparated())",
                isDiscount: false
            ))
        }


        if let strikeout = priceData?.strikeout, let originalAmount = strikeout.totalAmount, let totalAmount = priceData?.totalAmount,
           originalAmount > totalAmount {
            let discountAmount = originalAmount - totalAmount
            self.fairSummaryData.append(FareItem(
                title: "Discount",
                value: "- \(currency) \(discountAmount.commaSeparated())",
                isDiscount: true
            ))
            self.savingsTextforFareBreakup = "You are saving \(currency) \(discountAmount.commaSeparated())"
        } else {
            self.fairSummaryData.append(FareItem(
                title: "Discount",
                value: "- \(currency) 0.00",
                isDiscount: true
            ))
            self.savingsTextforFareBreakup = "You are saving \(currency) 0.00"
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

    func cancelBooking(reasonCode: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constants.APIURLs.cancelBookingURL) else {
            self.errorMessage = "Invalid URL for cancel booking"
            completion(false)
            return
        }
        let requestBody = [
            "order_no": orderNumberForCancel,
            "reason_code": reasonCode,
            "currency": currencyGlobal
        ]
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.tokenKey: ssoTokenGlobal,
            Constants.APIHeaders.siteId: ssoSiteIdGlobal
        ]
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<CancelBookingAPIResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.statusCode == 200, response.data?.status == "CANCELLED" {
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

    func preCancelBooking(orderNo: String) {
        let urlString = Constants.APIURLs.preCancelBooking
        guard let url = URL(string: urlString) else {
            return
        }
        
        let requestBody = PreCancelBookingRequst(orderNo: orderNo, currency: currencyGlobal)

        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            Constants.APIHeaders.tokenKey: ssoTokenGlobal,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? ""
        ]
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<PreCancelBookingResponse, Error>) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.preCancelbookingResponse = result
                }
                
            case .failure(let error):
                break
            }
        }
        
    }

    func showToastMessage(_ message: String) {
        toastMessage = message
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showToast = false
        }
    }
}
