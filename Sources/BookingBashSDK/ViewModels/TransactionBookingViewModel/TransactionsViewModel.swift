//
//  TransactionsViewModel.swift
//  VisaActivity
//
//  Created by praveen on 04/09/25.
//
import Foundation

class TransactionsViewModel: ObservableObject {
    @Published var selectedTab: TransactionTab = .Upcoming
    @Published var bookings: [Booking] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/booking-list")!
    
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
            "Authorization": "Basic Qy1FWTNSM0c6OWRjOWMwOWRiMzdkYWRmYmQyNDAxYTljNjBmODY1MGY1YjZlMDFjYg=="
        ]
        
        print(" Fetching bookings...")
        
        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<BookingResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    let data = response.data.bookings
                    self.bookings = data
                    print("✅ Got \(data.count) bookings")
                    data.forEach { print($0) }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("❌ Booking fetch error:", error.localizedDescription)
                }
            }
        }
    }
}


//class TransactionsViewModel: ObservableObject {
//    @Published var selectedTab: TransactionTab = .Upcoming
//    @Published var items: [Booking] = []
//    @Published var isLoading = false
//    @Published var bookings: [Booking] = []
//    @Published var errorMessage: String?
//    
//    private let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/booking-list")!
//    
//    func fetchBookings() {
//        guard let url = URL(string: "https://travelapi-sandbox.bookingbash.com/services/api/activities/2.0/booking-list") else { return }
//        
//        let requestBody = BookingListRequest(
//            email: customerEmail,
//            site_id: "68b585760e65320801973737"
//        )
//        print(requestBody)
//        let headers = [
//            "Content-Type": "application/json",
//            "site_id": "68b585760e65320801973737",
//            "token": encryptedPayload,
//            "Authorization": "Basic Qy1FWTNSM0c6OWRjOWMwOWRiMzdkYWRmYmQyNDAxYTljNjBmODY1MGY1YjZlMDFjYg=="
//        ]
//        print(" Fetching bookings from API...")
//        print(" Request Body:", requestBody)
//        print(" Headers:", headers)
//        
//        NetworkManager.shared.post(url: url, body: requestBody, headers: headers) { (result: Result<BookingResponse, Error>) in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    print(" API Success")
//                    print(" Response Data:", response)
//                    self.setUIData(responseData: response.data.bookings)
//                case .failure(let error):
//                    self.errorMessage = error.localizedDescription
//                    print("❌ Booking fetch error:", error.localizedDescription)
//                }
//            }
//        }
//    }
//    private func setUIData(responseData: [Booking]) {
//        self.bookings = responseData
//        self.items = responseData
//        print(" UI Data Prepared - Bookings Count:", responseData.count)
//    }
//}
