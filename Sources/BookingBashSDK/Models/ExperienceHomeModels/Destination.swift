
import Foundation

struct Destination: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let imageURL: String?
    
    let destinationId: String
    let destinationType: Int
    let locationName: String
    let city: String
    let state: String
    let region: String
    
    init(name: String, imageURL: String, destinationId: String, destinationType: Int, locationName: String, city: String, state: String, region: String) {
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
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
        self.imageURL = nil
        self.destinationId = ""
        self.destinationType = 2  // Default to city type (2) instead of 0
        self.locationName = name
        self.city = ""
        self.state = ""
        self.region = ""
    }
}
