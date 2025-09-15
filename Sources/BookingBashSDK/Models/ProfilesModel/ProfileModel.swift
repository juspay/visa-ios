//
//  ProfileModel.swift
//  VisaActivity
//
//  Created by Apple on 04/09/25.
//

import Foundation

//struct ProfileModel {
//    let name: String
//    let email: String
//    let phone: String
//}
struct ProfileModel {
    let name: String        
    let email: String
    let mobileNumber: String
    let mobileCountryCode: String
    
    // keep raw values if you want them separate too
    let firstName: String
    let lastName: String
}


struct SavedTravelerModel: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let phone: String
}
