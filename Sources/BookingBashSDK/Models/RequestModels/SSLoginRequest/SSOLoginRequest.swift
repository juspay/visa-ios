import Foundation

struct SSOLoginRequestModel: Codable {
    let token: String
    
    init(token: String) {
        self.token = token
    }
}
