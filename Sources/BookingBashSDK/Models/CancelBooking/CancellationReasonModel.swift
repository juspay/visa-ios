
import Foundation

struct CancellationReasonsAPIResponse: Codable {
    let status: Bool
    let status_code: Int
    let data: [CancellationReason]
}

struct CancellationReason: Identifiable, Equatable, Codable {
    let id = UUID()
    let title: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case title = "cancellation_text"
        case code = "cancellation_code"
    }
}
