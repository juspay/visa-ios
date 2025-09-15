//
//  ExperienceBookingConfirmationViewModel.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation

class ExperienceBookingConfirmationViewModel: ObservableObject {
    @Published var title : String?
    @Published var location : String?
    @Published var bookingStatus: BookingStatus = .confirmed
    @Published var errorMessage: String?
    @Published var supplierName: String? {
        didSet {
            updateContactDetails()
        }
    }
    
    // New dynamic properties based on API response
    @Published var trackId: String?
    @Published var currency: String = "AED"
    @Published var totalAmount: Double = 0.0
    @Published var baseRate: Double = 0.0
    @Published var taxes: Double = 0.0
    @Published var strikeoutAmount: Double = 0.0
    @Published var savingPercentage: Int = 0
    @Published var supplierTransactionId: String?
    @Published var bookingRef: String?
    @Published var travelDate: String?
    @Published var totalTravellers: Int = 0
    @Published var totalAdults: Int = 0
    @Published var totalChildren: Int = 0
    @Published var exclusions: ConfirmationReusableInfoModel = ConfirmationReusableInfoModel(title: "What's Not Included?", points: ["-"])
    @Published var duration: String?
    @Published var activityCode: String?
    @Published var supplierEmail: String = "support@supplier.com"
    @Published var supplierPhone: String = "+971 4 123 4567"
    @Published var orderNumberForCancel: String = ""

    
    private func updateContactDetails() {
        let supplier = supplierName ?? "Unknown Supplier"
        contactDetails = [
            ContactDetailsModel(keyIcon: "UserGray", value: supplier),
            ContactDetailsModel(keyIcon: "Frame", value: supplierEmail),
            ContactDetailsModel(keyIcon: "Mobile", value: supplierPhone)
        ]
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
        bookingMessage: "Oops, your booking failed. It seems something went wrong during the booking process."
    )
    
    // Initialize with empty arrays - will be populated dynamically from API
    @Published var bookingBasicDetails: [BasicBookingDetailsModel] = []
    @Published var contactDetails: [ContactDetailsModel] = []
    @Published var cancellationPolicy = ConfirmationReusableInfoModel(title: "Cancellation refund policy", points: ["-"])
    @Published var leadTraveller = ConfirmationReusableInfoModel(title: "Lead Traveler", points: ["-"])
    @Published var specialRequest = ConfirmationReusableInfoModel(title: "Special Request", points: ["-"])
    @Published var meetingPickup = ConfirmationReusableInfoModel(title: "Meeting and Pickup", points: ["-"])
    @Published var inclusions = ConfirmationReusableInfoModel(title: "What includes?", points: ["-"])
    @Published var OtherDetails = ConfirmationReusableInfoModel(title: "Other Details", points: ["-"])
    @Published var personContactDetails: [ContactDetailsModel] = []
    @Published var additionalInformation = ConfirmationReusableInfoModel(title: "Additional Information", points: ["-"])
    
    // MARK: - Cancellation Reasons API Response Model
    struct CancellationReasonsAPIResponse: Codable {
        let status: Bool
        let status_code: Int
        let data: [CancellationReason]
    }
    
    @Published var reasons: [CancellationReason] = []
    @Published var selectedReason: CancellationReason?
    @Published var amountPaid: Int = 0
    @Published var cancellationFee: Int = 0
    
    var totalRefunded: Int {
        amountPaid - cancellationFee
    }
    
    @Published var fairSummaryData: [FareItem] = []
    
    func fetchBookingStatus(orderNo: String, siteId: String, isFromBookingJourney: Bool = true) {
        print("🔍 fetchBookingStatus called with orderNo: '\(orderNo)', siteId: '\(siteId)', isFromBookingJourney: \(isFromBookingJourney)")
        orderNumberForCancel = orderNo
        // If orderNo is empty, add some fallback test data for UI testing
        if orderNo.isEmpty {
            print("⚠️ OrderNo is empty, setting up fallback test data")
            self.setupFallbackData()
            return
        }
        
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/book") else {
            print("❌ Invalid URL for booking status")
            return
        }
        
