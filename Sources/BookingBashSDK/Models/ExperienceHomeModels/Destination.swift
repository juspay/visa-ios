//
//  Model.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation

struct Destination: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String // Keep for backward compatibility
    let imageURL: String? // New property for network images
    
    // Navigation data for ExperienceListDetailView
    let destinationId: String
    let destinationType: String
    let locationName: String
    let city: String
    let state: String
    let region: String
    
    // Convenience initializer for network images with full data
    init(name: String, imageURL: String, destinationId: String, destinationType: String, locationName: String, city: String, state: String, region: String) {
        self.name = name
        self.imageName = ""
        self.imageURL = imageURL
        self.destinationId = destinationId
        self.destinationType = destinationType
        self.locationName = locationName
        self.city = city
        self.state = state
        self.region = region
    }
    
    // Existing initializer for local images (with default values for navigation data)
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
        self.imageURL = nil
        self.destinationId = ""
        self.destinationType = ""
        self.locationName = name
        self.city = ""
        self.state = ""
        self.region = ""
    }
}
