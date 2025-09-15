import SwiftUI
import SUINavigation

public struct BookingBashSDK {
    public init() {}

    @State private var isActive = true

    public static func createExperienceHomeView(encryptPayLoad: String) -> some View {
        ExperienceHomeView(
                encryptPayLoad: encryptPayLoad
            ,   isActive: $isActive
            ,   onFinish: {
                        print("Got callback")
                }
        )
    }
    
    public static func createMyTransactionView() -> some View {
        MyTransactionView()
    }
}