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
    
    @Published var bookingBasicDetails = [
        BasicBookingDetailsModel(key: "Booking ID", value: "NF7V9NME9MGLHRS31117"),
        BasicBookingDetailsModel(key: "Voucher ID", value: "ABCDLHRS31117"),
        BasicBookingDetailsModel(key: "Booking Date", value: checkInDateG)
    ]
    
    @Published var contactDetails = [
        ContactDetailsModel(keyIcon: "User", value: "John Smith"),
        ContactDetailsModel(keyIcon: "Frame", value: "johnsmith@gmail.com"),
        ContactDetailsModel(keyIcon: "Mobile", value: "+91 987878767")
    ]
    
    @Published var cancellationPolicy = ConfirmationReusableInfoModel(
        title: "Cancellation refund policy",
        points: ["Tickets are non-cancellable, non-refundable and non-transferable."]
    )
    
    @Published var leadTraveller = ConfirmationReusableInfoModel(
        title: "Lead Traveler",
        points: ["Mr. Rohit Roy"]
    )
    
    @Published var specialRequest = ConfirmationReusableInfoModel(
        title: "Special Request",
        points: ["-"]
    )
    
    @Published var meetingPickup = ConfirmationReusableInfoModel(
        title: "Meeting and Pickup",
        points: ["You may start this tour at any of the stops listed."]
    )
    
    @Published var inclusions = ConfirmationReusableInfoModel(
        title: "What includes?",
        points: ["Admission to LEGOLAND® Water Park",
                 "All activities",
                 "Unlimited rides",
                 "Free parking at Dubai Parks and Resorts",
                 "Complimentary buggy service during the summer months"
                ]
    )
    
    @Published var OtherDetails = ConfirmationReusableInfoModel(
        title: "Other Details",
        points: ["Tour language: English – Guide"]
    )
    
    @Published var personContactDetails = [
        ContactDetailsModel(keyIcon: "User", value: "John Smith"),
        ContactDetailsModel(keyIcon: "Mobile", value: "+91 987878767")
    ]
    
    @Published var additionalInformation = ConfirmationReusableInfoModel(
        title: "Additional Information",
        points: ["According to government regulations, a valid Photo ID has to be carried by every person above the age of 18 staying at the hotel. The identification proofs accepted are Drivers License, Voters Card, Passport, Ration Card. Without valid ID the guest will not be allowed to check in.",
                 "Children accompanying adults must be between 1-12 years.",
                 "Cancellation and prepayment policies vary according to room type. Please check the Fare policy associated with your room."
                ]
    )
    
    @Published var reasons: [CancellationReason] = [
        .init(title: "Change of travel plan (normal cancellation)"),
        .init(title: "Natural disaster"),
        .init(title: "Illness / Health issue"),
        .init(title: "Death in the family")
    ]
    
    @Published var selectedReason: CancellationReason?
    @Published var amountPaid: Int = 885
    @Published var cancellationFee: Int = 85
    
    var totalRefunded: Int {
        amountPaid - cancellationFee
    }
    
    @Published var fairSummaryData = [
        FareItem(title: "1 Adult", value: "AED 590", isDiscount: false),
        FareItem(title: "Discount", value: "- AED 125", isDiscount: true)
    ]
    
    func fetchBookingStatus(orderNo: String, siteId: String) {
            guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/book") else {
                print("Invalid URL for booking status")
                return
            }
        print("urlllllll")
        print("headersss")
        print("requestBody------")
            
            // Prepare request body
            let requestBody = ConfirmationRequest(orderNo: orderNo, siteId: siteId)
        print(requestBody)
            let headers = [
                "Content-Type": "application/json",
                "Authorization": "Basic Qy1FWTNSM0c6OWRjOWMwOWRiMzdkYWRmYmQyNDAxYTljNjBmODY1MGY1YjZlMDFjYg==",
                "token": encryptedPayload
            ]
            
        print(headers)
            NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<SuccessPageResponse, Error>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if response.status{
                            print("response - \(response)")
                            print("================")
                            
                            // Update view model's published properties
                            self.title = response.data.productInfo.title
                            self.location = "\(response.data.productInfo.city) - \(response.data.productInfo.country)"
                            
                            // Update booking basic details with actual order information
                            self.bookingBasicDetails = [
                                BasicBookingDetailsModel(key: "Booking ID", value: response.data.bookingDetails.orderNo),
                                BasicBookingDetailsModel(key: "Voucher ID", value: response.data.trackId), // You may want to get this from response if available
                                BasicBookingDetailsModel(key: "Booking Date", value: checkInDateG)
                            ]
                            
                            // Also update global variables for backward compatibility
                            packageTitleG = response.data.productInfo.title
                            addressG = "\(response.data.productInfo.city) - \(response.data.productInfo.country)"
                            
                            print(response.data.productInfo.title)
                        } else {
                            self.errorMessage = "Invalid response:"
                        }
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        print("Failed to load booking status:", error)
                    }
                }
            }
        }
    private func setUIData(from bookings: [Booking]) {
        guard let booking = bookings.first else {
            errorMessage = "No bookings found"
            return
        }
//        title = booking.productTitle
////        location =
//        title = data.info.title
//        addressG = data.info.city

        bookingBasicDetails = [
            .init(key: "Order No", value: booking.bookingRef),
            .init(key: "Booking Ref", value: booking.bookingRef),
            .init(key: "Booking Date", value: formatDate(booking.bookingDate)),
            .init(key: "Status", value: booking.status.rawValue.capitalized)
        ]

        bookingTopInfo = BookingConfirmationTopInfoModel(
            image: imageForStatus(booking.status),
            bookingStatus: booking.status.rawValue.capitalized,
            bookingMessage: "Your booking is processed!"
        )
    }

    private func imageForStatus(_ status: TransactionStatus) -> String {
        switch status {
        case .confirmed: return "CheckFill"
        case .pending: return "Pending"
        case .cancelled: return "Failed"
        case .completed: return "CheckFill"
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
