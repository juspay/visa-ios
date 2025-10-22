//
//  ProfileViewModel.swift
//  VisaActivity
//
//  Created by Apple on 04/09/25.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var userProfile: ProfileModel
    @Published var savedTravelers: [SavedTravelerModel] = []
    
    init() {
        // Create ProfileModel with safe defaults to avoid validation errors
        self.userProfile = ProfileModel(
            name: "\(firstName.isEmpty ? "Guest" : firstName) \(lastName.isEmpty ? "User" : lastName)",
            email: customerEmail.isEmpty ? "" : customerEmail,
            mobileNumber: mobileNumber.isEmpty ? "" : mobileNumber,
            mobileCountryCode: mobileCountryCode.isEmpty ? "+971" : mobileCountryCode, // Always provide valid country code
            firstName: firstName.isEmpty ? "" : firstName,
            lastName: lastName.isEmpty ? "" : lastName,
            passPort: "" // Passport can be optional
        )
        
        self.savedTravelers = [
            SavedTravelerModel(
                name: "Mr. Manish Kamath",
                email: "rohitk@gmail.com",
                phone: "+91 98978 98780"
            ),
            SavedTravelerModel(
                name: "Mr. Rakesh Kamath",
                email: "rohitk@gmail.com",
                phone: "+91 98978 98780"
            )
        ]
    }
    
    func deleteTraveler(at index: Int) {
        guard index < savedTravelers.count else { return }
        savedTravelers.remove(at: index)
    }
}
