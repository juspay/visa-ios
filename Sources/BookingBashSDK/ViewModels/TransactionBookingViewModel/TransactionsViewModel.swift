//
//  TransactionsViewModel.swift
//  VisaActivity
//
//  Created by praveen on 04/09/25.
//
import Foundation


class TransactionsViewModel: ObservableObject {
    @Published var selectedTab: TransactionTab = .Upcoming
    @Published private var allBookings: [Booking] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/booking-list")!
    
    // Computed property to return filtered bookings based on selected tab
    var bookings: [Booking] {
        switch selectedTab {
        case .Upcoming:
            return upcomingBookings
        case .Completed:
            return completedBookings
        case .Cancelled:
            return cancelledBookings
        }
    }
    
    // Filter for upcoming bookings: travelDate >= today AND status == confirmed
    private var upcomingBookings: [Booking] {
        let today = Calendar.current.startOfDay(for: Date())
        return allBookings.filter { booking in
            let bookingDate = Calendar.current.startOfDay(for: booking.travelDate)
            return bookingDate >= today && booking.status == .confirmed
        }
    }
    
    // Filter for completed bookings: travelDate < today AND status == confirmed
    private var completedBookings: [Booking] {
        let today = Calendar.current.startOfDay(for: Date())
        return allBookings.filter { booking in
            let bookingDate = Calendar.current.startOfDay(for: booking.travelDate)
            return bookingDate < today && booking.status == .confirmed
        }
    }
    
    // Filter for cancelled bookings: status == cancelled (date doesn't matter)
    private var cancelledBookings: [Booking] {
        return allBookings.filter { booking in
            booking.status == .cancelled
        }
    }
    
    func fetchBookings() {
        isLoading = true
        let requestBody = BookingListRequest(
            email: customerEmail,
            site_id: "68b585760e65320801973737"
        )
        
        let headers = [
            "Content-Type": "application/json",
            "site_id": "68b585760e65320801973737",
            "token": encryptedPayload,
            "Authorization": TokenProvider.getAuthHeader() ?? ""
        ]
        
        print(" Fetching bookings...")
        
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<BookingResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    let data = response.data.bookings
                    self.allBookings = data
                    print("✅ Got \(data.count) bookings")
                    print("📊 Upcoming: \(self.upcomingBookings.count), Completed: \(self.completedBookings.count), Cancelled: \(self.cancelledBookings.count)")
                    print("response for my transaction  \(data) ")
                    data.forEach { print($0) }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ Booking fetch error:", error.localizedDescription)
                }
            }
        }
    }
}
