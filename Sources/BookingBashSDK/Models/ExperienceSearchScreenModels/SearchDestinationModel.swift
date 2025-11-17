import Foundation

struct SearchDestinationModel: Identifiable, Codable, Equatable {
    let id: String = UUID().uuidString
    let name: String
    let destinationId: String?
    let destinationType: Int?
    let isRecent: Bool
    
}
