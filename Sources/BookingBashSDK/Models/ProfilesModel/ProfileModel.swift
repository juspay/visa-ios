import Foundation

struct ProfileModel {
    let name: String        
    let email: String
    let mobileNumber: String
    let mobileCountryCode: String
    let firstName: String
    let lastName: String
    let passPort: String
}
struct SavedTravelerModel: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let phone: String
}