        // Prepare request body with dynamic updateFlag based on navigation source
        let updateFlag = isFromBookingJourney ? true : false
        let requestBody = ConfirmationRequest(orderNo: orderNo, siteId: siteId, updateFlag: updateFlag)
        print("📤 Request body: \(requestBody)")
        print("🔄 updateFlag set to: \(updateFlag) (isFromBookingJourney: \(isFromBookingJourney))")
        let headers = [
            "Content-Type": "application/json",
            "Authorization": TokenProvider.getAuthHeader() ?? "",
            "token": encryptedPayload
        ]
        print("📤 Headers: \(headers)")
        
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<SuccessPageResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ API Response received - status: \(response)")
                    if response.status{
                        print("📊 Processing response data...")
                        print("================")
                        
                        // Update basic product info
                        self.title = response.data.productInfo?.title
                        self.location = "\(response.data.productInfo?.city ?? "") - \(response.data.productInfo?.country ?? "")"
                        self.trackId = response.data.trackId
                        self.activityCode = response.data.productInfo?.activityCode
                        
                        print("🏷️ Title: \(self.title ?? "nil")")
                        print("📍 Location: \(self.location ?? "nil")")
                        
                        // Update pricing information
                        if let priceInfo = response.data.productInfo?.price {
                            self.currency = priceInfo.currency
                            self.baseRate = priceInfo.baseRate
                            self.taxes = priceInfo.taxes
                            self.totalAmount = priceInfo.totalAmount
                            
                            print("💰 Pricing - Currency: \(self.currency), Base: \(self.baseRate), Taxes: \(self.taxes), Total: \(self.totalAmount)")
                            
                            // Handle strikeout pricing (check if it exists in the model)
                            if response.data.productInfo?.price.strikeout != nil {
                                let strikeout = priceInfo.strikeout
                                self.strikeoutAmount = strikeout.totalAmount
                                self.savingPercentage = strikeout.savingPercentage
                                print("🏷️ Strikeout: \(self.strikeoutAmount), Savings: \(self.savingPercentage)%")
                            }
                        } else {
                            print("❌ No pricing info found in response")
                        }
                        
                        // Update booking details
                        let bookingDetails = response.data.bookingDetails
                        self.bookingRef = bookingDetails.bookingRef
                        self.supplierTransactionId = bookingDetails.supplierTransactionId
                        
                        // Update traveller information
                      
                        let travellerInfo = response.data.travellerInfo
                        print(bookingDetails.createdAt)
                        print(travellerInfo.travelDate)
                        self.travelDate = self.formatTravelDate(from: travellerInfo.travelDate)
                        
                        self.totalTravellers = travellerInfo.totalTraveller
                        self.totalAdults = travellerInfo.totalAdult
                        self.totalChildren = travellerInfo.totalChild
                        
                        print("👥 Travellers - Total: \(self.totalTravellers), Adults: \(self.totalAdults), Children: \(self.totalChildren)")
                        
                        // Update booking basic details with actual order information
                        let bookingId = response.data.bookingDetails.bookingRef
                        
                        let voucherId = "ABCDLHRS31117"
                        var bookingDate = "-"
                        if let bookingResponse = response.data.bookingResponse.first {
                            bookingDate = self.formatBookingDate(from: bookingResponse.timestamp)
                        }
                        
                        self.bookingBasicDetails = [
                            BasicBookingDetailsModel(key: "Booking ID", value: bookingId),
                            BasicBookingDetailsModel(key: "Voucher ID", value: voucherId),
                            BasicBookingDetailsModel(key: "Booking Date", value: bookingDate)
                        ]
                        
                        // Update supplier information
                        let supplierValue = response.data.productInfo?.supplier?.name ??
                        response.data.productInfo?.supplierName ??
                        response.data.productInfo?.providerSupplierName ??
                        "Digital Connect Singapore"
                        self.supplierName = supplierValue
                        
                        // Update contact details with dynamic supplier info
                        self.contactDetails = [
                            ContactDetailsModel(keyIcon: "UserGray", value: supplierValue),
                            ContactDetailsModel(keyIcon: "Frame", value: self.supplierEmail),
                            ContactDetailsModel(keyIcon: "Mobile", value: self.supplierPhone)
                        ]
                        
                        // Set leadTraveller dynamically
                        let leadName = "\(travellerInfo.title) \(travellerInfo.firstName) \(travellerInfo.lastName)".trimmingCharacters(in: .whitespaces)
                        self.leadTraveller = ConfirmationReusableInfoModel(
                            title: "Lead Traveler",
                            points: [leadName.isEmpty ? "-" : leadName]
                        )
                        
                        // Set person contact details
                        self.personContactDetails = [
                            ContactDetailsModel(keyIcon: "UserGray", value: leadName.isEmpty ? "-" : leadName),
                            ContactDetailsModel(keyIcon: "Mobile", value: "+\(travellerInfo.code) \(travellerInfo.mobile)")
                        ]
                        
                        // Set specialRequest dynamically
                        let specialRequestValue = travellerInfo.specialRequest.trimmingCharacters(in: .whitespacesAndNewlines)
                        self.specialRequest = ConfirmationReusableInfoModel(
                            title: "Special Request",
                            points: [specialRequestValue.isEmpty ? "-" : specialRequestValue]
                        )
                        
                        // Set inclusions dynamically
                        let inclusionsArray = response.data.productInfo?.inclusions ?? []
                        self.inclusions = ConfirmationReusableInfoModel(
                            title: "What includes?",
                            points: inclusionsArray.isEmpty ? ["-"] : inclusionsArray
                        )
                        
                        // Set exclusions dynamically
                        let exclusionsArray = response.data.productInfo?.exclusions ?? []
                        self.exclusions = ConfirmationReusableInfoModel(
                            title: "What's Not Included?",
                            points: exclusionsArray.isEmpty ? ["-"] : exclusionsArray
                        )
                        
                        // Set additionalInformation dynamically
                        let additionalInfoArray = response.data.productInfo?.additionalInfo ?? []
                        self.additionalInformation = ConfirmationReusableInfoModel(
                            title: "Additional Information",
                            points: additionalInfoArray.isEmpty ? ["-"] : additionalInfoArray
                        )
                        
                        // Set cancellation policy dynamically
                        let cancellationPolicyText = response.data.productInfo?.cancellationPolicyString ??
                                                   response.data.productInfo?.cancellationPolicy.description ??
                                                   "Tickets are non-cancellable, non-refundable and non-transferable."
                        self.cancellationPolicy = ConfirmationReusableInfoModel(
                            title: "Cancellation refund policy",
                            points: [cancellationPolicyText]
                        )
                        
                        // Set duration information
                        if let supplierDuration = response.data.productInfo?.supplierDuration {
                            let minHours = supplierDuration.variableDurationFromMinutes / 60
                            let maxHours = supplierDuration.variableDurationToMinutes / 60
                            self.duration = "\(minHours)-\(maxHours) hours"
                        } else {
                            self.duration = response.data.productInfo?.duration ?? "-"
                        }
                        
                        // Set other details with language information
                        let languageName = response.data.productInfo?.languageDtl.name ??
                                          response.data.productInfo?.languageName ??
                                          "English"
                        self.OtherDetails = ConfirmationReusableInfoModel(
                            title: "Other Details",
                            points: [
                                "Tour language: \(languageName)",
                                "Duration: \(self.duration ?? "-")",
                                "Region: \(response.data.productInfo?.region ?? "-")"
                            ]
                        )
                        
                        // Set meeting and pickup information
                        if let pickupInfo = response.data.productInfo?.pickupDtl {
                            let pickupDetails = [
                                "Location: \(pickupInfo.name)",
                                "Address: \(pickupInfo.address)",
                                "City: \(pickupInfo.city), \(pickupInfo.country)",
                                "Type: \(pickupInfo.pickupType)"
                            ]
                            self.meetingPickup = ConfirmationReusableInfoModel(
                                title: "Meeting and Pickup",
                                points: pickupDetails
                            )
                        }
                        
                        // Update fare summary with dynamic pricing from API response
                        var fareItems: [FareItem] = []
                        
                        // Use traveller info and pricing data from API response
                        let apiTotalAmount = self.totalAmount
                        let apiStrikeoutAmount = self.strikeoutAmount
                        let apiCurrency = self.currency
                        
                        print("🧮 Building fare items with - Total: \(apiTotalAmount), Strikeout: \(apiStrikeoutAmount), Currency: \(apiCurrency)")
                        
                        // Add adult fare with strikeout price as per new logic
                        if self.totalAdults > 0 {
                            let adultTitle = "\(self.totalAdults) Adult\(self.totalAdults > 1 ? "s" : "") x \(apiCurrency) \(String(format: "%.1f", apiStrikeoutAmount))"
                            let adultValue = "\(apiCurrency) \(String(format: "%.1f", apiStrikeoutAmount))"
                            let fareItem = FareItem(
                                title: adultTitle,
                                value: adultValue,
                                isDiscount: false
                            )
                            fareItems.append(fareItem)
                            print("➕ Added adult fare: \(fareItem.title) - \(fareItem.value)")
                        }
                        
                        // Add children fare if any (using strikeout price logic)
                        if self.totalChildren > 0 {
                            let childStrikeoutPrice = apiStrikeoutAmount * Double(self.totalChildren) / Double(max(self.totalAdults, 1))
                            let childTitle = "\(self.totalChildren) Child\(self.totalChildren > 1 ? "ren" : "") x \(apiCurrency) \(String(format: "%.1f", childStrikeoutPrice))"
                            let childValue = "\(apiCurrency) \(String(format: "%.1f", childStrikeoutPrice))"
                            let fareItem = FareItem(
                                title: childTitle,
                                value: childValue,
                                isDiscount: false
                            )
                            fareItems.append(fareItem)
                            print("➕ Added children fare: \(fareItem.title) - \(fareItem.value)")
                        }
                        
                        // Add discount: strikeout.totalAmount - price.totalAmount
                        if apiStrikeoutAmount > 0 && apiStrikeoutAmount > apiTotalAmount {
                            let discount = apiStrikeoutAmount - apiTotalAmount
                            let fareItem = FareItem(
                                title: "Discount",
                                value: "- \(apiCurrency) \(String(format: "%.1f", discount))",
                                isDiscount: true
                            )
                            fareItems.append(fareItem)
                            print("➕ Added discount: \(fareItem.title) - \(fareItem.value)")
                        }
                        
                        // If no strikeout amount or no discount, show base fare
                        if fareItems.isEmpty || apiStrikeoutAmount <= apiTotalAmount {
                            // Clear existing items and add simple fare structure
                            fareItems.removeAll()
                            
                            if self.totalAdults > 0 {
                                let adultTitle = "\(self.totalAdults) Adult\(self.totalAdults > 1 ? "s" : "") x \(apiCurrency) \(String(format: "%.1f", apiTotalAmount))"
                                let adultValue = "\(apiCurrency) \(String(format: "%.1f", apiTotalAmount))"
                                let fareItem = FareItem(
                                    title: adultTitle,
                                    value: adultValue,
                                    isDiscount: false
                                )
                                fareItems.append(fareItem)
                                print("➕ Added simple adult fare: \(fareItem.title) - \(fareItem.value)")
                            }
                        }
                        
                        print("📝 Final fare items count: \(fareItems.count)")
                        for (index, item) in fareItems.enumerated() {
                            print("   \(index + 1). \(item.title): \(item.value)")
                        }
                        
                        self.fairSummaryData = fareItems
                        
                        // Update amount paid for cancellation calculations from API
                        self.amountPaid = Int(round(apiTotalAmount))
                        
                        // Set cancellation fee to 0 for full refund scenario
                        // Total Amount → whatever was originally paid (totalAmount)
                        // Deduction → 0 (since you're refunding fully)
                        // Total Amount Processed → same as totalAmount
                        self.cancellationFee = 0
                        
                        print("💰 Cancellation Details - API Total: \(apiTotalAmount), Amount Paid: \(self.amountPaid), Fee: \(self.cancellationFee), Refund: \(self.totalRefunded)")
                        
                        print("✅ Successfully updated all dynamic fields from API response")
                        print("🎯 fairSummaryData updated with \(self.fairSummaryData.count) items")
                        
                    } else {
                        print("❌ API response status is false")
                        self.errorMessage = "Invalid response"
                    }
                case .failure(let error):
                    print("❌ API call failed: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    print("Failed to load booking status:", error)
                }
            }
        }
    }
    
    private func setupFallbackData() {
        print("🧪 Setting up comprehensive fallback test data for UI")
        
        // Set basic properties from your API response example
        self.title = "Singapore Data eSIM - High-Speed Connectivity"
        self.location = "Singapore - Singapore"
        self.currency = "AED"
        self.baseRate = 315.0
        self.taxes = 15.0
        self.totalAmount = 333.0
        self.strikeoutAmount = 370.0
        self.savingPercentage = 10
        self.totalAdults = 1
        self.totalTravellers = 1
        self.totalChildren = 0
        self.trackId = "72ab950e-bd51-4768-a110-26f793ed9c64"
        self.activityCode = "5549862P28"
        self.duration = "7-30 days"
        
        // Set travel date to a specific future date instead of current date
        self.travelDate = "Sat, 22 Jun 2025"
        
        // Set booking basic details
        self.bookingBasicDetails = [
            BasicBookingDetailsModel(key: "Booking ID", value: "68b82d4256bcac8e9b36eb7c"),
            BasicBookingDetailsModel(key: "Voucher ID", value: "ACT24596"),
            BasicBookingDetailsModel(key: "Booking Date", value: "Tue, 12 Sep 2025")
        ]
        
        // Set supplier contact details
        self.supplierName = "Digital Connect Singapore"
        self.supplierEmail = "support@digitalconnect.sg"
        self.supplierPhone = "+65 6789 1234"
        self.contactDetails = [
            ContactDetailsModel(keyIcon: "UserGray", value: "Digital Connect Singapore"),
            ContactDetailsModel(keyIcon: "Frame", value: "support@digitalconnect.sg"),
            ContactDetailsModel(keyIcon: "Mobile", value: "+65 6789 1234")
        ]
        
        // Set lead traveller details
        self.leadTraveller = ConfirmationReusableInfoModel(
            title: "Lead Traveler",
            points: ["Mr Shaheryar Shaikh"]
        )
        
        // Set person contact details
        self.personContactDetails = [
            ContactDetailsModel(keyIcon: "UserGray", value: "Mr Shaheryar Shaikh"),
            ContactDetailsModel(keyIcon: "Mobile", value: "+91 8412921601")
        ]
        
        // Set special request
        self.specialRequest = ConfirmationReusableInfoModel(
            title: "Special Request",
            points: ["-"]
        )
        
        // Set inclusions from API response
        self.inclusions = ConfirmationReusableInfoModel(
            title: "What includes?",
            points: [
                "eSIM activation QR code",
                "Installation instructions",
                "Customer support",
                "Data allowance as per plan",
                "Setup guide",
                "Troubleshooting assistance",
                "Multiple device support"
            ]
        )
        
        // Set exclusions from API response
        self.exclusions = ConfirmationReusableInfoModel(
            title: "What's Not Included?",
            points: [
                "Voice calls",
                "SMS services",
                "Device compatibility guarantee",
                "Refund for unused data",
                "Physical SIM card",
                "Local phone number",
                "International calls"
            ]
        )
        
        // Set additional information from API response
        self.additionalInformation = ConfirmationReusableInfoModel(
            title: "Additional Information",
            points: [
                "Instant activation via QR code",
                "No physical SIM required",
                "High-speed 4G/5G data",
                "Compatible with most devices",
                "24/7 customer support",
                "Multiple data plans available",
                "Works across Singapore",
                "Easy installation process",
                "No roaming charges",
                "Environmentally friendly",
                "Immediate email delivery",
                "Device must be unlocked",
                "iOS 12.1+ or Android 9+ required",
                "Data sharing/hotspot available"
            ]
        )
        
        // Set cancellation policy
        self.cancellationPolicy = ConfirmationReusableInfoModel(
            title: "Cancellation refund policy",
            points: ["Non-refundable. No cancellation allowed once QR code is delivered."]
        )
        
        // Set meeting and pickup information
        self.meetingPickup = ConfirmationReusableInfoModel(
            title: "Meeting and Pickup",
            points: [
                "Location: Digital Service",
                "Address: Instant activation via email",
                "City: Singapore, Singapore",
                "Type: Digital Delivery"
            ]
        )
        
        // Set other details
        self.OtherDetails = ConfirmationReusableInfoModel(
            title: "Other Details",
            points: [
                "Tour language: English",
                "Duration: 7-30 days",
                "Region: Asia/Singapore",
                "Service Type: Digital eSIM"
            ]
        )
        
        // Create fare summary data matching screenshot format
        var fareItems: [FareItem] = []
        
        // Format: "1 Adult x AED strikeoutAmount" with "AED strikeoutAmount" on right
        fareItems.append(FareItem(
            title: "1 Adult x AED \(String(format: "%.1f", self.strikeoutAmount))",
            value: "AED \(String(format: "%.1f", self.strikeoutAmount))",
            isDiscount: false
        ))
        
        // Format: "Discount" with "- AED discount_amount" on right
        let discount = self.strikeoutAmount - self.totalAmount
        fareItems.append(FareItem(
            title: "Discount",
            value: "- AED \(String(format: "%.1f", discount))",
            isDiscount: true
        ))
        
        self.fairSummaryData = fareItems
        self.amountPaid = Int(round(self.totalAmount))
        
        print("✅ Comprehensive fallback data setup complete with all dynamic fields populated")
        print("📊 Fare items: \(fareItems.count), Inclusions: \(self.inclusions.points.count), Exclusions: \(self.exclusions.points.count)")
        print("💰 Fallback - Amount Paid: \(self.amountPaid), Total Amount: \(self.totalAmount)")
    }
    
    func formatBookingDate(from timestamp: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: timestamp) else {
            // Try without fractional seconds if needed
            isoFormatter.formatOptions = [.withInternetDateTime]
            guard let fallbackDate = isoFormatter.date(from: timestamp) else {
                return "-"
            }
            return formatDate(date: fallbackDate)
        }
        return formatDate(date: date)
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy" // Sat, 22 Jun 2025
        return formatter.string(from: date)
    }
    
    func formatTravelDate(from dateString: String) -> String {
        print("🗓️ Formatting travel date from: '\(dateString)'")
        
        // Try multiple date formats that might come from API
        let possibleFormats = [
            "yyyy-MM-dd",           // 2025-09-15
            "dd/MM/yyyy",           // 15/09/2025
            "MM/dd/yyyy",           // 09/15/2025
            "yyyy-MM-dd HH:mm:ss",  // 2025-09-15 00:00:00
            "dd-MM-yyyy",           // 15-09-2025
            "yyyy/MM/dd"            // 2025/09/15
        ]
        
        for format in possibleFormats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = format
            formatter.timeZone = TimeZone.current
            
            if let date = formatter.date(from: dateString) {
                let displayFormatter = DateFormatter()
                displayFormatter.locale = Locale(identifier: "en_US_POSIX")
                displayFormatter.dateFormat = "EEE, dd MMM yyyy" // Mon, 15 Sep 2025
                let formattedDate = displayFormatter.string(from: date)
                print("✅ Successfully formatted travel date: '\(formattedDate)'")
                return formattedDate
            }
        }
        
        // If no format works, return the original string or a fallback
        print("⚠️ Could not parse travel date, returning original string")
        return dateString.isEmpty ? "-" : dateString
    }
    
    // MARK: - Fetch Cancellation Reasons
    func fetchCancellationReasons(orderNo: String, completion: (() -> Void)? = nil) {
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/cancel-reason") else {
            self.errorMessage = "Invalid URL for cancellation reasons"
            completion?()
            return
        }
        let requestBody = ["order_no": orderNo]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": TokenProvider.getAuthHeader() ?? "",
            "token": encryptedPayload
        ]
        print("requestBody for cancel reasons \(requestBody)")
        print("headers for cancel reasons \(headers)")
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<CancellationReasonsAPIResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status {
                        self.reasons = response.data
                        print("response from cancel booking---")
                        print(self.reasons)
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
    
    // MARK: - Cancel Booking API Response Model
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
    
    // MARK: - Cancel Booking
    func cancelBooking(orderNoo: String, siteId : String, reasonCode: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/cancel") else {
            self.errorMessage = "Invalid URL for cancel booking"
            completion(false)
            return
        }
        let requestBody = [
            "order_no": orderNumberForCancel,
            "reason_code": reasonCode,
           
        ]
        let headers = [
            "Content-Type": "application/json",
            "Authorization": TokenProvider.getAuthHeader() ?? "",
            "token": encryptedPayload,
            "site_id": siteId
        ]
        print("requestbody for cancel - \(requestBody)")
        print("headers for cancel - \(headers)")
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<CancelBookingAPIResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status, let data = response.data, data.booking_status == "CANCELLED" {
                        print("Booking cancelled successfully:", data)
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
}
