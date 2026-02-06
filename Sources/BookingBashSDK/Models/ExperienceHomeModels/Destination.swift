
import Foundation

struct Destination: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let imageURL: String?
    
    let destinationId: String
    let destinationType: Int
    
    init(name: String, imageURL: String, destinationId: String, destinationType: Int) {
        self.name = name
        self.imageName = ""
        self.imageURL = imageURL
        self.destinationId = destinationId
        self.destinationType = destinationType
    }
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
        self.imageURL = nil
        self.destinationId = ""
        self.destinationType = 2
    }
}

