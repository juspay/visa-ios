import SwiftUI
import SUINavigation

public struct BookingBashSDK {
    public init() {}
    
    public static func createExperienceHomeView(encryptPayLoad: String) -> some View {
        ExperienceHomeView(encryptPayLoad: encryptPayLoad)
    }
    
    public static func createMyTransactionView() -> some View {
        MyTransactionView()
    }
}