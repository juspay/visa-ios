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
        // Sample data - replace with actual user data
//        self.userProfile = ProfileModel(
//            name: "\(firstName) \(lastName)",
//            email: customerEmail,
//            phone: "+91 8654 xxxxxx"
//        )
        self.userProfile = ProfileModel(
                   name: "\(firstName) \(lastName)",
                   email: customerEmail,
                   phone: "+91 8654 xxxxxx",
                   firstName: firstName,
                   lastName: lastName
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
